#!/usr/bin/env python3
"""Write Formula/xyntetik-runner.rb for a Runner release.

    tools/update-formula.py 1.18.0

The checksums are read from the release's own SHA256SUMS, never typed: the
formula installs exactly the archives the release workflow built and hashed.
"""
import pathlib
import sys
import urllib.request

REPO = "Joakimpalm-Zen/xyntetik-runner"
ASSETS = {"macos": "runner-macos-arm64.tar.gz", "linux": "runner-linux-x86_64.tar.gz"}

TEMPLATE = '''class XyntetikRunner < Formula
  desc "Local GGUF inference engine with signed, replayable receipts"
  homepage "https://xyntetik.com"
  version "{version}"
  license all_of: ["Apache-2.0", "MIT"]

  on_macos do
    depends_on arch: :arm64
    url "{base}/{macos}"
    sha256 "{macos_sha}"
  end

  on_linux do
    depends_on arch: :x86_64
    url "{base}/{linux}"
    sha256 "{linux_sha}"
  end

  def install
    bin.install (OS.mac? ? "runner-macos-arm64" : "runner-linux-x86_64") => "runner"
    doc.install "README.md", "MANUAL.md", "BUILD-INFO.txt"
    pkgshare.install "NOTICE", "LICENSES"
  end

  test do
    assert_match "runner #{{version}}", shell_output("#{{bin}}/runner --version")
  end
end
'''


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    version = sys.argv[1].lstrip("v")
    base = f"https://github.com/{REPO}/releases/download/v{version}"
    with urllib.request.urlopen(f"{base}/SHA256SUMS", timeout=60) as r:
        sums = {}
        for line in r.read().decode().splitlines():
            digest, _, name = line.partition(" ")
            sums[name.strip().lstrip("*")] = digest
    missing = [a for a in ASSETS.values() if a not in sums]
    if missing:
        sys.exit(f"SHA256SUMS of v{version} does not list: {', '.join(missing)}")
    out = TEMPLATE.format(version=version, base=base, macos=ASSETS["macos"], linux=ASSETS["linux"],
                          macos_sha=sums[ASSETS["macos"]], linux_sha=sums[ASSETS["linux"]])
    path = pathlib.Path(__file__).resolve().parents[1] / "Formula" / "xyntetik-runner.rb"
    path.write_text(out, encoding="utf-8")
    print(f"wrote {path.relative_to(path.parents[1])} for v{version}")


if __name__ == "__main__":
    main()
