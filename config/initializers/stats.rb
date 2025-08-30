Rails.application.config.after_initialize do
  DoubtStat.instance if defined? Rails::Server
end
