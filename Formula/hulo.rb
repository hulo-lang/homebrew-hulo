class Hulo < Formula
  desc "Hulo programming language - a modern scripting language"
  homepage "https://github.com/hulo-lang/hulo"
  version "0.1.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hulo-lang/hulo/releases/download/v0.1.0/hulo_Darwin_arm64.tar.gz"
      sha256 "e6dc94e6706938120eef800986e1abf261b00ed80715428a5f9e0ce96e00a3c8"
    else
      url "https://github.com/hulo-lang/hulo/releases/download/v0.1.0/hulo_Darwin_x86_64.tar.gz"
      sha256 "b7dae732f7716ab56b1a49d51ebed9b054b0165d6efc4fe1d28167d97131d4eb"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hulo-lang/hulo/releases/download/v0.1.0/hulo_Linux_arm64.tar.gz"
      sha256 "351e3afe77395eb2bc6949e1f8bbca4d41474b410be3b4646bfe79a24448e4a5"
    elsif Hardware::CPU.intel?
      if Hardware::CPU.is_64_bit?
        url "https://github.com/hulo-lang/hulo/releases/download/v0.1.0/hulo_Linux_x86_64.tar.gz"
        sha256 "351849620a9e60b6d259abd98c289d603983f1621592d69ccc151a251658a421"
      else
        url "https://github.com/hulo-lang/hulo/releases/download/v0.1.0/hulo_Linux_i386.tar.gz"
        sha256 "9a72ed4a46a3ce684199b07888673a064c4655aa11b4ea33c5a2a8dc5e91d54f"
      end
    end
  elsif OS.windows?
    if Hardware::CPU.arm?
      url "https://github.com/hulo-lang/hulo/releases/download/v0.1.0/hulo_Windows_arm64.zip"
      sha256 "1415aef36f9dbeae687cf2cc41943c84da8b4b372f53f02bb5567a1bdde968bd"
    elsif Hardware::CPU.intel?
      if Hardware::CPU.is_64_bit?
        url "https://github.com/hulo-lang/hulo/releases/download/v0.1.0/hulo_Windows_x86_64.zip"
        sha256 "a3c2741d313d05e8d26fb461840d7258ddda709e4776378bdfce4533c63ab668"
      else
        url "https://github.com/hulo-lang/hulo/releases/download/v0.1.0/hulo_Windows_i386.zip"
        sha256 "213d735aaeb9ff3a11cd9ae8032d90539ab1d8861bcc99a7bd60e04f3452f00f"
      end
    end
  end

  depends_on :arch => :x86_64 if OS.mac? && Hardware::CPU.intel?
  depends_on :arch => :arm64 if OS.mac? && Hardware::CPU.arm?

  def install
    if OS.windows?
      system "powershell", "-Command", "Expand-Archive", "-Path", "#{cached_download}", "-DestinationPath", "#{buildpath}", "-Force"
    else
      system "tar", "-xzf", "#{cached_download}"
    end

    extracted_dir = Dir.glob("*").first
    if extracted_dir && Dir.exist?(extracted_dir)
      bin.install Dir["#{extracted_dir}/*"]
    else
      bin.install Dir["*"]
    end

    if OS.windows?
      bin.install_symlink "hulo.exe" => "hulo"
    else
      chmod 0755, bin/"hulo"
    end
  end

  def post_install
    ohai "Hulo #{version} has been installed successfully!"
    ohai "You can now use 'hulo' command to run Hulo programs."

    system bin/"hulo", "-V" if File.exist?(bin/"hulo")
  end

#   test do
#     system bin/"hulo", "-V"

#     (testpath/"test.hl").write <<~EOS
#       echo "Hello from Hulo!"
#     EOS

#     # 运行测试程序
#     output = shell_output("#{bin}/hulo #{testpath}/test.hl 2>&1", 1)
#     assert_match "Hello from Hulo!", output
#   end

  def caveats
    <<~EOS
      Hulo has been installed to #{bin}

      To start using Hulo:
        hulo -V                 # Check version
        hulo your_script.hl     # Run a script

      For more information, visit:
        https://github.com/hulo-lang/hulo
    EOS
  end
end
