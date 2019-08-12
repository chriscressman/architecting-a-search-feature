# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

shelley = Author.create(
  name: 'Mary Shelley',
  image: 'mary-shelley.jpg',
  description: 'Mary Wollstonecraft Shelley was an English novelist who wrote the Gothic novel Frankenstein; or, The Modern Prometheus. She also edited and promoted the works of her husband, the Romantic poet and philosopher Percy Bysshe Shelley.'
)

stevenson = Author.create(
  name: 'Robert Louis Stevenson',
  image: 'robert-louis-stevenson.jpg',
  description: "Robert Louis Stevenson was a Scottish novelist and travel writer, most noted for Treasure Island, Kidnapped, Strange Case of Dr Jekyll and Mr Hyde, and A Child's Garden of Verses."
)

wells = Author.create(
  name: 'H.G. Wells',
  image: 'h-g-wells.jpg',
  description: 'Herbert George Wells was an English writer. He was prolific in many genres, writing dozens of novels, short stories, and works of social commentary, satire, biography, and autobiography, and even including two books on recreational war games.'
)

horror = Genre.create(
  name: 'Horror',
  image: 'horror.jpg',
  description: 'Horror is a genre of speculative fiction which is intended to frighten, scare, disgust, or startle its readers by inducing feelings of horror and terror.'
)

scifi = Genre.create(
  name: 'Science Fiction',
  image: 'science-fiction.jpg',
  description: 'Science fiction (sometimes called Sci-Fi) is a genre of speculative fiction that has been called the "literature of ideas". It typically deals with imaginative and futuristic concepts such as advanced science and technology, time travel, parallel universes, fictional worlds, space exploration, and extraterrestrial life.'
)

adventure = Genre.create(
  name: 'Adventure',
  image: 'adventure.jpg',
  description: 'Adventure fiction is fiction that usually presents danger, or gives the reader a sense of excitement.'
)

frankenstein = Book.create(
  name: 'Frankenstein',
  image: 'frankenstein.jpg',
  description: 'Frankenstein; or, The Modern Prometheus is a novel written by English author Mary Shelley that tells the story of Victor Frankenstein, a young scientist who creates a hideous sapient creature in an unorthodox scientific experiment.',
  isbn: Faker::Code.unique.isbn,
  published_at: Time.new('2018'),
  author: shelley
)

jekyll_and_hyde = Book.create(
  name: 'Strange Case of Dr Jekyll and Mr Hyde',
  image: 'dr-jekyll-and-mr-hyde.jpg',
  description: 'Strange Case of Dr Jekyll and Mr Hyde is a gothic novella by Scottish author Robert Louis Stevenson, first published in 1886. The work is also known as The Strange Case of Jekyll Hyde, Dr Jekyll and Mr Hyde, or simply Jekyll & Hyde. It is about a London legal practitioner named Gabriel John Utterson who investigates strange occurrences between his old friend, Dr Henry Jekyll, and the evil Edward Hyde.',
  isbn: Faker::Code.unique.isbn,
  published_at: Time.new('2018'),
  author: stevenson
)

time_matchine = Book.create(
  name: 'The Time Machine',
  image: 'the-time-machine.jpg',
  description: 'The Time Machine is a science fiction novella by H. G. Wells, published in 1895 and written as a frame narrative. The work is generally credited with the popularization of the concept of time travel by using a vehicle or device to travel purposely and selectively forward or backward through time.',
  isbn: Faker::Code.unique.isbn,
  published_at: Time.new('2019'),
  author: wells
)

treasure_island = Book.create(
  name: 'Treasure Island',
  image: 'treasure-island.jpg',
  description: 'Treasure Island is an adventure novel by Scottish author Robert Louis Stevenson, narrating a tale of "buccaneers and buried gold."',
  isbn: Faker::Code.unique.isbn,
  published_at: Time.new('2019'),
  author: stevenson
)

frankenstein.genres << horror
jekyll_and_hyde.genres << horror
jekyll_and_hyde.genres << scifi
time_matchine.genres << scifi
treasure_island.genres << adventure
