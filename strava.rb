require 'json'
require 'net/http'
require 'uri'
require 'logger'
require 'date'
require 'openssl'

class Strava
  attr :cookie

  def initialize
    super
  end

  def set_header(request)
    request["Authority"]          = "www.strava.com"
    request["Accept"]             = "application/json, text/plain, */*"
    request["content-type"]       = "application/json;charset=UTF-8"
    request["Accept-Language"]    = "en-US"
    request["Cache-Control"]      = "no-cache"
    request["Cookie"]             = ENV['cookie'] 
    request["Dnt"]                = "1"
    request["Pragma"]             = "no-cache"
    request["Referer"]            = "https://www.strava.com/dashboard"
    request["X-Requested-With"]   = "XMLHttpRequest"
    request
  end

  def list
    target = "https://www.strava.com/dashboard/feed?feed_type=following&athlete_id=558333"
    puts target
    uri     = URI.parse(target)
    request = Net::HTTP::Get.new(uri)
    request = set_header request

    req_options = {
      use_ssl:     uri.scheme == "https",
      verify_mode: OpenSSL::SSL::VERIFY_NONE,
    }
    response    = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    JSON.parse(response.body)['entries']
  end

  def get_msg(type)
    [
      
      "好样的！你完成了！",
      "恭喜！你成功完成了这次[sport]！",
      "太棒了！你展现了出色的耐力和毅力！",
      "你真的很强！祝贺你完成这次挑战！",
      "你是个顽强的运动员！我为你感到骄傲！",
      "这是一个了不起的成就！你真的很厉害！",
      "祝贺你超越了自己的极限！",
      "你证明了自己是个真正的冠军！",
      "你的坚持和努力得到了回报，太棒了！",
      "继续保持！你向目标迈进了一大步！",
      "跑得漂亮！骑得真快！恭喜你的出色表现！",
      "看到你的努力和汗水，我对你的成就感到非常欣慰。",
      "你是一个不屈不挠的战士！祝贺你征服了这次挑战！",
      "祝贺你完成了这次[sport]，你已经成为一个更强大的人！",
      "你的毅力和坚持给了我巨大的启发，感谢你分享这次经历！",
      "希望这些祝贺用语能够帮助你向朋友表达对他们运动成就的祝贺！",
      "你的努力和毅力真的让我敬佩！恭喜你完成了这次[sport]！",
      "你战胜了自己，展现了无限的力量！祝贺你的壮举！",
      "你的决心和坚持是不可思议的！太棒了！",
      "你创造了新的里程碑，我为你感到非常高兴！",
      "跑得如此出色，骑得如此迅猛，你真的是个运动天才！",
      "恭喜你跑得如此轻盈，骑得如此飞快！你是个真正的速度之王！",
      "你的坚持证明了你有无限的潜力和能量！",
      "你战胜了困难，证明了自己的实力！太了不起了！",
      "祝贺你完成了这次挑战，你已经超越了一般的运动水平！",
      "你的努力和毅力为我们树立了榜样！感谢你的奋斗！",
      "你用汗水和坚持铸就了成功的底蕴，恭喜你！",
      "你的成就是你不断努力和训练的结果！太棒了！",
      "看到你坚持不懈地追求自己的目标，我对你感到无比自豪！",
      "你的坚持和毅力是你成功的关键！恭喜你迈向新的高度！",
      "你的[sport]成就让我想要加入你的队伍！你真的很了不起！",
      "Well done!",
     "Congratulations on your fantastic performance!",
     "You nailed it!",
     "Way to go!",
     "That was impressive!",
     "You were amazing out there!",
     "Great job on your [sport] skills!",
     "You really crushed it!",
     "What a remarkable achievement!",
     "You're a true [sport] champion!",
     "I'm so proud of your accomplishment!",
     "You played [sport] like a pro!",
     "You've got serious talent!",
     "That was an outstanding display of skill!",
     "Your hard work paid off—congratulations!",
     "Your dedication and effort really shined through.",
     "You make it look easy!",
     "You're an inspiration to others in [sport].",
     "Congratulations on your well-deserved victory!",
     "Keep up the fantastic work!",
     "Of course! Here are some additional words and phrases to congratulate someone on their sport activity:",
     "Bravo! Exceptional performance!",
     "Outstanding job—your skills are unmatched!",
     "You left everyone in awe with your performance.",
     "That was a masterclass in [sport]!",
     "You're a force to be reckoned with in [sport]!",
     "You blew us away with your talent and determination.",
     "Congratulations on dominating the competition!",
     "Your athleticism and technique are truly impressive.",
     "You've reached new heights in your [sport] career—congrats!",
     "The way you executed your game plan was flawless.",
     "You have the heart of a champion—well done!",
     "Your passion for [sport] is evident in every move you make.",
     "You made it look effortless—congratulations!",
     "Your victory is well-deserved—congratulations on your hard work paying off!",
     "You're a shining example of what dedication can achieve in [sport].",
     "Your performance was nothing short of extraordinary!",
     "Congratulations on a remarkable win!",
     "You've proven yourself as a true competitor in [sport].",
     "Your commitment and perseverance paid off—amazing job!",
     "This is just the beginning of your bright future in [sport]—congratulations!",
    ].sample.gsub("[sport]", type)
  end

  def comment(id, msg)
    uri     = URI.parse("https://www.strava.com/feed/activity/#{id}/comment")
    request = Net::HTTP::Post.new(uri)

    request     = set_header request
    req_options = {
      use_ssl:     uri.scheme == "https",
      verify_mode: OpenSSL::SSL::VERIFY_NONE,
    }

    request.body = {"comment" => "#{msg}"}.to_json
    puts request.body
    response     = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    puts "#{response.code} #{response.body}"
  end

  def kudo2(id)
    uri     = URI.parse("https://www.strava.com/feed/activity/#{id}/kudo")
    request = Net::HTTP::Post.new(uri)
    request = set_header request

    req_options = {
      use_ssl: uri.scheme == "https",
      verify_mode: OpenSSL::SSL::VERIFY_NONE,
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    # response.code
    # response.body
  end

  def kudo(id)
    uri         = URI.parse("https://www.strava.com/feed/activity/#{id}/kudo")
    request     = Net::HTTP::Post.new(uri)
    request     = set_header request
    req_options = {
      use_ssl:     uri.scheme == "https",
      verify_mode: OpenSSL::SSL::VERIFY_NONE,
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    puts "#{response.code} #{response.body}"
  end

  def enough(activity)
    type     = activity['activity']['type']
    #length = activity['activity']['stats'].find { |item| item[:key] == "stat_one" }['value']
    stat_one_hash = activity['activity']['stats'].find { |item| item["key"] == "stat_one" }
    stat_one_value = stat_one_hash["value"].scan(/\d+\.\d+/).first.to_f

    type == "Run" && stat_one_value >=8
  end

end

s = Strava.new
lst = s.list
note = ''
count = 0
lst.each do |activity|
  begin
    next if activity['activity'].nil?
    id     = activity['activity']['id']
    a_name = activity['activity']['activityName']

    type     = activity['activity']['type']
    name     = activity['activity']['athlete']['athleteName']
    ath_id       = activity['activity']['athlete']['athleteId']
    can_kudo = activity['activity']['kudosAndComments']['canKudo']

    
#      if ath_id == "38221829" || ath_id == "16856669"
#        puts "give comment to ju"
#        note = 'has them'
#        s.comment(id, s.get_msg(type))
#      end
#    
    if can_kudo
      puts "give a kudo to ~#{name}~ ~#{a_name}~"
      s.kudo id
      count +=1
      if ath_id == "38221829" || ath_id == "16856669" || ath_id == '93620153'
        if s.enough(activity)
          puts "give comment to ju"
          note = 'has them'
          s.comment(id, s.get_msg(type))
        else
          s.comment(id, "好棒棒")
        end
      end
      sleep 3
    else
      puts 'all kudo ...'
    end
  rescue => e
    puts e.message
    puts activity
    next
  end
end
if count == 0
  last_count = File.read("strava_count.txt").to_i rescue 0
  puts last_count
  puts last_count+=1
  File.open("strava_count.txt", "w") {|f| f.write(last_count+=1)}
  puts 'no exit'
  exit
end
uri     = URI.parse("https://hooks.slack.com/services/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")
request = Net::HTTP::Post.new(uri)

req_options  = {
  use_ssl: uri.scheme == "https",
}
req_options  = {
  use_ssl:     uri.scheme == "https",
  verify_mode: OpenSSL::SSL::VERIFY_NONE,
}
request.body = "payload={\"channel\": \"#strava\", \"username\": \"strava-bot\", \"text\": \"done #{count}.#{note}\", \"icon_emoji\": \":ghost:\"}"
response     = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

puts response.code
puts response.body
