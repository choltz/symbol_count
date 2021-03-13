class Count
  MAX_OUTPUT = 20

  def self.start(path, type)
    function = ->(){ path }        >>
               files_in_path(type) >>
               map(&char_data)     >>
               aggregate

    function.call[0, MAX_OUTPUT].each do |key, count|
      puts "\"#{key}\" - #{count}"
    end
  end

  def self.aggregate
    ->(array) do
      array.flatten
           .group_by { |c| c }
           .map { |c, instances| [c, instances.length] }
           .sort { |a, b| b[1] <=> a[1] }
    end
  end

  def self.files_in_path(type)
    ->(path) do
      Dir.glob("#{path}/**/*.#{type}").to_a
    end
  end

  def self.map(&block)
    ->(array) do
      array.map(&block)
    end
  end

  def self.char_data
    ->(path) do
      results = []
      File.open(path, 'r') do |file|
        results = file.read.split(//)
                      .reject{|c| c =~ /[a-zA-Z0-9]/ }
                      .reject{|c| c =~ /[ \n\.:]/ }
      end
      results
    end
  end
end

Count.start ARGV[0], ARGV[1]
