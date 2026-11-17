# Orient Mini Market — Daily Check

A bilingual (English / 中文) daily checklist web app for a small market.
Staff tick off tasks and zone inspections; managers and staff all see the
same shared record. Data lives in Supabase, one row per calendar day.

Live site: https://catilin2018.github.io/mini-market-daily-check/
Source: https://github.com/Catilin2018/mini-market-daily-check

## Files

| File | Purpose |
| --- | --- |
| `index.html` | The entire app — HTML, CSS, and JavaScript in one file (~700 lines) |
| `config.js` | Your Supabase project URL and anon key (the only thing you must fill in) |
| `supabase-setup.sql` | Run once in Supabase SQL Editor to create the table and access policy |
| `.gitignore` | Keeps staff data and migration secrets out of the public repo |

## How the code is organised (read `index.html` in this order)

1. **Lines 1–252 — Layout & styles.** The page structure (header, tabs, cards,
   dialogs) and all CSS. CSS variables at the top define the colour theme.
2. **Lines 253–289 — Content from the Word document.** `DUTIES` is the 11-row
   work-time schedule; `ZONES` is the 19 shelf/fridge/freezer codes. To edit
   task wording, change the text here.
3. **Lines 291–302 — Supabase client.** Creates the database client using the
   values from `config.js`.
4. **Lines 304–328 — State & helpers.** The in-memory `state` object, empty-day
   template, save-status indicator, toast messages, and small utilities.
5. **Lines 329–395 — Load & save.** `loadDate()` fetches one day from Supabase;
   `markDirty()` records a changed field and starts a 700 ms debounce timer;
   `flush()` re-reads the latest row, merges only the changed fields (so two
   people editing at once do not overwrite each other), then inserts or updates.
6. **Lines 396–520 — Rendering.** Three views: entry form, read-only overview,
   and history list.
7. **Lines 521–586 — Events.** One delegated click handler and one input handler
   cover the whole page; the name picker uses browser `localStorage`.
8. **Lines 587–693 — Excel export.** `buildExcel()` builds a four-sheet workbook
   with SheetJS: Summary, Work Time, Shelf Check, Activity.

## Key ideas worth learning

- **Single-file app.** No build step, no framework — open `index.html` and it runs.
- **Debounced autosave.** Edits wait 700 ms, then batch-write; the dot in the
  header shows saved / saving / error.
- **Field-level merge.** Before saving, the app re-fetches the row and copies
  only the fields this user touched, so concurrent staff do not clobber each other.
- **No login.** Access is controlled by the URL and by Supabase Row Level
  Security. Anyone with the link can read and write — keep the link internal.

## Setup from scratch

1. Create a free project at https://supabase.com.
2. Open **SQL Editor**, paste all of `supabase-setup.sql`, and run it.
3. Open **Project Settings → API**. Copy the **Project URL** and the
   **anon public** key into `config.js`.
4. Commit and push `config.js`. GitHub Pages rebuilds in ~1 minute.
5. (Optional) To bring across old records, fill in the two values at the top of
   `migrate-data.mjs` using the **service_role** key, then run
   `node migrate-data.mjs`. That file is gitignored on purpose.

## Security note

The anon key is meant to be public in browser apps; the RLS policy in
`supabase-setup.sql` is what controls access. Because the app has no login,
that policy allows anyone with the site URL to read and write. Share the URL
only with store staff. For stricter control later, add a PIN or accounts and
tighten the RLS policy.
