---
layout: example
title: "OSpec Examples"
description: "Real-world OSpec examples from simple websites to ML pipelines"
permalink: /examples/
---

# OSpec Examples

Explore real-world examples of OSpec specifications across different outcome types and complexity levels.

## Featured Examples

<div class="example-grid">
  {% assign examples = site.examples | sort: 'complexity' %}
  {% for example in examples %}
    {% unless example.url == page.url %}
    <div class="example-card">
      <h3><a href="{{ example.url | relative_url }}">{{ example.title }}</a></h3>
      <p>{{ example.description }}</p>
      
      <div class="example-meta">
        {% if example.outcome_type %}<span class="outcome-type">{{ example.outcome_type }}</span>{% endif %}
        {% if example.complexity %}<span class="complexity {{ example.complexity }}">{{ example.complexity | capitalize }}</span>{% endif %}
        {% if example.stack %}<span class="stack">{{ example.stack }}</span>{% endif %}
      </div>
    </div>
    {% endunless %}
  {% endfor %}
</div>

## Example Categories

### Web Applications
- [Shop Website]({{ 'examples/shop-website/' | relative_url }}) - E-commerce site with authentication and payments
- Examples of full-stack web applications with authentication, databases, and deployment

### APIs & Services  
- [API Service]({{ 'examples/api-service/' | relative_url }}) - RESTful API with comprehensive features
- RESTful and GraphQL APIs with proper documentation and testing

### CLI Tools
- [CLI Tool]({{ 'examples/cli-tool/' | relative_url }}) - Command-line application with subcommands
- Command-line utilities and developer tools

### Mobile Applications
- [Mobile App]({{ 'examples/mobile-app/' | relative_url }}) - React Native cross-platform app
- Native and cross-platform mobile development examples

### Games & Interactive
- [2D Web Game]({{ 'examples/game-project/' | relative_url }}) - Multiplayer space shooter game
- Interactive applications and real-time systems

### Libraries & Packages
- [JavaScript Library]({{ 'examples/library-package/' | relative_url }}) - Reusable utility library
- Open source packages and reusable components

### Machine Learning
- [ML Training Pipeline]({{ 'examples/ml-pipeline/' | relative_url }}) - End-to-end ML workflow
- ML pipelines, data processing, and model deployment examples

### Infrastructure
- [Cloud Infrastructure]({{ 'examples/infrastructure-project/' | relative_url }}) - Production-ready cloud setup
- Infrastructure as code and deployment automation

## Contributing Examples

Have an interesting OSpec example to share? We welcome contributions!

1. Fork the [repository]({{ site.repository | prepend: 'https://github.com/' }})
2. Add your example in `_examples/your-example.md`  
3. Follow the [example template]({{ site.repository | prepend: 'https://github.com/' }}/blob/main/.github/EXAMPLE_TEMPLATE.md)
4. Submit a pull request

## Related Resources

- [Getting Started Guide]({{ 'guides/getting-started/' | relative_url }}) - Learn OSpec basics
- [OSpec Specification]({{ 'specification/' | relative_url }}) - Complete technical reference
- [Cookbook]({{ 'cookbook/' | relative_url }}) - Common patterns and solutions