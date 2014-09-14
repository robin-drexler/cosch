

module RapidSchedule
  module Commands
    class New
      def execute!(args, options = {})
        template_path = File.expand_path(File.join(__FILE__, '..', '..', 'template'))

        raise ArgumentError.new("You need to provide a PATH") if args.empty?

        destination = File.expand_path(args.join(" "), Dir.pwd)

        FileUtils.mkdir_p(destination)
        FileUtils.cp_r(Dir[File.join(template_path, '*')], destination)
      end
    end
  end
end