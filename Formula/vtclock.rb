class Vtclock < Formula
  desc "Text-mode fullscreen digital clock"
  homepage "https://github.com/dse/vtclock"
  url "https://github.com/dse/vtclock/archive/0.0.20161228.tar.gz"
  sha256 "0148411febd672c34e436361f5969371ae5291bdc497c771af403a5ee85a78b4"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/dse/vtclock.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "34bc3937dbc073c9f9a210beda09527ae97f49826a3ef32f8f997317481cdf72"
    sha256 cellar: :any_skip_relocation, big_sur:       "c545d476592374b924d2d05a07d37e02461868d9c8ab9ba83cc82b9d6c21ba15"
    sha256 cellar: :any_skip_relocation, catalina:      "a9d8600f4ab8ef25a88f5778d4625ad04c7600b8770e08300193f2841451c6d4"
    sha256 cellar: :any_skip_relocation, mojave:        "380055ab532f75e4cb03f91d5e0cbceb14371d4b57ddad9771d562cf572e5746"
    sha256 cellar: :any_skip_relocation, high_sierra:   "d72cbcb6862c0030433a2413fbf1d1773d6ed8207a5c681c9ffd206fa5798f45"
    sha256 cellar: :any_skip_relocation, sierra:        "766e69763326b8a8c5cfdc636cbba9f6fcffde0739be56612c54a2904d95d456"
    sha256 cellar: :any_skip_relocation, el_capitan:    "f87c685e59533a0085b439c4153c2734d4091447f5a81c627ccc0d2e589ac65d"
    sha256 cellar: :any_skip_relocation, yosemite:      "a72a8c176276c40a3e9b0c6083a61013efb55b5ea43cd786000dad3c4243dd96"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "vtclock"
  end

  test do
    system "#{bin}/vtclock", "-h"
  end
end
