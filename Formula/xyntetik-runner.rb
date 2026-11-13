class XyntetikRunner < Formula
  desc "Local GGUF inference engine with signed, replayable receipts"
  homepage "https://xyntetik.com"
  version "1.18.0"
  license all_of: ["Apache-2.0", "MIT"]

  on_macos do
    depends_on arch: :arm64
    url "https://github.com/Joakimpalm-Zen/xyntetik-runner/releases/download/v1.18.0/runner-macos-arm64.tar.gz"
    sha256 "f07705e9e1dbeac184729454db38ef23dd98f202db54176e003818e5092418e7"
  end

  on_linux do
    depends_on arch: :x86_64
    url "https://github.com/Joakimpalm-Zen/xyntetik-runner/releases/download/v1.18.0/runner-linux-x86_64.tar.gz"
    sha256 "5807c6c557bd7856e4be45db615e771999295b7c02d3e6579b50b6c4cedb506a"
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
