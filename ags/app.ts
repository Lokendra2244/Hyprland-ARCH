import app from "ags/gtk4/app"
import css from "./style.css"
import BrightnessPopup from "./widget/BrightnessPopup"

// If "ags/gtk4/app" doesn't resolve, your project targets GTK3 instead —
// swap to "ags/gtk3/app" here and see the note at the top of
// widget/BrightnessPopup.tsx for the other GTK3-specific changes needed.

app.start({
    css,
    main() {
        BrightnessPopup()
    },
})

// Toggling: the window registers itself via `name="brightness-popup"` +
// `application={app}` inside BrightnessPopup.tsx, which is all `ags`
// needs to expose it to its built-in toggle command — no custom
// requestHandler needed:
//   ags toggle brightness-popup
