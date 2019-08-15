class DestroySearchBookJob < ApplicationJob
  queue_as :default

  def perform(book_id)
    client = Book.__elasticsearch__.client
    index = Book.index_name
    client.delete(index: index, id: book_id)
  end
end
