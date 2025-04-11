# Yuon (Yes You On) | A Self-Hosted Notion Clone

<img src="https://woodpecker.rocks/assets/mstile-310x310-ea79ff4f.png" alt="Yuon Logo" width="100" height="100">

An open-source, self-hostable alternative to Notion built with modern Rails.

## Tech Stack

* Ruby 3.3.6
* Rails 8.0.2
* SQLite database
* Tailwind CSS for styling
* Turbo and Stimulus for dynamic interactions
* Kamal for deployment

## Features

* Page creation and management
* Block-based content editor
* Support for various content blocks (text, headings, code, images) <-- let's add more
* Block reordering
* User authentication

## Getting Started

### Prerequisites

* Ruby 3.3.6
* SQLite3

### Installation

1. Clone the repository
   ```
   git clone https://github.com/yourusername/notion-clone.git
   cd notion-clone
   ```

2. Install dependencies
   ```
   bundle install
   ```

3. Setup database
   ```
   bin/rails db:setup
   ```

4. Start the server
   ```
   bin/rails server
   ```

5. Visit `http://localhost:3000` in your browser

## Development

* Run tests: `bin/rails test`
* Run the development server: `bin/dev`

## Deployment

This application uses Kamal for deployment:

1. Configure your deployment settings in `config/deploy.yml`
2. Deploy with: `kamal deploy`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.