class ReportsController < ApplicationController
  
  def new
    @report = Report.new
  end
  
  def create
    @report = Report.new(params[:report])
    if @report.save
      redirect_to @report
    else
      render :new
    end
  end
  
  def show
    @report = Report.find(params[:id])
  end
  
  def edit
    @report = Report.find(params[:id])
  end
  
  def update
    @report = Report.find(params[:id])
  end
  
  def destroy
    @report = Report.find(params[:id])
    @report.destroy
    redirect_to 'root'
  end
  
end
