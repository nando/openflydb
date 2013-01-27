# encoding: UTF-8
class CreateCompetitions < ActiveRecord::Migration
  def change
    #create_table :competitions do |t|
    #  t.string :name
    #  t.string :dates
    #  t.string :url
    #  t.string :logo_url
    #  t.string :location
    #  t.string :from
    #  t.string :to
    #end
    [
     {
      :name => 'I Open de Ala Delta de Pedro Bernardo',
      :dates => 'Del 28 de abril a 1 de Mayo de 2012',
      :url => 'http://primer.opendepb.com',
      :location => 'Pedro Bernardo - Ávila (Spain)',
      :from => '2012-04-28',
      :to => '2012-05-01',
      :logo_url => 'http://primer.opendepb.com/images/logo.png'
     },
     {
      :name => 'II Open FAI de Ala Delta de Pedro Bernardo',
      :dates => 'Del 1 al 4 de Mayo de 2013',
      :url => 'http://segundo.opendepb.com',
      :location => 'Pedro Bernardo - Ávila (Spain)',
      :from => '2013-05-01',
      :to => '2013-05-04',
      :logo_url => 'http://segundo.opendepb.com/images/logo.png'
     },
     {
      :name => 'Campeonato de España de Ala Delta Piedrahita 2013',
      :dates => 'Del 19 al 27 de Julio de 2013',
      :url => 'http://piedrahita2013.com',
      :location => 'Piedrahita - Ávila (Spain)',
      :from => '2013-07-19',
      :to => '2013-07-27',
      :logo_url => 'http://piedrahita2013.com/images/logo.png'
     }
    ].each do |params|
      comp = Competition.create(params, :without_protection => true)
    end
  end
end
