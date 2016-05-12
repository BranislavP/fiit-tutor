if ENV["REDISCLOUD_URL"]
  $redis = Redis.new(:url => ENV["REDISCLOUD_URL"])
else
  $redis = Redis::Namespace.new("my_app", :redis => Redis.new)
end
