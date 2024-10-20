# frozen_string_literal: true

class CrawledData < ApplicationRecord
  self.implicit_order_column = "created_at"
end
