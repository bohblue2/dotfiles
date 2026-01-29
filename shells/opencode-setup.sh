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

  "agents": {
    "sisyphus": { "model": "openai/gpt-5.2-codex" },
    "oracle": { "model": "openai/gpt-5.2", "variant": "high" },
    "librarian": { "model": "openai/gpt-5.2" },
    "explore": { "model": "github-copilot/gpt-5-mini" },
    "multimodal-looker": { "model": "openai/gpt-5.2" },
    "prometheus": { "model": "openai/gpt-5.2-codex", "variant": "high" },
    "metis": { "model": "openai/gpt-5.2" },
    "momus": { "model": "openai/gpt-5.2", "variant": "medium" },
    "atlas": { "model": "openai/gpt-5.2", "variant": "high" }
  },

  "categories": {
    "visual-engineering": { "model": "github-copilot/gemini-3-pro" },
    "ultrabrain": { "model": "openai/gpt-5.2-codex", "variant": "xhigh" },
    "artistry": { "model": "github-copilot/gemini-3-pro", "variant": "max" },
    "quick": { "model": "opeani/gpt-5-mini" },
    "unspecified-low": { "model": "github-copilot/claude-sonnet-4.5" },
    "unspecified-high": { "model": "github-copilot/claude-sonnet-4.5" },
    "writing": { "model": "openai/gpt-5-mini" }
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

  "plugin": ["oh-my-opencode@latest"],

  "model": "opencode/gpt-5.2",

  "agent": {
    "plan": {
      "mode": "primary",
      "model": "opencode/gpt-5.2-codex",
      "reasoningEffort": "xhigh",
      "permission": { "edit": "ask", "bash": "ask" }
    },

    "build": {
      "mode": "primary",
      "model": "opencode/gpt-5.2-codex",
      "reasoningEffort": "high",
      "permission": {
        "bash": {
          "*": "ask",
          "git *": "allow",
          "rg *": "allow",
          "grep *": "allow"
        },
        "edit": "ask"
      }
    },

    "general": {
      "mode": "subagent",
      "model": "openai/gpt-5.2",
      "reasoningEffort": "high"
    },

    "explore": {
      "mode": "subagent",
      "model": "openai/gpt-5-mini"
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
