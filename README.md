# Xyntetik Homebrew tap

Homebrew formulae for [Xyntetik Runner](https://github.com/Joakimpalm-Zen/xyntetik-runner), the local GGUF inference engine.

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

For maintainers: `tools/update-formula.py X.Y.Z` rewrites the formula for a release, reading the checksums from that release's `SHA256SUMS`.
