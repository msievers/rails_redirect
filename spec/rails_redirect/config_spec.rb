describe RailsRedirect::Config do
  let(:yaml) do
    <<-yaml.strip_heredoc
    ---
    rules:
      - /foo: /bar
      - !ruby/regexp /\/foo\/(?<id>\\d+)/: /bar/\\k<id>
    yaml
  end

  describe ".new" do
    it "can be called with a hash" do
      config = described_class.new(YAML.load(yaml))
      expect(config).not_to be_nil # bogus test, mainly for internal development
    end
  end
end
