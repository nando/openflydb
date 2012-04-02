# encoding: UTF-8
class PilotsController < ApplicationController
  before_filter :require_admin, :except => :create

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
    @pilots = Pilot.order(:name, :surname)
    respond_to do |format|
      format.html 
      format.json {
        pilots = @pilots.map{|p|
          {
            :name => p.name,
            :surname => p.surname,
            :brand => p.glider_manuf.upcase,
            :model => p.glider_model,
            :glider_class => p.glider_class,
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
    end

  end

  # GET /pilots/1
  # GET /pilots/1.xml
  def show
    @pilot = Pilot.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @pilot }
      format.pdf {
        render :pdf => "pilot_#{params[:id]}",
               :layout => 'layouts/application.html.erb'
      }
    end
  end

  # GET /pilots/new
  # GET /pilots/new.xml
  def new
    @pilot = Pilot.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pilot }
    end
  end

  # GET /pilots/1/edit
  def edit
    @pilot = Pilot.find(params[:id])
  end

  # POST /pilots
  # POST /pilots.xml
  def create
    @pilot = Pilot.new(params[:pilot])
    referer_base = request.referer[/^.*\//]
    redirect_to referer_base + (@pilot.save ? 'ok' : 'ko') + '.html'
  end

  # PUT /pilots/1
  # PUT /pilots/1.xml
  def update
    @pilot = Pilot.find(params[:id])

    respond_to do |format|
      if @pilot.update_attributes(params[:pilot])
        format.html { redirect_to(@pilot, :notice => 'Pilot was successfully updated.') }
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
    @pilot = Pilot.find(params[:id])
    @pilot.destroy

    respond_to do |format|
      format.html { redirect_to(pilots_url) }
      format.xml  { head :ok }
    end
  end
  private
    def require_admin
      return true if params[:action] == 'index' and params[:format] == 'json'
      set_admin_cookie if params[:admin]
      redirect_to("/404.html") unless admin?
    end

    def set_admin_cookie
      cookies[:admin] = Digest::SHA512.hexdigest("#{params[:admin]}")
    end

    def admin?
      require 'digest/sha2'
      "#{cookies[:admin]}" == "be937be440e14e7321f3faaff47e4643afd21e820c65fc2ea3f2d571fcee558e0da40eb43bdc5cbbb768a94979b4e4d2d72f9f30e5033b7347d0a1b7fba15e74"
    end
end
