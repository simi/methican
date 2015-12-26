module MethicParser
  class TreeNode
    include Enumerable
    attr_reader :text, :offset, :elements

    def initialize(text, offset, elements = [])
      @text = text
      @offset = offset
      @elements = elements
    end

    def each(&block)
      @elements.each(&block)
    end
  end

  class TreeNode1 < TreeNode
    attr_reader :head, :multitive, :tail

    def initialize(text, offset, elements)
      super
      @head = elements[0]
      @multitive = elements[0]
      @tail = elements[1]
    end
  end

  class TreeNode2 < TreeNode
    attr_reader :space, :operator, :additive_op, :operand, :multitive

    def initialize(text, offset, elements)
      super
      @space = elements[2]
      @operator = elements[1]
      @additive_op = elements[1]
      @operand = elements[3]
      @multitive = elements[3]
    end
  end

  class TreeNode3 < TreeNode
    attr_reader :head, :primary, :tail

    def initialize(text, offset, elements)
      super
      @head = elements[0]
      @primary = elements[0]
      @tail = elements[1]
    end
  end

  class TreeNode4 < TreeNode
    attr_reader :space, :operator, :multitive_op, :operand, :primary

    def initialize(text, offset, elements)
      super
      @space = elements[2]
      @operator = elements[1]
      @multitive_op = elements[1]
      @operand = elements[3]
      @primary = elements[3]
    end
  end

  class TreeNode5 < TreeNode
    attr_reader :space, :expression

    def initialize(text, offset, elements)
      super
      @space = elements[3]
      @expression = elements[2]
    end
  end

  ParseError = Class.new(StandardError)

  FAILURE = Object.new

  module Grammar
    def _read_expression
      address0, index0 = FAILURE, @offset
      cached = @cache[:expression][index0]
      if cached
        @offset = cached[1]
        return cached[0]
      end
      address0 = _read_additive
      @cache[:expression][index0] = [address0, @offset]
      return address0
    end

    def _read_additive
      address0, index0 = FAILURE, @offset
      cached = @cache[:additive][index0]
      if cached
        @offset = cached[1]
        return cached[0]
      end
      index1, elements0 = @offset, []
      address1 = FAILURE
      address1 = _read_multitive
      unless address1 == FAILURE
        elements0 << address1
        address2 = FAILURE
        remaining0, index2, elements1, address3 = 0, @offset, [], true
        until address3 == FAILURE
          index3, elements2 = @offset, []
          address4 = FAILURE
          address4 = _read_space
          unless address4 == FAILURE
            elements2 << address4
            address5 = FAILURE
            address5 = _read_additive_op
            unless address5 == FAILURE
              elements2 << address5
              address6 = FAILURE
              address6 = _read_space
              unless address6 == FAILURE
                elements2 << address6
                address7 = FAILURE
                address7 = _read_multitive
                unless address7 == FAILURE
                  elements2 << address7
                else
                  elements2 = nil
                  @offset = index3
                end
              else
                elements2 = nil
                @offset = index3
              end
            else
              elements2 = nil
              @offset = index3
            end
          else
            elements2 = nil
            @offset = index3
          end
          if elements2.nil?
            address3 = FAILURE
          else
            address3 = TreeNode2.new(@input[index3...@offset], index3, elements2)
            @offset = @offset
          end
          unless address3 == FAILURE
            elements1 << address3
            remaining0 -= 1
          end
        end
        if remaining0 <= 0
          address2 = TreeNode.new(@input[index2...@offset], index2, elements1)
          @offset = @offset
        else
          address2 = FAILURE
        end
        unless address2 == FAILURE
          elements0 << address2
        else
          elements0 = nil
          @offset = index1
        end
      else
        elements0 = nil
        @offset = index1
      end
      if elements0.nil?
        address0 = FAILURE
      else
        address0 = TreeNode1.new(@input[index1...@offset], index1, elements0)
        @offset = @offset
      end
      address0.extend(@types::BinaryOperation)
      @cache[:additive][index0] = [address0, @offset]
      return address0
    end

    def _read_additive_op
      address0, index0 = FAILURE, @offset
      cached = @cache[:additive_op][index0]
      if cached
        @offset = cached[1]
        return cached[0]
      end
      index1 = @offset
      chunk0 = nil
      if @offset < @input_size
        chunk0 = @input[@offset...@offset + 1]
      end
      if chunk0 == "+"
        address0 = TreeNode.new(@input[@offset...@offset + 1], @offset)
        @offset = @offset + 1
      else
        address0 = FAILURE
        if @offset > @failure
          @failure = @offset
          @expected = []
        end
        if @offset == @failure
          @expected << "'+'"
        end
      end
      if address0 == FAILURE
        @offset = index1
        chunk1 = nil
        if @offset < @input_size
          chunk1 = @input[@offset...@offset + 1]
        end
        if chunk1 == "-"
          address0 = TreeNode.new(@input[@offset...@offset + 1], @offset)
          @offset = @offset + 1
        else
          address0 = FAILURE
          if @offset > @failure
            @failure = @offset
            @expected = []
          end
          if @offset == @failure
            @expected << "'-'"
          end
        end
        if address0 == FAILURE
          @offset = index1
        end
      end
      address0.extend(@types::AdditiveOpNode)
      @cache[:additive_op][index0] = [address0, @offset]
      return address0
    end

    def _read_multitive
      address0, index0 = FAILURE, @offset
      cached = @cache[:multitive][index0]
      if cached
        @offset = cached[1]
        return cached[0]
      end
      index1, elements0 = @offset, []
      address1 = FAILURE
      address1 = _read_primary
      unless address1 == FAILURE
        elements0 << address1
        address2 = FAILURE
        remaining0, index2, elements1, address3 = 0, @offset, [], true
        until address3 == FAILURE
          index3, elements2 = @offset, []
          address4 = FAILURE
          address4 = _read_space
          unless address4 == FAILURE
            elements2 << address4
            address5 = FAILURE
            address5 = _read_multitive_op
            unless address5 == FAILURE
              elements2 << address5
              address6 = FAILURE
              address6 = _read_space
              unless address6 == FAILURE
                elements2 << address6
                address7 = FAILURE
                address7 = _read_primary
                unless address7 == FAILURE
                  elements2 << address7
                else
                  elements2 = nil
                  @offset = index3
                end
              else
                elements2 = nil
                @offset = index3
              end
            else
              elements2 = nil
              @offset = index3
            end
          else
            elements2 = nil
            @offset = index3
          end
          if elements2.nil?
            address3 = FAILURE
          else
            address3 = TreeNode4.new(@input[index3...@offset], index3, elements2)
            @offset = @offset
          end
          unless address3 == FAILURE
            elements1 << address3
            remaining0 -= 1
          end
        end
        if remaining0 <= 0
          address2 = TreeNode.new(@input[index2...@offset], index2, elements1)
          @offset = @offset
        else
          address2 = FAILURE
        end
        unless address2 == FAILURE
          elements0 << address2
        else
          elements0 = nil
          @offset = index1
        end
      else
        elements0 = nil
        @offset = index1
      end
      if elements0.nil?
        address0 = FAILURE
      else
        address0 = TreeNode3.new(@input[index1...@offset], index1, elements0)
        @offset = @offset
      end
      address0.extend(@types::BinaryOperation)
      @cache[:multitive][index0] = [address0, @offset]
      return address0
    end

    def _read_multitive_op
      address0, index0 = FAILURE, @offset
      cached = @cache[:multitive_op][index0]
      if cached
        @offset = cached[1]
        return cached[0]
      end
      index1 = @offset
      chunk0 = nil
      if @offset < @input_size
        chunk0 = @input[@offset...@offset + 1]
      end
      if chunk0 == "*"
        address0 = TreeNode.new(@input[@offset...@offset + 1], @offset)
        @offset = @offset + 1
      else
        address0 = FAILURE
        if @offset > @failure
          @failure = @offset
          @expected = []
        end
        if @offset == @failure
          @expected << "'*'"
        end
      end
      if address0 == FAILURE
        @offset = index1
        chunk1 = nil
        if @offset < @input_size
          chunk1 = @input[@offset...@offset + 1]
        end
        if chunk1 == "/"
          address0 = TreeNode.new(@input[@offset...@offset + 1], @offset)
          @offset = @offset + 1
        else
          address0 = FAILURE
          if @offset > @failure
            @failure = @offset
            @expected = []
          end
          if @offset == @failure
            @expected << "'/'"
          end
        end
        if address0 == FAILURE
          @offset = index1
        end
      end
      address0.extend(@types::MultitiveOpNode)
      @cache[:multitive_op][index0] = [address0, @offset]
      return address0
    end

    def _read_primary
      address0, index0 = FAILURE, @offset
      cached = @cache[:primary][index0]
      if cached
        @offset = cached[1]
        return cached[0]
      end
      index1 = @offset
      address0 = _read_variable
      if address0 == FAILURE
        @offset = index1
        address0 = _read_number
        if address0 == FAILURE
          @offset = index1
          index2, elements0 = @offset, []
          address1 = FAILURE
          index3 = @offset
          chunk0 = nil
          if @offset < @input_size
            chunk0 = @input[@offset...@offset + 1]
          end
          if chunk0 == "("
            address1 = TreeNode.new(@input[@offset...@offset + 1], @offset)
            @offset = @offset + 1
          else
            address1 = FAILURE
            if @offset > @failure
              @failure = @offset
              @expected = []
            end
            if @offset == @failure
              @expected << "'('"
            end
          end
          if address1 == FAILURE
            address1 = TreeNode.new(@input[index3...index3], index3)
            @offset = index3
          end
          unless address1 == FAILURE
            elements0 << address1
            address2 = FAILURE
            address2 = _read_space
            unless address2 == FAILURE
              elements0 << address2
              address3 = FAILURE
              address3 = _read_expression
              unless address3 == FAILURE
                elements0 << address3
                address4 = FAILURE
                address4 = _read_space
                unless address4 == FAILURE
                  elements0 << address4
                  address5 = FAILURE
                  index4 = @offset
                  chunk1 = nil
                  if @offset < @input_size
                    chunk1 = @input[@offset...@offset + 1]
                  end
                  if chunk1 == ")"
                    address5 = TreeNode.new(@input[@offset...@offset + 1], @offset)
                    @offset = @offset + 1
                  else
                    address5 = FAILURE
                    if @offset > @failure
                      @failure = @offset
                      @expected = []
                    end
                    if @offset == @failure
                      @expected << "')'"
                    end
                  end
                  if address5 == FAILURE
                    address5 = TreeNode.new(@input[index4...index4], index4)
                    @offset = index4
                  end
                  unless address5 == FAILURE
                    elements0 << address5
                  else
                    elements0 = nil
                    @offset = index2
                  end
                else
                  elements0 = nil
                  @offset = index2
                end
              else
                elements0 = nil
                @offset = index2
              end
            else
              elements0 = nil
              @offset = index2
            end
          else
            elements0 = nil
            @offset = index2
          end
          if elements0.nil?
            address0 = FAILURE
          else
            address0 = TreeNode5.new(@input[index2...@offset], index2, elements0)
            @offset = @offset
          end
          address0.extend(@types::PrimaryNode)
          if address0 == FAILURE
            @offset = index1
          end
        end
      end
      @cache[:primary][index0] = [address0, @offset]
      return address0
    end

    def _read_variable
      address0, index0 = FAILURE, @offset
      cached = @cache[:variable][index0]
      if cached
        @offset = cached[1]
        return cached[0]
      end
      index1, elements0 = @offset, []
      address1 = FAILURE
      remaining0, index2, elements1, address2 = 1, @offset, [], true
      until address2 == FAILURE
        address2 = _read_letter
        unless address2 == FAILURE
          elements1 << address2
          remaining0 -= 1
        end
      end
      if remaining0 <= 0
        address1 = TreeNode.new(@input[index2...@offset], index2, elements1)
        @offset = @offset
      else
        address1 = FAILURE
      end
      unless address1 == FAILURE
        elements0 << address1
        address3 = FAILURE
        remaining1, index3, elements2, address4 = 0, @offset, [], true
        until address4 == FAILURE
          index4 = @offset
          address4 = _read_number_character
          if address4 == FAILURE
            @offset = index4
            address4 = _read_dot
            if address4 == FAILURE
              @offset = index4
            end
          end
          unless address4 == FAILURE
            elements2 << address4
            remaining1 -= 1
          end
        end
        if remaining1 <= 0
          address3 = TreeNode.new(@input[index3...@offset], index3, elements2)
          @offset = @offset
        else
          address3 = FAILURE
        end
        unless address3 == FAILURE
          elements0 << address3
          address5 = FAILURE
          remaining2, index5, elements3, address6 = 0, @offset, [], true
          until address6 == FAILURE
            address6 = _read_letter
            unless address6 == FAILURE
              elements3 << address6
              remaining2 -= 1
            end
          end
          if remaining2 <= 0
            address5 = TreeNode.new(@input[index5...@offset], index5, elements3)
            @offset = @offset
          else
            address5 = FAILURE
          end
          unless address5 == FAILURE
            elements0 << address5
          else
            elements0 = nil
            @offset = index1
          end
        else
          elements0 = nil
          @offset = index1
        end
      else
        elements0 = nil
        @offset = index1
      end
      if elements0.nil?
        address0 = FAILURE
      else
        address0 = TreeNode.new(@input[index1...@offset], index1, elements0)
        @offset = @offset
      end
      address0.extend(@types::TextNode)
      @cache[:variable][index0] = [address0, @offset]
      return address0
    end

    def _read_letter
      address0, index0 = FAILURE, @offset
      cached = @cache[:letter][index0]
      if cached
        @offset = cached[1]
        return cached[0]
      end
      chunk0 = nil
      if @offset < @input_size
        chunk0 = @input[@offset...@offset + 1]
      end
      if chunk0 =~ /\A[a-zA-Z]/
        address0 = TreeNode.new(@input[@offset...@offset + 1], @offset)
        @offset = @offset + 1
      else
        address0 = FAILURE
        if @offset > @failure
          @failure = @offset
          @expected = []
        end
        if @offset == @failure
          @expected << "[a-zA-Z]"
        end
      end
      @cache[:letter][index0] = [address0, @offset]
      return address0
    end

    def _read_dot
      address0, index0 = FAILURE, @offset
      cached = @cache[:dot][index0]
      if cached
        @offset = cached[1]
        return cached[0]
      end
      chunk0 = nil
      if @offset < @input_size
        chunk0 = @input[@offset...@offset + 1]
      end
      if chunk0 == "."
        address0 = TreeNode.new(@input[@offset...@offset + 1], @offset)
        @offset = @offset + 1
      else
        address0 = FAILURE
        if @offset > @failure
          @failure = @offset
          @expected = []
        end
        if @offset == @failure
          @expected << "'.'"
        end
      end
      @cache[:dot][index0] = [address0, @offset]
      return address0
    end

    def _read_number_character
      address0, index0 = FAILURE, @offset
      cached = @cache[:number_character][index0]
      if cached
        @offset = cached[1]
        return cached[0]
      end
      chunk0 = nil
      if @offset < @input_size
        chunk0 = @input[@offset...@offset + 1]
      end
      if chunk0 =~ /\A[0-9]/
        address0 = TreeNode.new(@input[@offset...@offset + 1], @offset)
        @offset = @offset + 1
      else
        address0 = FAILURE
        if @offset > @failure
          @failure = @offset
          @expected = []
        end
        if @offset == @failure
          @expected << "[0-9]"
        end
      end
      @cache[:number_character][index0] = [address0, @offset]
      return address0
    end

    def _read_number
      address0, index0 = FAILURE, @offset
      cached = @cache[:number][index0]
      if cached
        @offset = cached[1]
        return cached[0]
      end
      remaining0, index1, elements0, address1 = 1, @offset, [], true
      until address1 == FAILURE
        chunk0 = nil
        if @offset < @input_size
          chunk0 = @input[@offset...@offset + 1]
        end
        if chunk0 =~ /\A[0-9]/
          address1 = TreeNode.new(@input[@offset...@offset + 1], @offset)
          @offset = @offset + 1
        else
          address1 = FAILURE
          if @offset > @failure
            @failure = @offset
            @expected = []
          end
          if @offset == @failure
            @expected << "[0-9]"
          end
        end
        unless address1 == FAILURE
          elements0 << address1
          remaining0 -= 1
        end
      end
      if remaining0 <= 0
        address0 = TreeNode.new(@input[index1...@offset], index1, elements0)
        @offset = @offset
      else
        address0 = FAILURE
      end
      address0.extend(@types::NumberNode)
      @cache[:number][index0] = [address0, @offset]
      return address0
    end

    def _read_space
      address0, index0 = FAILURE, @offset
      cached = @cache[:space][index0]
      if cached
        @offset = cached[1]
        return cached[0]
      end
      remaining0, index1, elements0, address1 = 0, @offset, [], true
      until address1 == FAILURE
        chunk0 = nil
        if @offset < @input_size
          chunk0 = @input[@offset...@offset + 1]
        end
        if chunk0 == " "
          address1 = TreeNode.new(@input[@offset...@offset + 1], @offset)
          @offset = @offset + 1
        else
          address1 = FAILURE
          if @offset > @failure
            @failure = @offset
            @expected = []
          end
          if @offset == @failure
            @expected << "\" \""
          end
        end
        unless address1 == FAILURE
          elements0 << address1
          remaining0 -= 1
        end
      end
      if remaining0 <= 0
        address0 = TreeNode.new(@input[index1...@offset], index1, elements0)
        @offset = @offset
      else
        address0 = FAILURE
      end
      @cache[:space][index0] = [address0, @offset]
      return address0
    end
  end

  class Parser
    include Grammar

    def initialize(input, actions, types)
      @input = input
      @input_size = input.size
      @actions = actions
      @types = types
      @offset = 0
      @cache = Hash.new { |h,k| h[k] = {} }
      @failure = 0
      @expected = []
    end

    def parse
      tree = _read_expression
      if tree != FAILURE and @offset == @input_size
        return tree
      end
      if @expected.empty?
        @failure = @offset
        @expected << "<EOF>"
      end
      raise ParseError, Parser.format_error(@input, @failure, @expected)
    end

    def self.format_error(input, offset, expected)
      lines, line_no, position = input.split(/\n/), 0, 0
      while position <= offset
        position += lines[line_no].size + 1
        line_no += 1
      end
      message, line = "Line #{line_no}: expected #{expected * ", "}\n", lines[line_no - 1]
      message += "#{line}\n"
      position -= line.size + 1
      message += " " * (offset - position)
      return message + "^"
    end
  end

  def self.parse(input, options = {})
    parser = Parser.new(input, options[:actions], options[:types])
    parser.parse
  end
end
