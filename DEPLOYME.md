Deploying GitFeeds
==================

This is the configuration of my Fedora 15 staging server.

* [RVM](http://beginrescueend.com) to isolate the environment.
* [Thin](http://code.macournoyer.com/thin) to serve the Rails app.
* [Resque](https://github.com/defunkt/resque) to queue background jobs.
* [Supervisor](http://supervisord.org) to monitor the app and workers.
* [Nginx](http://wiki.nginx.org) to proxy requests to the app servers.


### Server Configuration

```bash
# Install RVM systemwide.
$ sudo yum install git
$ sudo bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
$ sudo usermod -a -G rvm $(whoami)
$ source /etc/profile.d/rvm.sh

# Install Ruby build dependencies (as told by `rvm requirements`).
$ sudo yum install -y gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison iconv-devel

# Install misc gem build dependencies.
$ sudo yum install gcc-c++       # eventmachine
$ sudo yum install sqlite3-devel # sqlite

# Grab the latest source from GitHub.
$ git clone git://github.com/adammck/gitfeeds.git ~/gitfeeds

# Create an isolated environment with RVM.
$ rvm use --install --create 1.9.2@gitfeeds
$ rvm wrapper 1.9.2@gitfeeds gitfeeds rake rails bundle

# Install app dependencies with Bundler.
$ /usr/local/rvm/bin/gitfeeds_bundle install --gemfile=~/gitfeeds/Gemfile

# Spawn the SQLite database.
$ RAILS_ENV=production rake db:setup

# Install Redis.
$ sudo yum install redis
$ sudo /etc/init.d/redis start
$ sudo chkconfig --levels 235 redis on

# Install Supervisor.
# (See below for config.)
$ sudo yum install supervisor
$ sudo /etc/init.d/supervisord start
$ sudo chkconfig --levels 235 supervisord on

# Install Nginx.
# (See below for config.)
$ sudo yum install nginx
$ sudo /etc/init.d/nginx start
$ sudo chkconfig --levels 235 nginx on

# Open port 80.
$ sudo yum install lokkit
$ sudo lokkit -p http:tcp
```


### Supervisor Configuration

```
[program:gitfeeds_resque]
directory=/home/adammck/gitfeeds
command=/usr/local/rvm/bin/gitfeeds_rake resque:work
environment=RAILS_ENV=production,QUEUE=*
user=adammck
umask=022
autostart=True
autorestart=True
redirect_stderr=True

[program:gitfeeds_worker]
directory=/home/adammck/gitfeeds
command=/usr/local/rvm/bin/gitfeeds_rake gitfeeds:work
environment=RAILS_ENV=production,INTERVAL=60
user=adammck
umask=022
autostart=True
autorestart=True
redirect_stderr=True

[program:gitfeeds_app]
directory=/home/adammck/gitfeeds
command=/usr/local/rvm/bin/gitfeeds_rails server thin -e production -p 8002
user=adammck
umask=022
autostart=True
autorestart=True
redirect_stderr=True
```


### Nginx Configuration

```
upstream gitfeeds_server {
  server 127.0.0.1:8002 fail_timeout=0;
}

server {
  server_name gitfeeds.com;
  listen 80;

  location / {
    proxy_pass http://gitfeeds_server;
    proxy_redirect off;

    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }
}
```

### Sudoers Configuration

```
adammck ALL=(ALL) NOPASSWD: /usr/bin/supervisorctl
```