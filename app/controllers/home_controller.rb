include ActionView::Helpers::TextHelper

class HomeController < ApplicationController
  def index
    @model = `cat ./code/models/original-model.smv `
    @output = `NuSMV ./code/models/original-model.smv `

    #@model.gsub!(/\r\n?/, "\n");
    #@model_html = simple_format(@model)

    #@output.gsub!(/\r\n?/, "\n");
    #@output_html = simple_format(@output)

  end

  def original
    @model = `cat ./code/models/original-model.smv `
    @output = `NuSMV ./code/models/original-model.smv `
  end

  def pattern1
    @model = `cat ./code/models/pattern1.smv `
    @output = `NuSMV ./code/models/pattern1.smv `
  end

  def pattern2
    @model = `cat ./code/models/pattern2.smv `
    @output = `NuSMV ./code/models/pattern2.smv `
  end

  def pattern3
    @model = `cat ./code/models/pattern3.smv `
    @output = `NuSMV ./code/models/pattern3.smv `
  end

  def custom
    # Read from form
    @model = `cat ./code/models/tmp_model.smv `
    p @model
    @output = `NuSMV ./code/models/tmp_model.smv `
    p @output
  end

  def execute_nusmv
    @tmp_model = params[:model]
    filepath = "./code/models/tmp_model.smv"
    File.open(filepath, "w+") do |f|
      f.write(@tmp_model)
    end
    
    @model = `cat ./code/models/tmp_model.smv `
    @output = `NuSMV ./code/models/tmp_model.smv `
  end

  def custom_norms
    filepath = "./code/models/tmp_model.smv"
    @tmp_model_top = `cat ./code/models/tmp_model_top.smv `
    @tmp_model_bot = `cat ./code/models/tmp_model_bot.smv `
    File.open(filepath, "w+") do |f|
      f.write(@tmp_model_top)
      f.write("\n")
      #f.write(@tmp_norms)
      #f.write("\n")
      f.write(@tmp_model_bot)
    end
    
    @model = `cat ./code/models/tmp_model.smv `
    @output = `NuSMV ./code/models/tmp_model.smv `
  end
  
  def execute_custom_norms
    @tmp_norms = params[:norms]
    filepath = "./code/models/tmp_model.smv"
    @tmp_model_top = `cat ./code/models/tmp_model_top.smv `
    @tmp_model_bot = `cat ./code/models/tmp_model_bot.smv `
    File.open(filepath, "w+") do |f|
      f.write(@tmp_model_top)
      f.write("\n")
      f.write(@tmp_norms)
      f.write("\n")
      f.write(@tmp_model_bot)
    end
    
    @model = `cat ./code/models/tmp_model.smv `
    @output = `NuSMV ./code/models/tmp_model.smv `
  end
end
