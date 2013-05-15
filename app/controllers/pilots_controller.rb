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
            :name => p.name.titleize,
            :surname => p.surname.titleize,
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
    @pilot = Pilot.new
    @pilot.competition = competition

    respond_to do |format|
      format.html #{ render :action => 'show.pdf.erb' } 
      format.xml  { render :xml => @pilot }
      format.pdf {
        render :pdf => I18n.transliterate("hoja de inscripción #{@competition.name}").parameterize,
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
    @pilot = Pilot.new(params[:pilot], :without_protection => true)
    @pilot.surname = params[:pilot][:surname].strip
    @pilot.competition ||= competition
    redirect_to referer_base + (@pilot.save ? '/ok' : '/ko') + ".html?competition_id=#{competition.id}"
  rescue
    logger.info $!
    redirect_to referer_base + "/ko.html?competition_id=#{@pilot.competition_id}"
  end

  # PUT /pilots/1
  # PUT /pilots/1.xml
  def update
    respond_to do |format|
      if @pilot.update_attributes(params[:pilot], :without_protection => true)
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
      format.html { redirect_to pilots_url(:view => 'admin', :competition_id => @pilot.competition_id) }
      format.xml  { head :ok }
    end
  end
  private
    def require_admin
      redirect_to("/404.html") unless public_index? or admin?
    end

    def public_index?
      params[:action] == 'index' and %w{json pdf}.include?(params[:format])
    end

    def current_user
      @current_user ||= if session[:user_id]
                          Pilot.find_by_id session[:user_id]
                        elsif params[:admin] and admin = Pilot.find_with_password(params[:admin])
                          session[:user_id] = admin.id
                          admin
                        end
    end

    def admin?
      current_user && current_user.admin?
    end

    def referer_base
      @referer_base ||= request.referer[/^.*\//][0..-2]
    end

    def competition
      @competition ||= (params[:competition_id] ? Competition.find(params[:competition_id]) :  Competition.find_by_url(referer_base))
    end

    def set_pilot_and_competition
      if params[:id] == 'ok' or params[:id] == 'ko'
        redirect_to :action => 'index', :view => 'admin', :competition_id => params[:competition_id]
      else
        @pilot = Pilot.find(params[:id])
        @competition = @pilot.competition
      end
    end
end
