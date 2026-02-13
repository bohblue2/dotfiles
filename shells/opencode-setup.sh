#!/usr/bin/env bash
set -euo pipefail

############################################
# opencode full bootstrap script
# - config files generation
# - json validation (jq)
# - opencode sanity check
############################################

CONFIG_DIR="$HOME/.config/opencode"
OMO_FILE="$CONFIG_DIR/oh-my-opencode.json"
MAIN_FILE="$CONFIG_DIR/config.json"

echo "==> [1/6] Create config directory"
mkdir -p "$CONFIG_DIR"

############################################
# oh-my-opencode.json
############################################
echo "==> [2/6] Writing oh-my-opencode.json"

cat <<'EOF' > "$OMO_FILE"
{
  "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  "lsp": {
    "marksman": {
      "command": [
        "marksman",
        "server"
      ],
      "extensions": [
        ".md"
      ]
    }
  },
  "sisyphus_agent": {
    "disabled": true
  },
  "agents": {
    "sisyphus": { "model": "openai/gpt-5.3-codex", "variant": "xhigh" },
    "oracle": { "model": "openai/gpt-5.2", "variant": "xhigh" },
    "librarian": { "model": "openai/gpt-5.1-codex-mini" },
    "explore": { "model": "openai/gpt-5.1-codex-mini" },
    "multimodal-looker": { "model": "openai/gpt-5.2" },
    "prometheus": { "model": "openai/gpt-5.3-codex", "variant": "xhigh" },
    "metis": { "model": "openai/gpt-5.3-codex", "variant": "xhigh" },
    "momus": { "model": "openai/gpt-5.2", "variant": "medium" },
    "atlas": { "model": "openai/gpt-5.3-codex", "variant": "medium" }
  },
  "categories": {
    "visual-engineering": { "model": "openai/gpt-5.3-codex" },
    "ultrabrain": { "model": "openai/gpt-5.3-codex", "variant": "xhigh" },
    "deep": {"model": "openai/gpt-5.3-codex", "variant": "xhigh"},
    "artistry": { "model": "openai/gpt-5.2", "variant": "high" },
    "quick": { "model": "openai/gpt-5.1-codex-mini" },
    "unspecified-low": { "model": "openai/gpt-5.1-codex-mini" },
    "unspecified-high": { "model": "openai/gpt-5.3-codex" },
    "writing": { "model": "openai/gpt-5.1-codex-mini" }
  }
}
EOF

############################################
# main config.json
############################################
echo "==> [3/6] Writing config.json"

cat <<'EOF' > "$MAIN_FILE"
{
  "$schema": "https://opencode.ai/config.json",
  "default_agent": "charles",
  "theme": "opencode",
  "share": "manual",
  "autoupdate": true,
  "keybinds": {
    "app_exit": "ctrl+d,<leader>q",
    "session_interrupt": "ctrl+c,escape",
    "input_clear": "ctrl+l"
  },
  "plugin": [
    "oh-my-opencode@3.4.0",
    "opencode-openai-codex-auth"
  ],
  "tui": {
    "scroll_speed": 5,
    "scroll_acceleration": {
      "enabled": true
    },
    "diff_style": "auto"
  },
  
  "agent": {
    "charles": {
      "description": "A-tier MAIN for Research and Complex Problem solving, The savant. Reasoning Complexity: extreme. Handles the most challenging tasks with deep analysis and multi-step problem solving.",
      "model": "openai/gpt-5.2",
      "permission": {
        "write": "allow",
        "edit": "allow",
        "bash": "allow"
      },
      "options": {
        "reasoning": {
          "effort": "xhigh",
          "summary": "none"
        },
        "text": {
          "verbosity": "high"
        }
      }
    },

    "explore-shallower": {
      "mode": "subagent",
      "model": "openai/gpt-5.3-codex-spark"
    },

    "explore-deeper": {
      "mode": "subagent",
      "model": "openai/gpt-5.3-codex"
    }
  }
}
EOF

############################################
# jq validation
############################################
echo "==> [4/6] Validating JSON with jq"

if ! command -v jq >/dev/null 2>&1; then
  echo "❌ jq not found. Install jq first."
  exit 1
fi

jq . "$OMO_FILE" >/dev/null
jq . "$MAIN_FILE" >/dev/null
echo "✔ JSON syntax OK"

############################################
# opencode sanity check
############################################
echo "==> [5/6] Checking opencode availability"

if ! command -v opencode >/dev/null 2>&1; then
  echo "❌ opencode CLI not found."
  echo "   Install: https://opencode.ai"
  exit 1
fi

############################################
# opencode diagnostics
############################################
echo "==> [6/6] opencode diagnostics"
opencode config list || true
opencode doctor || true

echo
echo "🎉 opencode setup completed successfully"
