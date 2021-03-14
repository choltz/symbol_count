# Public: Count all symbols in the given path for a file type.
#
# Example: > ruby count.rb /some/source/path rb
#          "_" - 28674
#          "#" - 15682
#          "'" - 12192
#          "," - 11226
#          "(" - 9972
#          ...
module Count
  MAX_OUTPUT = 20

  # Public: Begin processing the pipeline.
  #
  # path - Folder path to evaluate.
  # type - Filter on this file type.
  def self.start(path, type)
    # Create a functional composition pipeline to process the given path into
    # a result set.
    pipeline = -> { path }                     >>
               Private.files_in_path(type)     >>
               Private.map(&Private.char_data) >>
               Private.aggregate

    # This could be added to the pipleline above, but it has side-effects, so
    # for now, it runs after the pipeline is defined.
    pipeline.call[0, MAX_OUTPUT].each do |key, count|
      puts "\"#{key}\" - #{count}"
    end
  end

  # Since this is not a class file, an inner module is used to establish a sense
  # of private vs public scope.
  module Private
    # Internal: Combine symbol counts from all files and sort by frequency.
    #
    # Returns a Lambda.
    #   array - array of symbol data to combine.
    #
    #   Retrns an array of combined data.
    def self.aggregate
      ->(array) do
        array.flatten
             .group_by { |c| c }
             .map { |char, instances| [char, instances.length] }
             .sort { |a, b| b[1] <=> a[1] }
      end
    end

    # Internal: Extract character counts from the given file and remove
    # non-symbols.
    #
    # Returns a Lambda.
    #   path - File path to evaluate.
    #
    #   Returns an array of characters.
    def self.char_data
      ->(path) do
        File.open(path, 'r') do |file|
          file.read
              .split(//)
              .reject{|char| char =~ /[a-zA-Z0-9]/ }
              .reject{|char| char =~ /[ \n\.:]/ }
        end
      end
    end

    # Internal:  Get all files in a path and filter on the given file type.
    #
    # type - File type filter. (eg. rb, js, etc.)
    #
    # Returns a lambda
    #   path - File path to evaluate
    #
    #   Returns an Array of files.
    def self.files_in_path(type)
      ->(path) do
        Dir.glob("#{path}/**/*.#{type}").to_a
      end
    end

    # Internal: To facilitate composition, wrap the standared Array map method
    # in a Lamba object.
    def self.map(&block)
      ->(array) do
        array.map(&block)
      end
    end
  end
end

Count.start ARGV[0], ARGV[1]
