class ReportsController < ApplicationController

  before_filter :authenticate_user!, :only => [:new, :edit, :create, :update, :confirm, :inaccurate]
  before_filter :find_user, :only => [:confirm, :inaccurate]
  before_filter :find_report, :only => [:confirm, :inaccurate, :edit, :update]
  before_filter :match_report_user, :only => [:edit, :update]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json'}

  # POST /reports/:id/confirm
  # POST /reports/:id/confirm.json
  def confirm
    @report.add_evaluation(:confirm_votes, 1, @user) #reputation system
    @vote = Confirm.new(:report_id => params[:id], :user_id => @user.id)
    respond_to do |format|
      if @vote.save!
        format.html { redirect_to @report, notice: 'Report was confirmed.' }
        format.json { render json: @report, status: :created, location: @report }
      else
        format.html { render action: "show" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /reports/:id/inaccurate
  # POST /reports/:id/inaccurate.json
  def inaccurate
    @report.add_evaluation(:inaccurate_votes, 1, @user)
    @vote = Inaccurate.new
    @vote.report_id = params[:id]
    @vote.user_id = @user.id
    respond_to do |format|
      if @vote.save!
        format.html { redirect_to @report, notice: 'Report was marked as inaccurate.' }
        format.json { render json: @report, status: :created, location: @report }
      else
        format.html { render action: "show" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /reports.json
  def index
    @reports = Report.all
    render json: @reports.map(&:to_hash)
  end

  # GET /reports/1.json
  def show
    @report = Report.find(params[:id])

    render json: @report.to_hash
  end

  # GET /reports/new
  # GET /reports/new.json
  def new
    @report = Report.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @report }
    end
  end

  # GET /reports/1/edit
  def edit
    @report = Report.find(params[:id])
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(params[:report])
    @report.user_id = current_user.id
    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render json: @report, status: :created, location: @report }
      else
        format.html { render action: "new" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reports/1
  # PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update_attributes(params[:report])
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def find_user
    @user = current_user
  end

  def find_report
    @report = Report.find(params[:id])
  end

  def match_report_user
    current_user.id == @report.user_id
  end
end
