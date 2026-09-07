class Rw < Formula
  desc "Documentation engine - CLI"
  homepage "https://github.com/rwdocs/rw"
  version "0.1.36"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.36/rw-aarch64-apple-darwin.tar.xz"
      sha256 "f506557a28bd46f086d0271e123d2989c78fe92c99bca81434b5b20704d8469a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.36/rw-x86_64-apple-darwin.tar.xz"
      sha256 "b3e03cc6e6e19c0ad1e6cdfb5d4bf154d8bf12a5aec51e83309fd4417747b3f5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.36/rw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "607eac192834c821b14af68fadb220977a8c134895ea6c5008712898da52ff3f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.36/rw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "66927936463a2bc60a726d6c65e7392a4967a62943b54cfad405dfd5db5a6a1f"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "rw"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rw"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rw"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rw"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
