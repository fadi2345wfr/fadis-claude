# Quick Start - Claude Code Autonom

Die einfachste Installation mit nur 3 Befehlen!

## Download & Installation

### Schritt 1: Download tar.gz
```bash
# Falls du die tar.gz Datei hast, kopiere sie in dein Home-Verzeichnis
# Zum Beispiel: fadis-claude-autonomous.tar.gz
```

### Schritt 2: Extrahieren
```bash
cd ~
tar -xzf fadis-claude-autonomous.tar.gz
cd fadis-claude
```

### Schritt 3: Installieren
```bash
./install.sh
```

Das war's! Das Skript macht automatisch:
- ✓ Prüft Node.js/npm Installation
- ✓ Installiert Claude Code (falls nicht vorhanden)
- ✓ Kopiert alle Plugins
- ✓ Konfiguriert settings.json
- ✓ Aktiviert autonomen Modus

## Starten

```bash
cd ~/dein-projekt
claude
```

Claude arbeitet jetzt **ohne Nachfragen** und trifft intelligente Entscheidungen!

## Verfügbare Befehle

| Befehl | Beschreibung |
|--------|--------------|
| `/commit` | Automatischer Commit mit Message |
| `/commit-push-pr` | Commit, Push und PR in einem |
| `/feature-dev` | Autonome Feature-Entwicklung |
| `/code-review` | Automatisiertes Code Review |
| `/new-sdk-app` | Agent SDK App erstellen |
| `/clean_gone` | Stale Branches aufräumen |

## Was ist anders?

Im Vergleich zu Standard Claude Code:

- **Keine Nachfragen** - Claude trifft Entscheidungen selbst
- **Smart Defaults** - Verwendet sinnvolle Standardwerte
- **Autonome Ausführung** - Implementiert Features durchgängig
- **Educational Insights** - Erklärt trotzdem, was er macht

## Beispiel-Workflow

```bash
# Feature entwickeln
cd ~/mein-projekt
claude

> Implementiere ein Login-Feature mit JWT Authentication
# Claude analysiert Code, trifft Architektur-Entscheidungen und implementiert alles

> Führe die Tests aus und behebe alle Fehler
# Claude führt Tests aus, findet Fehler und behebt sie automatisch

> Erstelle einen Commit und pushe die Änderungen
# Claude committed und pusht alles
```

## Fehlerbehebung

### Node.js nicht gefunden
```bash
# Fedora/RHEL:
sudo dnf install nodejs npm

# Oder mit nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install 18
```

### Permissions-Fehler
```bash
chmod +x ~/fadis-claude/install.sh
./install.sh
```

### Claude fragt immer noch nach
```bash
# Prüfe ob Hook geladen wird:
cat ~/.claude/settings.json | grep SessionStart

# Hook sollte vorhanden sein und auf:
# ~/.claude/plugins/explanatory-output-style/hooks-handlers/session-start.sh
# zeigen
```

## Mehr Informationen

- `INSTALLATION.md` - Detaillierte Installations-Anleitung
- `AUTONOMOUS_MODE.md` - Was wurde geändert und warum
- `README.md` - Allgemeine Plugin-Dokumentation

## Support

Bei Problemen:
1. Prüfe `~/.claude/settings.json`
2. Teste Hook manuell: `bash ~/.claude/plugins/explanatory-output-style/hooks-handlers/session-start.sh`
3. Checke Logs und Fehler
4. Öffne ein Issue auf GitHub

---

**Viel Spaß mit autonomem Claude Code!**
