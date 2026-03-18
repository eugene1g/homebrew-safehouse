class AgentSafehouse < Formula
  desc "macOS sandbox wrapper for coding agents"
  homepage "https://github.com/eugene1g/agent-safehouse"
  url "https://github.com/eugene1g/agent-safehouse/releases/download/v0.5.2/safehouse.sh"
  version "0.5.2"
  sha256 "dc2846e804a8cea8f2470daf068ca6a40a835531547017386ee5fa64f9e8e39b"
  license "Apache-2.0"
  head "https://github.com/eugene1g/agent-safehouse.git", branch: "main"

  def install
    odie "Agent Safehouse requires macOS" unless OS.mac?
    artifact_path = build.head? ? "dist/safehouse.sh" : "safehouse.sh"
    bin.install artifact_path => "safehouse"
  end

  test do
    assert_match "(version 1)", shell_output("#{bin}/safehouse --stdout")
  end
end
