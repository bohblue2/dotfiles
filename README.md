# Dotfiles
This repo contains everything to bootstrap my Macbook Air.

For various reasons, there are some things that need to be handled by hand rather than in a command script. Check out the `Manual Setup` section.

## Manual Setup

### VS Code Extensions (VSIX from Open VSX)

아래 확장은 Open VSX에서 VSIX를 받아 수동 설치한다.

1. **[Ruff](https://open-vsx.org/extension/charliermarsh/ruff)** – Python linter/formatter  
2. **[ty](https://open-vsx.org/extension/astral-sh/ty)** – Type checker

설치 방법:

1. 각 링크에서 페이지 접속 → `Download` 버튼으로 `.vsix` 다운로드
2. 설치 실행:

   ```bash
   code --install-extension /path/to/charliermarsh.ruff-*.vsix
   code --install-extension /path/to/astral-sh.ty-*.vsix
   ```

### openai/codex-auth
### github/copilot-auth
### opencode-auth

### tmux
tmux source-file ~/.tmux.conf


### Karabiner
1. Unzip the `(this repo)/zips/karabiner.zip` file under `~./config/`
2. all configuration files should exist under `~./config/karabiner`.

## References 
https://github.com/appkr/dotfiles/blob/master/bootstrap.sh
https://gitlab.com/dnsmichi/dotfiles/-/blob/main/bootstrap.sh?ref_type=heads
https://yadm.io/docs/examples
https://github.com/mathiasbynens/dotfiles/blob/main/.macosfffff