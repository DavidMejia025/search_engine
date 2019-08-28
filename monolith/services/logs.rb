class Logs
  def initialize
    # create instance and persistance of logs for future implementation if needed.
    # and for practice singleton if it is a good solution here.
    # Add times stamps and the service file that calls it.
  end

  def self.add(msg:)
    puts "Logs: #{msg} #{"." * 100}"
  end

  def self.find_create
  end
end
