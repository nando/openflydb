if Rails.env.development?
  WickedPdf.config = {
    #:exe_path => Rails.root.join('bin', "wkhtmltopdf-amd64").to_s
    :exe_path => Rails.root.join('bin', "wkhtmltopdf-i386").to_s
  }
end
