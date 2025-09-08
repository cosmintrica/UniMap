#!/bin/bash

# =============================================
# SCRIPT RESTORE SUPABASE DATABASE
# =============================================

# Configurare
BACKUP_DIR="./backups"

echo "🔄 Restore baza de date UniMap..."
echo "📁 Director backup: $BACKUP_DIR"

# Verifică dacă directorul de backup există
if [ ! -d "$BACKUP_DIR" ]; then
    echo "❌ Directorul de backup nu există: $BACKUP_DIR"
    exit 1
fi

# Lista backup-urile disponibile
echo "📋 Backup-uri disponibile:"
ls -la "$BACKUP_DIR"/unimap_backup_*.sql 2>/dev/null || {
    echo "❌ Nu există backup-uri în directorul $BACKUP_DIR"
    exit 1
}

# Alege backup-ul (cel mai recent sau specificat)
if [ -z "$1" ]; then
    BACKUP_FILE=$(ls -t "$BACKUP_DIR"/unimap_backup_*.sql | head -n1)
    echo "🔄 Folosesc cel mai recent backup: $(basename "$BACKUP_FILE")"
else
    BACKUP_FILE="$BACKUP_DIR/$1"
    if [ ! -f "$BACKUP_FILE" ]; then
        echo "❌ Fișierul de backup nu există: $BACKUP_FILE"
        exit 1
    fi
    echo "🔄 Folosesc backup-ul specificat: $(basename "$BACKUP_FILE")"
fi

# Confirmă restore-ul
echo "⚠️  ATENȚIE: Acest proces va șterge toate datele existente!"
echo "📁 Fișier: $BACKUP_FILE"
read -p "Ești sigur că vrei să continui? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Restore anulat."
    exit 1
fi

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

# Restore backup-ul
echo "💾 Restore backup-ul..."
supabase db reset --file "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Restore completat cu succes!"
    echo "🎉 Baza de date a fost restaurată din: $(basename "$BACKUP_FILE")"
else
    echo "❌ Eroare la restore!"
    exit 1
fi
