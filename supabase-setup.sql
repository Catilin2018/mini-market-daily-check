-- Orient Mini Market Daily Check — Supabase setup
-- Run this once in your Supabase project's SQL Editor.

-- 1. Table: one row per calendar date, holding both checklists as JSON.
CREATE TABLE IF NOT EXISTS daily_reports (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  report_date DATE NOT NULL UNIQUE,
  data JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Row Level Security.
--    The app has no login, so staff use the public anon key. These policies
--    allow read/write on daily_reports for anon and signed-in users.
--    Anyone with the website URL can edit records — treat the URL as the key.
ALTER TABLE daily_reports ENABLE ROW LEVEL SECURITY;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.daily_reports TO anon, authenticated;

DROP POLICY IF EXISTS daily_reports_all ON daily_reports;
CREATE POLICY daily_reports_all ON daily_reports
  FOR ALL TO anon, authenticated
  USING (true) WITH CHECK (true);
