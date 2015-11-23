require "pg"
require 'pry'

TITLES = ["Roasted Brussels Sprouts",
  "Fresh Brussels Sprouts Soup",
  "Brussels Sprouts with Toasted Breadcrumbs, Parmesan, and Lemon",
  "Cheesy Maple Roasted Brussels Sprouts and Broccoli with Dried Cherries",
  "Hot Cheesy Roasted Brussels Sprout Dip",
  "Pomegranate Roasted Brussels Sprouts with Red Grapes and Farro",
  "Roasted Brussels Sprout and Red Potato Salad",
  "Smoky Buttered Brussels Sprouts",
  "Sweet and Spicy Roasted Brussels Sprouts",
  "Smoky Buttered Brussels Sprouts",
  "Brussels Sprouts and Egg Salad with Hazelnuts"]

def db_connection
  begin
    connection = PG.connect(dbname: "brussels_sprouts_recipes")
    yield(connection)
  ensure
    connection.close
  end
end

# CREATE TABLE recipes (names varchar(200));
# CREATE TABLE comments (comments varchar(300), names varchar(200));

TITLES.each do |title|
  db_connection do |conn|
    conn.exec_params("INSERT INTO recipes (names) VALUES ($1)", [title])
  end
end

db_connection do |conn|
  conn.exec_params("INSERT INTO comments (comments,names) VALUES ($1, $2)", ['This recipe is the absolute best!', 'Brussels Sprouts with Goat Cheese'])
end

db_connection do |conn|
  conn.exec_params("INSERT INTO comments (comments,names) VALUES ($1, $2)", ['The goat cheese... it\'s all about the goat cheese!!', 'Brussels Sprouts with Goat Cheese'])
end

db_connection do |conn|
  conn.exec_params("SELECT COUNT(*) FROM recipes")
end

db_connection do |conn|
  conn.exec_params("SELECT COUNT(names) FROM comments")
end

db_connection do |conn|
  conn.exec_params("SELECT COUNT(comments) FROM comments")
end

db_connection do |conn|
  conn.exec_params("SELECT * FROM comments WHERE names = 'Brussels Sprouts with Goat Cheese'")
end
