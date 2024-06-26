class TopNav < Phlex::HTML
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::ImageTag

  def template(&)
    header(class: "relative flex h-16 flex-shrink-0 items-center bg-white") do
      div(class: "absolute inset-y-0 left-0 lg:static lg:flex-shrink-0") do
        a(href: "#", class: "flex h-16 w-16 items-center justify-center bg-cyan-400 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-blue-600 lg:w-20") do
          image_tag("icon.png", class: "h-8 w-auto")
        end
      end

      div(class: "hidden lg:flex lg:min-w-0 lg:flex-1 lg:items-center lg:justify-between") do
        div(class: "min-w-0 flex1") do
          div(class: "relative max-w-2xl text-gray-400 focus-within:text-gray-500") do
            label(for: "blueprints-search", class: "sr-only") { "Search all blueprints" }
            input(id: "blueprints-search", data: { controller: 'search', action: 'keyup->search#updatelist' }, type: "search", placeholder: "Search all blueprints", class: "block w-full border-transparent pl-12 text-gray-900 focus:border-transparent focus:ring-0 sm:text-sm")
            div(class: "pointer-events-none absolute inset-y-0 left-0 flex items-center justify-center pl-4") do
              svg(class: "h-5 w-5", viewBox: "0 0 20 20", fill: "currentColor", aria_hidden: "true") do |s|
                s.path(fill_rule: "evenodd", d: "M9 3.5a5.5 5.5 0 100 11 5.5 5.5 0 000-11zM2 9a7 7 0 1112.452 4.391l3.328 3.329a.75.75 0 11-1.06 1.06l-3.329-3.328A7 7 0 012 9z", clip_rule: "evenodd")
              end
            end
          end
        end
      end
    end
  end
end
