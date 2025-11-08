#!/bin/bash

# Automatisches Installations-Skript für Claude Code mit autonomen Plugins
# Erstellt von Fadis

set -e  # Bei Fehler abbrechen

echo "========================================"
echo "Claude Code Autonome Installation"
echo "========================================"
echo ""

# Farben für Ausgabe
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Funktion für Success-Meldungen
success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Funktion für Info-Meldungen
info() {
    echo -e "${YELLOW}→${NC} $1"
}

# Funktion für Fehler-Meldungen
error() {
    echo -e "${RED}✗${NC} $1"
}

# 1. Prüfe ob Node.js installiert ist
info "Prüfe Node.js Installation..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    success "Node.js ist installiert: $NODE_VERSION"
else
    error "Node.js ist nicht installiert!"
    echo ""
    echo "Bitte installiere Node.js (Version 18 oder höher):"
    echo ""
    echo "Option 1 - Mit dnf (Fedora/RHEL):"
    echo "  sudo dnf install nodejs npm"
    echo ""
    echo "Option 2 - Mit nvm (empfohlen):"
    echo "  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash"
    echo "  source ~/.bashrc"
    echo "  nvm install 18"
    echo ""
    exit 1
fi

# 2. Prüfe ob npm installiert ist
info "Prüfe npm Installation..."
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm -v)
    success "npm ist installiert: $NPM_VERSION"
else
    error "npm ist nicht installiert!"
    exit 1
fi

# 3. Prüfe ob Claude Code installiert ist
info "Prüfe Claude Code Installation..."
if command -v claude &> /dev/null; then
    success "Claude Code ist bereits installiert"
else
    info "Installiere Claude Code global..."
    npm install -g @anthropic-ai/claude-code
    success "Claude Code wurde installiert"
fi

# 4. Erstelle .claude Verzeichnis
info "Erstelle ~/.claude Verzeichnis..."
mkdir -p ~/.claude/plugins
success "Verzeichnis erstellt"

# 5. Kopiere Plugins
info "Kopiere autonome Plugins..."
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cp -r "$SCRIPT_DIR/plugins/"* ~/.claude/plugins/
success "Plugins kopiert nach ~/.claude/plugins/"

# 6. Erstelle Marketplace
info "Erstelle Marketplace-Konfiguration..."
mkdir -p ~/.claude/plugins/.claude-plugin
cat > ~/.claude/plugins/.claude-plugin/marketplace.json << 'MARKETPLACE_EOF'
{
  "name": "Fadis Custom Plugins",
  "marketplaceId": "fadis-local",
  "description": "Lokale Plugins aus fadis-claude Repository mit autonomem Modus",
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
MARKETPLACE_EOF
success "Marketplace erstellt"

# 7. Erstelle oder aktualisiere settings.json
info "Konfiguriere ~/.claude/settings.json..."

# Backup der alten Konfiguration
if [ -f ~/.claude/settings.json ]; then
    info "Erstelle Backup der alten Konfiguration..."
    cp ~/.claude/settings.json ~/.claude/settings.json.backup.$(date +%Y%m%d_%H%M%S)
    success "Backup erstellt"
fi

# Erstelle neue settings.json
cat > ~/.claude/settings.json << SETTINGS_EOF
{
    "\$schema": "https://json.schemastore.org/claude-code-settings.json",
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
SETTINGS_EOF
success "settings.json konfiguriert"

# 8. Setze executable Permissions auf Hooks
info "Setze Permissions auf Hook-Skripte..."
chmod +x ~/.claude/plugins/*/hooks-handlers/*.sh 2>/dev/null || true
chmod +x ~/.claude/plugins/*/hooks/*.py 2>/dev/null || true
success "Permissions gesetzt"

echo ""
echo "========================================"
echo -e "${GREEN}Installation erfolgreich abgeschlossen!${NC}"
echo "========================================"
echo ""
echo "Claude Code wurde mit folgenden Features konfiguriert:"
echo ""
echo "  ✓ Autonomer Modus (keine Nachfragen)"
echo "  ✓ 8 Plugins installiert"
echo "  ✓ SessionStart Hook aktiviert"
echo "  ✓ Permissions konfiguriert"
echo ""
echo "Nächste Schritte:"
echo ""
echo "1. Navigiere zu deinem Projekt:"
echo "   cd ~/dein-projekt"
echo ""
echo "2. Starte Claude Code:"
echo "   claude"
echo ""
echo "3. Nutze die Plugins:"
echo "   /commit          - Automatischer Commit"
echo "   /feature-dev     - Autonome Feature-Entwicklung"
echo "   /code-review     - Code Review"
echo "   /new-sdk-app     - Agent SDK App erstellen"
echo ""
echo "Mehr Infos: siehe AUTONOMOUS_MODE.md und INSTALLATION.md"
echo ""
