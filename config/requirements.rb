# get all of the behind-the-scenes libraries and other helping bits
%w(config auth admin).each { |dependency| require 'config/'+dependency }

# mimics the Rails structure, pulls it all together
%w(models controllers helpers).each { |file| require 'app/'+file }
