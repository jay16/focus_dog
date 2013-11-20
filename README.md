1. cd focus_dog
2. gem install bundler
3. bundle install
4. thin start -e production
   passenger start


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
