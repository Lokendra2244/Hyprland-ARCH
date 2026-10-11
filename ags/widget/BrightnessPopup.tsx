import app from "ags/gtk4/app"
import Gtk from "gi://Gtk?version=4.0"
import Astal from "gi://Astal?version=4.0"
import { createState, For, type Accessor } from "ags"
import { execAsync } from "ags/process"
import { interval } from "ags/time"

// GTK3 project instead? Swap:
//   "gi://Gtk?version=4.0"    -> "gi://Gtk?version=3.0"
//   "gi://Astal?version=4.0"  -> "gi://Astal?version=3.0"
// and in LabeledSlider/BoundLabeledSlider below, the slider's
// `onChangeValue={({ value }) => ...}` -> `onDragged={(self) => ...
// props.onChangeValue(self.value))}` (GTK3's Astal.Slider uses a
// different signal name/payload shape than GTK4's).

const BIN = "/home/lokendra/.local/bin" // literal string — bundled at build time, no $HOME expansion

type ExternalDisplay = { bus: number; model: string; pct: number | null }

// ---- Presentational helpers (pure — safe at module scope) ---------------

function LabeledSlider(props: {
    label: string
    value: number
    min: number
    max: number
    onChangeValue: (v: number) => void
}) {
    return (
        <box orientation={Gtk.Orientation.VERTICAL} class="labeled-slider">
            <box>
                <label label={props.label} hexpand halign={Gtk.Align.START} />
                <label label={`${Math.round(props.value)}`} />
            </box>
            <slider
                min={props.min}
                max={props.max}
                value={props.value}
                onChangeValue={({ value }) => props.onChangeValue(value)}
            />
        </box>
    )
}

// Same, but takes a live Accessor (from createState) instead of a plain
// number — for the persistent sliders (internal display, temp, gamma)
// rather than the per-item sliders rendered by <For>.
function BoundLabeledSlider(props: {
    label: string
    value: Accessor<number>
    min: number
    max: number
    onChangeValue: (v: number) => void
}) {
    return (
        <box orientation={Gtk.Orientation.VERTICAL} class="labeled-slider">
            <box>
                <label label={props.label} hexpand halign={Gtk.Align.START} />
                <label label={props.value((v) => `${Math.round(v)}`)} />
            </box>
            <slider
                min={props.min}
                max={props.max}
                value={props.value}
                onChangeValue={({ value }) => props.onChangeValue(value)}
            />
        </box>
    )
}

// ---- Root widget ----------------------------------------------------------
//
// All state, polling, and subprocess calls live inside this function
// rather than at module scope: per the AGS docs, the whole module
// re-evaluates on every `ags toggle`/`ags run` client invocation (it's
// how the CLI detects an already-running instance), so anything with
// side effects at module scope would re-fire — spawning duplicate
// brightnessctl/ddcutil calls and duplicate interval timers — on every
// single click, in a disposable process that immediately exits.
// Everything here only runs once, when `main()` calls this function.

function ExternalDisplaySlider({ d }: { d: ExternalDisplay }) {
    const [pct, setPct] = createState(d.pct ?? 0)
    let timer: any = null

    function handleChange(v: number) {
        setPct(v)
        if (timer) clearTimeout(timer)
        timer = setTimeout(() => {
            execAsync([`${BIN}/ddc-brightness`, "set", `${d.bus}`, `${Math.round(v)}`])
                .catch(console.error)
        }, 120)
    }

    return (
        <BoundLabeledSlider
            label={d.model}
            value={pct}
            min={0}
            max={100}
            onChangeValue={handleChange}
        />
    )
}

