/*
# Monstruido - Create database tables

## Overview
This migration creates the database tables for "Monstruido", an educational web app where a monster
character reacts to classroom noise. Teachers create trivia sets and customize a monster personality.
The app is single-tenant (no login screen) — any visitor can read/write all data.

## New Tables

### `trivia_sets`
Stores trivia quiz collections created by the teacher.
- `id` (uuid, primary key)
- `name` (text, not null) — name of the trivia set
- `created_at` (timestamptz)

### `trivia_questions`
Stores individual questions within a trivia set.
- `id` (uuid, primary key)
- `trivia_set_id` (uuid, foreign key to trivia_sets, ON DELETE CASCADE)
- `question_text` (text, not null) — the question prompt
- `image_url` (text) — optional image attached to the question
- `created_at` (timestamptz)

### `trivia_answers`
Stores possible answers for each question. Multiple answers per question are supported (3+).
- `id` (uuid, primary key)
- `question_id` (uuid, foreign key to trivia_questions, ON DELETE CASCADE)
- `answer_text` (text, not null) — the answer text
- `image_url` (text) — optional image attached to the answer
- `is_correct` (boolean, default false) — marks the correct answer
- `created_at` (timestamptz)

### `monster_personalities`
Stores the teacher's customization of the monster personality and motivational phrases.
- `id` (uuid, primary key)
- `name` (text, not null) — monster's name
- `description` (text) — free-form personality description
- `favorite_food` (text) — monster's favorite food
- `hobby` (text) — monster's hobby
- `color` (text) — monster's color
- `superpower` (text) — monster's superpower
- `motivational_phrases_correct` (jsonb) — array of phrases shown on correct answers
- `motivational_phrases_wrong` (jsonb) — array of phrases shown on wrong answers
- `created_at` (timestamptz)

## Security
- RLS enabled on all tables.
- All tables grant CRUD to `anon` + `authenticated` (single-tenant, no login screen).
- All policies use `USING (true)` / `WITH CHECK (true)` because data is intentionally shared across all users of the app.
*/

CREATE TABLE IF NOT EXISTS trivia_sets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE trivia_sets ENABLE ROW LEVEL SECURITY;
GRANT SELECT, INSERT, UPDATE, DELETE ON trivia_sets TO anon, authenticated;
DROP POLICY IF EXISTS "anon_select_trivia_sets" ON trivia_sets;
CREATE POLICY "anon_select_trivia_sets" ON trivia_sets FOR SELECT
  TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "anon_insert_trivia_sets" ON trivia_sets;
CREATE POLICY "anon_insert_trivia_sets" ON trivia_sets FOR INSERT
  TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "anon_update_trivia_sets" ON trivia_sets;
CREATE POLICY "anon_update_trivia_sets" ON trivia_sets FOR UPDATE
  TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "anon_delete_trivia_sets" ON trivia_sets;
CREATE POLICY "anon_delete_trivia_sets" ON trivia_sets FOR DELETE
  TO anon, authenticated USING (true);

CREATE TABLE IF NOT EXISTS trivia_questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trivia_set_id uuid NOT NULL REFERENCES trivia_sets(id) ON DELETE CASCADE,
  question_text text NOT NULL,
  image_url text,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE trivia_questions ENABLE ROW LEVEL SECURITY;
GRANT SELECT, INSERT, UPDATE, DELETE ON trivia_questions TO anon, authenticated;
DROP POLICY IF EXISTS "anon_select_trivia_questions" ON trivia_questions;
CREATE POLICY "anon_select_trivia_questions" ON trivia_questions FOR SELECT
  TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "anon_insert_trivia_questions" ON trivia_questions;
CREATE POLICY "anon_insert_trivia_questions" ON trivia_questions FOR INSERT
  TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "anon_update_trivia_questions" ON trivia_questions;
CREATE POLICY "anon_update_trivia_questions" ON trivia_questions FOR UPDATE
  TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "anon_delete_trivia_questions" ON trivia_questions;
CREATE POLICY "anon_delete_trivia_questions" ON trivia_questions FOR DELETE
  TO anon, authenticated USING (true);

CREATE TABLE IF NOT EXISTS trivia_answers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id uuid NOT NULL REFERENCES trivia_questions(id) ON DELETE CASCADE,
  answer_text text NOT NULL,
  image_url text,
  is_correct boolean NOT NULL DEFAULT false,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE trivia_answers ENABLE ROW LEVEL SECURITY;
GRANT SELECT, INSERT, UPDATE, DELETE ON trivia_answers TO anon, authenticated;
DROP POLICY IF EXISTS "anon_select_trivia_answers" ON trivia_answers;
CREATE POLICY "anon_select_trivia_answers" ON trivia_answers FOR SELECT
  TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "anon_insert_trivia_answers" ON trivia_answers;
CREATE POLICY "anon_insert_trivia_answers" ON trivia_answers FOR INSERT
  TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "anon_update_trivia_answers" ON trivia_answers;
CREATE POLICY "anon_update_trivia_answers" ON trivia_answers FOR UPDATE
  TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "anon_delete_trivia_answers" ON trivia_answers;
CREATE POLICY "anon_delete_trivia_answers" ON trivia_answers FOR DELETE
  TO anon, authenticated USING (true);

CREATE TABLE IF NOT EXISTS monster_personalities (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  favorite_food text,
  hobby text,
  color text,
  superpower text,
  motivational_phrases_correct jsonb DEFAULT '[]'::jsonb,
  motivational_phrases_wrong jsonb DEFAULT '[]'::jsonb,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE monster_personalities ENABLE ROW LEVEL SECURITY;
GRANT SELECT, INSERT, UPDATE, DELETE ON monster_personalities TO anon, authenticated;
DROP POLICY IF EXISTS "anon_select_monster_personalities" ON monster_personalities;
CREATE POLICY "anon_select_monster_personalities" ON monster_personalities FOR SELECT
  TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "anon_insert_monster_personalities" ON monster_personalities;
CREATE POLICY "anon_insert_monster_personalities" ON monster_personalities FOR INSERT
  TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "anon_update_monster_personalities" ON monster_personalities;
CREATE POLICY "anon_update_monster_personalities" ON monster_personalities FOR UPDATE
  TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "anon_delete_monster_personalities" ON monster_personalities;
CREATE POLICY "anon_delete_monster_personalities" ON monster_personalities FOR DELETE
  TO anon, authenticated USING (true);
