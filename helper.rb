helpers do
  def helper_view(type, datetime, name)
    if type == "archive" 
      base_path = "/mnt/work/etl/agent"
      file_name = name+".html"
    else
      base_path = "/mnt/work/etl/logs/byday"
      file_name = name
    end

    archive_path = File.join(base_path,datetime,file_name)
    if File.exist?(archive_path)
      IO.read(archive_path)
    else
      archive_path+" Not Found!"
    end
  end
end
