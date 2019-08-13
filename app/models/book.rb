class Book < ApplicationRecord
  include Elasticsearch::Model
  belongs_to :author
  has_and_belongs_to_many :genres

  index_name "#{Rails.env}-books"

  settings number_of_replicas: 0 do
    mapping dynamic: 'false' do
      indexes :name, type: 'text' do
        indexes :raw, type: 'keyword'
      end
      indexes :image, type: 'keyword', index: false
      indexes :description, type: 'text'
      indexes :isbn, type: 'keyword'
      indexes :published_at, type: 'date'
      indexes :author_id, type: 'integer'

      indexes :published_at_year, type: 'integer'
      indexes :author_name, type: 'text'
      indexes :genre_ids, type: 'integer'
      indexes :genre_names, type: 'text'
    end
  end

  def published_at_year
    published_at.year
  end

  def author_name
    author.name
  end

  def genre_ids
    genres.map(&:id)
  end

  def genre_names
    genres.map(&:name)
  end

  def as_indexed_json(options={})
    as_json(
      methods: [
        :published_at_year,
        :author_name,
        :genre_ids,
        :genre_names
      ],
      except: [
        :created_at,
        :updated_at
      ]
    )
  end
end
