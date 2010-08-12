module Tbf
  require 'net/telnet'

  class Engine
    DICT = []

    def initialize()
    end

    def read_from_file(filename)
    f = File.open(filename)
      f.each_line {|line|
      DICT.push line
     }
    end

    def read_from_memory
      DICT.each do |x| puts "=> #{x}" ; end
    end


    def connect_by_telnet(target_ip) 
        tn = Net::Telnet.new({"Host"  =>  target_ip}) { |str| print str }
        begin
          DICT.each do |current_password| 
          tn.cmd('String'=> current_password) { |c| puts c, current_password  }
        end
          rescue Timeout::Error
          puts "disconnected."
        end
    end

  end
  
end

module Launch
  def self.usage
    puts ""
  end

  def self.main(ip_address)
    t = Tbf::Engine.new
    t.read_from_file("dict")
    t.connect_by_telnet(ip_address)
  end
end


if $0 == __FILE__ 
  if(ARGV.empty?)
    Launch.usage
  else
    begin
    ip_address = (ARGV[0])
    Launch.main ip_address
    rescue
      puts "Invalid url/ip"
    end
  end
end

