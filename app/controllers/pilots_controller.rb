# encoding: UTF-8
class PilotsController < ApplicationController
  before_filter :require_admin, :except => :create
  before_filter :set_pilot_and_competition, :only => [:show, :edit, :update, :destroy]

  def mailer_form
  end

  def send_mail
    pilot = Pilot.find_by_surname('García Samblas')
    PilotsMailer.custom_email(pilot, params[:subject], params[:message])
    redirect_to :action => :mailer_form
  end


  # GET /pilots
  # GET /pilots.xml
  def index
    @pilots = if params[:format].nil? and params[:view] == 'admin'
      competition.pilots.order(:fsdb_id)
    else
      competition.pilots.order(:name, :surname)
    end
    respond_to do |format|
      format.html {
        if params[:view] == 'admin' and params[:emails] == 'true'
          render :text => @pilots.map{|p| p.email}.join(',')
        else
          render :action => "index#{'_admin' if params[:view] == 'admin'}.html.erb"
        end
      }
      format.json {
        pilots = @pilots.map{|p|
          {
            :fsdb_id => p.fsdb_id,
            :name => p.name,
            :surname => p.surname,
            :brand => p.glider_manuf.upcase,
            :model => p.glider_model,
            :glider_class => p.glider_class,
            :club => p.club_name.upcase,
            :nat => p.nationality.upcase,
            :paid => p.paid?
          }
        }
        render :json => pilots.to_json, :callback => params[:callback]
      }
      format.fsdb
      format.csv {
        render :layout => false
      }
      format.xml {
        respond_with @pilots
      }
      format.pdf {
        render :pdf => "registro_de_despegues",
               :layout => 'layouts/application.html.erb'
      }
    end

  end

  # GET /pilots/1
  # GET /pilots/1.xml
  def show
    respond_to do |format|
      format.html { render :action => 'show.pdf.erb' }
      format.xml { render :xml => @pilot }
      format.pdf {
        render :pdf => "piloto_#{params[:id]}",
               :layout => 'layouts/application.html.erb'
      }
    end
  end

  # GET /pilots/new
  # GET /pilots/new.xml
  def new
    @pilot = Pilot.new(:competition => competition)

    respond_to do |format|
      format.html #{ render :action => 'show.pdf.erb' } 
      format.xml  { render :xml => @pilot }
      format.pdf {
        render :pdf => "inscripcion_open_de_pb",
               :template => 'pilots/show',
               :layout => 'layouts/application.html.erb'
      }
    end
  end

  # GET /pilots/1/edit
  def edit
  end

  # POST /pilots
  # POST /pilots.xml
  def create
    @pilot = Pilot.new(params[:pilot])
    @pilot.surname = params[:pilot][:surname].strip
    @pilot.competition ||= competition
    redirect_to referer_base + (@pilot.save ? '/ok' : '/ko') + '.html'
  rescue
    logger.info $!
    redirect_to referer_base + '/ko.html'
  end

  # PUT /pilots/1
  # PUT /pilots/1.xml
  def update
    respond_to do |format|
      if @pilot.update_attributes(params[:pilot])
        format.html { redirect_to(@pilot,
          :view => 'admin',
          :notice => 'Pilot was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pilot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pilots/1
  # DELETE /pilots/1.xml
  def destroy
    @pilot.destroy

    respond_to do |format|
      format.html { redirect_to pilots_url(:view => 'admin') }
      format.xml  { head :ok }
    end
  end
  private
    def require_admin
      return true if public_index?
      set_admin_cookie if params[:admin]
      redirect_to("/404.html") unless admin?
    end

    def public_index?
      params[:action] == 'index' and %w{json pdf}.include?(params[:format])
    end

    def set_admin_cookie
      cookies[:admin] = Digest::SHA512.hexdigest("#{params[:admin]}")
    end

    def admin?
      require 'digest/sha2'
      "#{cookies[:admin]}" == "be937be440e14e7321f3faaff47e4643afd21e820c65fc2ea3f2d571fcee558e0da40eb43bdc5cbbb768a94979b4e4d2d72f9f30e5033b7347d0a1b7fba15e74"
    end

    def referer_base
      @referer_base ||= request.referer[/^.*\//][0..-2]
    end

    def competition
      @competition ||= (params[:competition_id] ? Competition.find(params[:competition_id]) :  Competition.find_by_url(referer_base))
    end

    def set_pilot_and_competition
      @pilot = Pilot.find(params[:id])
      @competition = @pilot.competition
    end
end
