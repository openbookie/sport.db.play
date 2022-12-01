# encoding: UTF-8

module SportDb::Market


class CreateDb < ActiveRecord::Migration

  def up

create_table :services do |t|  # quote service (e.g. tipp3,tipico,etc.)
  t.string     :title,  :null => false
  t.string     :key,    :null => false
  t.timestamps
end

create_table :quotes do |t|
  t.references :service, :null => false   # quote service (e.g. tipp3,tipico,etc.)
  t.references :game,    :null => false
  t.decimal    :odds1,   :null => false
  t.decimal    :oddsx,   :null => false
  t.decimal    :odds2,   :null => false
  t.string     :comments
  t.timestamps
end

create_table :event_quotes do |t|
  t.references  :service, :null => false   # quote service (e.g. tipp3,tipico,etc.)
  t.references  :event,   :null => false
  t.references  :team,    :null => false
  t.decimal     :odds,    :null => false   # winner odds (e.g. 3,5 or 90 etc.)
  t.string      :comments
  t.timestamps
end

create_table :group_quotes do |t|
  t.references  :service, :null => false   # quote service (e.g. tipp3,tipico,etc.)
  t.references  :group,   :null => false
  t.references  :team,    :null => false
  t.decimal     :odds,    :null => false   # winner odds (e.g. 3,5 or 90 etc.)
  t.string      :comments
  t.timestamps
end

  end # method up

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end # class CreateDb


end # module SportDb::Market
