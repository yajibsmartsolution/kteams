KEDCO RE/TE network panels and scope correction - 02 October 2026

Based on the attached current page Pasted text(20261002-091648).txt.

Installation
1. Save Install-RETE-Network-Scope-Fix.ps1 in the KEDCO project folder.
2. Open PowerShell in that folder (currently I:\KEDCO-Automation-LOCAL-STORAGE-COMPLETE).
3. Run:
   powershell.exe -ExecutionPolicy Bypass -File ".\Install-RETE-Network-Scope-Fix.ps1" -ProjectRoot (Get-Location).Path
4. If successful, restart with the existing Stop/Start scripts and press Ctrl+F5.

The installer is self-contained. It verifies all source fragments and existing
assets before writing. It preserves current surrounding changes, backs up existing
files, restores them on a write failure, and can be rerun safely. It does not clear
Local Storage or alter account roles, routing, recipient IDs or approval logic.

Corrections
- Removes the orphan closing div that put four cards, forms and records outside
  the map section and the main layout.
- Keeps all four cards in responsive grids; tables scroll inside their cards.
- Uses the selected RE/TE role, region and maintenance unit/TSP for eForm options.
- Includes a TE's recorded upstream 33 kV supply in map filters and context.
- Removes the unconditional Funtua source and route option; recorded Funtua links
  remain available when the active scope actually contains that source.
- Shares scope helpers across the main page, map and route editor, and refreshes
  their options after a scope change.
- Makes the feeder band chart use the same scoped network as the other charts.
- Fixes the mistyped linked-form missingRequired property.

Source data
A source omitted from the station-name list is linked through recorded feeders
when their state assignments agree (including Gagarawa).
All maintenance feeder names, units, network records and stored route keys remain
as supplied. Matching ignores case, spaces and punctuation; it does not invent
station relationships or silently equate differently spelled feeder names.
If a feeder has no recorded topology link, the map identifies it for review and
the eForm still offers the original responsibility-register feeder. The source
registers contain some spelling differences and missing links; these require
confirmed source data to draw additional routes accurately.

Manual installation
The frontend folder contains the full corrected page and its assistance assets.
Use the installer to preserve unrelated changes and obtain automatic backups.
