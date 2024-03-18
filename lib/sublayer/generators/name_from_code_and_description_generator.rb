module Sublayer
  module Generators
    class NameFromCodeAndDescriptionGenerator < Base
      attr_reader :code, :description, :results

      llm_output_adapter type: :single_string,
        name: "blueprint_name",
        description: "The generated name for the blueprint"

      def initialize(code:, description:)
        @code = code
        @description = description
      end

      def generate
        super
      end

      def prompt
        <<-PROMPT
        You have been provided with the following code and description for a blueprint:

        ###Code###
        #{code}
        ###Code End###

        ###Description###
        #{description}
        ###Description End###

        Your task is to analyze the provided information and generate a suitable name for this blueprint.

        Take a deep breath and think step by step before you start coding.
        PROMPT
      end
    end
  end
end
