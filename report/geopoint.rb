class Geopoint
  EARTH_RADIUS_METERS = 6371e3

  attr_reader :latitude, :longitude

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude  
  end

  def distance_in_km(other_point)
    h = haversine_func(other_point)
    EARTH_RADIUS_METERS * h / 1000
  end

  private 

  def haversine_func(other_point)
    d_lat = d_lat(other_point)
    d_lon = d_lon(other_point)
    a = Math.sin(d_lat / 2) * Math.sin(d_lat / 2) +
        Math.cos(self.to_radians.latitude) * 
        Math.cos(other_point.to_radians.latitude) *
        Math.sin(d_lon / 2) * Math.sin(d_lon / 2)

    2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)) 
  end

  def d_lat(other_point)
    other_point.to_radians.latitude - self.to_radians.latitude
  end

  def d_lon(other_point)
    other_point.to_radians.longitude - self.to_radians.longitude
  end

  def degrees_to_radians(value)
    value * Math::PI / 180 
  end 

  def radians_to_degrees(value)
    value * 180 / Math::PI
  end
end

class GeopointDegrees < Geopoint
  def to_radians
    GeopointRadians.new(
      degrees_to_radians(latitude), 
      degrees_to_radians(longitude)
    ) 
  end

  def to_degrees
    self
  end

  def within_range?(ref_geopoint, max_distance)
    distance_in_km(ref_geopoint) <= max_distance
  end
end

class GeopointRadians < Geopoint
  def to_radians
    self
  end

  def to_degrees
    GeopointDegrees.new(
      radians_to_degrees(latitude), 
      radians_to_degrees(longitude)
    ) 
  end
end
