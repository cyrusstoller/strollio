## Starting up the application

```
$ bundle install
$ rake db:create # first time only
$ rake db:migrate # only if you updated the database
$ foreman start
$ bundle exec autotest
```

## Deploying on Heroku

You'll need to change your host so that callbacks will provide the appropriate url. Change the url in `config/config.yml`.

### Setting up your application

```
$ heroku create --stack cedar
$ git push heroku master
$ heroku run rake db:create
$ heroku run rake db:migrate
```

### Updating your application

```
$ git push heroku master
$ heroku run rake db:migrate # only if you updated the database
```