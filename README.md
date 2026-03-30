# COAST.NET v4.0 – Behörden-Terminal für FiveM

## ⚡ Schnellstart (5 Minuten)

### 1. Resource einfügen
Diesen Ordner `coastnet` in deinen `resources/`-Ordner legen.

### 2. Server.cfg eintragen
```
ensure coastnet
```

### 3. Owner-License eintragen
Öffne `config.lua` und trage deine FiveM-License ein:
```lua
Config.OwnerLicense = "license:DEINE_LICENSE_HIER"
```
**Wo finde ich meine License?**  
→ [keymaster.fivem.net](https://keymaster.fivem.net) → dein Profil  
→ Alternativ: Im Server-Log steht beim Verbinden `license:xxxxxxxx`

### 4. Datenbank importieren
Importiere `coastnet_database.sql` in deine MySQL-Datenbank.  
(phpMyAdmin, HeidiSQL, oder CLI: `mysql -u root -p deinDB < coastnet_database.sql`)

### 5. Framework einstellen (optional)
In `config.lua`:
```lua
Config.Framework = "esx"  -- "esx" | "qbcore" | "standalone"
```

---

## 🔑 Owner-Zugang
Wenn deine FiveM-License in `config.lua` eingetragen ist:
- Beim Einloggen auf dem Server wirst du **automatisch erkannt**
- Drücke `F5` → das Tablet öffnet sich **direkt im Master-Modus** (kein Passwort nötig)
- Du hast Zugriff auf **alle** Funktionen ohne Einschränkungen

---

## 📋 Abhängigkeiten
- `mysql-async` (im `server_scripts` als `@mysql-async/lib/MySQL.lua`)
- Optional: `es_extended` (ESX) oder `qb-core` (QBCore) für Job-Sync

---

## 🎮 Befehle
| Befehl | Beschreibung |
|--------|-------------|
| `F5` | Tablet öffnen |
| `/token` | Neuen Token anzeigen |
| `/cn_token` | Token über Client anfordern |
| `/fix` | Cursor-Reset wenn Maus feststeckt |

---

## ⚙️ Konfiguration (config.lua)

### Job-Berechtigungen
Trage deine Job-Keys ein um Berechtigungen zu vergeben:
```lua
Config.JobPermissions = {
    canGiveStVO    = { "police", "sheriff" },
    canArrest      = { "police", "sheriff" },
    canManageLicenses = { "police", "immigration" },
    -- ...
}
```

### Job-Anzeigenamen
```lua
Config.JobLabels = {
    ["police"] = "LSPD",
    ["sheriff"] = "BCSO",
    -- ...
}
```

---

## 🗄️ Datenbank-Tabellen
| Tabelle | Inhalt |
|---------|--------|
| `coastnet_citizens` | Bürger-Profile |
| `coastnet_tokens` | Registrierungs-Tokens |
| `coastnet_vehicles` | Fahrzeuge |
| `coastnet_stvo` | StVO-Punkte |
| `coastnet_licenses` | Führerscheine & Lizenzen |
| `coastnet_arrests` | Verhaftungs-Historie |
| `coastnet_documents` | Dokumente |
| `coastnet_audit` | Server Audit-Log |

---

## 🚀 Neue Features in v4.0
- ✅ **Owner-License** → Automatischer Master-Zugang
- ✅ **Job-Sync** → Berechtigungen per Job aus Config
- ✅ **StVO-Punkte** → Vergabe und Verlauf pro Bürger
- ✅ **Lizenzen** → Ausstellen und Entziehen
- ✅ **Verhaftungen** → Verhaftungs-Historie pro Bürger
- ✅ **Server Audit-Log** → Alle Aktionen serverseitig geloggt
- ✅ **Dokumente-Sync** → Dokumente in DB gespeichert
- ✅ **Live-Map** → Spieler-Positionen in Echtzeit

---

## ❓ Häufige Probleme

**Tablet öffnet sich nicht:**  
→ `/fix` eingeben, dann erneut `F5`

**Kein Token erhalten:**  
→ `/token` im Chat eingeben

**MySQL-Fehler beim Start:**  
→ Sicherstellen dass `mysql-async` korrekt installiert ist  
→ `coastnet_database.sql` importieren

**Owner-Erkennung funktioniert nicht:**  
→ License in `config.lua` prüfen (Format: `license:xxxxxxxx`)  
→ Server neu starten nach Änderung

---

*COAST.NET v4.0 – by Nibi*
