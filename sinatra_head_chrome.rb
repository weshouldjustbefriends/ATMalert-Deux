# sinatra.rb
require 'rubygems'
require 'nokogiri'
require 'logger'
require 'mechanize'
require 'watir-webdriver'
require 'headless'
require 'sinatra'

require 'config'

helpers do
  def parse_single_result( doc )
    balance = doc.css( 'b' )[ 1 ].next
    #clean up
    balance = balance.to_s.strip
    #remove the beginning $ and any commas
    balance = balance.gsub(/[^0-9\.]/, "")
    balance = balance.to_i

    ##

    columns = Array.new

    lulz = doc.css( 'table[class=ATMAssistDefaultDataGrid]' ).css( 'tr')

    lulz[ 1 ].css( 'td' ).each do |single_column|
      columns << single_column.text
    end

    ##

    proper_columns = Hash.new

    #[1..-1] removes the beginning $
    proper_columns[ 'time' ] = columns[ 0 ]
    proper_columns[ 'sequence' ] = columns[ 1 ]
    proper_columns[ 'credit_card' ] = columns[ 2 ]
    proper_columns[ 'withdrawal_amount' ] = columns[ 3 ][ 1..-1 ].to_i
    proper_columns[ 'surcharge' ] = columns[ 4 ][ 1..-1 ].to_i
    proper_columns[ 'authorization' ] = columns[ 5 ]
    proper_columns[ 'cmpcd' ] = columns[ 6 ]
    proper_columns[ 'transaction_type' ] = columns[ 7 ]
    proper_columns[ 'network' ] = columns[ 8 ]

    if proper_columns[ 'authorization' ] == 'APPROVED'
      proper_columns[ 'balance'] = balance - proper_columns[ 'withdrawal_amount' ]
    else
      proper_columns[ 'balance'] = balance
    end

    return proper_columns
  end
  
  def output_pretty( args )
    lulz = ''
    args.each do |index,vitamin|
      lulz = lulz + "<b>#{index}:</b> #{vitamin} <br />"
    end    
    return lulz
  end
end

before do
  @wut = erb :filler
  @wut
end

get '/' do
  stream do |out|
    out << '<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>ATMalert Deux</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le styles -->
    <link href="css/bootstrap.css" rel="stylesheet">
    <style type="text/css">
      body {
        padding-top: 60px;
        padding-bottom: 40px;
      }
    </style>
    <link href="css/bootstrap-responsive.css" rel="stylesheet">

    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="ico/favicon.ico">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="ico/apple-touch-icon-57-precomposed.png">
  </head>

  <body>

    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </a>
          <a class="brand" href="#">ATMalert [Deux]</a>
          <div class="nav-collapse">
            <ul class="nav">
              <li class="active"><a href="#">Home</a></li>
              <li><a href="#about">About</a></li>
              <li><a href="#contact">Contact</a></li>
            </ul>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>

    <div class="container">

      <!-- Le javascript
      ================================================== -->
      <!-- Placed at the end of the document so the pages load faster -->
      <script src="js/jquery-1.7.1.min.js"></script>
      <script src="js/bootstrap.min.js"></script>
      
      <!-- Main hero unit for a primary marketing message or call to action -->
      <div class="hero-unit">
        <h1>Hello, world!</h1>
        <br />
        <p>'
    
    headless = Headless.new
    headless.start
    
    out << "<i>Starting up browser...</i> <br />"
    out << '<script> $( "#progressbar" ).progressbar({ value: 0 }); </script>'
    out << 'var percentage = 20; $("#progressbar").progressbar(\'value\',percentage);'
    
    out << "<i>Starting up browser...</i> <br />"
    browser = Watir::Browser.new config[ 'browser' ].to_sym
    browser.goto config[ 'login_url' ]
    
    out << "<i>Logging in...</i> <br />"
    browser.text_field( :name => 'StandardLoginControl1$LoginUserNameTextbox' ).set config[ 'username' ]
    browser.text_field( :name => 'StandardLoginControl1$LoginPasswordTextbox' ).set config[ 'password' ]
    browser.button( :type => 'submit' ).click

    out << "<i>Prepping to go to terminal result page(s)...</i> <br /><br />`"
    browser.text.include? 'Welcome '
    browser.goto config[ 'terminal_selection_url' ]
    browser.button( :type => 'submit' ).click
    
    terminal.each_with_index {|identifier, index| puts "#{x} => #{y}" }
      out << "<i>Scraping ATM ##{index}...</i> <br />"
      browser.text.include? identifier
      doc = Nokogiri::HTML.parse( browser.html )
      the_return = parse_single_result( doc )
      final_return = output_pretty( the_return )
      out << final_return + "<br />"
      browser.button( :name => 'btnTermUp' ).click
    end
    
    out << "Done. <br />"
    
    browser.close
    headless.destroy
    
    out << '        </p>
      </div>

      <hr>

      <footer>
        <p>&copy; Ats Co[rp]. 2011-2012 | Developers | Legal</p>
      </footer>

    </div> <!-- /container -->

  </body>
</html>'
  end
end

get '/hai' do
  @wut = erb :filler
  @wut
end