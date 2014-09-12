require 'digest'

class AppcacheVersionGenerator
  def generate_appcache_version
    md5 = Digest::MD5.new
    md5s = ''

    Dir.glob('build/**').each do |file|
      md5s << md5.hexdigest(File.read(file))
    end

    md5.hexdigest md5s
  end

end