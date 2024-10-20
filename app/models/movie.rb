# frozen_string_literal: true

class Movie < ApplicationRecord
  self.implicit_order_column = "created_at"

  has_many :reviews

  validates :movie_id, presence: true, uniqueness: true
end
