module Sublayer
  module Generators
    class CodeDescriptionGenerator < Base
      attr_reader :code, :technologies, :results

      llm_output_adapter type: :single_string,
        name: "generated_description",
        description: "The generated description of the code's functionality"

      def initialize(code:, technologies:)
        @code = code
        @technologies = technologies
      end

      def generate
        super
      end

      def prompt
        <<-PROMPT
        You are an expert programmer in #{technologies.join(", ")}.

        You are tasked with analyzing and describing the functionality of code in the following technologies: #{technologies.join(", ")}.

        Here is the code snippet:
        #{code}

        After reviewing the code, please provide a complete and accurate description of what the code does functionally.
        PROMPT
      end
    end
  end
end
