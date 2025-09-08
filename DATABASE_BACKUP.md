# 🗄️ Database Backup & Recovery Guide

## 📋 Overview

Acest ghid explică cum să faci backup și să restaurezi baza de date UniMap.

## 🔒 Tipuri de Backup

### 1. **Schema Backup (Structura)**
- **Locație**: `supabase/migrations/`
- **Conținut**: Toate modificările structurii bazei de date
- **Backup automat**: Da (prin Git)
- **Restore**: Rulează migrațiile în ordine

### 2. **Data Backup (Conținut)**
- **Locație**: `backups/` (generat automat)
- **Conținut**: Toate datele din baza de date
- **Backup automat**: Nu (trebuie rulat manual)
- **Restore**: Folosește scripturile din `scripts/`

## 🚀 Cum să faci Backup

### Metoda 1: Script Automat (Recomandat)
```bash
# Backup complet
./scripts/backup_database.sh

# Backup-ul se salvează în ./backups/unimap_backup_YYYYMMDD_HHMMSS.sql
```

### Metoda 2: Supabase Dashboard
1. Mergi în **Supabase Dashboard**
2. **Settings** → **Database** → **Backups**
3. **Create backup** → Download

### Metoda 3: Supabase CLI Manual
```bash
# Backup complet
supabase db dump --file backup_$(date +%Y%m%d_%H%M%S).sql

# Backup doar schema
supabase db dump --schema-only --file schema_backup.sql

# Backup doar datele
supabase db dump --data-only --file data_backup.sql
```

## 🔄 Cum să Restaurezi

### Metoda 1: Script Automat
```bash
# Restore cel mai recent backup
./scripts/restore_database.sh

# Restore backup specific
./scripts/restore_database.sh unimap_backup_20240907_120000.sql
```

### Metoda 2: Supabase CLI Manual
```bash
# Restore complet
supabase db reset --file backup_20240907_120000.sql

# Restore doar schema
supabase db reset --schema-only --file schema_backup.sql
```

## 📁 Structura Backup-urilor

```
UniMap/
├── supabase/migrations/          ← Schema backup (Git)
│   ├── 20240907000001_complete_schema.sql
│   ├── 20240907000002_update_educational_data.sql
│   ├── 20240907000003_add_study_year_to_announcements.sql
│   └── 20240907000004_add_admin_system.sql
├── scripts/                      ← Scripturi backup/restore
│   ├── backup_database.sh
│   └── restore_database.sh
├── backups/                      ← Backup-uri automate (ignorat de Git)
│   ├── unimap_backup_20240907_120000.sql
│   └── unimap_backup_20240907_130000.sql
└── DATABASE_BACKUP.md           ← Acest fișier
```

## ⚙️ Configurare Inițială

### 1. Instalează Supabase CLI
```bash
npm install -g supabase
```

### 2. Login în Supabase
```bash
supabase login
```

### 3. Link la proiect
```bash
# Înlocuiește YOUR_PROJECT_ID cu ID-ul proiectului tău
supabase link --project-ref YOUR_PROJECT_ID
```

### 4. Configurează scriptul de backup
Editează `scripts/backup_database.sh` și înlocuiește:
```bash
PROJECT_ID="your-project-id"  # ← Înlocuiește cu ID-ul tău
```

## 🔄 Backup Automat (Opțional)

### Cron Job (Linux/Mac)
```bash
# Adaugă în crontab pentru backup zilnic la 2:00 AM
0 2 * * * cd /path/to/UniMap && ./scripts/backup_database.sh
```

### GitHub Actions (Recomandat)
Creează `.github/workflows/backup.yml`:
```yaml
name: Database Backup
on:
  schedule:
    - cron: '0 2 * * *'  # Zilnic la 2:00 AM
  workflow_dispatch:  # Manual trigger

jobs:
  backup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Supabase CLI
        run: npm install -g supabase
      - name: Backup Database
        run: ./scripts/backup_database.sh
        env:
          SUPABASE_ACCESS_TOKEN: ${{ secrets.SUPABASE_ACCESS_TOKEN }}
```

## 🚨 În Caz de Urgență

### Restore Rapid
```bash
# 1. Restore cel mai recent backup
./scripts/restore_database.sh

# 2. Verifică că totul funcționează
supabase db diff
```

### Verificare Status
```bash
# Verifică statusul bazei de date
supabase status

# Verifică diferențele față de migrații
supabase db diff
```

## 📞 Suport

Dacă ai probleme cu backup-ul:
1. Verifică că Supabase CLI este instalat
2. Verifică că ești logat în Supabase
3. Verifică că proiectul este link-at corect
4. Verifică log-urile pentru erori

## 🔐 Securitate

- **Nu commita** backup-urile în Git (sunt în `.gitignore`)
- **Păstrează** backup-urile într-un loc sigur
- **Testează** restore-ul periodic
- **Documentează** orice modificări importante
