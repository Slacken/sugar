require "sugar/version"
module Sugar
  class Pinyin
    def initialize(options = {})
      options = {with_tone: false}.merge(options)
      dict = File.expand_path("../../data/pinyin.txt", __FILE__)
      @hash = {}
      File.read(dict).split("\n").map do |line|
        key, *values = line.split(" ")
        @hash[key] = options[:with_tone] ? values : values.map{|v| v[/[a-z]+/]}.uniq
      end
    end

    def get(word)
      @hash[word]
    end

    def chinese?(char)
      !@hash[word].nil?
    end

    def pinyins
      @hash.values.flatten.uniq
    end

    def inspect
      "<\#Sugar::Pinyin>"
    end
  end
end