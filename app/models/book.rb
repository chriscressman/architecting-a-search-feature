class Book < ApplicationRecord
  include Elasticsearch::Model
  belongs_to :author
  has_and_belongs_to_many :genres

  after_save { SaveSearchBookJob.perform_later(id) }
  after_destroy { DestroySearchBookJob.perform_later(id) }

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

  def self.available_sorts
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

  def self.search(q, options={})
    selected_author = options[:author]
    selected_genre = options[:genre]
    selected_year = options[:year]
    selected_sort = available_sorts[options.fetch(:sort, :best)]

    search_definition = Elasticsearch::DSL::Search.search do

      query do
        bool do
          filter { term author_id: selected_author } if selected_author
          filter { term genre_ids: selected_genre } if selected_genre
          filter { term published_at_year: selected_year } if selected_year
          must do
            if q.present?
              multi_match do
                query q
                fields [
                  'isbn^10',
                  'name^9',
                  'author_name^5',
                  'genre_names^1',
                  'description'
                ]
              end
            else
              match_all
            end
          end
        end
      end

      sort do
        by selected_sort[:field], order: selected_sort[:order]
      end

      aggregation :authors do
        terms field: 'author_id'
      end
      aggregation :genres do
        terms field: 'genre_ids'
      end
      aggregation :years do
        terms field: 'published_at_year'
      end
    end

    __elasticsearch__.search(search_definition)
  end
end
