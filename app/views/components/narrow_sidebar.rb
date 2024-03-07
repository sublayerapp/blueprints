class NarrowSidebar < Phlex::HTML
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes

  def template
    nav(aria_label: "Sidebar", class: "hidden lg:block lg:flex-shrink-0 lg:overflow-y-auto lg:bg-gray-800") do
      div(class: "relative flex w-20 flex-col space-y-3 p-3") do
        link_to root_path, class: "bg-gray-900 text-white inline-flex h-14 w-14 flex-shrink-0 items-center justify-center rounded-lg" do
          span(class: "sr-only") { "Open" }
          svg(class: "h-6 w-6", fill: "none", viewBox: "0 0 24 24", stoke_width: "1.5", stroke: "currentColor", aria_hidden: "true") do |s|
            s.path(stroke_linecap: "round", stroke_linejoin: "round", d: "M2.25 13.5h3.86a2.25 2.25 0 012.012 1.244l.256.512a2.25 2.25 0 002.013 1.244h3.218a2.25 2.25 0 002.013-1.244l.256-.512a2.25 2.25 0 012.013-1.244h3.859m-19.5.338V18a2.25 2.25 0 002.25 2.25h15A2.25 2.25 0 0021.75 18v-4.162c0-.224-.034-.447-.1-.661L19.24 5.338a2.25 2.25 0 00-2.15-1.588H6.911a2.25 2.25 0 00-2.15 1.588L2.35 13.177a2.25 2.25 0 00-.1.661z")
          end
        end

        link_to downloads_path, class: "bg-gray-900 text-white inline-flex h-14 w-14 flex-shrink-0 items-center justify-center rounded-lg" do
          span(class: "sr-only") { "Download" }
          svg(class: "h-6 w-6", fill: "none", viewBox: "0 0 24 24", stoke_width: "1.5", stroke: "currentColor", aria_hidden: "true") do |s|
            s.path(stroke_linecap: "round", stroke_linejoin: "round", d: "M3 16.5v2.25A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75V16.5M16.5 12 12 16.5m0 0L7.5 12m4.5 4.5V3")
          end
        end
      end
    end
  end
end
