require_relative 'game'
require_relative 'collection'
require 'csv'
<<<<<<< HEAD

class GameCollection
  attr_accessor :games

class GameCollection < Collection
  def initialize(csv_file_path)
    super(csv_file_path, Game)
  end
end
