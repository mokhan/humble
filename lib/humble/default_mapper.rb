class DefaultMapper
  attr_reader :session, :table

  def initialize(table, session)
    @table = table
    @session = session
  end

  def map_from(row)
    table.type.new.tap do |entity|
      table.each do |column|
        column.apply(row, entity, session)
      end
    end
  end
end
