module ApplicationHelper

	def glyphicon(klass = '', text = '', options = {})
	 content_tag(:i, '', options.merge(:class => "icon-#{klass.to_s}")) + " #{text}"
	end

	def doc nav = false, &block
		content = capture(&block)
		# content += content_tag(:hr) if !capture(&block).blank?

		content_tag(:div, nav ? content_tag(:h3, content) : content_tag(:dd, content), :class => "span6 docs")
	end

	def desc nav = false, &block
		content = capture(&block)
		# content += content_tag(:hr) if !capture(&block).blank?
		content_tag(:div, nav ? content_tag(:h3, content) : content_tag(:dd, content) , :class => "span5 defs")
	end

	def row &block
		content_tag :div, capture(&block), :class => "row-fluid docs-def"
	end

	def doc_row *args, &block
		if args.size == 1
			d2 = args[0].to_s
		elsif args.size == 2
			if args[1].is_a?(TrueClass) || args[1].is_a?(FalseClass)
				d2 = args[0].to_s
				nav = args[1]
			else
				d1 = args[0].to_s
				d2 = args[1].to_s
			end
		else
			d1 = args[0].to_s
			d2 = args[1].to_s
			nav = args[2]
		end

		nav ||= false

		row do
			[(doc(nav){(block.present? ? capture(&block) : d1)} if d1 || block), desc(nav){d2}].reverse.compact.join.html_safe
		end
	end

end