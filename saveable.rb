require 'rubygems'
require 'active_support/inflector'

module Saveable
  def save_method
    class_name = self.class.to_s
    table_name = class_name.downcase.pluralize
    vars = self.instance_variables[1..-1]
    col_names = vars.map! { |col_name| col_name.to_s[1..-1] }
    query = "INSERT INTO
      #{table_name}(#{col_names.join(", ")})
      VALUES 
      (#{vars.map { |var| '"'+self.send(var)+'"'}.join(', ')})"
    AppAcademyDb.instance.execute(query)
  end
  
  def update_method
    class_name = self.class.to_s
    table_name = class_name.downcase.pluralize
    vars = self.instance_variables[1..-1]
    col_names = vars.map! { |col_name| col_name.to_s[1..-1] }
    

    mapped_vars = vars.map { |x| self.send(x)}
    
    p col_names
    mapped_vars_string = mapped_vars.each_with_index.map { |x, idx| "#{col_names[idx]} = " + "\'#{x}\'" }

    final_set = mapped_vars_string.join(", ")

    query = "UPDATE #{table_name}
    SET #{final_set}
    WHERE
    id = #{@id}"
    
    p query
    AppAcademyDb.instance.execute(query)
  end
end