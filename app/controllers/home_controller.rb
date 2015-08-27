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
      @norms[index]="\nnext(#{con}) :=\n\tcase"
    end

    antecendent_check = false
    @tmp_norms.each_with_index do|tmp_norms, index|
      if @norm_type[index] == "c"
        norm = "\t\t#{@antecendent[index]} & !#{@deadline[index]}: TRUE; -- from #{@norm_name[index]} --" + "\n\t\tTRUE: {TRUE, FALSE}; -- from #{@norm_name[index]} --"
      elsif @norm_type[index] == "a"
        norm = "\t\t!#{@antecendent[index]}: FALSE; -- from #{@norm_name[index]} --" + "\n\t\t#{@antecendent[index]}: {TRUE, FALSE}; -- from #{@norm_name[index]} --" + "\n\t\tTRUE: {TRUE, FALSE}; -- from #{@norm_name[index]} --"
        antecendent_check = true
      elsif @norm_type[index] == "p"
        if @consequent[index] == "disclose_PHI_family" or @consequent[index] == "disclose_PHI_online" or @consequent[index] == "logged_in"
          norm = "\t\t#{@antecendent[index]} & !#{@deadline[index]}: FALSE; -- from #{@norm_name[index]} --"
        else
          norm = "\t\t#{@antecendent[index]} & !#{@deadline[index]}: FALSE; -- from #{@norm_name[index]} --" + "\n\t\tTRUE: {TRUE, FALSE}; -- from #{@norm_name[index]} --"
        end
      end
          
      @norms[@norm_hash[@consequent[index]]] = @norms[@norm_hash[@consequent[index]]] + "\n" + norm
    end

=begin
  next(consent):=
    case
      consent: TRUE; -- monotonicity rule --
      TRUE: {TRUE, FALSE};
    esac;

  next(logged_in):=
    case
      access_PC: {TRUE, FALSE}; -- precondition rule --
      TRUE: FALSE;
    esac;

  next(disclose_PHI_family):=
    case
      EHR: {TRUE, FALSE}; -- precondition rule --
      TRUE: FALSE;
    esac;

  next(disclose_PHI_online):=
    case
      EHR: {TRUE, FALSE}; -- precondition rule --
      TRUE: FALSE;
    esac;
=end


    if @norm_hash["consent"] != nil
      @norms[@norm_hash["consent"]] = @norms[@norm_hash["consent"]] + "\n\t\tconsent: TRUE; -- monotonicity rule --\n\t\tTRUE: {TRUE, FALSE};"
    else
      @norms.push("\nnext(consent) :=\n\tcase\n\t\tconsent: TRUE; -- monotonicity rule --\n\t\tTRUE: {TRUE, FALSE};")
    end

    if @norm_hash["logged_in"] != nil
      @norms[@norm_hash["logged_in"]] = @norms[@norm_hash["logged_in"]]  + "\n\t\taccess_PC: {TRUE, FALSE}; -- precondition rule --\n\t\tTRUE: FALSE;"
    else
      @norms.push("\nnext(logged_in) :=\n\tcase\n\t\taccess_PC: {TRUE, FALSE}; -- precondition rule --\n\t\tTRUE: FALSE;")
    end

    if @norm_hash["disclose_PHI_family"] != nil
      @norms[@norm_hash["disclose_PHI_family"]] = @norms[@norm_hash["disclose_PHI_family"]]  + "\n\t\tEHR: {TRUE, FALSE}; -- precondition rule --\n\t\tTRUE: FALSE;"
    else
      @norms.push("\nnext(disclose_PHI_family) :=\n\tcase\n\t\tEHR: {TRUE, FALSE}; -- precondition rule --\n\t\tTRUE: FALSE;")
    end

    if @norm_hash["disclose_PHI_online"] != nil
      @norms[@norm_hash["disclose_PHI_online"]] = @norms[@norm_hash["disclose_PHI_online"]]  + "\n\t\tEHR: {TRUE, FALSE}; -- precondition rule --\n\t\tTRUE: FALSE;"
    else
      @norms.push("\nnext(disclose_PHI_online) :=\n\tcase\n\t\tEHR: {TRUE, FALSE}; -- precondition rule --\n\t\tTRUE: FALSE;")
    end

    #if !antecendent_check
    #  @norms = @norms + "\n TRUE: {TRUE, FALSE};"
    #end

    @norms.each_with_index do|norm, index|
      @norms[index] = norm + "\n\tesac;\n"
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

      #f.write("\n")
      #f.write("\n----------------\n-- properties --\n----------------\n")
      #f.write(params[:requirements])

    end
    
    @model = `cat ./code/models/tmp_model.smv `
    #@output = `NuSMV ./code/models/tmp_model.smv `

    @requirements = Array.new
    @tmp_requirements = Array.new

  end

  def generate_model
  end

  def verify_requirements

    @tmp_norms = Array.new
    @requirements = String.new
    @tmp_requirements = Array.new

    @tmp_norms = params[:norms].split("\n").map(&:strip)
    @requirements = params[:requirements].strip
    @tmp_requirements = @requirements.split("--").map(&:strip).reject!(&:empty?)
    @requirements_status = Array.new
    @requirements_spec = Array.new

    @tmp_requirements.each_with_index do |tmp_requirement, index|
      if tmp_requirement != nil and tmp_requirement != "" and tmp_requirement.split("\n")[0] != nil #and tmp_requirement.split("\n")[0].split["="] != nil
        @requirements_spec[index] = tmp_requirement.split("\n").map(&:strip)[2].chomp(";")
        @requirements_status[index] = tmp_requirement.split("\n").map(&:strip)[0].split("=").map(&:strip)[1]
      end
    end


    filepath = "./code/models/tmp_model.smv"
    @model = `cat ./code/models/tmp_model.smv `
    @tmp_model_top = `cat ./code/models/tmp_model_top.smv `
    @tmp_model_bot = `cat ./code/models/tmp_model_bot.smv `
    File.open(filepath, "w+") do |f|
      f.write(@model)
      f.write("\n----------------\n-- properties --\n----------------\n")
      f.write(params[:requirements])
    end

    @output = `NuSMV ./code/models/tmp_model.smv `

    counter = 0
    @requirements_nusmv_status = Array.new

    @output.split("\n").map(&:strip).each do |linewise_output|
      if linewise_output != nil and @requirements_spec[counter] != nil and linewise_output.include? @requirements_spec[counter]
        #@requirements_nusmv_status[counter] = linewise_output.split(")  is ").map(&:strip)[1]
        @requirements_nusmv_status[counter] = linewise_output.split(@requirements_spec[counter] + "  is").map(&:strip)[1]
        counter = counter + 1
      end
    end

    render :execute_norm_refinement
  end

end
