-- =============================================
-- MIGRAȚIE COMPLETĂ PENTRU UNIMAP
-- =============================================

-- 1. Tabele pentru ierarhia educațională
-- =============================================

-- Tabel pentru universități
CREATE TABLE universities (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    code TEXT UNIQUE NOT NULL,
    city TEXT,
    country TEXT DEFAULT 'România',
    website TEXT,
    logo_url TEXT,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabel pentru facultăți
CREATE TABLE faculties (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    university_id UUID REFERENCES universities(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    code TEXT NOT NULL,
    description TEXT,
    dean_name TEXT,
    website TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(university_id, code)
);

-- Tabel pentru specializări
CREATE TABLE specializations (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    faculty_id UUID REFERENCES faculties(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    code TEXT NOT NULL,
    duration_years INTEGER DEFAULT 3,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(faculty_id, code)
);

-- Tabel pentru mastere
CREATE TABLE masters (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    faculty_id UUID REFERENCES faculties(id) ON DELETE CASCADE,
    specialization_id UUID REFERENCES specializations(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    code TEXT NOT NULL,
    duration_years INTEGER DEFAULT 2,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(faculty_id, specialization_id, code)
);

-- 2. Tabel pentru profiluri utilizatori
-- =============================================

-- Tabel pentru profiluri utilizatori (legat de auth.users)
CREATE TABLE user_profiles (
    id UUID REFERENCES auth.users(id) PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    avatar_url TEXT,
    
    -- Informații educaționale
    university_id UUID REFERENCES universities(id),
    faculty_id UUID REFERENCES faculties(id),
    specialization_id UUID REFERENCES specializations(id),
    master_id UUID REFERENCES masters(id),
    study_year INTEGER CHECK (study_year BETWEEN 1 AND 6),
    
    -- Informații personale
    phone TEXT,
    birth_date DATE,
    bio TEXT,
    
    -- Preferințe
    preferred_language TEXT DEFAULT 'ro',
    notifications_enabled BOOLEAN DEFAULT true,
    
    -- Metadate
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Tabele pentru hărți și conținut
-- =============================================

-- Tabel pentru clădiri
CREATE TABLE buildings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    university_id UUID REFERENCES universities(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    address TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    floor_count INTEGER DEFAULT 1,
    image_url TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabel pentru camere
CREATE TABLE rooms (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    building_id UUID REFERENCES buildings(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    room_number TEXT,
    floor INTEGER,
    room_type TEXT, -- 'classroom', 'office', 'lab', 'library', etc.
    capacity INTEGER,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabel pentru fișiere de hartă
CREATE TABLE map_files (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    university_id UUID REFERENCES universities(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    file_path TEXT NOT NULL,
    file_type TEXT NOT NULL, -- 'json', 'image', 'pdf', etc.
    file_size BIGINT,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabel pentru noduri de hartă
CREATE TABLE map_nodes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    map_file_id UUID REFERENCES map_files(id) ON DELETE CASCADE,
    node_id TEXT NOT NULL,
    x DOUBLE PRECISION,
    y DOUBLE PRECISION,
    node_type TEXT, -- 'room', 'building', 'entrance', etc.
    room_id UUID REFERENCES rooms(id),
    building_id UUID REFERENCES buildings(id),
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabel pentru muchii de hartă
CREATE TABLE map_edges (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    map_file_id UUID REFERENCES map_files(id) ON DELETE CASCADE,
    from_node_id TEXT NOT NULL,
    to_node_id TEXT NOT NULL,
    weight DOUBLE PRECISION DEFAULT 1.0,
    edge_type TEXT, -- 'corridor', 'stairs', 'elevator', etc.
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Tabel pentru anunțuri
-- =============================================

CREATE TABLE announcements (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    priority TEXT DEFAULT 'medium', -- 'low', 'medium', 'high', 'urgent'
    target_university_id UUID REFERENCES universities(id),
    target_faculty_id UUID REFERENCES faculties(id),
    target_specialization_id UUID REFERENCES specializations(id),
    is_active BOOLEAN DEFAULT true,
    published_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. Indexuri pentru performanță
-- =============================================

CREATE INDEX idx_faculties_university_id ON faculties(university_id);
CREATE INDEX idx_specializations_faculty_id ON specializations(faculty_id);
CREATE INDEX idx_masters_faculty_id ON masters(faculty_id);
CREATE INDEX idx_masters_specialization_id ON masters(specialization_id);
CREATE INDEX idx_user_profiles_university_id ON user_profiles(university_id);
CREATE INDEX idx_user_profiles_faculty_id ON user_profiles(faculty_id);
CREATE INDEX idx_user_profiles_specialization_id ON user_profiles(specialization_id);
CREATE INDEX idx_user_profiles_master_id ON user_profiles(master_id);
CREATE INDEX idx_buildings_university_id ON buildings(university_id);
CREATE INDEX idx_rooms_building_id ON rooms(building_id);
CREATE INDEX idx_map_files_university_id ON map_files(university_id);
CREATE INDEX idx_map_nodes_map_file_id ON map_nodes(map_file_id);
CREATE INDEX idx_map_edges_map_file_id ON map_edges(map_file_id);
CREATE INDEX idx_announcements_target_university_id ON announcements(target_university_id);
CREATE INDEX idx_announcements_published_at ON announcements(published_at);

-- 6. Date de test
-- =============================================

-- Inserare universități
INSERT INTO universities (name, code, city, website, description) VALUES
('Universitatea din București', 'UB', 'București', 'https://unibuc.ro', 'Cea mai veche universitate din România'),
('Universitatea Politehnica București', 'UPB', 'București', 'https://upb.ro', 'Universitatea tehnică de prestigiu'),
('Universitatea Babeș-Bolyai', 'UBB', 'Cluj-Napoca', 'https://ubbcluj.ro', 'Universitatea din Cluj-Napoca');

-- Inserare facultăți
INSERT INTO faculties (university_id, name, code, description) VALUES
((SELECT id FROM universities WHERE name = 'Universitatea din București'), 'Facultatea de Matematică și Informatică', 'FMI', 'Facultatea de Matematică și Informatică'),
((SELECT id FROM universities WHERE name = 'Universitatea din București'), 'Facultatea de Fizică', 'FEFS', 'Facultatea de Fizică'),
((SELECT id FROM universities WHERE name = 'Universitatea Politehnica București'), 'Facultatea de Automatică și Calculatoare', 'AC', 'Facultatea de Automatică și Calculatoare'),
((SELECT id FROM universities WHERE name = 'Universitatea Babeș-Bolyai'), 'Facultatea de Matematică și Informatică', 'FMI', 'Facultatea de Matematică și Informatică');

-- Inserare specializări
INSERT INTO specializations (faculty_id, name, code, duration_years) VALUES
((SELECT id FROM faculties WHERE code = 'FMI' AND university_id = (SELECT id FROM universities WHERE name = 'Universitatea din București')), 'Informatică', 'INFO', 3),
((SELECT id FROM faculties WHERE code = 'FMI' AND university_id = (SELECT id FROM universities WHERE name = 'Universitatea din București')), 'Matematică', 'MATE', 3),
((SELECT id FROM faculties WHERE code = 'AC' AND university_id = (SELECT id FROM universities WHERE name = 'Universitatea Politehnica București')), 'Ingineria Sistemelor', 'IS', 4),
((SELECT id FROM faculties WHERE code = 'FMI' AND university_id = (SELECT id FROM universities WHERE name = 'Universitatea Babeș-Bolyai')), 'Informatică', 'INFO', 3);

-- Inserare mastere
INSERT INTO masters (faculty_id, specialization_id, name, code, duration_years) VALUES
((SELECT id FROM faculties WHERE code = 'FMI' AND university_id = (SELECT id FROM universities WHERE name = 'Universitatea din București')), 
 (SELECT id FROM specializations WHERE code = 'INFO' AND faculty_id = (SELECT id FROM faculties WHERE code = 'FMI' AND university_id = (SELECT id FROM universities WHERE name = 'Universitatea din București'))), 
 'Intelligence Artificială', 'IA', 2),
((SELECT id FROM faculties WHERE code = 'FMI' AND university_id = (SELECT id FROM universities WHERE name = 'Universitatea din București')), 
 (SELECT id FROM specializations WHERE code = 'INFO' AND faculty_id = (SELECT id FROM faculties WHERE code = 'FMI' AND university_id = (SELECT id FROM universities WHERE name = 'Universitatea din București'))), 
 'Securitate Cibernetică', 'SEC', 2);

-- Inserare anunțuri de test (după ce toate tabelele sunt create)
INSERT INTO announcements (title, content, priority, target_university_id) VALUES
('Bine ai venit la UniMap!', 'Aplicația UniMap îți oferă hărți interactive ale campusului universitar, anunțuri importante și multe altele.', 'high', 
 (SELECT id FROM universities WHERE name = 'Universitatea din București')),
('Începutul anului universitar', 'Anul universitar 2024-2025 începe pe 1 octombrie. Verifică orarul pentru prima săptămână.', 'medium', 
 (SELECT id FROM universities WHERE name = 'Universitatea din București'));

-- Anunț pentru facultate (după ce facultatea este creată)
INSERT INTO announcements (title, content, priority, target_faculty_id) VALUES
('Workshop de programare', 'Workshop gratuit de programare Python pentru studenții de la FMI. Înscrieri până pe 15 octombrie.', 'medium', 
 (SELECT id FROM faculties WHERE university_id = (SELECT id FROM universities WHERE name = 'Universitatea din București') AND code = 'FMI'));
