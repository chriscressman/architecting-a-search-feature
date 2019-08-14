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

  def self.sorts
    {
      best: {
        display_name: 'Best Match',
        field: '_score',
        order: 'desc'
      },
      date: {
        display_name: 'Date Published',
        field: 'published_at',
        order: 'desc'
      },
      title: {
        display_name: 'Title',
        field: 'name.raw',
        order: 'asc'
      }
    }
  end

  # search_definition(
  #   'frankenstein',
  #   :date,
  #   { authors: [1], genres: [1,2], published_at_years: [2018] }
  # )
  def self.search_definition(search_query, sort=:best, filters={})
    Elasticsearch::DSL::Search.search do

      query do
        multi_match do
          query search_query
          fields [
            'isbn^10',
            'name^9',
            'author_name^5',
            'genre_names^1',
            'description'
          ]
        end
      end

      sort do
        by Book.sorts[sort][:field], order: Book.sorts[sort][:order]
      end
    end
  end
end
