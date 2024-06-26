# Blueprints by Sublayer

This Ruby on Rails app enables you to store chunks of your code we call
"blueprints" and then use them as a basis for generating new code using those
previously saved blueprints as a base for GPT4 to generate from.

Blog post sharing some background info: [Is Software Engineering Dead?](https://www.sublayer.com/blog/posts/is-software-engineering-dead)

[Demo video showing Blueprints usage in VSCode](https://www.loom.com/share/727e449a764e4362b28a74460db84655)

## Installation

### OpenAI Configuration
* Get an OpenAI API key: https://platform.openai.com/
* Set the API key in your environment as: `OPENAI_API_KEY`

### Google Configuration
* Get a Gemini API key: https://ai.google.dev/
* Set the API key in your environment as: `GEMINI_API_KEY`
* Set config.ai_provider to `google` in `config/application.rb`

* Install Postgres (if not installed): `brew install postgres`
* Install pgvector (if on postgres14): `brew install pgvector`

* Install one of the editor plugins:
- Vim: [blueprints.vim](https://github.com/sublayerapp/blueprints.vim)
- VSCode: [blueprints.code](https://github.com/sublayerapp/blueprints.code)
- IntelliJ: [blueprints.idea](https://github.com/sublayerapp/blueprints.idea)
- SublimeText: [blueprints_subl](https://github.com/sublayerapp/blueprints_subl)

* Clone the repo: `git clone https://github.com/sublayerapp/blueprints`
* Change to the blueprints directory: `cd blueprints`
* Install dependencies: `bundle install`
* Create your database: `bin/rails db:create`
* Run migrations: `bin/rails db:migrate`
* Generate the tailwind css: `bin/rails tailwindcss:build`
* Run the server: `bin/rails s`

## Usage

With a server running on http://localhost:3000 you can use any of the above
plugins to start storing blueprints locally and generating new ones.

Once you have a handful of blueprints you can view them and their associated
descriptions at `http://localhost:3000`

### LLM Performance specs

1. go to `spec_perforamnce/llms/ai_models.yml` to specify which llms you'd like to test
2. run `rspec spec_performance`

_You must have the appropriate llm setup. See [sublayer](https://github.com/sublayerapp/sublayer) for setup instructions._

## How It Works

### Create A New Blueprint

When you use the editor plugin to POST your highlighted code to `blueprints#create` it first sends the code
to gpt4 to generate a description and a name.

Once it has a description and a name, it creates vector embeddings of that
description and stores the whole record in the database for future lookup.


### Create A Blueprint Variant

When you use the editor plugin to POST your highlighted description to
`blueprint_variants#create` it uses the description to find the closest
blueprint.

Once the closest blueprint is found, it sends that blueprint's description,
associated code, and the new description to gpt4 for generation and replaces the
highlighted text in your editor with the generated code.

## Community

Like what you see, or looking for more people working on the future of
programming with LLMs?

 Come join us in the [Sublayer Discord](https://discord.gg/sjTJszPwXt)
