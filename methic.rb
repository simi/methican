require './methic_parser'

module Methic
  module Types
    module BinaryOperation
      def eval(env = {})
        tail.elements.inject(head.eval(env)) do |value, element|
          element.operator.apply(value, element.operand.eval(env))
        end
      end
    end

    module PrimaryNode
      def eval(env = {})
        expression.eval(env)
      end
    end

    module NumberNode
      def eval(env = {})
        text.to_f
      end
    end

    module TextNode
      def eval(env = {})
        env[text]
      end
    end

    module AdditiveOpNode
      def apply(left, right)
        return (left + right) if(text[0] == '+')
        return (left - right) if(text[0] == '-')
      end
    end

    module MultitiveOpNode
      def apply(left, right)
        return (left * right) if(text[0] == '*')
        return (left / right) if(text[0] == '/')
      end
    end
  end

  def self.parse(expression)
    MethicParser.parse(expression, types: Types)
  end
end
