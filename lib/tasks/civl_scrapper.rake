#encoding: UTF-8
require 'rubygems'
require 'cgi'
require 'open-uri'
require 'hpricot'
require 'mechanize'

#require 'ruby-debug'

namespace :openflydb do

  def elems_for(pilot)
puts pilot
      url = 'http://civlrankings.fai.org/FL.aspx?a=308'
      page = agent.post(url, {"ctl02$ctr_search_for_person" => pilot,
        '__EVENTARGUMENT' => '',	
        '__EVENTTARGET' => '',	
        '__LASTFOCUS' => '',	
        'ctl02$ctr_search_button' => 'Find',
        '__VIEWSTATE' => '/wEPDwULLTE2OTc3ODE0MDBkZKbgiS2cHL1GR70jvZbMrJbmDVnn'})
      doc = Hpricot(page.parser.to_s)
      elems = doc/"td[@class=list_row]"
  end


  desc "Carga de datos de los pilotos desde fai.org"
  task :civl_scrapper => :environment do
    COUNTRIES = {
      'Spain' => 'ESP',
      'Portugal' => 'PRT'
    }
    agent = Mechanize.new

    Pilot.all.each do |p|
      elems = elems_for(p.name + ' ' + p.surname)
      elems = elems_for(p.name + ' ' + p.surname).gsub(/ñ/,'n') unless elems.size == 4
      elems = elems_for(p.name.gsub(/ \(.+\)/, '') + ' ' + p.surname) unless elems.size == 4
      elems = elems_for(p.name.gsub(/ \(.+\)/, '') + ' ' + p.surname).gsub(/ñ/,'n') unless elems.size == 4
      if elems.size == 4
        civl_id = elems[0].inner_html
        sex = elems[2].inner_html
        nat = COUNTRIES[elems[3].inner_html]
        puts "#{pilot} #{civl_id} #{nat} #{sex}"
      else
        puts "=================================> Piloto no encontrado '#{pilot}'"
      end
      sleep 2
    end
    
  end
end
