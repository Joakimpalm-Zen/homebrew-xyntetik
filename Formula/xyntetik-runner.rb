class XyntetikRunner < Formula
  desc "Local GGUF inference engine with signed, replayable receipts"
  homepage "https://xyntetik.com"
  license all_of: ["Apache-2.0", "MIT"]

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/Joakimpalm-Zen/xyntetik-runner/releases/download/v1.21.0/runner-macos-arm64.tar.gz"
      sha256 "8c6f62a407c4bd5b79dfe2a6716469d8acd9ab4a02cbca46c9f4159ac453554b"
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/Joakimpalm-Zen/xyntetik-runner/releases/download/v1.21.0/runner-linux-x86_64.tar.gz"
      sha256 "2ac770fe1500a79dc3d4d9312c244e098c8fdf20cb49987e80b9ba3c7b96d363"
    end
  end

  def install
    bin.install (OS.mac? ? "runner-macos-arm64" : "runner-linux-x86_64") => "runner"
    doc.install "README.md", "MANUAL.md", "BUILD-INFO.txt"
    pkgshare.install "NOTICE", "LICENSES"
  end

  test do
    assert_match "runner #{version}", shell_output("#{bin}/runner --version")
  end
end
