class CustomerInviteReport
  def initialize(ref_geopoint)
    @reference_geopoint = ref_geopoint
  end

  def name_and_id_within_range(max_distance)  
    Customer.within_geopoint_range(@reference_geopoint, max_distance)
      .map{ |c| { name: c.name , id: c.id } }
      .sort_by{ |c| c[:id] }
  end
end