defmodule ExGcloudPubsubPuller.Scheduler do
  use Quantum.Scheduler,
    otp_app: :ex_gcloud_pubsub_puller
end
