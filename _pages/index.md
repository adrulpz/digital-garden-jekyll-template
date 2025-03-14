---
layout: page
title: Home
id: home
permalink: /
---

# Welcome!🌱

<div style="display: flex; gap: 10px; align-items: flex-start; padding-left: 0;">
  <img src="/assets/images/growing-flower.gif" alt="Growing Flower" style="width: 150px; height: auto; margin-top: 20px; margin-right: 10px;">
  
  <p style="padding: 3em 1em; background: #e5d6cc; border-radius: 4px; flex: 1;">
    This is where I document my research, technical explorations, and evolving ideas. Unlike a traditional blog, this space is always growing—some notes are well-developed, while others are just starting to take shape.
    <br><br>
    Feel free to explore my latest notes below, and if you're curious about my work, check out my <a href="/about" class="internal-link" style="border-bottom: none; font-weight: bold;">About</a> page. You can also browse through all my notes in the <a href="/archive" class="internal-link" style="border-bottom: none; font-weight: bold;">Archive</a>!
  </p>
</div>

<strong>Recently updated notes</strong>

<ul>
  {% assign recent_notes = site.notes | sort: "last_modified_at_timestamp" | reverse %}
  {% for note in recent_notes limit: 5 %}
    <li>
      {{ note.last_modified_at | date: "%Y-%m-%d" }} — <a class="internal-link" href="{{ note.url }}">{% if note.title %}{{ note.title }}{% else %}{{ note.path | split: "/" | last | replace: ".md", "" }}{% endif %}</a>
    </li>
  {% endfor %}
</ul>

<p style="margin-top: 3em; padding: 1.5em; background: #e5d6cc; border-radius: 4px;">
  Want to start your own digital garden? 🌿 This template is free, open-source, and <a href="https://github.com/maximevaillancourt/digital-garden-jekyll-template" class="internal-link" style="border-bottom: none; font-weight: bold;">available on GitHub</a>. The easiest way to get started is by following this <a href="https://maximevaillancourt.com/blog/setting-up-your-own-digital-garden-with-jekyll" class="internal-link" style="border-bottom: none; font-weight: bold;">step-by-step guide</a>.
</p>

<style>
  .wrapper {
    max-width: 46em;
  }
</style>
