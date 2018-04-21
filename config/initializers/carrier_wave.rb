if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'backblaze',
      :b2_account_id         => ENV['B2_ACCOUNT_ID'],
      :b2_account_token      => ENV['B2_ACCOUNT_TOKEN'],
    #   :b2_bucket_name        => ENV['B2_BUCKET_NAME'],
    #   :b2_bucket_id          => ENV['B2_BUCKET_ID'],
    }
    config.fog_directory     =  ENV['B2_BUCKET_ID']
  end
end
