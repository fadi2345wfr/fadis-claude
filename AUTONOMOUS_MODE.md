# Autonomer Modus für Claude Code

Diese Dokumentation beschreibt, wie Sie Claude Code so konfigurieren, dass er vollständig autonom arbeitet, ohne ständig nach Bestätigungen zu fragen.

## Überblick der Änderungen

Dieses Repository wurde so modifiziert, dass Claude Code:
- **Keine Nachfragen** mehr stellt (z.B. "Soll ich weitermachen?", "Soll ich den Build starten?")
- **Autonome Entscheidungen** trifft basierend auf existierenden Code-Patterns und Best Practices
- **Direkt implementiert** ohne auf Benutzerbestätigung zu warten

## Geänderte Plugins

### 1. Feature Development Plugin (`plugins/feature-dev/`)
- **Vorher**: Fragte in jeder Phase nach Bestätigung
- **Jetzt**: Trifft intelligente Entscheidungen und implementiert autonom
- Alle "Ask user", "Wait for confirmation", "Do not proceed without approval" wurden entfernt

### 2. Agent SDK Development Plugin (`plugins/agent-sdk-dev/`)
- **Vorher**: Fragte Schritt für Schritt nach Sprache, Projektname, etc.
- **Jetzt**: Verwendet sinnvolle Defaults (TypeScript, npm) und leitet automatisch aus dem Kontext ab

### 3. Learning/Explanatory Output Style Plugins
- **Vorher**: `learning-output-style` fragte nach Code-Beiträgen vom Benutzer
- **Jetzt**: Implementiert alles autonom, gibt aber weiterhin Educational Insights
- Beide Plugins arbeiten im "Autonomous Execution Mode"

### 4. Code Review Plugin (`plugins/code-review/`)
- **Vorher**: Stoppte bei geschlossenen PRs oder wenn keine Issues gefunden wurden
- **Jetzt**: Führt Review immer durch und dokumentiert Ergebnisse

## Automatisches Passwort-Handling

Für Programme, die Passwörter benötigen, gibt es mehrere Lösungen:

### Option 1: Passwort aus Umgebungsvariable
```bash
# In .bashrc oder .profile
export MY_APP_PASSWORD="your-password-here"

# Im Skript
password="$MY_APP_PASSWORD"
```

### Option 2: Passwort aus Datei mit `-s` Option
```bash
# Passwort in Datei speichern (sichere Permissions setzen!)
echo "your-password" > ~/.my-app-password
chmod 600 ~/.my-app-password

# Passwort einlesen ohne Terminal-Interaktion
password=$(cat ~/.my-app-password)

# Oder mit -s Option (je nach Tool)
my-tool -s < ~/.my-app-password
```

### Option 3: Password Manager Integration
```bash
# Beispiel mit pass (Unix Password Manager)
password=$(pass show my-app/password)

# Beispiel mit 1Password CLI
password=$(op read "op://vault/item/password")
```

### Option 4: SSH Agent für Git
```bash
# SSH Key ohne Passwort-Prompt verwenden
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# Oder SSH Key ohne Passphrase erstellen
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_rsa_no_pass
```

## Konfiguration für Claude Code

Um sicherzustellen, dass Claude Code nie nach Eingaben fragt, können Sie folgende Einstellungen verwenden:

### `.claude/settings.json`
```json
{
  "hooks": {
    "SessionStart": {
      "enabled": true,
      "handlers": [
        "plugins/explanatory-output-style/hooks-handlers/session-start.sh"
      ]
    }
  },
  "plugins": {
    "enabled": [
      "feature-dev",
      "agent-sdk-dev",
      "commit-commands",
      "code-review"
    ]
  }
}
```

### Custom Session-Start Hook
Die Session-Start-Hooks in diesem Repository wurden so angepasst, dass sie folgende Direktive enthalten:

```
DO NOT ask the user for:
- Implementation choices
- Design decisions
- Code contributions
- Confirmations to proceed
- Whether to run builds or tests

Just make the best decision and move forward.
```

## Verwendung

Nach diesen Änderungen können Sie Claude Code einfach starten und Aufgaben geben, ohne dass er stoppt und fragt:

```bash
claude
> Implementiere ein neues Feature XYZ
# Claude implementiert direkt ohne Nachfragen

> Führe die Tests aus und behebe alle Fehler
# Claude führt Tests aus und behebt Fehler autonom

> Erstelle einen Commit und pushe die Änderungen
# Claude macht alles automatisch
```

## Abbruch bei Bedarf

Wie Sie richtig erkannt haben: Wenn etwas schiefgeht, können Sie jederzeit:
- "Prozess beenden" schreiben
- Ctrl+C drücken
- Einen neuen Befehl geben

Claude stoppt dann und wartet auf neue Anweisungen.

## Vorteile

✅ **Schnellerer Workflow**: Keine Zeit mehr mit Bestätigungen verschwendet
✅ **Intelligente Entscheidungen**: Claude nutzt Code-Patterns aus dem Repository
✅ **Volle Kontrolle**: Sie können jederzeit eingreifen und korrigieren
✅ **Educational Insights**: Sie lernen trotzdem durch die Erklärungen

## Hinweis

Diese Konfiguration ist ideal für:
- Erfahrene Entwickler, die Claude vertrauen
- Projekte mit klaren Code-Konventionen
- Iterative Entwicklung mit schnellem Feedback

Für kritische Produktions-Code oder unsichere Szenarien können Sie natürlich jederzeit zu den Standard-Plugins zurückkehren.
