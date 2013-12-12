module ApplicationHelper

  def css(*css_files)
    css_files.map do |file|
      "<link href='/#{file}.css' media='screen, projection' rel='stylesheet' />"
    end.join
  end

  def js(*js_files)
    js_files.map do |file|
      "<script src='/#{file}.js' media='screen, projection' type='text/javascript'><script/>"
    end.join
  end

end
