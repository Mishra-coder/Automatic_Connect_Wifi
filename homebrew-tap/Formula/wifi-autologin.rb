class WifiAutologin < Formula
  desc "Automatic WiFi portal login for macOS"
  homepage "https://github.com/devendramishra/wifi-autologin"
  url "https://github.com/devendramishra/wifi-autologin/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "PLACEHOLDER_SHA256"
  license "MIT"
  
  depends_on "python@3.11"
  
  resource "selenium" do
    url "https://files.pythonhosted.org/packages/selenium-4.16.0.tar.gz"
    sha256 "PLACEHOLDER"
  end
  
  resource "keyring" do
    url "https://files.pythonhosted.org/packages/keyring-24.3.0.tar.gz"
    sha256 "PLACEHOLDER"
  end
  
  resource "requests" do
    url "https://files.pythonhosted.org/packages/requests-2.31.0.tar.gz"
    sha256 "PLACEHOLDER"
  end
  
  resource "webdriver-manager" do
    url "https://files.pythonhosted.org/packages/webdriver_manager-4.0.1.tar.gz"
    sha256 "PLACEHOLDER"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
    
    libexec.install "wifi_auto_login.py"
    
    bin.install "bin/wifi-autologin"
    
    (bin/"wifi-autologin").chmod 0755
  end

  def post_install
    ohai "WiFi Auto-Login installed successfully!"
    puts ""
    puts "Quick Start:"
    puts "  1. Setup credentials:    wifi-autologin setup"
    puts "  2. Start service:        wifi-autologin start"
    puts "  3. Check status:         wifi-autologin status"
    puts ""
    puts "Documentation: #{homepage}"
  end

  def caveats
    <<~EOS
      WiFi Auto-Login has been installed!
      
      To get started:
        $ wifi-autologin setup
        $ wifi-autologin start
      
      To check if it's running:
        $ wifi-autologin status
      
      To view logs:
        $ wifi-autologin logs
      
      The service will automatically start on login.
    EOS
  end

  test do
    assert_match "WiFi Auto-Login", shell_output("#{bin}/wifi-autologin --version")
  end
end
