class AgentSafehouse < Formula
  desc "macOS sandbox wrapper for coding agents"
  homepage "https://github.com/eugene1g/agent-safehouse"
  url "https://github.com/eugene1g/agent-safehouse/releases/download/v0.6.0/safehouse.sh"
  version "0.6.0"
  sha256 "a19eed6f3e9d0621a22ca1a950c0e50b4b10ca7caa5b10af137006b07beb3bc3"
  license "Apache-2.0"
  head "https://github.com/eugene1g/agent-safehouse.git", branch: "main"

  def install
    odie "Agent Safehouse requires macOS" unless OS.mac?
    artifact_path = build.head? ? "dist/safehouse.sh" : "safehouse.sh"
    bin.install artifact_path => "safehouse"

    # Universal wrappers for all shells (Bash, Zsh, Fish, etc.)
    (bin/"safe").write <<~SH
      #!/bin/bash
      export SAFEHOUSE_APPEND_PROFILE="$HOME/.config/agent-safehouse/local-overrides.sb"
      if [ ! -f "$SAFEHOUSE_APPEND_PROFILE" ]; then
        mkdir -p "$(dirname "$SAFEHOUSE_APPEND_PROFILE")"
        touch "$SAFEHOUSE_APPEND_PROFILE"
      fi
      exec "#{opt_bin}/safehouse" --append-profile="$SAFEHOUSE_APPEND_PROFILE" "$@"
    SH

    (bin/"safe-claude").write <<~SH
      #!/bin/bash
      exec "#{opt_bin}/safe" claude --dangerously-skip-permissions "$@"
    SH
  end

  test do
    assert_match "(version 1)", shell_output("#{bin}/safehouse --stdout")
  end
end
