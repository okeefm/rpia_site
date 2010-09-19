module ApplicationHelper

  # Return a title on a per-page basis.               # Documentation comment
  def title                                           # Method definition
    base_title = "RPI Ambulance"                      # Variable assignment
    if @title.nil?                                    # Boolean test for nil
      base_title                                      # Implicit return
    else
      "#{base_title} | #{@title}"                     # String interpolation
    end
  end

  def logo
    image_tag("logo.jpg", :alt => "RPI Ambulance", :class => "round")
  end

end
