require 'formula'

class Libqglviewer < Formula
  homepage 'http://www.libqglviewer.com/'
=begin  
    url 'http://www.libqglviewer.com/src/libQGLViewer-2.3.16.tar.gz'
    md5 'e5b358a5af2e8aeeab91021770b10211'
=end 
  url   'https://gforge.inria.fr/frs/download.php/30459/libQGLViewer-2.3.15-py.tgz'
  md5 '6c1958d6dbf9bdb49f40a5c4e367d345'

  depends_on 'qt'

  def options
    [
      ['--universal', "Build both x86_64 and x86 architectures."],
    ]
  end

  def patches
    DATA
  end

  def install
    args = ["PREFIX=#{prefix}"]

    if ARGV.include? '--universal'
      args << "CONFIG += x86 x86_64"
    end

    cd 'QGLViewer' do
      system "qmake", *args
      system "make"
    end
  end

  def caveats
     <<-EOS.undent
      To avoid issues with runtime linking and facilitate usage of the library:
        sudo ln -s "#{prefix}/QGLViewer.framework" "/Library/Frameworks/QGLViewer.framework"
    EOS
  end
end

__END__
--- a/QGLViewer/QGLViewer.pro
+++ b/QGLViewer/QGLViewer.pro
@@ -246,7 +246,7 @@
     FRAMEWORK_HEADERS.path = Headers
     QMAKE_BUNDLE_DATA += FRAMEWORK_HEADERS

-    DESTDIR = ~/Library/Frameworks/
+    DESTDIR = $${PREFIX}

     QMAKE_POST_LINK=cd $$DESTDIR/QGLViewer.framework/Headers && ln -s . QGLViewer
