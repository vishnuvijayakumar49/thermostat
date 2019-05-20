# frozen_string_literal: true

APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env].with_indifferent_access
