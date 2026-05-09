class CreateSeqToOrders < ActiveRecord::Migration[8.0]
  def self.up
    execute <<-SQL
      create sequence orders_seq increment by 1 minvalue 1 MAXVALUE 999999 start with 1 CYCLE;
    SQL
  end

  def self.down
    execute <<-SQL
      drop sequence orders_seq;
    SQL
  end
end
