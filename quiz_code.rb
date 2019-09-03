# Q6 - Query to get books from before 1985
SELECT * FROM books WHERE year < 1985

# Q7 - Query to get 3 most recent books by Jules Verne
SELECT * FROM books
JOIN authors ON authors.id = books.author_id
WHERE authors.name = 'Jules Verne'
ORDER BY books.year DESC
LIMIT 3

# Q10 - Write migrations for our library schema
class CreateAuthors < ActiveRecord::Migration[5.1]
  def change
    create_table :authors do |t|
      t.string :name
      t.timestamps
    end
  end
end

class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :year
      t.references :authors, foreign_key: true
      t.timestamps
    end
  end
end

class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.timestamps
    end
  end
end

class CreateReadings < ActiveRecord::Migration[5.1]
  def change
    create_table :readings do |t|
      t.references :books, foreign_key: true
      t.references :users, foreign_key: true
      t.timestamps
    end
  end
end

# Q11 - Write a migration to add `category` to our `books` table
class AddCategoryToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :category, :string
  end
end

# Q12 - Define ActiveRecord models for each table of our DB, including relations.
class Author < ActiveRecord::Base
  has_many :books
end

class Book < ActiveRecord::Base
  belongs_to :author
  has_many :readings
  has_many :users, through: :readings
end

class User < ActiveRecord::Base
  has_many :readings
  has_many :books, through: :readings
end

class Reading < ActiveRecord::Base
  belongs_to :book
  belongs_to :user
end

# Q13 Complete the following code using relevant ActiveRecord methods.
# Add favorite author to the DB
Author.create(name: "Tom Clancy")
# Get all authors
Author.all
# Get author with id = 8
Author.find(8)
# Get "Jules Verne" and store in varaible `jules`
jules = Author.find_by(name: "Jules Verne")
# Get Jules Vernes books
jules.books
# Create new book with really long title, and store in variable
twenty_thousand = Book.new(title: "20000 Leagues Under the seas")
# Add Jules Verne as this books author
twenty_thousand.author = jules
# Save it in the DB
twenty_thousand.save
# The End!

# Q14 - Add validations of your choice to the `Author` class.
#       Can we save an object in DB if its validations do not pass?
class Author < ActiveRecord::Base
  has_many :books

  validates :name, presence: true
end

# Yes, we *can* save it, by using dirty tricks!
# The real answer is *no*.
# If the validations fail the object won't save to the DB.
