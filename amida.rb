require 'enumerable/lazy'

class Amida
  attr_accessor :goal_num

  def initialize(line_num)
    self.line_num = line_num
  end

  def line_num
    @line_num
  end

  def line_num=(line_num)
    @line_num = line_num
    @max_label_length = nil
    @bridge = nil
    @none_bridge = nil
    self.goal_num  = rand 0...line_num
  end

  def label_generator
    @label_generator ||= Enumerator.new {|y|
      l = "A"
      loop { y << l; l = l.next }
    }.lazy
  end

  def bridge_generator
    @bridge_generator ||= Enumerator.new {|y|
      prev = rand >= 0.5
      loop { y << prev = prev ? false : rand >= 0.5 }
    }.lazy
  end

  def max_label_length
    @max_label_length ||= labels.drop(line_num-1).first.length
  end

  def label_width
    max_label_length + 2
  end

  def labels
    label_generator.take(line_num)
  end

  def print_label(label)
    print format "%*s", label_width, label
  end

  def print_labels
    labels.each {|label|
      print_label(label)
    }
    puts
  end

  def print_goal
    goal_pos = (goal_num + 1) * label_width
    puts format "%*s", goal_pos, '*'
  end

  def bridge_width
    label_width - 1
  end

  def bridge
    @bridge ||= = "-" * bridge_width
  end

  def none_bridge
    @none_bridge ||= " " * bridge_width
  end

  def print_amida_row!
    print format "%*s|", label_width - 1, ''
    bridges = bridge_generator.take(river_num)
    bridges.each_with_index {|b, i|
      @status[i] ||= b
      print b ? bridge : none_bridge
      print "|"
    }
    puts
  end

  def river_num
    line_num - 1
  end

  def reset_amida_status!
    @status = Array.new(river_num, false)
  end

  def amida_finish?
    @status.all?
  end

  def print_amida!
    reset_amida_status!
    print_amida_row! until amida_finish?
  end

  def display!
    print_labels
    print_amida!
    print_goal
  end
end

people_num = (ARGV[0] || 5).to_i
amida = Amida.new(people_num)
amida.display!

__END__
あみだくじつくりました。

縦棒は道です。縦棒と縦棒の間は川です。
そこに橋をかけるイメージで書きました。

|      |
|------|
|      |
    ↑
橋がかかってる川


|      |
|      |
|      |

    ↑
橋がかかってない川

あみだを生成しはじめたら川の間にランダムに橋をかけます。
すべての川に橋をかけたらおわります。
なので終わらない可能性あります。
高さは指定できないです。

「らくしょー」と思ってたら以外と書けなかった。
勉強会には参加出来なかったので今度はみんないるときにわいわいやるぞー。
