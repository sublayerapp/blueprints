module Sublayer
  module Agents
    class GenerateCategoriesFromCodeAgent
      include Sublayer::Capabilities::LLMAssistance
      include Sublayer::Capabilities::HumanAssistance

      attr_reader :code, :categories, :results

      llm_result_format type: :single_string,
        name: "code_categories",
        description: "categories separated by commas"

      def initialize(code:)
        @code = code
      end

      def execute
        @categories = llm_generate
      end

      def prompt
        <<-PROMPT
        You are an expert programmer and data analyst.

        You are tasked with analyzing and categorizing the functionality of code.

        Here is the code snippet:
        
        ###CODE###
        #{code}
        ###END CODE###

        After reviewing the code, please suggest the appropriate categories for this code.
        Choose categories that will be useful for querying for other code that is similar.
        Consider aspects like languages, libraries, frameworks, technologies, and functionality.
        Categories should be specific enough to narrow down a library of code
        PROMPT
      end
    end
  end
end
