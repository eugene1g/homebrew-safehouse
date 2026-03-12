class AgentSafehouse < Formula
  desc "macOS sandbox wrapper for coding agents"
  homepage "https://github.com/eugene1g/agent-safehouse"
  url "https://github.com/eugene1g/agent-safehouse/releases/download/v0.3.1/safehouse.sh"
  version "0.3.1"
  sha256 "4c897c89917952dd8e8a7d16b9e1d89999629f5477eaee3fad586eefceddb610"
  license "Apache-2.0"
  head "https://github.com/eugene1g/agent-safehouse.git", branch: "main"

  def install
    odie "Agent Safehouse requires macOS" unless OS.mac?
    artifact_path = build.head? ? "dist/safehouse.sh" : "safehouse.sh"
    bin.install artifact_path => "safehouse"

    # Fish shell integration
    (share/"fish/vendor_conf.d").mkpath
    (share/"fish/vendor_conf.d/safehouse.fish").write <<~'FISH'
      set -gx SAFEHOUSE_APPEND_PROFILE "$HOME/.config/agent-safehouse/local-overrides.sb"

      # Ensure config dir and overrides file exist
      if not test -f $SAFEHOUSE_APPEND_PROFILE
          mkdir -p (dirname $SAFEHOUSE_APPEND_PROFILE)
          touch $SAFEHOUSE_APPEND_PROFILE
      end

      function safe
          safehouse --append-profile="$SAFEHOUSE_APPEND_PROFILE" $argv
      end

      function safe-claude
          safe claude --dangerously-skip-permissions $argv
      end
    FISH
  end

  def caveats
    <<~EOS
      Fish shell: `safe` and `safe-claude` are available in new sessions.

      Bash/zsh: add to your profile:
        export SAFEHOUSE_APPEND_PROFILE="$HOME/.config/agent-safehouse/local-overrides.sb"
        mkdir -p ~/.config/agent-safehouse && touch "$SAFEHOUSE_APPEND_PROFILE"
    EOS
  end

  test do
    assert_match "(version 1)", shell_output("#{bin}/safehouse --stdout")
  end
end
