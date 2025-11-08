# Installation: Claude Code im autonomen Modus

Diese Anleitung zeigt, wie du Claude Code mit den autonomen Plugins aus diesem Repository installierst.

## Voraussetzungen

1. **Node.js und npm installieren** (falls nicht vorhanden):
   ```bash
   # Für Fedora/RHEL-basierte Systeme:
   sudo dnf install nodejs npm

   # Oder mit nvm (empfohlen für Node 18+):
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
   source ~/.bashrc
   nvm install 18
   ```

2. **Claude Code installieren**:
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

## Installation der autonomen Plugins

### Schritt 1: Repository klonen
```bash
git clone https://github.com/fadi2345wfr/fadis-claude.git
cd fadis-claude
```

### Schritt 2: Plugins kopieren
```bash
mkdir -p ~/.claude/plugins
cp -r plugins/* ~/.claude/plugins/
```

### Schritt 3: Marketplace erstellen
```bash
mkdir -p ~/.claude/plugins/.claude-plugin
cat > ~/.claude/plugins/.claude-plugin/marketplace.json << 'EOF'
{
  "name": "Fadis Custom Plugins",
  "marketplaceId": "fadis-local",
  "description": "Lokale Plugins aus fadis-claude Repository",
  "plugins": [
    {
      "pluginId": "commit-commands",
      "name": "Git Commit Commands",
      "description": "Git Workflow Automatisierung",
      "author": "Fadis",
      "version": "1.0.0",
      "source": {"type": "directory", "path": "commit-commands"}
    },
    {
      "pluginId": "code-review",
      "name": "Code Review",
      "description": "Automatisierte PR Code Reviews",
      "author": "Fadis",
      "version": "1.0.0",
      "source": {"type": "directory", "path": "code-review"}
    },
    {
      "pluginId": "feature-dev",
      "name": "Feature Development",
      "description": "Autonomer Feature-Entwicklungs-Workflow",
      "author": "Fadis",
      "version": "1.0.0",
      "source": {"type": "directory", "path": "feature-dev"}
    },
    {
      "pluginId": "agent-sdk-dev",
      "name": "Agent SDK Dev",
      "description": "Claude Agent SDK Entwicklung",
      "author": "Fadis",
      "version": "1.0.0",
      "source": {"type": "directory", "path": "agent-sdk-dev"}
    },
    {
      "pluginId": "pr-review-toolkit",
      "name": "PR Review Toolkit",
      "description": "Pull Request Review Tools",
      "author": "Fadis",
      "version": "1.0.0",
      "source": {"type": "directory", "path": "pr-review-toolkit"}
    },
    {
      "pluginId": "security-guidance",
      "name": "Security Guidance",
      "description": "Sicherheitsrichtlinien",
      "author": "Fadis",
      "version": "1.0.0",
      "source": {"type": "directory", "path": "security-guidance"}
    },
    {
      "pluginId": "explanatory-output-style",
      "name": "Explanatory Output Style",
      "description": "Erklärender Ausgabestil (autonom)",
      "author": "Fadis",
      "version": "1.0.0",
      "source": {"type": "directory", "path": "explanatory-output-style"}
    },
    {
      "pluginId": "learning-output-style",
      "name": "Learning Output Style",
      "description": "Lernorientierter Stil (autonom)",
      "author": "Fadis",
      "version": "1.0.0",
      "source": {"type": "directory", "path": "learning-output-style"}
    }
  ]
}
EOF
```

### Schritt 4: Settings konfigurieren
```bash
cat > ~/.claude/settings.json << 'EOF'
{
    "$schema": "https://json.schemastore.org/claude-code-settings.json",
    "extraKnownMarketplaces": {
        "fadis-local": {
            "source": {
                "source": "directory",
                "path": "$HOME/.claude/plugins"
            }
        }
    },
    "enabledPlugins": {
        "commit-commands@fadis-local": true,
        "code-review@fadis-local": true,
        "feature-dev@fadis-local": true,
        "agent-sdk-dev@fadis-local": true,
        "pr-review-toolkit@fadis-local": true,
        "security-guidance@fadis-local": true,
        "explanatory-output-style@fadis-local": true,
        "learning-output-style@fadis-local": true
    },
    "hooks": {
        "SessionStart": [
            {
                "matcher": "",
                "hooks": [
                    {
                        "type": "command",
                        "command": "$HOME/.claude/plugins/explanatory-output-style/hooks-handlers/session-start.sh"
                    }
                ]
            }
        ]
    },
    "permissions": {
        "allow": ["Skill", "Bash", "Read", "Write", "Edit", "Glob", "Grep", "Task"],
        "defaultMode": "acceptEdits"
    }
}
EOF
```

**WICHTIG**: Ersetze `$HOME` mit deinem tatsächlichen Home-Verzeichnis, z.B.:
```bash
sed -i "s|\$HOME|$HOME|g" ~/.claude/settings.json
```

## Verwendung

Nach der Installation kannst du Claude Code einfach starten:

```bash
cd ~/dein-projekt
claude
```

Claude arbeitet jetzt im **autonomen Modus** ohne Nachfragen!

### Verfügbare Befehle

- `/commit` - Erstellt automatisch einen Commit
- `/commit-push-pr` - Commit, Push und PR in einem Schritt
- `/feature-dev` - Autonome Feature-Entwicklung
- `/code-review` - Automatisiertes Code Review
- `/new-sdk-app` - Agent SDK App erstellen

## Was ist anders?

Im Vergleich zu Standard-Claude Code:

- **Keine Nachfragen**: Claude trifft intelligente Entscheidungen basierend auf Code-Patterns
- **Autonome Ausführung**: Implementiert Features komplett durch ohne Unterbrechungen
- **Smart Defaults**: Verwendet sinnvolle Standardwerte statt zu fragen
- **Session-Start Hook**: Aktiviert automatisch den autonomen Modus bei jedem Start

Siehe `AUTONOMOUS_MODE.md` für Details zu den Modifikationen.

## Fehlerbehebung

### Claude fragt immer noch nach Bestätigung

Prüfe, ob der SessionStart Hook korrekt geladen wird:
```bash
# Teste den Hook manuell:
bash ~/.claude/plugins/explanatory-output-style/hooks-handlers/session-start.sh
```

### Plugins werden nicht gefunden

Prüfe die Pfade in `~/.claude/settings.json`:
```bash
cat ~/.claude/settings.json
ls -la ~/.claude/plugins/
```

### Permission-Fehler

Stelle sicher, dass die Permissions in der settings.json richtig gesetzt sind:
```json
"permissions": {
    "allow": ["Skill", "Bash", "Read", "Write", "Edit", "Glob", "Grep", "Task"],
    "defaultMode": "acceptEdits"
}
```
