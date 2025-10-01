module Jekyll
  class AdmonitionConverter
    def self.convert(content)
      # Convert Obsidian-style admonition syntax to HTML
      lines = content.split("\n")
      result = []
      i = 0
      
      while i < lines.length
        line = lines[i]
        
        # Check if this line starts an admonition
        if line.match(/^>\s*\[!(\w+)\]\s*(.*)$/)
          type = $1.downcase
          title_text = $2.strip
          continuation_lines = []
          
          # Collect continuation lines
          i += 1
          while i < lines.length && lines[i].match(/^>\s*(.*)$/)
            continuation_lines << lines[i].gsub(/^>\s*/, '').strip
            i += 1
          end
          
          # Process title and continuation lines separately
          processed_title = title_text
          processed_title = processed_title.gsub(/\*\*(.*?)\*\*/) { "<strong>#{$1}</strong>" }
          processed_title = processed_title.gsub(/`(.*?)`/) { "<code>#{$1}</code>" }
          processed_title = processed_title.gsub(/\[([^\]]+)\]\(([^)]+)\)/) { "<a href=\"#{$2}\">#{$1}</a>" }
          
          processed_content = ""
          if continuation_lines.any?
            processed_content = "<br>" + continuation_lines.map do |line|
              line = line.gsub(/\*\*(.*?)\*\*/) { "<strong>#{$1}</strong>" }
              line = line.gsub(/`(.*?)`/) { "<code>#{$1}</code>" }
              line = line.gsub(/\[([^\]]+)\]\(([^)]+)\)/) { "<a href=\"#{$2}\">#{$1}</a>" }
              line
            end.join("<br>")
          end
          
          # Generate HTML based on type - title gets its own strong tag
          html = case type
          when 'info', 'note'
            "<div class=\"admonition info\"><strong>ℹ️ #{processed_title}</strong>#{processed_content}</div>"
          when 'tip'
            "<div class=\"admonition tip\"><strong>💡 #{processed_title}</strong>#{processed_content}</div>"
          when 'warning'
            "<div class=\"admonition warning\"><strong>⚠️ #{processed_title}</strong>#{processed_content}</div>"
          when 'error'
            "<div class=\"admonition error\"><strong>❌ #{processed_title}</strong>#{processed_content}</div>"
          else
            "<div class=\"admonition info\"><strong>ℹ️ #{processed_title}</strong>#{processed_content}</div>"
          end
          
          result << html
          i -= 1 # Adjust for the loop increment
        else
          result << line
        end
        
        i += 1
      end
      
      result.join("\n")
    end
  end
end

# Process all pages, posts, and documents
Jekyll::Hooks.register [:pages, :posts, :documents], :pre_render do |page|
  begin
    if page.content.include?('[!')
      page.content = Jekyll::AdmonitionConverter.convert(page.content)
    end
  rescue => e
    puts "Error processing admonitions in #{page.path}: #{e.message}"
    puts e.backtrace.first(3)
  end
end 