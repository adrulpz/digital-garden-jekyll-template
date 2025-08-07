# frozen_string_literal: true

module WordCount
  # Generate word count for all markdown pages
  class Generator < Jekyll::Generator
    def generate(site)
      puts "WordCount generator running..."
      items = site.collections['notes'].docs
      puts "Processing #{items.length} notes..."
      items.each do |page|
        # Get the content without front matter
        content = page.content.strip
        
        # Remove HTML tags and count words
        text_content = content.gsub(/<[^>]*>/, '')  # Remove HTML tags
        text_content = text_content.gsub(/[^\w\s]/, ' ')  # Replace punctuation with spaces
        text_content = text_content.gsub(/\s+/, ' ')  # Normalize whitespace
        
        word_count = text_content.split(' ').length
        
        # Store word count in page data
        page.data['word_count'] = word_count
        puts "  #{page.data['title']}: #{word_count} words"
      end
    end
  end
end 