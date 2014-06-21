require 'sugar'
require 'api_access'

class Domain
  def initialize
    @pinyin = Sugar::Pinyin.new
  end

  def double(&condition)
    pinyins = @pinyin.pinyins
    params = {}
    condition = ->(a, b){ (a+b).length <= 7 } if condition.nil?
    pinyins.product(pinyins).uniq.each do |a, b|
      if condition.call(a,b)
        params[a+b+".com"] = {name: a+b}
      end
    end

    result = ApiAccess.batch_post('http://www.qiuyumi.org/query/whois.com.php', params, 10)
    result.select{|k, v| v['available']}.keys
  end

  def phrase

  end
end