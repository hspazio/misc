# add lib directory to the require load path
$LOAD_PATH.unshift(File.expand_path('path/to/lib', __FILE__))

# Use %W to run commands
rate = '1000B'
options = %W[--limit-rate #{rate} -O]  # interpolation allowed!
url = %W[http://www.gnu.org/software/gettext/manual/gettext.html]
curl_flags = options + url
system "curl", *curl_flags

# Singleton pattern with private :new method
class Logger
  class << self
  	private :new 
  end

  def self.instance
    @instance ||= new
  end
end

# or using the Singleton module
require 'singleton'

class Logger
  include Singleton
end

# creating object with cache
# e.g. RpsMove.new(:rock) #=> same object if run twice
class RpsMove
  def self.new(move)
    @cache ||= {}
    @cache[move] ||= super(move)
  end

  def initialize(move)
  	@move = move
  end
end

# dynamic plugins
def init_plugins
  @plugins = []
  ::Plugins.constants.each do |name|
    @plugins << ::Plugins.const_get(name).new(self)
  end
end

# system method and environment variables
system({ 'HOME' => '/tmp' }, 'cd ~; pwd') # change env variables
system('ls', [:out, :err] => '/dev/null') # redirection
# system command returns true/false
# also use $? to query for the latest command's error
system('ls', [:err => :out]) # merge stderr into stdout

# Initialize Hash with default behavior if key does not exists
word_count = Hash.new do |hash, missing_key|
  hash[missing_key] = 0
end

