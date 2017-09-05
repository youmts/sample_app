module ApplicationHelper
  
  # ページごとの完全なタイトルを返します。
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"

    if page_title.blank? then
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
