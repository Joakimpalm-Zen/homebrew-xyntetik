class XyntetikRunner < Formula
  desc "Local GGUF inference engine with signed, replayable receipts"
  homepage "https://xyntetik.com"
  license all_of: ["Apache-2.0", "MIT"]

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/Joakimpalm-Zen/xyntetik-runner/releases/download/v1.19.0/runner-macos-arm64.tar.gz"
      sha256 "e3470b3a3128d08e79c90d7eb9ea0f73e8772156b7ec7c770c650fea2d6689d8"
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/Joakimpalm-Zen/xyntetik-runner/releases/download/v1.19.0/runner-linux-x86_64.tar.gz"
      sha256 "60d76d5dcfda7485575856f9da6ec7d7a9c42a7d4fd2ec695e99fb90440ebbd3"
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
