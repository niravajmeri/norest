include ActionView::Helpers::TextHelper

class HomeController < ApplicationController
	def index
	  @model = `cat ./code/models/original-model.smv `
	  p @model
      @output = `NuSMV ./code/models/original-model.smv `
      p @output

      @model.gsub!(/\r\n?/, "\n");
      @model_html = simple_format(@model)

      @output.gsub!(/\r\n?/, "\n");
      @output_html = simple_format(@output)

	end
end
