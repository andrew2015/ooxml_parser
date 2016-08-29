module OoxmlParser
  class TableMargins < OOXMLDocumentObject
    attr_accessor :is_default, :top, :bottom, :left, :right

    def initialize(is_default = true, top = nil, bottom = nil, left = nil, right = nil)
      @is_default = is_default
      @top = top
      @bottom = bottom
      @left = left
      @right = right
    end

    # TODO: Separate @is_default attribute and remove this method
    def ==(other)
      instance_variables.each do |current_attribute|
        next if current_attribute == :@parent
        next if current_attribute == :@is_default
        unless instance_variable_get(current_attribute) == other.instance_variable_get(current_attribute)
          return false
        end
      end
      true
    end

    def to_s
      'Default: ' + is_default.to_s + ' top: ' + @top.to_s + ', bottom: ' + @bottom.to_s + ', left: ' + @left.to_s + ', right: ' + @right.to_s
    end

    def round(count_of_digits = 1)
      top = @top.round(count_of_digits)
      bottom = @bottom.round(count_of_digits)
      left = @left.round(count_of_digits)
      right = @right.round(count_of_digits)
      TableMargins.new(@is_default, top, bottom, left, right)
    end

    def self.parse(margin_node)
      cell_margins = TableMargins.new
      margin_node.xpath('*').each do |cell_margin_node|
        case cell_margin_node.name
        when 'left'
          cell_margins.left = (cell_margin_node.attribute('w').value.to_f / 566.9).round(2)
        when 'top'
          cell_margins.top = (cell_margin_node.attribute('w').value.to_f / 566.9).round(2)
        when 'right'
          cell_margins.right = (cell_margin_node.attribute('w').value.to_f / 566.9).round(2)
        when 'bottom'
          cell_margins.bottom = (cell_margin_node.attribute('w').value.to_f / 566.9).round(2)
        end
      end
      cell_margins
    end
  end
end
