# Sinatra Boilerplate

This is just a template I'm setting up for firing up Sinatra apps quickly. You're welcome to build on it, if you like. It's far from finished.

## Some General Notes

Authentication is handled via [OmniAuth](https://github.com/intridea/omniauth), specifically using another template I created, [OmniAuth for Sinatra](https://github.com/charliepark/omniauth-for-sinatra). You'll need OAuth keys from a third-party, like Twitter.

The app requires a file in the ~/config directory, called 'config.rb'. This will need a few variables:
* CONSUMER_KEY = <the consumer key for your OAuth provider>
* CONSUMER_SECRET = <the consumer secret for your OAuth provider>
* SECRET_CSRF_TOKEN = <some long and hard-to-guess string, used to protect from CSRF>

The Sanitize gem is available. Generally, this would lead to something like this to keep malicious code out of the database:
    post '/article' do
      Article.create(:body => Sanitize.clean(params[:body]), :user_id => current_user.id, :created_at => Time.now)
      # whatever else, possibly: redirect '/'
    end



## Credits and Links

### Admin Stuff

#### OmniAuth

* https://github.com/charliepark/omniauth-for-sinatra



### Security Stuff

#### Sanitize


#### CSRF

* https://github.com/baldowl/rack_csrf
* http://emilloer.com/2011/01/15/preventing-csrf-in-sinatra/
