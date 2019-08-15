class Genre < ApplicationRecord
  has_and_belongs_to_many :books,
    after_add: :save_search_book,
    after_remove: :save_search_book

  def save_search_book(book)
    SaveSearchBookJob.perform_later(book.id)
  end
end
