#!/usr/bin/env ruby
#created by deden ari januar (dedenarijanuar@gmail.com)
#generate result data on tables and parsing to html

class Generator
  require File.expand_path('../../config/environment', __FILE__)
  
  def check_tables
    tables = [];
    puts "\n=================================================================\n"
    puts "you must input one or more tables on database of your application"
    puts "you have tables:\n"
    
    #check all table on database your application
    ActiveRecord::Base.connection.tables.map { |t| tables << t }
    tables.delete_if{|x| x == "schema_migrations" }
    tables.map{|t| puts "-> #{t} => #{t.to_s.classify.constantize.count rescue 0} record"  }
    
    puts "\nto generate result data on table, you should input the command:"
    puts "-> ./script/generate_table_data.rb name_your_table\n\n"
    puts "or if you want to generate multiple result_data:"
    puts "-> ./script/generate_table_data.rb name_your_table1/name_your_table2/name_your_table3\n"
    puts "\n                         ||||                                    \n"
    puts "\n\n Thanks for using. \n created by: Deden Ari Januar\n"
    puts "\n email: dedenarijanuar@gmail.com\n skype: dedenarijanuar\n\n\n"
    puts "\n=================================================================\n"
  end
  
  def generate_result(tables)
    models = []
    tables.split('/').each do |s|
      models << s.to_s.classify.constantize rescue nil
    end
    generate_view(models)
  end
  
  def generate_view(tables)
    html = "";
    #check table if data nil or empty don't push into html
    tables.delete_if{|x| x.blank? }
    tables.delete_if{|x| x.first.nil? }
    
    puts "\n=================================================================\n\n\n"
    puts "loading..."
    
    html << "<style> th {background: silver; padding: 5px 10px;} td {background: whitesmoke; padding: 5px 10px;} </style>"

      tables.each do |table|
        html << "<div style='overflow: scroll; width: 88%; float: left; height: 100%;'>"
          html << "<h2 id='#{table.name}'>#{table.name} data</h2>"
          html << "<table border='0' style='font-size: 11px;' cellpadding='0' cellspacing='0'>"
          html << "<tr>"
          html << "<th>id</th>"
          table.first.attributes.each do |x,y|
            html << "<th>#{x}</th>"
          end
          html << "</tr>"

          table.all.each_with_index do |t, i| 
            html << "<tr>"
            html << "<td> #{i+1} </td>"
            t.attributes.each do |x,y|
              html << "<td> #{y} </td>"
            end   
            html << "</tr>"
          end 
          html << "</table>"
        html << "</div>"
      end
    html << "<div style='position: fixed; right:18px;'>"
      html << "<h3>Table names</h3>"
      tables.each do |table|
        html << "<a href='##{table.name}'> #{table.name}</a><hr/>"
      end
    html << "</div>"

    puts "get result as HTML format..."
    
    File.open("tmp/generate_table_data.html", 'w') {|f| f.write(html) }
    puts "open on firefox browser"
    system("firefox tmp/generate_table_data.html")

    puts "done."
    puts "the file has been saved in tmp/generate_table_data.html"
    puts "\n                         ||||                                    \n"
    puts "\n\n Thanks for using. \n created by: Deden Ari Januar\n"
    puts "\n email: dedenarijanuar@gmail.com\n skype: dedenarijanuar\n\n\n"
    puts "\n=================================================================\n"
  end
end

generator = Generator.new
if ARGV[0].blank?
  generator.check_tables
else
  tbs = ARGV[0];
  tb = tbs.split('/').first
  #check first table if table exist, its will be generate html viewer 
  if ActiveRecord::Base.connection.tables.include?(tb)
    generator.generate_result(ARGV[0])
  else
    generator.check_tables
  end
end

