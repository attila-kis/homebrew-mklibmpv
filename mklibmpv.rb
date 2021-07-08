# Last check with upstream: fbe5f11471748ac696089a00a2c1396945de3cda
# https://github.com/Homebrew/homebrew-core/blob/master/Formula/mpv.rb

class MKLibMpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.33.1.tar.gz"
  sha256 "100a116b9f23bdcda3a596e9f26be3a69f166a4f1d00910d1789b6571c46f3a9"
  revision 3
  head "https://github.com/mpv-player/mpv.git"

  keg_only "it is intended to only be used for building IINA. This formula is not recommended for daily use"

  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build

  depends_on "mkffmpeg"
  depends_on "jpeg"
  depends_on "libarchive"
  depends_on "libass"

  depends_on "little-cms2"
  depends_on "lua@5.1"
  depends_on "libbluray"
  depends_on "openssl"
  
  depends_on "mujs"
  depends_on "uchardet"
  # depends_on "vapoursynth"
  #depends_on "youtube-dl"

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"
    args = %W[
      --enable-lgpl
      --disable-cplayer
      --disable-lua
      --prefix=#{prefix}
      --enable-javascript
      --enable-libmpv-shared
      --disable-macos-cocoa-cb
      --disable-macos-media-player
      --disable-cocoa  
      --enable-lua
      --enable-libarchive
      --enable-uchardet
      --enable-libbluray
      --disable-swift
      --disable-debug-build
      --disable-macos-touchbar
      --confdir=#{etc}/mpv
      --datadir=#{pkgshare}
      --mandir=#{man}
      --docdir=#{doc}
      --disable-libarchive
    ]
    system "./bootstrap.py"
    system "python3", "waf", "configure", *args
    system "python3", "waf", "install"
  end

  test do
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
  end
end
