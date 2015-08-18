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

  def norm_refinement
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
    @requirements = Array.new
    @model = `cat ./code/models/tmp_model.smv `
    @output = `NuSMV ./code/models/tmp_model.smv `
  end

  def execute_norm_refinement

    @tmp_norms = params[:norms].split("\n").map(&:strip)
    #@tmp_requirements = params[:requirements].split("\n").map(&:strip)

    @norm_name = Array.new
    @norm_type = Array.new
    @role1 = Array.new
    @role2 = Array.new
    @antecendent = Array.new
    @consequent = Array.new
    @deadline = Array.new

    @tmp_norms.each_with_index do|tmp_norm, index|
      @norm_name[index] = tmp_norm.split(":").map(&:strip)[0]
      @norm_type[index] = tmp_norm.split(":").map(&:strip)[1].split("(").map(&:strip)[0]
      @role1[index] = tmp_norm.split(":").map(&:strip)[1].split("(").map(&:strip)[1].split(",").map(&:strip)[0]
      @role2[index] = tmp_norm.split(":").map(&:strip)[1].split("(").map(&:strip)[1].split(",").map(&:strip)[1]
      @antecendent[index] = tmp_norm.split(":").map(&:strip)[1].split("(").map(&:strip)[1].split(",").map(&:strip)[2]
      @consequent[index] = tmp_norm.split(":").map(&:strip)[1].split("(").map(&:strip)[1].split(",").map(&:strip)[3]
      @deadline[index] = tmp_norm.split(":").map(&:strip)[1].split("(").map(&:strip)[1].split(",").map(&:strip)[4].split(")").map(&:strip)[0]
    end

    @norms = Array.new
    @norm_hash = Hash.new

    @consequent.uniq.each_with_index do|con, index|
      @norm_hash[con] = index
      @norms[index]="\nnext(#{con}) :=\n  case"
    end

    antecendent_check = false
    @tmp_norms.each_with_index do|tmp_norms, index|
      if @norm_type[index] == "c"
        norm = "  #{@antecendent[index]} & !#{@deadline[index]}: TRUE; -- from #{@norm_name[index]} --" + "\n  TRUE: {TRUE, FALSE}; -- from #{@norm_name[index]} --"
      elsif @norm_type[index] == "a"
        norm = "  !#{@antecendent[index]}: FALSE; -- from #{@norm_name[index]} --" + "\n  #{@antecendent[index]}: {TRUE, FALSE}; -- from #{@norm_name[index]} --"
        antecendent_check = true
      elsif @norm_type[index] == "p"
        norm = "  #{@antecendent[index]} & !#{@deadline[index]}: FALSE; -- from #{@norm_name[index]} --" + "\n  TRUE: {TRUE, FALSE}; -- from #{@norm_name[index]} --"
      end
          
      @norms[@norm_hash[@consequent[index]]] = @norms[@norm_hash[@consequent[index]]] + "\n" + norm
    end

    #if !antecendent_check
    #  @norms = @norms + "\n TRUE: {TRUE, FALSE};"
    #end

   @norms.each_with_index do|norm, index|
    @norms[index] = norm + "\nesac;\n"
   end

    @requirements = params[:requirements].split("--").map(&:strip)



    @requirements.each do |tmp_requirement|
    end

    filepath = "./code/models/tmp_model.smv"
    @tmp_model_top = `cat ./code/models/tmp_model_top.smv `
    @tmp_model_bot = `cat ./code/models/tmp_model_bot.smv `
    File.open(filepath, "w+") do |f|
      f.write(@tmp_model_top)
      f.write("\n")
      f.write(params[:norms])
      f.write("\n")
      f.write(@tmp_model_bot)
      f.write("\n-----------\n-- norms --\n-----------\n")

      @norms.each_with_index do|norm, index|
        next if (index == @norm_hash["disclosed"] or index == @norm_hash["consent"])
          #continue
        #end
      f.write(norm)
      end

    end
    
    @model = `cat ./code/models/tmp_model.smv `
    @output = `NuSMV ./code/models/tmp_model.smv `


  end

end
