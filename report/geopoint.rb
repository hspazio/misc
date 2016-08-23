module Geopoint
  EARTH_RADIUS = 6371e3

  def self.degrees_to_radians(value)
    value * Math::PI / 180 
  end 

  def self.radians_to_degrees(value)
    value * 180 / Math::PI
  end

  def self.distance_in_km(point_1, point_2)
  	point_1 = point_1.to_radians if point_1.is_a?(Degrees)
  	point_2 = point_2.to_radians if point_2.is_a?(Degrees)

    d_lat = point_2.latitude - point_1.latitude
    d_lon = point_2.longitude - point_1.longitude

    h = haversine_func(point_1, point_2, d_lat, d_lon)
    distance = EARTH_RADIUS * h / 1000
  end

  def self.haversine_func(point_1, point_2, d_lat, d_lon)
    a = Math.sin(d_lat / 2) * Math.sin(d_lat / 2) +
        Math.cos(point_1.latitude) * Math.cos(point_2.latitude) *
        Math.sin(d_lon / 2) * Math.sin(d_lon / 2)

    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)) 
  end
  
  private_class_method :haversine_func

  Degrees = Struct.new(:latitude, :longitude) do
    def to_radians
      Radians.new(
      	Geopoint.degrees_to_radians(latitude), 
      	Geopoint.degrees_to_radians(longitude)
      ) 
    end

    def within_range?(ref_geopoint, max_distance)
      Geopoint.distance_in_km(self, ref_geopoint) <= max_distance
    end
  end

  Radians = Struct.new(:latitude, :longitude) do
    def to_degrees
      Degrees.new(
      	Geopoint.radians_to_degrees(latitude), 
      	Geopoint.radians_to_degrees(longitude)
      ) 
    end
  end
end