class Paket < Formula
  desc "Dependency manager for .NET with support for NuGet and Git repositories"
  homepage "https://fsprojects.github.io/Paket/"
  url "https://github.com/fsprojects/Paket/releases/download/5.245.4/paket.exe"
  sha256 "e188726bd5fe97b498d3808cb5bae085c63d8a90846d005e35890586001cfc54"

  bottle :unneeded

  depends_on "mono"

  def install
    libexec.install "paket.exe"
    (bin/"paket").write <<~EOS
      #!/bin/bash
      mono #{libexec}/paket.exe "$@"
    EOS
  end

  test do
    test_package_id = "Paket.Test"
    test_package_version = "1.2.3"

    touch testpath/"paket.dependencies"
    touch testpath/"testfile.txt"

    system bin/"paket", "install"
    assert_predicate testpath/"paket.lock", :exist?

    (testpath/"paket.template").write <<~EOS
      type file

      id #{test_package_id}
      version #{test_package_version}
      authors Test package author

      description
          Description of this test package

      files
          testfile.txt ==> lib
    EOS

    system bin/"paket", "pack", "output", testpath
    assert_predicate testpath/"#{test_package_id}.#{test_package_version}.nupkg", :exist?
  end
end
