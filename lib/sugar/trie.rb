require "sugar/version"

module Sugar
  class Trie
    # FIXME: should be class method
    attr_accessor :trie, :frequnces, :count

    def initialize
      dict = File.expand_path("../../dict.txt", __FILE__)
      self.trie, self.frequnces, self.count = Sugar::Trie.build(dict)
    end

    def word?(word)
      sfx = suffix(word)
      !!sfx && sfx.has_key?('')
    end

    def suffix(word)
      p = trie
      word.each_char do |char|
        return nil if p[char].nil?
        p = p[char]
      end
      p
    end

    def frequnce(word)
      frequnces[word]
    end
    
    # construct a DAG of sentence
    def DAG(sentence)
      n = sentence.length
      dag = Array.new(n){[]} # [[]]*n
      0.upto(n-1) do |i|
        sfx = suffix(sentence[i])
        i.upto(n-1) do |j|
          if sfx == nil
            break
          elsif sfx['']
            dag[i].push(j)
          end
          sfx = sfx[sentence[j+1]]
        end
      end
      dag
    end

    # Viterbi算法，递归过程
    def viterbi_distance(graph, sentence, i, path)
      if i < graph.size
        max, node = -1, -1
        graph[i].map.with_index do |j, index|
          path[j+1] = {}
          distance = viterbi_distance(graph, sentence, j+1, path[j+1])*possibility(sentence[i..j])
          if max < distance # find the min distance
            max, node = distance, index
          end
          distance
        end.each_with_index do |distance, index|
          path.delete(graph[i][index] + 1) if distance != max
        end
        max
      else
        1
      end
    end

    def possibility(word)
      1.0*frequnce(word)/count
    end

    # 
    def best_segmentation(sentence)
      dag = self.DAG(sentence)
      path = {1 => {}}
      min_distance = viterbi_distance(dag, sentence, 0, path)
      return [min_distance, path]
    end
    
    # load from dict.txt
    def self.build(dict)
      trie, frequnces, count = {}, {}, 0
      File.read(dict).split("\n").each do |line|
        word, freq, _ = line.rstrip.split(' ')
        count += (frequnces[word] = freq.to_i)
        p = trie # reference pointer
        word.each_char do |char|
          p[char] = {} if p[char].nil?
          p = p[char]
        end
        p[''] = '' # label the end of word
      end
      [trie, frequnces, count]
    end

    # load from cache
    def self.load(tempfile)
      Marshal.load(tempfile.read)
    end

    def dump(tempfile)
      tempfile.write(Marshal.dump(self))
    end

    def insepct
      "#<trie: #{trie.keys[0..10].join(',')}..., count: #{count}>"
    end
  end
end