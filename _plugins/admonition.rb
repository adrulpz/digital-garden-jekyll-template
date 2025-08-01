module Jekyll
  class AdmonitionConverter
    def self.convert(content)
      # Convert Obsidian-style admonition syntax to HTML
      content.gsub(/^>\s*\[!(\w+)\](.*?)(?:\n>\s*(.*?))*(?=\n[^>]|\n$|$)/m) do |match|
        type = $1.downcase
        title_text = $2.strip
        
        # Get all continuation lines
        continuation_lines = []
        match.scan(/\n>\s*(.*?)(?=\n[^>]|\n$|$)/m).each do |line|
          continuation_lines << line[0].strip
        end
        
        # Combine title and continuation lines with proper line breaks
        full_content = title_text
        if continuation_lines.any?
          full_content += "<br>" + continuation_lines.join("<br>")
        end
        
        # Process the content to handle markdown formatting
        # Convert **text** to <strong>text</strong>
        full_content = full_content.gsub(/\*\*(.*?)\*\*/) { "<strong>#{$1}</strong>" }
        # Convert `text` to <code>text</code>
        full_content = full_content.gsub(/`(.*?)`/) { "<code>#{$1}</code>" }
        
        case type
        when 'info', 'note'
          "<div class=\"admonition info\"><strong>ℹ️</strong> #{full_content}</div>"
        when 'tip'
          "<div class=\"admonition tip\"><strong>💡</strong> #{full_content}</div>"
        when 'warning'
          "<div class=\"admonition warning\"><strong>⚠️</strong> #{full_content}</div>"
        when 'error'
          "<div class=\"admonition error\"><strong>❌</strong> #{full_content}</div>"
        else
          "<div class=\"admonition info\"><strong>ℹ️</strong> #{full_content}</div>"
        end
      end
    end
  end
end

# Process all pages, posts, and documents
Jekyll::Hooks.register [:pages, :posts, :documents], :pre_render do |page|
  if page.content.include?('[!')
    page.content = Jekyll::AdmonitionConverter.convert(page.content)
  end
end 