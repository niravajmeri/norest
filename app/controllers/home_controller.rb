include ActionView::Helpers::TextHelper

class HomeController < ApplicationController
  def index
    p `echo $PATH`
    @model = `cat ./code/models/original-model.smv `
    p "---MODEL---"
    p @model
    @output = `NuSMV ./code/models/original-model.smv `
    p "---OUTPUT---"
    p @output

    #@model.gsub!(/\r\n?/, "\n");
    #@model_html = simple_format(@model)

    @output.gsub!(/\r\n?/, "\n");
    @output_html = simple_format(@output)

  end

  def original
    @model = `cat ./code/models/original-model.smv `
    p @model
    @output = `NuSMV ./code/models/original-model.smv `
    p @output
  end

  def pattern1
    @model = `cat ./code/models/pattern1.smv `
    p @model
    @output = `NuSMV ./code/models/pattern1.smv `
    p @output		
  end

  def pattern2
    @model = `cat ./code/models/pattern2.smv `
    p @model
    @output = `NuSMV ./code/models/pattern2.smv `
    p @output
  end

  def pattern3
    @model = `cat ./code/models/pattern3.smv `
    p @model
    @output = `NuSMV ./code/models/pattern3.smv `
    p @output
  end

  def custom
    # Read from form
    @model = `cat ./code/models/pattern3.smv `
    p @model
    @output = `NuSMV ./code/models/pattern3.smv `
    p @output
  end
end
