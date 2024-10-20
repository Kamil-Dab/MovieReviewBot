class CreateCrawledData < ActiveRecord::Migration[6.1]
  def change
    create_table :crawled_data do |t|
      t.text(:method)
      t.text(:url)
      t.jsonb(:headers)
      t.binary(:result)

      t.timestamps
    end
  end
end
