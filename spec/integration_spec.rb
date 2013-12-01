require 'spec_helper'

describe Morpher do
  include Morpher::NodeHelpers

  def strip(text)
    return text if text.empty?
    lines = text.lines
    match = /\A[ ]*/.match(lines.first)
    range = match[0].length..-1
    source = lines.map do |line|
      line[range]
    end.join
    source.chomp << "\n"
  end

  class Foo
    include Anima.new(:attribute_a, :attribute_b)
  end

  class Bar
    include Anima.new(:baz)
  end

  class Baz
    include Anima.new(:value)
  end

  let(:tree_a) do
    Foo.new(
      attribute_a: Baz.new(value: :value_a),
      attribute_b: :value_b
    )
  end

  let(:transformer_ast) do
    s(:block,
      s(:guard, s(:primitive, Hash)),
      s(:hash_transform,
        s(:symbolize_key, :attribute_a,
          s(:guard, s(:primitive, String))
        ),
        s(:symbolize_key, :attribute_b,
          s(:guard, s(:primitive, Fixnum))
        )
      ),
      s(:anima_load, Foo)
    )
  end

  let(:predicate_ast) do
    s(:block,
      s(:key_fetch, :attribute_a),
      s(:eql, 'foo')
    )
  end

  specify 'allows to execute a transformation' do
    evaluator = Morpher.evaluator(transformer_ast)

    valid = {
      'attribute_a' => 'a string',
      'attribute_b' => 8015
    }

    expect(evaluator.call(valid)).to eql(
      Foo.new(attribute_a: 'a string', attribute_b: 8015)
    )

    evaluation = evaluator.evaluation(valid)

    expect(evaluation.output).to eql(
      Foo.new(attribute_a: 'a string', attribute_b: 8015)
    )

    invalid = {
      'attribute_a' => 0,
      'attribute_b' => 8015
    }

    expect { evaluator.call(invalid) }.to raise_error(Morpher::Evaluator::Transformer::TransformError)

    # FIXME: Evaluations should be able to signal error also
    # evaluation = evaluator.evaluation(invalid)
  end

  specify 'allows to inverse a transformations' do
    evaluator = Morpher.evaluator(transformer_ast)

    expect(evaluator.inverse.inverse).to eql(evaluator)
  end

  specify 'allows predicates to be run from sexp' do

    valid = { attribute_a: 'foo' }
    invalid = { attribute_a: 'bar' }

    evaluator = Morpher.evaluator(predicate_ast)

    expect(evaluator.call(valid)).to be(true)
    expect(evaluator.call(invalid)).to be(false)

    evaluation = evaluator.evaluation(valid)

    expect(evaluation.output).to be(true)
    expect(evaluation.input).to be(valid)
    expect(evaluation.description).to eql(strip(<<-TEXT))
      Morpher::Evaluation::Nary
        input: {:attribute_a=>"foo"}
        output: true
        evaluator: Morpher::Evaluator::Transformer::Block
        evaluations:
          Morpher::Evaluation
            input: {:attribute_a=>"foo"}
            output: "foo"
            evaluator:
              Morpher::Evaluator::Transformer::Key::Fetch
                param: :attribute_a
          Morpher::Evaluation
            input: "foo"
            output: true
            evaluator:
              Morpher::Evaluator::Predicate::EQL
                param: "foo"
    TEXT
  end
end