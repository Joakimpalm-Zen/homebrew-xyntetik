class XyntetikRunner < Formula
  desc "Local GGUF inference engine with signed, replayable receipts"
  homepage "https://xyntetik.com"
  license all_of: ["Apache-2.0", "MIT"]

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/Joakimpalm-Zen/xyntetik-runner/releases/download/v1.20.0/runner-macos-arm64.tar.gz"
      sha256 "f36decbb844557d0b378eaed1979d171d9cd016949b79dcf92aa650d48079def"
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/Joakimpalm-Zen/xyntetik-runner/releases/download/v1.20.0/runner-linux-x86_64.tar.gz"
      sha256 "eb77d7e92142abd09df8b0659613e98289cc4e25d8dc15b17caf8f634a975218"
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
