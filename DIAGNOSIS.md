The inactive RE/TE menus are caused by a repeating DOM observer update in
`frontend/kedco-central-eform-workflow.js`.

The uploaded `re_te.html` already contains the earlier startup correction.
Its menu listeners exist and target the expected sections. After the central
workflow loads, its body observer calls `ensureRecipientOptions()` on every
child-list mutation. That function replaces the receiving-region, personnel,
and station options and rewrites the directory status even when unchanged.
Those writes trigger the same observer again. The repeated microtasks prevent
the event loop from reaching menu clicks and timers.

| Evidence | Original uploaded source | Corrected source |
| --- | --- | --- |
| Minimal central-workflow fixture | A 100 ms timer never runs; process terminated after 4 seconds | Timer runs and fixture completes |
| Complete RE/TE page with uploaded helpers | Local startup succeeds, then test times out after central services start | All five menu panels switch |
| E-form tabs after central services load | Cannot complete the test | All seven tabs render with Send controls |
| Idle form mutations | Repeating observer loop | Zero recurring form mutations in the idle observation window |

The correction compares the live option values and labels before replacing
them, changes the status only when its text differs, and coalesces observer
work into a task. It disconnects observation during its own synchronous
updates. The workflow also reuses the routing fields already present in
the current RE/TE forms, avoiding duplicate fields with the same names.

The page's shared-script cache token changes to `20261001-menu-v1` so the
browser requests the corrected workflow. Its footer shows `menu fix 1`.
The original menu handlers, form definitions, data keys, and send functions
remain intact. The installer applies only source-matched fragments to the
actual `frontend` layout and backs up the affected originals.

Two separate observations:

- The required operational-scope dialog intentionally covers the page until
  the user selects a scope and clicks Continue. Its confirmation works in
  the corrected fixture.
- `re_te.html` references `kedco-cloud-backup.js`, which is absent from the
  uploaded project. That optional integration reports an unavailable-service
  warning. It does not cause the reproduced menu freeze.

These results come from executing the uploaded scripts in DOM fixtures with
mock local services. They do not confirm a Windows installation, real account
delivery, external Google Maps rendering, or graphical signature rendering.
