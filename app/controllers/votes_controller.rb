class VotesController < ApplicationController
  
  def new
    @vote = Vote.new
  end
  
  def create
    @vote = Vote.new(params[:vote])
    @vote.save
  end
  
end
