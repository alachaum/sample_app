# Define a factory using the user model
Factory.define :user do |user|
  user.name "Arnaud Lachaume"
  user.email "arnaud.lachaume@gmail.com"
  user.password "foobar"
  user.password_confirmation "foobar"
end