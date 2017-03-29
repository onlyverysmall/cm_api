- run `bundle install`
- seed the database: `ruby seeds.rb`
- run `rackup config.ru`
- POST to `localhost:8080/license-key` with 
```ruby
{
    userID:4,
    userID_customer:1,
    licenseKey:'SOME_STRING',
    orderID:1
}
```
- run the tests: `rspec spec/`
