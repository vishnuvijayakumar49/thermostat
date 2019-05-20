# frozen_string_literal: true

REDIS = if Rails.env.test?
          Redis::Namespace.new(:test_redis, redis: MockRedis.new)
        else
          Redis::Namespace.new(:production,
                               redis: Redis.new(APP_CONFIG[:redis_conf]))
        end
