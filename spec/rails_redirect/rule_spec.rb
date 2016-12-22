describe RailsRedirect::Rule do
  RSpec::Matchers.define :be_regexp_selector do |regexp|
    match do |actual|
      actual.callable == nil && actual.regexp == regexp && actual.string == nil
    end
  end

  RSpec::Matchers.define :be_string_selector do |string|
    match do |actual|
      actual.callable == nil && actual.regexp == nil && actual.string == string
    end
  end

  RSpec::Matchers.define :be_string_transformation do |string, status = nil|
    match do |actual|
      actual.callable == nil && actual.string == string &&
      status ? actual.status == status : true
    end
  end

  describe ".new" do
    context "string selectors" do
      it 'can be called with { "/foo" => "/bar" }' do
        rule = described_class.new("/foo" => "/bar")

        expect(rule.selector).to be_string_selector("/foo")
        expect(rule.transformation).to be_string_transformation("/bar")
      end

      it 'can be called with { "/foo" => ["/bar"] }' do
        rule = described_class.new("/foo" => ["/bar"])

        expect(rule.selector).to be_string_selector("/foo")
        expect(rule.transformation).to be_string_transformation("/bar")
      end

      it 'can be called with { "/foo" => ["/bar", 302] }' do
        rule = described_class.new("/foo" => ["/bar", 302])

        expect(rule.selector).to be_string_selector("/foo")
        expect(rule.transformation).to be_string_transformation("/bar", 302)
      end
    end

    context "regexp selectors" do
      it 'can be called with { /foo/ => "/bar" }' do
        rule = described_class.new(/foo/ => "/bar")

        expect(rule.selector).to be_regexp_selector(/foo/)
        expect(rule.transformation).to be_string_transformation("/bar")
      end

      it 'can be called with { /foo/ => ["/bar"] }' do
        rule = described_class.new(/foo/ => ["/bar"])

        expect(rule.selector).to be_regexp_selector(/foo/)
        expect(rule.transformation).to be_string_transformation("/bar")
      end

      it 'can be called with { /foo/ => ["/bar", 302] }' do
        rule = described_class.new(/foo/ => ["/bar", 302])

        expect(rule.selector).to be_regexp_selector(/foo/)
        expect(rule.transformation).to be_string_transformation("/bar", 302)
      end

      it 'can be called with { /foo\/(\d+)/ => "/bar/\\\\1" }' do # "\\\\" to keep spec output in-sync with code
        rule = described_class.new(/foo\/(\d+)/ => "/bar/\\1")

        expect(rule.selector).to be_regexp_selector(/foo\/(\d+)/)
        expect(rule.transformation).to be_string_transformation("/bar/\\1")
      end

      it 'can be called with { /foo\/(?<id>\d+)/ => "/bar/\\\\k<id>" }' do # "\\\\" to keep spec output in-sync with code
        rule = described_class.new(/foo\/(?<id>\d+)/ => "/bar/\\k<id>")

        expect(rule.selector).to be_regexp_selector(/foo\/(?<id>\d+)/)
        expect(rule.transformation).to be_string_transformation("/bar/\\k<id>")
      end
    end
  end
end
