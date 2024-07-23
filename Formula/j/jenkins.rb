class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.469/jenkins.war"
  sha256 "954b2759e2309151596e90bb5a88ddfd950d9397440403641bbefe5c3a2a016e"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c13a66814dae1157bb22fd7476a8ce1650909cf81a62e24aeff0d61825ac174"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c13a66814dae1157bb22fd7476a8ce1650909cf81a62e24aeff0d61825ac174"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c13a66814dae1157bb22fd7476a8ce1650909cf81a62e24aeff0d61825ac174"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c13a66814dae1157bb22fd7476a8ce1650909cf81a62e24aeff0d61825ac174"
    sha256 cellar: :any_skip_relocation, ventura:        "3c13a66814dae1157bb22fd7476a8ce1650909cf81a62e24aeff0d61825ac174"
    sha256 cellar: :any_skip_relocation, monterey:       "3c13a66814dae1157bb22fd7476a8ce1650909cf81a62e24aeff0d61825ac174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1168654ef2453ff40daae1d371534292fa409ad62c5db71d2ea48a0a6ec7d0f0"
  end

  head do
    url "https://github.com/jenkinsci/jenkins.git", branch: "master"
    depends_on "maven" => :build
  end

  depends_on "openjdk@21"

  def install
    if build.head?
      system "mvn", "clean", "install", "-pl", "war", "-am", "-DskipTests"
    else
      system "#{Formula["openjdk@21"].opt_bin}/jar", "xvf", "jenkins.war"
    end
    libexec.install Dir["**/jenkins.war", "**/cli-#{version}.jar"]
    bin.write_jar_script libexec/"jenkins.war", "jenkins", java_version: "21"
    bin.write_jar_script libexec/"cli-#{version}.jar", "jenkins-cli", java_version: "21"

    (var/"log/jenkins").mkpath
  end

  def caveats
    <<~EOS
      Note: When using launchctl the port will be 8080.
    EOS
  end

  service do
    run [opt_bin/"jenkins", "--httpListenAddress=127.0.0.1", "--httpPort=8080"]
    keep_alive true
    log_path var/"log/jenkins/output.log"
    error_log_path var/"log/jenkins/error.log"
  end

  test do
    ENV["JENKINS_HOME"] = testpath
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"

    port = free_port
    fork do
      exec "#{bin}/jenkins --httpPort=#{port}"
    end
    sleep 60

    output = shell_output("curl localhost:#{port}/")
    assert_match(/Welcome to Jenkins!|Unlock Jenkins|Authentication required/, output)
  end
end
