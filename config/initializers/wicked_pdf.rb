puts Rails.root.join('bin', "wkhtmltopdf-#{Rails.env == :production ? 'amd64' : 'i386'}").to_s
WickedPdf.config = {
  :exe_path => Rails.root.join('bin', "wkhtmltopdf-#{Rails.env == :production ? 'amd64' : 'i386'}").to_s
}
