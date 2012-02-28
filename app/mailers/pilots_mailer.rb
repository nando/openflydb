class PilotsMailer < ActionMailer::Base
  default :from => "fernando.gs@gmail.com"

  def custom_email(pilot, subject, message)
    mail(:to => pilot.email, :subject => subject, :message => message)
  end  
end
