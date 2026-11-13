# Xyntetik Homebrew tap

Homebrew formulae for [Xyntetik Runner](https://github.com/Joakimpalm-Zen/xyntetik-runner), the local GGUF inference engine, and [Xyntetik Dojo](https://github.com/Joakimpalm-Zen/xyntetik-dojo), one window of terminals for agent harnesses.

## Runner

```sh
brew install joakimpalm-zen/xyntetik/xyntetik-runner
runner --version
```

It installs the released `runner` binary for your platform: macOS on Apple silicon, or Linux on x86-64. Nothing is compiled. The formula downloads the archive the release workflow built and checks it against the sha256 the release published, so what you run is byte for byte the release asset.

To update after a new Runner release:

```sh
brew update && brew upgrade xyntetik-runner
```

Limits:

- No Intel Mac and no Linux arm64 build exists, so the formula refuses those.
- The macOS binary is not signed or notarized. Homebrew does not quarantine what it downloads, so it runs; a copy you download by hand in a browser needs `xattr -d com.apple.quarantine runner` first.
- On Linux the binary uses an NVIDIA GPU when the CUDA driver is present and runs on the CPU otherwise. Homebrew installs neither.

## Dojo

```sh
brew install joakimpalm-zen/xyntetik/xyntetik-dojo
xyntetik-dojo    # opens the app
```

It builds the app from the tagged source on your Mac, which takes a few minutes, and adds `xyntetik-dojo`, which opens it. Nothing prebuilt is downloaded. You need macOS 14 or later and the Command Line Tools (`xcode-select --install` once); Dojo's own [README](https://github.com/Joakimpalm-Zen/xyntetik-dojo#install) says what it needs to run harnesses.

Limits:

- macOS only.
- The app lives in Homebrew's prefix, not in /Applications. `make install` from a clone of the repository puts it there.
- The build is signed ad hoc on your Mac, so macOS asks again for the Desktop, Documents and the local network after each upgrade.
- No prebuilt app is offered: the app is not notarized, and Homebrew does not install an app that Gatekeeper would stop.

## For maintainers

`tools/update-formula.py X.Y.Z` rewrites the Runner formula for a release, reading the checksums from that release's `SHA256SUMS`. `tools/update-dojo-formula.py X.Y.Z` rewrites the Dojo formula for the tag `vX.Y.Z`, hashing the tag's source archive.
