# encoding: UTF-8
class CompetitionsController < ApplicationController
  before_filter :require_admin

  def index
    @competitions = Competition.order('id DESC')
  end

end
