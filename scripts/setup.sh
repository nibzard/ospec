#!/bin/bash

# OSpec Website Setup Script
# This script sets up the development environment for the OSpec website

set -e  # Exit on error

echo "🚀 Setting up OSpec website development environment..."

# Check Ruby installation
if ! command -v ruby &> /dev/null; then
    echo "❌ Ruby is not installed. Please install Ruby 3.0+ first."
    echo "   Visit: https://www.ruby-lang.org/en/documentation/installation/"
    exit 1
fi

echo "✅ Ruby $(ruby -v | grep -oE '[0-9]+\.[0-9]+\.[0-9]+') detected"

# Check Bundler installation
if ! command -v bundle &> /dev/null; then
    echo "📦 Installing Bundler..."
    gem install bundler
fi

echo "✅ Bundler $(bundle -v | grep -oE '[0-9]+\.[0-9]+\.[0-9]+') detected"

# Install Ruby dependencies
echo "📦 Installing Ruby dependencies..."
bundle install

# Check Node.js installation (optional but recommended)
if command -v node &> /dev/null; then
    echo "✅ Node.js $(node -v) detected"
    
    # Install Node dependencies if package.json exists
    if [ -f "package.json" ]; then
        echo "📦 Installing Node.js dependencies..."
        npm install
    fi
else
    echo "⚠️  Node.js not found. Some development scripts may not work."
    echo "   Install Node.js for the best development experience."
fi

# Create necessary directories
echo "📁 Creating directory structure..."
mkdir -p _specification _guides _examples _cookbook _pages

# Set up Git hooks (optional)
if [ -d ".git" ]; then
    echo "🔗 Setting up Git hooks..."
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Pre-commit hook for OSpec

# Validate YAML front matter
echo "Validating YAML front matter..."
rake validate_yaml

# Check for broken links (optional, can be slow)
# echo "Checking for broken links..."
# rake check_links

echo "✅ Pre-commit checks passed!"
EOF
    chmod +x .git/hooks/pre-commit
fi

# Build the site once to check for errors
echo "🏗️  Building site to check for errors..."
bundle exec jekyll build

echo ""
echo "✅ Setup complete! You're ready to develop."
echo ""
echo "📝 Next steps:"
echo "   1. Start the development server: bundle exec jekyll serve --livereload"
echo "   2. Open your browser to: http://localhost:4000/ospec"
echo "   3. Make changes and see them live reload!"
echo ""
echo "📚 Useful commands:"
echo "   rake serve       - Start development server"
echo "   rake test        - Run tests"
echo "   rake build       - Build the site"
echo "   rake new_guide[name]    - Create a new guide"
echo "   rake new_example[name]  - Create a new example"
echo ""
echo "Happy coding! 🎉"