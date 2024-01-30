module Sublayer
  module Agents
    class GenerateNameFromCodeAndDescriptionAgent
      include Sublayer::Capabilities::LLMAssistance
      include Sublayer::Capabilities::HumanAssistance

      attr_reader :code, :description, :results

      llm_result_format type: :single_string,
        name: "blueprint_name",
        description: "The generated name for the blueprint"

      def initialize(code:, description:)
        @code = code
        @description = description
      end

      def execute
        @results = llm_generate
      end

      def prompt
        <<-PROMPT
        You have been provided with the following code and description for a blueprint:

        Code:
        #{code}

        Description:
        #{description}

        Your task is to analyze the provided information and generate a suitable name for this blueprint.

        Take a deep breath and think step by step before you start coding.
        PROMPT
      end
    end
  end
end
