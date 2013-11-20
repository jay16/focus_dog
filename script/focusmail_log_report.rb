#encoding: utf-8
require "fileutils"

def data_list(num)
        base_path = "/mnt/work/etl/logs/byday"
        dest_path = "/mnt/work/etl/agent"

        now   = Time.now - 24*60*60*num
        ymd   = now.strftime("%y%m%d")

        # list
        # 列出所有log文件
        # -------------------------------------
        logs_path = File.join(base_path,ymd)
        return false unless File.exist?(logs_path)

        data_path = File.join(dest_path,ymd)
        FileUtils.mkdir_p(data_path) unless File.exist?(data_path)

        list_path = File.join(data_path,"list.csv")
        FileUtils.rm_f(list_path) if File.exist?(list_path)

        list_file = File.new(list_path, File::CREAT|File::TRUNC|File::RDWR, 0644)
        logs_file = Dir.entries(logs_path).select { |f| File.file?(File.join(logs_path,f)) }.sort

        datas = Array.new
        ips   = Array.new
        for log_file in logs_file
          log_path = File.join(logs_path,log_file)
          size = File.size(log_path)
          rows = File.readlines(log_path).size
          ctime = File.ctime(log_path).strftime("%Y-%m-%d")
          mtime = File.mtime(log_path).strftime("%Y-%m-%d")
          if log_file =~ /^(\d*)\.(\d*)\.(\d*)\.(\d*)/
            ip = $&
          else
            ip = log_file
          end
          data = [ip,log_file,size,rows,ctime,mtime]

          datas.push(data); ips.push(ip)
          list_file.puts(data.join(","))
        end
        # -------------------------------------

        # data
        # 数据汇总
        # -------------------------------------
        dd_path = File.join(data_path,"data.csv")
        FileUtils.rm_f(dd_path) if File.exist?(dd_path)

        data_file = File.new(dd_path, File::CREAT|File::TRUNC|File::RDWR, 0644)
        ips.uniq!

        for ip in ips
          ip_logs = datas.select { |d| d[0] == ip }
          log_num = ip_logs.size
          row_num   = 0
          data_size = 0
          for log in ip_logs
            row_num   += log[2].to_i
            data_size += log[3].to_i
          end

          data_file.puts("#{ip},#{log_num},#{row_num},#{data_size}")
        end
        data_file.close
        # -------------------------------------
end


def report(baseurl, num)
        now   = Time.now - 24*60*60*num
        ymd   = now.strftime("%y%m%d")
        format = now.strftime('%Y/%m/%d')
        ymd_t = now.strftime("%y/%m/%d")

        dest_path = "/mnt/work/etl/agent"
        data_path = File.join(dest_path,ymd)
        dd_path = File.join(data_path,"data.csv")
        lines = File.readlines(dd_path).map { |line| line.split(/,/) }
        today_table = "
          <h3>FocusMail 日志报告 #{format}</h3>
          <h4>代理服务器日志信息
            <small>
              <a class='btn btn-mini' href='#{baseurl}/archive/#{ymd_t}/list'>文件列表</a>
	    </small>
	  </h4>
          <table border='1' style='text-align:center;'>
            <thead>
              <th>代理服务器ip</th>
              <th>日志文件数量</th>
              <th>日志文件总大小</th>
              <th>日志文件总行数</th>
            </thead>
        "

        details = String.new
        lines.each do |line|
          details << "
              <tr>
                 <td>#{line[0]}</td>
                 <td>#{line[1]}</td>
                 <td>#{line[2]}b</td>
                 <td>#{line[3]}</td>
              </tr>
        "
        end

        today_table << details
        today_table << "</table>"

        today_table << "
          <h4>过去7天代理服务器日志信息对比</h4>
          <table border='1' style='text-align:center;'>
            <thead>
              <th>日期</th>
              <th>代理服务器数量</th>
              <th>日志文件总大小</th>
              <th>日志文件总行数</th>
              <th>当天日志报告</th>
            </thead>
              <tr>
                 <td>#{format}</td>
                 <td>#{lines.size}</td>
                 <td>#{lines.inject(0) { |sum, line| sum+line[2].to_i }}b</td>
                 <td>#{lines.inject(0) { |sum, line| sum+line[3].to_i }}</td>
                 <td>今天日志报告</td>
              </tr>
        "

        last_7_days = String.new

        (1..7).each do |n|
          tmp_now = now - 24*60*60*n
          tmp_ymd   = tmp_now.strftime("%y%m%d")
          tmp_ymd_t = tmp_now.strftime("%y/%m/%d")
          tmp_format = tmp_now.strftime("%Y/%m/%d")
          tmp_data_path = File.join(dest_path,tmp_ymd)
          tmp_dd_path = File.join(tmp_data_path,"data.csv")
          lines = File.readlines(tmp_dd_path).map { |line| line.split(/,/) }
          if File.exist?(tmp_dd_path)
            tmp = "
              <tr>
                 <td>#{tmp_format}</td>
                 <td>#{lines.size}</td>
                 <td>#{lines.inject(0) { |sum, line| sum+line[2].to_i }}b</td>
                 <td>#{lines.inject(0) { |sum, line| sum+line[3].to_i }}</td>
                 <td><a class='btn btn-mini' href='#{baseurl}/archive/#{tmp_ymd_t}/report'>查看</a></td>
              </tr>
            "
          else
            tmp = "
              <tr>
                 <td>#{tmp_format}</td>
                 <td>不存在</td>
                 <td>不存在</td>
                 <td>不存在</td>
                 <td>不存在</td>
              </tr>
            "
          end
          last_7_days << tmp
        end
        
        today_table << last_7_days
        today_table << "</table>"
        puts today_table
        report_path = File.join(data_path,"report.html")
        FileUtils.rm_f(report_path) if File.exist?(report_path) 
        report_file = File.new(report_path, File::CREAT|File::TRUNC|File::RDWR, 0644)
        report_file.puts(today_table)
        report_file.close
