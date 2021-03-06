require 'pry'

class Volunteer 
  attr_accessor :name, :project_id
  attr_reader :id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @project_id = attributes.fetch(:project_id)
    @id = attributes.fetch(:id)
  end

  def ==(volunteer_to_compare)
    self.name == volunteer_to_compare.name
  end

  def self.all 
    all_volunteers = DB.exec("SELECT * FROM volunteers;")
    volunteers = []
    all_volunteers.each do | volunteer |
      name = volunteer.fetch("name")
      project_id = volunteer.fetch("project_id").to_i
      id = volunteer.fetch("id").to_i
      volunteers.push(Volunteer.new({name: name, project_id: project_id, id: id}))
    end
    volunteers
  end

  def save
    result = DB.exec("INSERT INTO volunteers (name, project_id) VALUES ('#{@name}', #{project_id}) RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  def delete 
    DB.exec("DELETE FROM volunteers WHERE id = #{@id};")
  end

  def update(name)
    @name = name
    DB.exec("UPDATE volunteers SET name = '#{name}' WHERE id = #{@id};")
  end

  
  def self.find(id)
    volunteer = DB.exec("SELECT * FROM volunteers WHERE id = #{id};").first
    if volunteer
      name = volunteer.fetch("name")
      project_id = volunteer.fetch("project_id").to_i
      id = volunteer.fetch("id").to_i
      Volunteer.new({name: name, project_id: project_id, id: id})
    else
      nil
    end
  end

  def project
    Project.find(@project_id)
  end

  def self.find_by_project(proj_id)
    volunteers =[]
    all_volunteers = DB.exec("SELECT * FROM volunteers WHERE project_id = #{proj_id};")
    all_volunteers.each do | v |
      name = v.fetch("name")
      id = v.fetch("id").to_i
      volunteers.push(Volunteer.new({name: name, project_id: proj_id, id: id}))
    end
    volunteers
  end
end

