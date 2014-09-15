require 'digest'

class AppcacheVersionGenerator
  def generate_appcache_version source_dir
    md5 = Digest::MD5.new
    md5s = ''

    Dir.glob(source_dir + '/**/*').each do |file|
      md5s << md5.hexdigest(File.read(file)) if File.file? file
    end

    md5.hexdigest md5s
  end

end