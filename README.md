This is a weixin demo.

1. gem install bundler
2. cd weixintest
3. bundle install
4. thin start -e production

nginx conf:

    #focusmail log
    server {
        listen 80;
        server_name focusdog.xsolife.com;
        access_log  /mnt/work/etl/focus_dog/logs/access.log;
        error_log   /mnt/work/etl/focus_dog/logs/error.log;

        location / {
          root /mnt/work/etl/focus_dog/public;
          passenger_enabled on;
          index index.html
        }
    }
