#!/usr/bin/zsh
set -eo 

############################################
# opencode full bootstrap script
# - config files generation
# - json validation (jq)
# - opencode sanity check
############################################

CONFIG_DIR="$HOME/.config/opencode"
OMO_FILE="$CONFIG_DIR/oh-my-opencode.json"
MAIN_FILE="$CONFIG_DIR/opencode.json"

rm -rf $OMO_FILE
rm -rf $MAIN_FILE

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
    },
    "my-server": {
      "command": [
        "my-lsp",
        "--stdio"
      ],
      "extensions": [
        ".toml"
      ]
    }
  },
  "background_task": {
    "defaultConcurrency": 100,
    "providerConcurrency": {
      "openai": 100
    },
    "modelConcurrency": {
      "openai/gpt-5.3-codex-spark": 100,
      "openai/gpt-5.3-codex": 100,
      "openai/gpt-5.2": 100
    }
  },
  "agents": {
    "sisyphus": { "model": "openai/gpt-5.3-codex", "variant": "medium" },
    "prometheus": { "model": "openai/gpt-5.2", "variant": "xhigh" },
    "metis": { "model": "openai/gpt-5.2", "variant": "xhigh" },
    "momus": { "model": "openai/gpt-5.2", "variant": "high" },
    "atlas": { "model": "openai/gpt-5.3-codex", "variant": "xhigh" },
    "oracle": { "model": "openai/gpt-5.2", "variant": "xhigh" },
    "librarian": { "model": "openai/gpt-5.3-codex-spark", "variant": "low" },
    "explore": { "model": "openai/gpt-5.3-codex-spark", "variant": "low" },
    "multimodal-looker": { "model": "openai/gpt-5.2", "variant": "high" }
  },
  "categories": {
    "quick": { "model": "openai/gpt-5.3-codex-spark", "variant": "low" },
    "unspecified-low": { "model": "openai/gpt-5.3-codex-spark", "variant": "low" },
    "unspecified-high": { "model": "openai/gpt-5.3-codex", "variant": "high" },
    "deep": {"model": "openai/gpt-5.3-codex", "variant": "xhigh"},
    "ultrabrain": { "model": "openai/gpt-5.2", "variant": "xhigh" },
    "visual-engineering": { "model": "openai/gpt-5.3-codex", "variant": "high" },
    "writing": { "model": "openai/gpt-5.2", "variant": "medium" },
    "artistry": { "model": "openai/gpt-5.2", "variant": "high" }
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
  "default_agent": "sisyphus",
  "theme": "system",
  "share": "manual",
  "autoupdate": true,
  "keybinds": {
    "app_exit": "ctrl+d,<leader>q",
    "session_interrupt": "ctrl+c,escape",
    "input_clear": "ctrl+l"
  },
  "plugin": [
    "oh-my-opencode",
    "opencode-openai-codex-auth"
  ],
  
  "mcp": {
    "playwright": {
      "type": "local",
      "command": [
        "npx",
        "@playwright/mcp@latest"
      ],
      "enabled": true
    }
  },

  "tui": {
    "scroll_speed": 12,
    "scroll_acceleration": { "enabled": true },
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
    
    "plan": {
      "mode": "primary",
      "model": "openai/gpt-5.3-codex",
      "reasoningEffort": "xhigh",
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

    "build": {
      "mode": "primary",
      "model": "openai/gpt-5.3-codex-spark",
      "reasoningEffort": "xhigh",
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
# ast-grep installation
############################################
echo "==> [5.5/6] Installing ast-grep"
npm install -g @ast-grep/cli

############################################
# opencode diagnostics
############################################
echo "==> [6/6] opencode diagnostics"
opencode config list || true
bunx oh-my-opencode doctor --verbose

echo
echo "🎉 opencode setup completed successfully"
