# 🚀 Ghid de Dezvoltare UniMap

## Configurare Inițială

### 1. Instalare Dependințe
```bash
# Supabase CLI (deja instalat)
supabase --version

# Xcode (pentru dezvoltare iOS)
# Instalează din App Store
```

### 2. Configurare Supabase

#### Opțiunea A: Supabase Local (Recomandat pentru dezvoltare)
```bash
# Pornește Supabase local
./supabase-commands.sh start

# Aplică migrările
./supabase-commands.sh migrate

# Deschide Supabase Studio
./supabase-commands.sh studio
```

#### Opțiunea B: Supabase Cloud
```bash
# Autentificare
./supabase-commands.sh login

# Link la proiectul tău
./supabase-commands.sh link

# Deploy migrările
./supabase-commands.sh deploy
```

### 3. Configurare Aplicație iOS

1. Deschide `UniMap.xcodeproj` în Xcode
2. Editează `UniMap/Resources/supabase-config.plist`:
   ```xml
   <key>SupabaseURL</key>
   <string>https://your-project.supabase.co</string>
   <key>SupabaseAnonKey</key>
   <string>your-anon-key</string>
   ```

## Comenzi Utile

### Supabase CLI
```bash
# Status
supabase status

# Pornește local
supabase start

# Oprește local
supabase stop

# Resetează baza de date
supabase db reset

# Aplică migrările
supabase db push

# Deschide Studio
supabase studio
```

### Script Personalizat
```bash
# Folosește scriptul nostru pentru comenzi rapide
./supabase-commands.sh help
./supabase-commands.sh start
./supabase-commands.sh studio
```

## Structura Proiectului

```
UniMap/
├── UniMap.xcodeproj/          # Proiect Xcode
├── UniMap/                    # Codul aplicației
│   ├── App/                   # Entry point
│   ├── Features/              # Funcționalități
│   │   ├── Auth/              # Autentificare
│   │   ├── Announcements/     # Anunțuri
│   │   ├── Map/               # Hărți
│   │   └── Admin/             # Admin panel
│   ├── Shared/                # Cod partajat
│   │   └── Utils/
│   │       └── Supabase/      # Integrarea Supabase
│   └── Resources/             # Configurare
├── supabase/                  # Configurare Supabase
│   ├── migrations/            # Migrări baza de date
│   ├── functions/             # Edge Functions
│   └── config.toml           # Configurare Supabase
└── supabase-commands.sh       # Script utilitar
```

## Dezvoltare

### 1. Pornește Mediul de Dezvoltare
```bash
# Terminal 1: Supabase local
./supabase-commands.sh start

# Terminal 2: Xcode
open UniMap.xcodeproj
```

### 2. Testează Funcționalitățile
- **Autentificare**: Înregistrare și login
- **Anunțuri**: Afișare anunțuri din baza de date
- **Profil**: Gestionare profil utilizator

### 3. Adaugă Funcționalități Noi

#### Pentru hărți interactive:
1. Adaugă date în tabelele `buildings`, `rooms`, `map_nodes`, `map_edges`
2. Folosește `SupabaseManager.shared.client.database.from("table_name")`

#### Pentru notificări push:
1. Configurează Edge Functions în `supabase/functions/`
2. Folosește `supabase functions deploy`

## Debugging

### Logs Supabase
```bash
# Vezi logs pentru funcții
supabase functions logs

# Vezi logs pentru baza de date
supabase db logs
```

### Xcode
- Folosește Console pentru debug
- Verifică `ProfileStore.shared.errorMessage` pentru erori auth
- Verifică network requests în Network tab

## Deploy

### 1. Testează Local
```bash
./supabase-commands.sh reset
./supabase-commands.sh migrate
# Testează toate funcționalitățile
```

### 2. Deploy la Supabase Cloud
```bash
./supabase-commands.sh login
./supabase-commands.sh link
./supabase-commands.sh deploy
```

### 3. Deploy Aplicație iOS
- Archive în Xcode
- Upload la App Store Connect

## Resurse Utile

- [Documentația Supabase](https://supabase.com/docs)
- [Supabase Swift SDK](https://github.com/supabase/supabase-swift)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Supabase Studio](http://localhost:54323) (când rulează local)