end


def list(baseurl, num)
        now   = Time.now - 24*60*60*num
        ymd   = now.strftime("%y%m%d")
        format = now.strftime('%Y/%m/%d')
        ymd_t = now.strftime("%y/%m/%d")

        dest_path = "/mnt/work/etl/agent"
        data_path = File.join(dest_path,ymd)
        dd_path = File.join(data_path,"list.csv")
        lines = File.readlines(dd_path).map { |line| line.split(/,/) }
        today_table = "
          <h3>FocusMail 日志报告 #{format}</h3>
          <h4>文件列表
            <small>
              <a class='btn btn-mini' href='#{baseurl}/archive/#{ymd_t}/report'>数据报告</a>
            </small>
          </h4>
          <table border='1' style='text-align:center;'>
            <thead>
              <th>文件名称</th>
              <th>文件大小</th>
              <th>文件行数</th>
              <th>创建时间</th>
            </thead>
        "

        details = String.new
        lines.each do |line|
          details << "
              <tr>
                 <td>#{line[1]}</td>
                 <td>#{line[2]}b</td>
                 <td>#{line[3]}</td>
                 <td>#{line[4]}</td>
              </tr>
        "
        end

        today_table << details
        today_table << "</table>"

        report_path = File.join(data_path,"list.html")
        FileUtils.rm_f(report_path) if File.exist?(report_path) 
        report_file = File.new(report_path, File::CREAT|File::TRUNC|File::RDWR, 0644)
        report_file.puts(today_table)
        report_file.close
end

data_list(1)
baseurl = "http://focusdog.xsolife.com"
report(baseurl, 1)
list(baseurl, 1)

require 'json'
require "open-uri"
require 'net/http'
require 'uri'

def send_mail(email)
        dest_path = "/mnt/work/etl/agent"
        now   = Time.now - 24*60*60*1
        ymd   = now.strftime("%y%m%d")
        report = File.readlines(File.join(dest_path,ymd,"report.html")).join(" ")

        base_url = "http://xsolife.com/api/sendmail"
        #pp = {:email => "527130673@qq.com", :subject => "#{Time.now.strftime('%Y/%m/%d')} FocusMail Log报告", :content => report}
        pp = {:email => email,
          :from => "FocusMail Assistant<noreply@focusmail.com>",
          :subject => "FocusMail 日志报告 #{Time.now.strftime('%Y/%m/%d')}",
          :content => report}

        header = {'Content-Type' => 'application/json'}
        uri = URI.parse(base_url)
        http = Net::HTTP.new(uri.host, uri.port)
        #http.open_timeout = 5
        #http.read_timeout = 5
        request = Net::HTTP::Post.new(uri.request_uri, header)
        request.body = pp.to_json

        begin
          response = http.request(request)
        rescue => e
          puts e.message
        else
          puts response.body
        end
end

#send_mail("jay_li@intfocus.com")
#send_mail("albert_li@intfocus.com")
#send_mail("eric_yue@intfocus.com")
