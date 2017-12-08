# README

* Ruby version
```ruby 2.4.2p198```

* System dependencies
```
postgresql
redis
```

* Configuration
```
postgres db with trusted access without password or password add to database.yml
postgres user is used
```

* Database creation
```
bin/rake db:create
bin/rake db:migrate
```

* Database initialization
```
to add values to db please use api endpoint POST /api/users
```

* How to run the test suite
```
bin/rspec
```

* Services (job queues, cache servers, search engines, etc.)
```
GetAccountKeyJob
```

* Start server
```
bin/rails s
bundle exec sidekiq
```
