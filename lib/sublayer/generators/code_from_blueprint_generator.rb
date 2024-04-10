module Sublayer
  module Generators
    class CodeFromBlueprintGenerator < Base
      attr_reader :description, :results

      llm_output_adapter type: :single_string,
        name: "generated_code",
        description: "The generated code for the description"

      def initialize(blueprint_description:, blueprint_code:, description:)
        @blueprint_description = blueprint_description
        @blueprint_code = blueprint_code
        @description = description
      end

      def generate
        super
      end

      def prompt
        <<-PROMPT
        You are an expert programmer. You are great at understanding existing patterns and applying them to new situations.

        The blueprint we're referencing is: "#{@blueprint_description}".
        The code for that blueprint is:

        ===CODE START===
        #{@blueprint_code}
        ===CODE END===

        Use the blueprint above as a reference,
        Copy, modify and generate the code to satisfy only the description below:

        ===DESCRIPTION START===
        #{@description}
        ===DESCRIPTION END===

        Take a deep breath and think step by step before you start coding.
        PROMPT
      end
    end
  end
end
