require 'sugar'

describe Sugar::Trie, "module" do
  trie = Sugar::Trie.new
  it "can segment word" do
    trie.word?('江西').should be_true
  end

  it "can segment sentence" do
    sentence = "江西是个好地方"
    segmentation = trie.best_segmentation(sentence)
    puts "\n" + sentence
    puts segmentation.to_s
  end
end