class XyntetikRunner < Formula
  desc "Local GGUF inference engine with signed, replayable receipts"
  homepage "https://xyntetik.com"
  license all_of: ["Apache-2.0", "MIT"]

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/Joakimpalm-Zen/xyntetik-runner/releases/download/v1.19.1/runner-macos-arm64.tar.gz"
      sha256 "4e01a47c536c491ae6021934bcfb95fde4a8e12d6e8f603b2d4fad94b3167ed4"
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/Joakimpalm-Zen/xyntetik-runner/releases/download/v1.19.1/runner-linux-x86_64.tar.gz"
      sha256 "5659198d85bd00c123dedbc4e492be42ea0024eb9a9b0984728ad6e7915b4cd1"
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
