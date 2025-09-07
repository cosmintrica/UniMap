# Configurare Supabase pentru UniMap

## 1. Creează un proiect Supabase

1. Mergi la [supabase.com](https://supabase.com)
2. Creează un cont și un proiect nou
3. Notează URL-ul proiectului și cheia anonimă (anon key)

## 2. Configurează baza de date

Rulează următoarele comenzi SQL în SQL Editor din Supabase:

```sql
-- Tabel pentru utilizatori
CREATE TABLE user_profiles (
    id UUID REFERENCES auth.users(id) PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    avatar_url TEXT,
    university TEXT,
    student_id TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabel pentru anunțuri
CREATE TABLE announcements (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    image_url TEXT,
    priority TEXT CHECK (priority IN ('low', 'medium', 'high', 'urgent')) DEFAULT 'medium',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE
);

-- Tabel pentru clădiri
CREATE TABLE buildings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
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
    floor INTEGER NOT NULL,
    room_type TEXT CHECK (room_type IN ('classroom', 'laboratory', 'office', 'library', 'cafeteria', 'bathroom', 'other')) DEFAULT 'classroom',
    capacity INTEGER,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabel pentru noduri pe hartă
CREATE TABLE map_nodes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    building_id UUID REFERENCES buildings(id) ON DELETE CASCADE,
    room_id UUID REFERENCES rooms(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    x DOUBLE PRECISION NOT NULL,
    y DOUBLE PRECISION NOT NULL,
    floor INTEGER NOT NULL,
    node_type TEXT CHECK (node_type IN ('room', 'corridor', 'stairs', 'elevator', 'entrance', 'exit', 'other')) DEFAULT 'room',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabel pentru muchii pe hartă
CREATE TABLE map_edges (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    from_node_id UUID REFERENCES map_nodes(id) ON DELETE CASCADE,
    to_node_id UUID REFERENCES map_nodes(id) ON DELETE CASCADE,
    weight DOUBLE PRECISION DEFAULT 1.0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS (Row Level Security) policies
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE announcements ENABLE ROW LEVEL SECURITY;
ALTER TABLE buildings ENABLE ROW LEVEL SECURITY;
ALTER TABLE rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE map_nodes ENABLE ROW LEVEL SECURITY;
ALTER TABLE map_edges ENABLE ROW LEVEL SECURITY;

-- Policy pentru user_profiles - utilizatorii pot vedea și edita doar propriul profil
CREATE POLICY "Users can view own profile" ON user_profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON user_profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON user_profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- Policy pentru announcements - toți utilizatorii autentificați pot citi anunțurile
CREATE POLICY "Authenticated users can read announcements" ON announcements FOR SELECT USING (auth.role() = 'authenticated');

-- Policy pentru buildings - toți utilizatorii autentificați pot citi clădirile
CREATE POLICY "Authenticated users can read buildings" ON buildings FOR SELECT USING (auth.role() = 'authenticated');

-- Policy pentru rooms - toți utilizatorii autentificați pot citi camerele
CREATE POLICY "Authenticated users can read rooms" ON rooms FOR SELECT USING (auth.role() = 'authenticated');

-- Policy pentru map_nodes - toți utilizatorii autentificați pot citi nodurile
CREATE POLICY "Authenticated users can read map_nodes" ON map_nodes FOR SELECT USING (auth.role() = 'authenticated');

-- Policy pentru map_edges - toți utilizatorii autentificați pot citi muchiile
CREATE POLICY "Authenticated users can read map_edges" ON map_edges FOR SELECT USING (auth.role() = 'authenticated');

-- Inserare date de test
INSERT INTO announcements (title, content, priority, is_active) VALUES
('Bine ai venit la UniMap!', 'Aplicația UniMap îți oferă hărți interactive ale campusului universitar, anunțuri importante și multe altele.', 'high', true),
('Programare examene', 'Perioada de programare pentru examenele din sesiunea de iarnă a început. Accesează platforma online pentru a-ți programa examenele.', 'urgent', true),
('Biblioteca extinsă', 'Biblioteca universitară își extinde programul de lucru în perioada sesiunii de examene. Programul nou: 8:00-22:00.', 'medium', true);

INSERT INTO buildings (name, description, latitude, longitude, floor_count) VALUES
('Clădirea Centrală', 'Clădirea principală a universității', 44.4268, 26.1025, 5),
('Biblioteca Centrală', 'Biblioteca principală cu sali de lectură', 44.4270, 26.1027, 3),
('Laboratorul de Informatică', 'Laboratoare pentru facultatea de informatică', 44.4265, 26.1020, 2);
```

## 3. Actualizează configurația în aplicație

1. Deschide `UniMap/Resources/supabase-config.plist`
2. Înlocuiește `https://your-project.supabase.co` cu URL-ul proiectului tău
3. Înlocuiește `your-anon-key` cu cheia anonimă din proiectul tău

## 4. Testează aplicația

1. Rulează aplicația în Xcode
2. Încearcă să te înregistrezi cu un cont nou
3. Verifică dacă anunțurile se încarcă din baza de date

## 5. Funcționalități disponibile

- **Autentificare**: Înregistrare și autentificare utilizatori
- **Anunțuri**: Afișare anunțuri din baza de date cu filtrare după prioritate
- **Profil utilizator**: Gestionare profil student cu informații despre universitate
- **Hărți interactive**: Structură pregătită pentru hărți ale campusului

## 6. Dezvoltare ulterioară

Pentru a adăuga funcționalități noi:

1. **Hărți interactive**: Folosește tabelele `buildings`, `rooms`, `map_nodes`, `map_edges`
2. **Notificări push**: Configurează Supabase Edge Functions
3. **Storage pentru imagini**: Folosește Supabase Storage pentru imagini
4. **Real-time updates**: Folosește Supabase Realtime pentru actualizări în timp real
