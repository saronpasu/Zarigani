
module Markov
  # 単語に分割された文章を、連鎖テーブルに分割する
  def slice_words(words)
    words.push(:EOS).unshift(:SOS)
    list = Array.new
    0.upto(words.size-1) do |i|
      break if words[i].eql?(:EOS)
      list.push([words[i], words[i+1]])
    end
    return list
  end
=begin
  # 1つか2つの単語で、次候補を探す
  def search_next(words, list)
    next_words = Array.new
    case words.size
      when 1
        next_words = list.select{|i|i[0].eql?(words.first)}.map{|j|j[1]}
      when 2
        list.each_with_index{|v, i|
          next_words.push(list[i+1][1]) if v.eql?(words) && list[i+1]
        }
    end
    return nil if next_words.size.zero?
    return next_words
  end
=end

  def create_dict(source)
    dict = source.map{|data|slice_words(data)}
    return dict
  end

  def choice(array, size = 1)
    if size > 1
      choice = rand(array.size-(size-1))
      return array[choice..choice+size-1]
    else
      choice = rand(array.size)
      return array[choice]
    end
  end

=begin
  # 接頭語を与えて、マルコフ連鎖させる。
  # Arrayにマルコフ辞書を入れたdictを与える
  # 最大ループ回数を与えて、無限ループを避ける
  #
  def markov_chain(word, dict, max_loop = 50)
    tmp_text = [word]
    next_words = dict.map{|d|search_next([word], d)}.flatten.uniq
    return nil if next_words.size.zero? 
    wd = choice(next_words)
    return nil if wd.eql?(:EOS)
    tmp_text.push(wd)
    loop_count = 0

    while loop_count < max_loop do
      loop_count += 1
      next_words = dict.map{|d|search_next(tmp_text[-2..-1], d)}.flatten.uniq
      break if next_words.size.zero?
      wd = choice(next_words)
      break if wd.eql?(:EOS)
      tmp_text.push(wd)
    end

    text = tmp_text.join
    return text
  end
=end

  def forward_search(words, list)
    next_words = Array.new
    case words.size
      when 1
        next_words = list.select{|i|i.first.eql?(words.first)}.map{|j|j[1]}
      when 2
        list.each_with_index{|v, i|
          next_words.push(list[i+1][1]) if v.eql?(words) && list[i+1]
        }
    end
    return nil if next_words.empty?
    return next_words
  end

  def backward_search(words, list)
    prev_words = Array.new
    case words.size
      when 1
        prev_words = list.select{|i|i[1].eql?(words.first)}.map{|j|j.first}
      when 2
        list.each_with_index{|v, i|
          prev_words.push(list[i-1][0]) if v.eql?(words) && list[i-1]
        }
    end
    return nil if prev_words.empty?
    return prev_words
  end

  def forward_chain(word, dict, max_loop = 50)
    tmp_text = [word]
    next_words = dict.map{|d|forward_search(tmp_text, d)}.flatten.uniq.compact
    return nil if next_words.empty?
    wd = choice(next_words)
    return nil if wd.eql?(:EOS)
    tmp_text.push(wd)
    loop_count = 0

    while loop_count < max_loop do
      loop_count += 1
      next_words = dict.map{|d|forward_search(tmp_text[-2..-1], d)}.flatten.uniq.compact
      break if next_words.empty?
      wd = choice(next_words)
      break if wd.eql?(:EOS)
      tmp_text.push(wd)
    end
    return tmp_text
  end

  def backward_chain(word, dict, max_loop = 50)
    tmp_text = [word]
    prev_words = dict.map{|d|backward_search(tmp_text, d)}.flatten.uniq.compact
    return nil if prev_words.empty?
    wd = choice(prev_words)
    return nil if wd.eql?(:SOS)
    tmp_text.unshift(wd)
    loop_count = 0

    while loop_count < max_loop do
      loop_count += 1
      prev_words = dict.map{|d|backward_search(tmp_text[0..1], d)}.flatten.uniq.compact
      break if prev_words.empty?
      wd = choice(prev_words)
      break if wd.eql?(:SOS)
      tmp_text.unshift(wd)
    end
    return tmp_text
  end

=begin rdoc
与えられた単語[word]を起点として、
前方マルコフ連鎖(forward_chain)と
後方マルコフ連鎖(backward_chain)を
最大ループ回数(max_loop)まで行い
その結果(result)を結合して返す。
マルコフ辞書(dict)を利用する。
=end
  def markov_chain(word, dict, max_loop = 50)
    head = backward_chain(word, dict, max_loop)
    tail = forward_chain(word, dict, max_loop)
    return nil unless head && tail
    result = head + tail[1..-1]
    return result.join
  end
end

