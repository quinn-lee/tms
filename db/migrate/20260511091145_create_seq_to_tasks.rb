class CreateSeqToTasks < ActiveRecord::Migration[8.0]
  def self.up
    execute <<-SQL
      create sequence tasks_seq increment by 1 minvalue 1 MAXVALUE 999999 start with 1 CYCLE;
    SQL
  end

  def self.down
    execute <<-SQL
      drop sequence tasks_seq;
    SQL
  end
end
