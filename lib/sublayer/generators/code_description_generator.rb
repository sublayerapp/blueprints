module Sublayer
  module Generators
    class CodeDescriptionGenerator < Base
      attr_reader :code, :technologies, :results

      llm_output_adapter type: :single_string,
        name: "generated_description",
        description: "The generated description of the code's functionality"

      llm_input_adapter type: :image

      def initialize(code:)
        @code = code
      end

      def generate
        super
      end

      def prompt
        <<-PROMPT
        You are an expert software engineer. Below is a chunk of code:

        #{@code}

        Please read the code carefully and provide a high-level description of what this code does, including its purpose, functionalities, and any noteworthy details.
        PROMPT
      end
    end
  end
end
