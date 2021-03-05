class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.19.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.19.tar.gz"
  sha256 "37ed12214122b972e18a0d94995039e57748191939ef74115b1d41d8811364bc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "801b2bf95118871ee206de507131325613a1aa59ab7809032bb456f1b5f01a89"
    sha256 cellar: :any, big_sur:       "36b492f1b0910367dd394cbdcffe1606f64ab41ec6701210becfb591a8557dee"
    sha256 cellar: :any, catalina:      "f7b5ab7363961fa6defcb66b4ffdf5365264fcb97d35bc413e754f173a3b1912"
    sha256 cellar: :any, mojave:        "0f65874bcd50d31aaf8b2e6c8ef414cb65a8d8b9eb6d1fa4ef179c6e0a94983c"
    sha256 cellar: :any, high_sierra:   "4a644af2fcc2781c3a161209deff7b62d760058bc1bac7c4f91a5ce5738f0798"
  end

  # --enable-libgdbm-compat for dbm.h / gdbm-ndbm.h compatibility:
  #   https://www.gnu.org.ua/software/gdbm/manual/html_chapter/gdbm_19.html
  # Use --without-readline because readline detection is broken in 1.13
  # https://github.com/Homebrew/homebrew-core/pull/10903
  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-libgdbm-compat
      --without-readline
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"

    # Avoid conflicting with macOS SDK's ndbm.h.  Renaming to gdbm-ndbm.h
    # matches Debian's convention for gdbm's ndbm.h (libgdbm-compat-dev).
    mv include/"ndbm.h", include/"gdbm-ndbm.h"
  end

  test do
    pipe_output("#{bin}/gdbmtool --norc --newdb test", "store 1 2\nquit\n")
    assert_predicate testpath/"test", :exist?
    assert_match "2", pipe_output("#{bin}/gdbmtool --norc test", "fetch 1\nquit\n")
  end
end
