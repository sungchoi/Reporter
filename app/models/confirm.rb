class Confirm < Vote

  belongs_to :report, :polymorphic => true
end
