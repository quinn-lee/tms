class TransportTask < ApplicationRecord
	belongs_to :truck, :class_name => 'Truck', :foreign_key => :truck_id, optional: true
  belongs_to :branch, :class_name => 'Branch', :foreign_key => :branch_id, optional: true

	#validates_presence_of :task_date, :truck_id
	before_validation :setup, :on => :create


  def sort_orders
    url="https://routes.googleapis.com/directions/v2:computeRoutes"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl =  true
    request = Net::HTTP::Post.new(uri.request_uri,initheader = {'Content-Type' =>'application/json', 'X-Goog-Api-Key'=>Rails.application.credentials.dig(:google, :apikey), 'X-Goog-FieldMask'=>'routes,geocodingResults.intermediates.intermediateWaypointRequestIndex'})
    intermediates = []
    OrderRoute.where(id: TaskOrderRelation.where(task_id: self.id).map(&:order_route_id)).order("id asc").each do |route|
      intermediates << {address: "#{route.last_detail['street']}#{route.last_detail['streetnum']} #{route.last_detail['housenum']},#{route.last_detail['city']}"}
    end
    params = {
      origin: {
        address: "#{branch.address}, #{branch.city}"
      },
      destination: {
        address: "#{branch.address}, #{branch.city}"
      },
      intermediates: intermediates,
      travelMode: "DRIVE",
      optimizeWaypointOrder: "true"
    }
    request.body=params.to_json
    response=http.request(request)
    res = JSON.parse(response.body)
  end

	private
	def setup
    self.task_no ||= gen_task_no
    self.status ||= "pending"
    self.driver_ids ||= []
  end

  def gen_task_no
    seq = ActiveRecord::Base.connection.execute("select nextval('tasks_seq')")[0]['nextval']
    "TT#{Time.now.strftime('%y%m%d')}#{sprintf('%06d', seq)}"
  end
end
