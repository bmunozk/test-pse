# Saves the information Captured directly from Skyscanner to be split and analyzed later
class RouteCapture < ApplicationRecord
  include AASM
  has_many :route_options

  aasm(timestamps: true) do
    state :created, initial: true
    state :scheduled, after_enter: :schedule_processing
    state :processing
    state :processed

    event :schedule do
      transitions from: :created, to: :scheduled
    end
    event :process_start do
      transitions from: :scheduled, to: :processing # It should be scheduled to processing not created to processing
    end

    event :process_complete do
      transitions from: :processing, to: :processed
    end
  end

  def payload
    Oj.load(raw_payload).deep_transform_keys { |k| k.underscore.to_sym } #Keys are changed to snake case
  end

  def schedule_processing
    ProcessRouteCaptureJob.set(wait: 2.minutes).perform_later(self)
  end
end
