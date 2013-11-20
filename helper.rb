helpers do
  def find_file(type, datetime, name)
    if type == "archive" 
      basepath = "/mnt/work/etl/agent"
      filetype = ".html"
    else
      basepath = "/mnt/work/etl/logs/byday"
      filetype = ".log"
    end

    archive_path = File.join(basepath,datetime,name+filetype)
    if File.exist?(archive_path)
      IO.readlines(archive_path).join
    else
      archive_path+" Not Found!"
    end
  end
end