export default function BrightnessPopup() {
    // -- Internal panel brightness --
    const [internalPct, setInternalPct] = createState(0)

    async function refreshInternal() {
        try {
            const out = await execAsync(["brightnessctl", "-c", "backlight", "-m"])
            const m = out.match(/,(\d+)%,/) // brightnessctl -m -> class,device,cur,pct%,max
            if (m) setInternalPct(parseInt(m[1]))
        } catch (err) {
            console.error(err)
        }
    }
    refreshInternal()
    interval(2000, refreshInternal)

    function setInternal(pct: number) {
        setInternalPct(pct) // optimistic, so the slider doesn't lag its own drag
        execAsync(["brightnessctl", "-c", "backlight", "set", `${Math.round(pct)}%`])
            .then(refreshInternal)
            .catch(console.error)
    }

    // -- External displays: any number, auto-detected, no config --
    const [externalDisplays, setExternalDisplays] = createState<ExternalDisplay[]>([])

    async function refreshExternal() {
        try {
            const out = await execAsync([`${BIN}/ddc-brightness`, "list-with-values"])
            setExternalDisplays(JSON.parse(out))
        } catch (err) {
            console.error(err)
        }
    }
    refreshExternal()
    interval(15000, refreshExternal)

    function setExternal(bus: number, pct: number) {
        setExternalDisplays((prev) => prev.map((d) => (d.bus === bus ? { ...d, pct } : d)))
        execAsync([`${BIN}/ddc-brightness`, "set", `${bus}`, `${Math.round(pct)}`])
            .then(refreshExternal)
            .catch(console.error)
    }

    // -- Sunsetr --
    // sunsetrOn tracks what WE last told sunsetr, not a live read of its
    // actual schedule state (see bin/sunsetr-ctl.sh's notes on the
    // preset-based toggle) — good enough as a click target, not
    // authoritative if something else changes sunsetr's state.
    const [sunsetrOn, setSunsetrOn] = createState(true)
    const [drawerOpen, setDrawerOpen] = createState(false)
    const [manualTemp, setManualTemp] = createState(4500)
    const [manualGamma, setManualGamma] = createState(100)

    let isSyncing = false

    async function refreshSunsetr() {
        try {
            const activePreset = (await execAsync(["sunsetr", "preset", "active"])).trim()
            const isCurrentlyOn = activePreset !== "neutral"
            if (sunsetrOn() !== isCurrentlyOn) {
                isSyncing = true
                setSunsetrOn(isCurrentlyOn)
                setTimeout(() => {
                    isSyncing = false
                }, 100)
            }

            // Sync current slider values from config on first launch
            const [tempOut, gammaOut] = await Promise.all([
                execAsync([`${BIN}/sunsetr-ctl.sh`, "get-temp"]),
                execAsync([`${BIN}/sunsetr-ctl.sh`, "get-gamma"]),
            ])
            const t = Number(tempOut.trim())
            const g = Number(gammaOut.trim())
            if (!isNaN(t) && t > 0) setManualTemp(t)
            if (!isNaN(g) && g > 0) setManualGamma(g)
        } catch (err) {
            console.error(err)
        }
    }
    refreshSunsetr()
    interval(3000, refreshSunsetr)

    function toggleSunsetr(active: boolean) {
        if (isSyncing) return
        const action = active ? "toggle-on" : "toggle-off"
        execAsync([`${BIN}/sunsetr-ctl.sh`, action]).catch(console.error)
    }

    let tempTimer: any = null
    function applyTemp(k: number) {
        setManualTemp(k)
        if (tempTimer) clearTimeout(tempTimer)
        tempTimer = setTimeout(() => {
            execAsync([`${BIN}/sunsetr-ctl.sh`, "set-temp", `${Math.round(k)}`]).catch(console.error)
        }, 150)
    }

    let gammaTimer: any = null
    function applyGamma(pct: number) {
        setManualGamma(pct)
        if (gammaTimer) clearTimeout(gammaTimer)
        gammaTimer = setTimeout(() => {
            execAsync([`${BIN}/sunsetr-ctl.sh`, "set-gamma", `${Math.round(pct)}`]).catch(console.error)
        }, 150)
    } 

    return (
        <window
            name="brightness-popup"
            application={app}
            class="BrightnessPopup"
            namespace="brightness-popup"
            visible = {false}
            default_width = {-1}
            layer={Astal.Layer.OVERLAY}
            anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT}
            margin_top = {10}
            margin_right = {10}
            keymode={Astal.Keymode.ON_DEMAND}
        >
            <box orientation={Gtk.Orientation.VERTICAL} class="popup-root">
                <BoundLabeledSlider
                    label="Internal display"
                    value={internalPct}
                    min={1}
                    max={100}
                    onChangeValue={setInternal}
                />

                <box orientation={Gtk.Orientation.VERTICAL} class="external-displays">
                    <label
                        class="empty-state"
                        label="No external displays detected"
                        halign={Gtk.Align.START}
                        visible={externalDisplays((d) => d.length === 0)}
                    />
                    <For each={externalDisplays}>
                        {(d: ExternalDisplay) =>  <ExternalDisplaySlider d={d} />}
                    </For>
                </box>

                <box class="sunsetr-row">
                    <label label="Sunsetr" hexpand halign={Gtk.Align.START} />
                    <switch
                        active={sunsetrOn}
                        onNotifyActive={({ active }) => toggleSunsetr(active)}
                    />
                </box>

                <button class="drawer-toggle" onClicked={() => setDrawerOpen((v) => !v)}>
                    <label
                        label={drawerOpen((open) => (open ? "Hide color controls ▲" : "Color controls ▼"))}
                    />
                </button>

                <revealer revealChild={drawerOpen} transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}>
        {/* sensitive={sunsetrOn} grays out and disables both sliders when off.
            Remove sensitive={sunsetrOn} if you want sliders adjustable while off. */}
                   <box orientation={Gtk.Orientation.VERTICAL} class="drawer" sensitive={sunsetrOn}>
                       <BoundLabeledSlider
                           label="Temperature (K)"
                           value={manualTemp}
                           min={1000}
                           max={6500}
                           onChangeValue={applyTemp}
                       />
                       <BoundLabeledSlider
                           label="Gamma (%)"
                           value={manualGamma}
                           min={10}
                           max={100}
                           onChangeValue={applyGamma}
                       />
                   </box>
                </revealer> 
            </box>
        </window>
    )
}
