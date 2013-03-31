#if Rails.env.development?
WickedPdf.config = {
    #:exe_path => Rails.root.join('bin', "wkhtmltopdf-amd64").to_s
    #:exe_path => Rails.root.join('bin', "wkhtmltopdf-i386").to_s
  :exe_path => '/app/vendor/bundle/ruby/1.9.1/bundler/gems/wkhtmltopdf-heroku-ad9f8e5f83fe/bin/wkhtmltopdf-linux-amd64'
}
#end
