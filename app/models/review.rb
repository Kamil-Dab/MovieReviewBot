# frozen_string_literal: true

class Review < ApplicationRecord
  self.implicit_order_column = "created_at"

  belongs_to :movie
end
