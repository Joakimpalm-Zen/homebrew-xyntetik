class XyntetikRunner < Formula
  desc "Local GGUF inference engine with signed, replayable receipts"
  homepage "https://xyntetik.com"
  license all_of: ["Apache-2.0", "MIT"]

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/Joakimpalm-Zen/xyntetik-runner/releases/download/v1.22.0/runner-macos-arm64.tar.gz"
      sha256 "95979da8bf706fc4c987b0318fc3391886afdc1bd2ac65e6de5ced8dc6075605"
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/Joakimpalm-Zen/xyntetik-runner/releases/download/v1.22.0/runner-linux-x86_64.tar.gz"
      sha256 "c668bf0ff781106360754e713d91fdabb278b6bf609c9901f86f37d6f03fcc87"
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
