-- =============================================
-- ADĂUGARE SISTEM ADMIN ȘI ÎMBUNĂTĂȚIRI ANUNȚURI
-- =============================================

-- 1. Adaugă coloana is_admin în user_profiles
ALTER TABLE user_profiles 
ADD COLUMN is_admin BOOLEAN DEFAULT false;

-- 2. Adaugă index pentru performanță
CREATE INDEX idx_user_profiles_is_admin ON user_profiles(is_admin);

-- 3. Declară utilizatorul principal ca admin
UPDATE user_profiles 
SET is_admin = true 
WHERE email = 'cosmin.trica@outlook.com';

-- 4. Verifică dacă target_study_year există în announcements
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'announcements' 
        AND column_name = 'target_study_year'
    ) THEN
        ALTER TABLE announcements 
        ADD COLUMN target_study_year INTEGER CHECK (target_study_year BETWEEN 1 AND 6);
        
        CREATE INDEX idx_announcements_target_study_year ON announcements(target_study_year);
    END IF;
END $$;

-- 5. Adaugă comentarii pentru claritate
COMMENT ON COLUMN user_profiles.is_admin IS 'Indică dacă utilizatorul are drepturi de administrator';
COMMENT ON COLUMN announcements.target_study_year IS 'Anul de studiu țintă pentru anunț (1-6). NULL = pentru toți studenții';

-- 6. Verifică rezultatul
SELECT 
    'Migration completed successfully' as status,
    COUNT(*) as total_users,
    COUNT(CASE WHEN is_admin = true THEN 1 END) as admin_users
FROM user_profiles;
