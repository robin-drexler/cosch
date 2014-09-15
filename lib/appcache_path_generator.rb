require 'digest'

class AppcachePathGenerator

  def initialize source_dir
    @source_dir = source_dir
  end

  def paths
    resources = []
    # cd into dir so glob does not contain first path part prefix in paths
    # e.g. if dir is build/ glob would contain build/foo/bat, but we want foo/bat
    Dir.chdir(@source_dir) do
      resources = Dir["**/*"].reject { |i| File.directory? i }
    end
    resources
  end

  # might be better placed elsewhere
  def appcache_version

    md5 = Digest::MD5.new
    md5s = ''

    paths.each do |file|
      md5s << md5.hexdigest(File.read(File.join(@source_dir, file)))
    end

    md5.hexdigest md5s
  end

end