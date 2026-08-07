class Rw < Formula
  desc "Documentation engine - CLI"
  homepage "https://github.com/rwdocs/rw"
  version "0.1.35"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.35/rw-aarch64-apple-darwin.tar.xz"
      sha256 "eb9ef37d5c42c881d81f719a54c75d00ad6f211567fa771c05a670fadcb3964a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.35/rw-x86_64-apple-darwin.tar.xz"
      sha256 "c7c1cb2a1f225bb6ed1899d427dc52ab90c8381129f390f086ed3c26b992f65a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.35/rw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "36bc2d5ef2517300d34ce70c2242557d608ae6b8a6174bea61ca8f4cc048d60f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.35/rw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7987368e3e3f165c756f04b07629db3ccb19abd532b07278a78ee3a7c1c6814e"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "rw" if OS.mac? && Hardware::CPU.arm?
    bin.install "rw" if OS.mac? && Hardware::CPU.intel?
    bin.install "rw" if OS.linux? && Hardware::CPU.arm?
    bin.install "rw" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
