class SaveSearchBookJob < ApplicationJob
  queue_as :default

  def perform(book_id)
    book = Book.find(book_id)
    book.__elasticsearch__.index_document
  end
end
