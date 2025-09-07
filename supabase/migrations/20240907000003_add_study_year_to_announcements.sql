-- =============================================
-- ADĂUGARE COLOANĂ STUDY_YEAR ÎN ANNOUNCEMENTS
-- =============================================

-- Adaugă coloana target_study_year în tabelul announcements
ALTER TABLE announcements 
ADD COLUMN target_study_year INTEGER CHECK (target_study_year BETWEEN 1 AND 6);

-- Adaugă index pentru performanță
CREATE INDEX idx_announcements_target_study_year ON announcements(target_study_year);

-- Actualizează anunțurile existente cu anul de studiu țintă
UPDATE announcements 
SET target_study_year = 1 
WHERE target_study_year IS NULL;
