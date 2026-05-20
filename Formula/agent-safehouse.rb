class AgentSafehouse < Formula
  desc "macOS sandbox wrapper for coding agents"
  homepage "https://github.com/eugene1g/agent-safehouse"
  url "https://github.com/eugene1g/agent-safehouse/releases/download/v0.10.1/safehouse.sh"
  version "0.10.1"
  sha256 "bf06e84d74a11dcdb3cec7293728b78df8f70a3cffdd195eb4ac8b86b5142642"
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
