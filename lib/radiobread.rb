# Large portions from http://www.pressure.to/ruby/

class Radiobread
  class << self
    def words text
      words_ = text.split(/\s+/)
      words_.map do |word|
        divide word
      end.flatten
    end

    def divide text
      text = text.dup
      divided = []
      dict = dictionary.keys.map(&:downcase).sort_by(&:length).reverse
      found_word = true
      while text != "" && found_word
        chosen_word = ""
        dict.each do |word|
          if text[0, word.size] == word
            chosen_word = word
            break
          end
        end
        text.gsub!(chosen_word, "")
        divided << chosen_word
        found_word = (chosen_word != "")
      end
      divided
    end

    def reverse_dictionary
      return @reverse_dictionary if @reverse_dictionary
      @foods = File.open(File.expand_path("../radiobread/foods.txt", __FILE__)).readlines.map(&:chomp).reject { |food| food.include?(" ") }
      @plural_foods = @foods.map { |food| food + "s" }
      @reverse_dictionary = {}
      IO.foreach(File.expand_path('../radiobread/dictionary', __FILE__)) do |line|
        next if line !~ /^[A-Z]/
        line.chomp!
        (word, *phonemes) = line.split(/  ?/)
        next unless @foods.include?(word.downcase) || @plural_foods.include?(word.downcase)
        phonemes = phonemes.reverse.take(3).reverse
        @reverse_dictionary[phonemes] ||= []
        @reverse_dictionary[phonemes] << word
      end
      @reverse_dictionary
    end

    def dictionary
      return @dictionary if @dictionary
      @dictionary = {}
      IO.foreach(File.expand_path('../radiobread/dictionary', __FILE__)) do |line|
        next if line !~ /^[A-Z]/
        line.chomp!
        (word, *phonemes) = line.split(/  ?/)
        @dictionary[word] = phonemes.reverse.take(3).reverse
      end
      @dictionary
    end

    def phonemes word
      dictionary[word.upcase]
    end

    def get_puns text
      text.downcase!
      puns = []
      words(text).map do |word|
        ph = phonemes word
        if reverse_dictionary[ph]
          reverse_dictionary[ph].each do |rhyming_word|
            rhyming_word.downcase!
            next if rhyming_word == word
            puns << text.gsub(word, rhyming_word)
          end
        end
      end
      puns
    end
  end
end
