class ChangePriceToDecimal < ActiveRecord::Migration
  def up
  	  change_column :bills, :price, :decimal, :precision => 6, :scale => 2
  end
end
