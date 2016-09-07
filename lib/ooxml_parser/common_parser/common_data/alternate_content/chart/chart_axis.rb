require_relative 'chart_axis_title'
module OoxmlParser
  # Parsing Chart axis tags 'catAx', 'valAx'
  class ChartAxis < OOXMLDocumentObject
    attr_accessor :title, :display, :position, :major_grid_lines, :minor_grid_lines

    def initialize(title = ChartAxisTitle.new,
                   display = true,
                   major_grid_lines = false,
                   minor_grid_lines = false,
                   parent: nil)
      @title = title
      @display = display
      @minor_grid_lines = minor_grid_lines
      @major_grid_lines = major_grid_lines
      @parent = parent
    end

    # Parse ChartAxis object
    # @param node [Nokogiri::XML:Element] node to parse
    # @return [ChartAxis] result of parsing
    def parse(node)
      node.xpath('*').each do |node_child|
        case node_child.name
        when 'delete'
          @display = false if node_child.attribute('val').value == '1'
        when 'title'
          @title = ChartAxisTitle.new(parent: self).parse(node_child)
        when 'majorGridlines'
          @major_grid_lines = true
        when 'minorGridlines'
          @minor_grid_lines = true
        when 'axPos'
          @position = Alignment.parse(node_child.attribute('val'))
        end
      end
      @display = false if @title.nil?
      self
    end
  end
end
