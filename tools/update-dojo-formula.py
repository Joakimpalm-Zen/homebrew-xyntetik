#!/usr/bin/env python3
"""Write Formula/xyntetik-dojo.rb for a Dojo version.

    tools/update-dojo-formula.py 0.1.0

The formula builds the app from the source archive of the tag v<version>. The
archive's sha256 is computed here from the download, never typed.
"""
import hashlib
import pathlib
import sys
import urllib.request

REPO = "Joakimpalm-Zen/xyntetik-dojo"

TEMPLATE = '''class XyntetikDojo < Formula
  desc "One window of terminals for agent harnesses, with a bus between them"
  homepage "https://xyntetik.com/dojo/"
  url "{url}"
  sha256 "{sha}"
  license "Apache-2.0"
  head "https://github.com/{repo}.git", branch: "main"

  depends_on macos: :sonoma

  def install
    # SwiftPM's own sandbox cannot start inside Homebrew's. The signature is ad hoc:
    # a build must not reach into the user's keychain.
    system "make", "app", "SWIFT_BUILD_FLAGS=--disable-sandbox", "SIGN=-"
    prefix.install "build/XyntetikDojo.app"
    (bin/"xyntetik-dojo").write <<~SH
      #!/bin/sh
      exec open "#{{opt_prefix}}/XyntetikDojo.app" "$@"
    SH
  end

  def caveats
    <<~EOS
      Open Xyntetik Dojo with:
        xyntetik-dojo

      The app was built on this Mac and lives in Homebrew's prefix, not in /Applications:
        #{{opt_prefix}}/XyntetikDojo.app
      It is signed ad hoc, so macOS asks again for the Desktop, Documents and the
      local network after each upgrade.
    EOS
  end

  test do
    app = prefix/"XyntetikDojo.app"
    system "codesign", "--verify", "--deep", "--strict", app
    plist = app/"Contents/Info.plist"
    assert_match version.to_s, shell_output("/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' #{{plist}}")
  end
end
'''


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    version = sys.argv[1].lstrip("v")
    url = f"https://github.com/{REPO}/archive/refs/tags/v{version}.tar.gz"
    with urllib.request.urlopen(url, timeout=120) as r:
        sha = hashlib.sha256(r.read()).hexdigest()
    path = pathlib.Path(__file__).resolve().parents[1] / "Formula" / "xyntetik-dojo.rb"
    path.write_text(TEMPLATE.format(url=url, sha=sha, repo=REPO), encoding="utf-8")
    print(f"wrote {path.relative_to(path.parents[1])} for v{version}")


if __name__ == "__main__":
    main()
