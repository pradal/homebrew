require 'formula'

class Pyqglviewer < Formula
  homepage 'http://pyqglviewer.gforge.inria.fr/'

  url   'https://gforge.inria.fr/frs/download.php/30908/PyQGLViewer-0.11.zip'
  md5   'cc7d847989fd6af9ac51736cec864e4b'

  depends_on 'pyqt'
  depends_on 'sip'
  depends_on 'libqglviewer'

=begin
  def options
    [
      ['--universal', "Build both x86_64 and x86 architectures."],
    ]
  end
=end

=begin
  def patches
    DATA
  end
=end

  def install
    ENV.prepend 'PYTHONPATH', 
                "#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages", ':'

    system 'python', 'configure.py', "-f", `brew --prefix libqglviewer`.strip(),
           '-I', '/usr/X11/include',
           "--module-install-path=#{lib}/#{which_python}/site-packages"
    system 'make'
    system 'make', 'install'

=begin
    args = ["-Q #{prefix}"]

    if ARGV.include? '--universal'
      args << "CONFIG += x86 x86_64"
    end

    cd 'QGLViewer' do
      system "python configure.py", *args
      system "make"
    end
=end

  end

  def caveats; <<-EOS.undent
    For non-Homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
    EOS
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end

