class AgentSafehouse < Formula
  desc "macOS sandbox wrapper for coding agents"
  homepage "https://github.com/eugene1g/agent-safehouse"
  license "Apache-2.0"
  head "https://github.com/eugene1g/agent-safehouse.git", branch: "main"

  def install
    odie "Agent Safehouse requires macOS" unless OS.mac?

    out = buildpath/"brew-dist"
    system "./scripts/generate-dist.sh", "--output", out/"safehouse", "--output-dir", out
    bin.install out/"safehouse"
  end

  test do
    assert_match "(version 1)", shell_output("#{bin}/safehouse --stdout")
  end
end
