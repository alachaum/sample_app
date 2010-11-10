module ApplicationHelper

  #Define the logo to be printed in the header
  def logo
    image_tag("logo.png", :alt => "Sample App", :class => "round")
  end


  #Define a title on a per page basis
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
