class XyntetikDojo < Formula
  desc "One window of terminals for agent harnesses, with a bus between them"
  homepage "https://xyntetik.com/dojo/"
  url "https://github.com/Joakimpalm-Zen/xyntetik-dojo/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "bbc46d1b3a43dcbd0ba8d2f461e2b5a4bab23ac163a2fe09a6a7f58dd2f0be68"
  license "Apache-2.0"
  head "https://github.com/Joakimpalm-Zen/xyntetik-dojo.git", branch: "main"

  depends_on macos: :sonoma

  def install
    # SwiftPM's own sandbox cannot start inside Homebrew's. The signature is ad hoc:
    # a build must not reach into the user's keychain.
    system "make", "app", "SWIFT_BUILD_FLAGS=--disable-sandbox", "SIGN=-"
    prefix.install "build/XyntetikDojo.app"
    (bin/"xyntetik-dojo").write <<~SH
      #!/bin/sh
      exec open "#{opt_prefix}/XyntetikDojo.app" "$@"
    SH
  end

  def caveats
    <<~EOS
      Open Xyntetik Dojo with:
        xyntetik-dojo

      The app was built on this Mac and lives in Homebrew's prefix, not in /Applications:
        #{opt_prefix}/XyntetikDojo.app
      It is signed ad hoc, so macOS asks again for the Desktop, Documents and the
      local network after each upgrade.
    EOS
  end

  test do
    app = prefix/"XyntetikDojo.app"
    system "codesign", "--verify", "--deep", "--strict", app
    plist = app/"Contents/Info.plist"
    assert_match version.to_s, shell_output("/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' #{plist}")
  end
end
