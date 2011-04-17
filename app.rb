%w(rubygems dm-core dm-migrations dm-sqlite-adapter oa-oauth sanitize sinatra).each { |dependency| require dependency }

require 'app/requirements'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/database.db")

class User
  include DataMapper::Resource
  property :id,         Serial
  property :uid,        String
  property :name,       String
  property :nickname,   String
  property :created_at, DateTime

  @@admin_users = ADMIN_UIDS

  def admin?
    @@admin_users.include?(uid.to_s)
  end
end

DataMapper.finalize
DataMapper.auto_upgrade!

get '/' do
  if current_user
    erb :index
  else
    erb :index_public
  end
end

enable :inline_templates

__END__

@@ layout
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Page Title</title>
    <style type="text/css">
      html,body,div,span,applet,object,iframe,h1,h2,h3,h4,h5,h6,p,blockquote,pre,a,abbr,acronym,address,big,cite,code,del,dfn,em,font,img,ins,kbd,q,s,samp,small,strike,strong,sub,sup,tt,var,b,u,i,center,dl,dt,dd,ol,ul,li,fieldset,form,label,legend,table,caption,tbody,tfoot,thead,tr,th,td{margin:0;padding:0;border:0;outline:0;font-size:100%;vertical-align:baseline;background:transparent}body{line-height:1}ol,ul{list-style:none}blockquote,q{quotes:none}blockquote:before,blockquote:after,q:before,q:after{content:'';content:none}:focus{outline:0}ins{text-decoration:none}del{text-decoration:line-through}table{border-collapse:collapse;border-spacing:0}article, aside, details, figcaption, figure, footer, header, hgroup, menu, nav, section{display:block}
      body, button, input, select, textarea{font-family:'lucida grande', 'helvetica neue',helvetica,arial,sans-serif;font-size:12px;line-height:20px}td{border-top:1px solid #ccc;padding:0 10px}th{font-weight:bold}
      a{border-bottom:1px solid #ccc;color:#00c;text-decoration:none;}
      body{margin:20px auto;width:500px;}
    </style>
  </head>
  <body>
  <div id="header"><h1>App Name</h1></div>
<%= yield %>
  <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"></script>
  <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.11/jquery-ui.min.js"></script>
  <script src="/javascripts/application.js" type="text/javascript"></script>
  <script type="text/javascript">
  $(function(){
    $().onloadEvents();
  };
  </script>
  </body>
</html>

@@ index
    <p>This is the logged-in page.</p>

@@ index_public
    <a href="/sign_up">create an account</a> or <a href="/sign_in">sign in with Twitter</a>
