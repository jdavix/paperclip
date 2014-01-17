module Paperclip
  class MediaTypeSpoofDetector

    def initialize(io_adapter)
      @file = io_adapter
    end

    def spoofed?
      ! supplied_file_media_type.include?(calculated_media_type)
    end

    private

    def supplied_file_media_type
      MIME::Types.type_for(@file).collect(&:media_type)
    end

    def calculated_media_type
      type_from_file_command.split("/").first
    end

    def type_from_file_command
      begin
        Paperclip.run("file", "-b --mime-type :file", :file => @filename)
      rescue Cocaine::CommandLineError
        ""
      end
    end
  end
end
