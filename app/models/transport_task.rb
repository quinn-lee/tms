class TransportTask < ApplicationRecord
	belongs_to :truck, :class_name => 'Truck', :foreign_key => :truck_id

	validates_presence_of :task_date, :truck_id
	before_validation :setup, :on => :create


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
