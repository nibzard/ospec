---
layout: guide
title: "OSpec Guides"
description: "Step-by-step tutorials for writing OSpecs and building compatible agents"
permalink: /guides/
---

# OSpec Guides

Learn how to work with OSpec through step-by-step tutorials and practical examples.

## Getting Started

<div class="guide-list">
  <div class="guide-item">
    <h3><a href="/guides/getting-started/">Getting Started with OSpec</a></h3>
    <p>Learn the basics of OSpec and create your first specification.</p>
    <span class="difficulty beginner">Beginner</span>
    <span class="time">15 minutes</span>
  </div>
  
  <div class="guide-item">
    <h3><a href="/guides/writing-ospecs/">Writing OSpecs</a></h3>
    <p>Deep dive into writing effective OSpec documents with best practices.</p>
    <span class="difficulty intermediate">Intermediate</span>
    <span class="time">45 minutes</span>
  </div>
</div>

## Core Guides

<div class="guide-list">
  <div class="guide-item">
    <h3><a href="/guides/stack-selection/">Stack Selection</a></h3>
    <p>Choose the right technology stack for your project requirements.</p>
    <span class="difficulty intermediate">Intermediate</span>
    <span class="time">30 minutes</span>
  </div>
  
  <div class="guide-item">
    <h3><a href="/guides/testing-strategies/">Testing Strategies</a></h3>
    <p>Comprehensive testing approaches for OSpec projects.</p>
    <span class="difficulty advanced">Advanced</span>
    <span class="time">60 minutes</span>
  </div>
  
  <div class="guide-item">
    <h3><a href="/guides/deployment/">Deployment</a></h3>
    <p>Deploy and manage OSpec projects in production environments.</p>
    <span class="difficulty advanced">Advanced</span>
    <span class="time">90 minutes</span>
  </div>
</div>

## Advanced Topics

<div class="guide-list">
  <div class="guide-item">
    <h3><a href="/guides/advanced-patterns/">Advanced Patterns</a></h3>
    <p>Complex patterns and advanced techniques for sophisticated use cases.</p>
    <span class="difficulty advanced">Advanced</span>
    <span class="time">120 minutes</span>
  </div>
  
  <div class="guide-item">
    <h3><a href="/guides/troubleshooting/">Troubleshooting</a></h3>
    <p>Common issues, debugging techniques, and solutions.</p>
    <span class="difficulty intermediate">Intermediate</span>
    <span class="time">60 minutes</span>
  </div>
</div>

## All Guides

{% assign guides = site.guides | sort: 'difficulty' %}
{% for guide in guides %}
  {% unless guide.url == page.url %}
  <div class="guide-item">
    <h3><a href="{{ guide.url | relative_url }}">{{ guide.title }}</a></h3>
    <p>{{ guide.description }}</p>
    {% if guide.difficulty %}<span class="difficulty {{ guide.difficulty }}">{{ guide.difficulty | capitalize }}</span>{% endif %}
    {% if guide.time %}<span class="time">{{ guide.time }}</span>{% endif %}
  </div>
  {% endunless %}
{% endfor %}

## Need Help?

- [OSpec Specification](/specification/) - Complete technical reference
- [Examples](/examples/) - Real-world OSpec examples  
- [Cookbook](/cookbook/) - Common patterns and solutions
- [GitHub Discussions]({{ site.repository | prepend: 'https://github.com/' }}/discussions) - Community support