---
layout: page
title: Archive
permalink: /archive/
---

<div class="archive-container">
    <h1 class="archive-title">All Notes</h1>
    
    <div class="archive-columns">
        <div class="archive-column">
            <h2 class="column-title">Research Notes</h2>
            {% assign research_notes = site.notes | where: "category", "research" | sort: "last_modified_at" | reverse %}
            
            <ul class="archive-list">
            {% for note in research_notes %}
                <li class="archive-item">
                    <span class="archive-date">{{ note.last_modified_at | date: "%Y-%m-%d" }}</span>
                    <a href="{{ note.url }}" class="archive-link">{{ note.title }}</a>{% if note.word_count %} <span class="word-count">({{ note.word_count }} words)</span>{% endif %}
                </li>
            {% endfor %}
            </ul>
        </div>

        <div class="archive-column">
            <h2 class="column-title">Other Topics</h2>
            {% assign other_notes = site.notes | where_exp: "note", "note.category != 'research'" | sort: "last_modified_at" | reverse %}
            
            <ul class="archive-list">
            {% for note in other_notes %}
                <li class="archive-item">
                    <span class="archive-date">{{ note.last_modified_at | date: "%Y-%m-%d" }}</span>
                    <a href="{{ note.url }}" class="archive-link">{{ note.title }}</a>{% if note.word_count %} <span class="word-count">({{ note.word_count }} words)</span>{% endif %}
                </li>
            {% endfor %}
            </ul>
        </div>
    </div>
</div> 