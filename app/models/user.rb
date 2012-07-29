class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :password, :password_confirmation, :remember_me

  has_many    :reports
  has_many    :votes
  has_many    :evaluations, class_name: "RSEvaluation", :as => :source
  
  has_reputation :trustworthiness,
    :source => { :reputation => :confirm_votes, :of => :reports},
    :aggregated_by => :sum


  has_reputation :dishonesty,
    :source => { :reputation => :inaccurate_votes, :of => :reports},
    :aggregated_by => :sum

  has_reputation :karma,
      :source => [
          { :reputation => :trustworthiness, :weight => 1.0 },
          { :reputation => :dishonesty, :weight => -1.0 }],
      :aggregated_by => :sum
  
  def voted_for?(report)
    evaluations.where(target_type: report.class, target_id: report.id).present?
  end
  
end
