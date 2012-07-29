class Inaccurate < Vote

  belongs_to :report, :polymorphic => true
end
