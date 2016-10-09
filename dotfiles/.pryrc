# === EDITOR ===
Pry.editor = 'vim'

# === THEME ===

Pry.config.theme = 'pry-modern-256'

# == Pry-Nav - Using pry as a debugger ==
Pry.commands.alias_command 'c', 'continue' rescue nil
Pry.commands.alias_command 's', 'step' rescue nil
Pry.commands.alias_command 'n', 'next' rescue nil

# === CUSTOM PROMPT ===
# This prompt shows the ruby version (useful for RVM)
Pry.config.prompt =  [
                        proc { |target_self, nest_level, pry|
                          prompt = "\e[0;90;49m"
                          prompt += "#{pry.input_array.size}"
                          target = Pry.view_clip(target_self)
                          prompt += " (#{target})" unless target == 'main'
                          prompt += " \e[0m"
                          prompt
                        },

                        proc { |target_self, nest_level, pry|
                          main_prompt = "#{pry.input_array.size}"
                          target = Pry.view_clip(target_self)
                          main_prompt += " (#{target})" unless target == 'main'
                          main_prompt += ' '
                          ' '*main_prompt.size
                        }
                      ]


# === Listing config ===
# Better colors - by default the headings for methods are too
# similar to method name colors leading to a "soup"
# These colors are optimized for use with Solarized scheme
# for your terminal
Pry.config.ls.separator = "\n" # new lines between methods
Pry.config.ls.heading_color = :magenta
Pry.config.ls.public_method_color = :green
Pry.config.ls.protected_method_color = :yellow
Pry.config.ls.private_method_color = :bright_black


# === CUSTOM COMMANDS ===
# from: https://gist.github.com/1297510
default_command_set = Pry::CommandSet.new do
  command "copy", "Copy argument to the clip-board" do |str|
     IO.popen('pbcopy', 'w') { |f| f << str.to_s }
  end

  command 'show-sql', "Show ActiveRecord SQL queries" do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  command 'hide-sql', "Show ActiveRecord SQL queries" do
    ActiveRecord::Base.logger = nil
  end

  command 'show-solr', "Show SOLR queries" do
    require "sunspot/rails/solr_logging"
  end

  block_command(/cp(\d+)/, "Copy the last n lines", :listing => "!cp") do |num_lines|
    start_index = (num_lines.to_i * -1) - 1 # our cp command shifts things back 1
    range = start_index..-2
    cp_hist = Pry.history.to_a[range].join "\n"
    IO.popen('pbcopy', 'w') { |f| f << cp_hist }
    puts cp_hist
  end

  command "clear" do
    system 'clear'
    if ENV['RAILS_ENV']
      output.puts "Rails Environment: " + ENV['RAILS_ENV']
    end
  end

  command "caller_method" do |depth|
    depth = depth.to_i || 1
    if /^(.+?):(\d+)(?::in `(.*)')?/ =~ caller(depth+1).first
      file   = Regexp.last_match[1]
      line   = Regexp.last_match[2].to_i
      method = Regexp.last_match[3]
      output.puts [file, line, method]
    end
  end

  command "rfg" do
    FactoryGirl.reload
  end
end

Pry.config.commands.import default_command_set

module PryToyHelper
  ALPHABET_WORDS = %w(apple banana cat dog elephant father goat house ice
                      jungle king love mother newspaper ocean person queen
                      rabbit school tree university world xray yellow zebra)
  module_function

  def random_word(chars: 3..5, letter_case: :mixcase)
    chars = rand(chars) if chars.is_a? Range
    (0...chars).map { random_char(letter_case: letter_case) }.join
  end

  def random_char(letter_case: :mixcase)
    case_offset = case letter_case
                  when :upcase   then 65
                  when :downcase then 97
                  when :mixcase  then [65,97].sample
                  else raise ArgumentError, "Bad letter case"
                  end
    (case_offset + rand(26)).chr
  end
end

module PryToys
  module_function
  def sequential_words(num: 10)
    PryToyHelper::ALPHABET_WORDS[0...num]
  end

  def random_words(num: 10, chars: 6, letter_case: :downcase)
    (0...num).map { PryToyHelper.random_word(chars: chars, letter_case: letter_case) }
  end
end

# === CONVENIENCE METHODS ===
# Stolen from https://gist.github.com/807492
# Use Array.toy or Hash.toy to get an array or hash to play with
class Array
  def self.toy(n: 10, type: :ints, order: :sequential, &block)
    return Array.new(n,&block) if block_given?

    # type, order = _normalize_toy_args type, order

    # case [type, order]
    # when
    Array.new(n) {|i| i+1}
  end

  private

  def self._normalize_toy_args(type, order)
    regular = ->(sym) { sym.to_s.singularize }
    # type, order = [type, order]
  end
end

class Hash
  def self.toy(n: 10)
    Hash[Array.toy(n: n){|c| (96+(c+1)).chr.to_sym}.zip(Array.toy(n: n))]
  end
end
