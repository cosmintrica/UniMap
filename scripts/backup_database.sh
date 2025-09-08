#!/bin/bash

# =============================================
# SCRIPT BACKUP AUTOMAT SUPABASE DATABASE
# =============================================

# Configurare
PROJECT_ID="your-project-id"  # Înlocuiește cu ID-ul proiectului tău
BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/unimap_backup_$DATE.sql"

# Creează directorul de backup
mkdir -p "$BACKUP_DIR"

echo "🔄 Începe backup-ul bazei de date UniMap..."
echo "📅 Data: $(date)"
echo "📁 Fișier: $BACKUP_FILE"

# Verifică dacă Supabase CLI este instalat
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI nu este instalat!"
    echo "📦 Instalează cu: npm install -g supabase"
    exit 1
fi

# Verifică dacă utilizatorul este logat
if ! supabase projects list &> /dev/null; then
    echo "🔐 Te rog să te loghezi în Supabase:"
    supabase login
fi

# Link la proiect (dacă nu este deja link-at)
if [ ! -f ".supabase/config.toml" ]; then
    echo "🔗 Link la proiectul Supabase..."
    supabase link --project-ref "$PROJECT_ID"
fi

# Face backup-ul
echo "💾 Creez backup-ul..."
supabase db dump --file "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Backup creat cu succes!"
    echo "📁 Locație: $BACKUP_FILE"
    echo "📊 Mărime: $(du -h "$BACKUP_FILE" | cut -f1)"
    
    # Șterge backup-urile vechi (păstrează ultimele 10)
    echo "🧹 Curăț backup-urile vechi..."
    ls -t "$BACKUP_DIR"/unimap_backup_*.sql | tail -n +11 | xargs -r rm
    
    echo "🎉 Backup completat cu succes!"
else
    echo "❌ Eroare la crearea backup-ului!"
    exit 1
fi
