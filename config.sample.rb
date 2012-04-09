# config.sample.rb

config = Hash.new

# these next two options can be overridden through the url
config[ 'browser' ] = 'firefox'
config[ 'operating' ] = 'headless'

# password is changed every so often
config[ 'login_url' ] = 'https://atm-sample-login-url.info'
config[ 'username' ] = 'username'
config[ 'password' ] = 'password'

terminal = Array.new
# there should be as many fields before as ATM terminals
terminal[] = 'Sample Terminal One Street Address'
terminal[] = 'Sample Terminal Two Street Address'
terminal[] = 'Sample Terminal Three Street Address'
terminal[] = 'Sample Terminal Four Street Address'
terminal[] = 'Sample Terminal Five Street Address'