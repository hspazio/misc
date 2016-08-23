require 'json'

class Customer
  include Enumerable

  class StoreError < StandardError; end

  attr_reader :id, :name, :geopoint

  def self.store=(file_store)
    @store = file_store
  end

  def self.within_geopoint_range(ref_geopoint, max_distance)
    each.select{ |c| c.within_range?(ref_geopoint, max_distance) }  
  end

  def self.each(&block)
    return to_enum(__callee__) unless block_given?
    open_store.each_line do |line|
      yield Customer.initialize_from_json(line)
    end
  end

  def self.open_store
    begin
      open(@store)
    rescue
      raise StoreError, 'Store not yet registered'
    end
  end

  private_class_method :open_store

  def self.initialize_from_json(json)
    params = JSON.parse(json, symbolize_names: true)

    new(id:       params[:user_id], 
    	name:     params[:name],
    	geopoint: GeopointDegrees.new(
    	  params[:latitude].to_f,
    	  params[:longitude].to_f))
  end
  
  def initialize(id:, name:, geopoint:)
    @id       = id
    @name     = name
    @geopoint = geopoint
  end

  def within_range?(ref_geopoint, max_distance)
    geopoint.within_range?(ref_geopoint, max_distance)
  end
end
