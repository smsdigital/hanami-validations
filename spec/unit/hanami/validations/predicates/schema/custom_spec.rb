# frozen_string_literal: true

RSpec.describe "Predicates: custom" do
  include_context "validator result"

  describe "with custom predicate" do
    before do
      @validator = Class.new do
        include Hanami::Validations

        def self.name
          "Validator"
        end

        validations do
          configure do
            config.messages_file = "spec/support/fixtures/messages.yml"

            def email?(current)
              current.match(/\@/)
            end
          end

          required(:foo) { email? }
        end
      end
    end

    describe "with valid input" do
      let(:input) { {foo: "test@hanamirb.org"} }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with invalid input" do
      let(:input) { {foo: "test"} }

      it "is successful" do
        expect_not_successful result, ["must be an email"]
      end
    end
  end

  describe "with custom predicates as module" do
    before do
      @validator = Class.new do
        include Hanami::Validations

        def self.name
          "Validator"
        end

        predicates(
          Module.new do
            include Hanami::Validations::Predicates
            self.messages_path = "spec/support/fixtures/messages.yml"

            predicate(:email?) do |current|
              current.match(/@/)
            end
          end
        )

        validations do
          required(:foo) { email? }
        end
      end
    end

    describe "with valid input" do
      let(:input) { {foo: "test@hanamirb.org"} }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with invalid input" do
      let(:input) { {foo: "test"} }

      it "is not successful" do
        expect_not_successful result, ["must be an email"]
      end
    end
  end

  describe "with custom predicate within predicates block" do
    before do
      @validator = Class.new do
        include Hanami::Validations

        def self.name
          "Validator"
        end

        predicate :url?, message: "must be an URL" do |current|
          current.start_with?("http")
        end

        validations do
          required(:foo) { url? }
        end
      end
    end

    describe "with valid input" do
      let(:input) { {foo: "http://hanamirb.org"} }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with invalid input" do
      let(:input) { {foo: "test"} }

      it "is not successful" do
        expect_not_successful result, ["must be an URL"]
      end
    end
  end

  describe "with inline custom predicate followed by a custom predicates module" do
    before do
      @validator = Class.new do
        include Hanami::Validations

        def self.name
          "Validator"
        end

        predicate :url?, message: "must be an URL" do |current|
          current.start_with?("http")
        end

        predicates(
          Module.new do
            include Hanami::Validations::Predicates
            self.messages_path = "spec/support/fixtures/messages.yml"

            predicate(:email?) do |current|
              current.match(/@/)
            end
          end
        )

        validations do
          required(:foo) { url? | email? }
        end
      end
    end

    describe "with valid url input" do
      let(:input) { {foo: "http://hanamirb.org"} }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with valid email input" do
      let(:input) { {foo: "foo@mailinator.com"} }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with invalid input" do
      let(:input) { {foo: "test"} }

      it "is not successful" do
        expect_not_successful result, ["must be an URL or must be an email"]
      end
    end
  end

  describe "with custom predicates module followed by an inline custom predicate block" do
    before do
      @validator = Class.new do
        include Hanami::Validations

        def self.name
          "Validator"
        end

        predicates(
          Module.new do
            include Hanami::Validations::Predicates
            self.messages_path = "spec/support/fixtures/messages.yml"

            predicate(:email?) do |current|
              current.match(/@/)
            end
          end
        )

        predicate :url?, message: "must be an URL" do |current|
          current.start_with?("http")
        end

        validations do
          required(:foo) { url? | email? }
        end
      end
    end

    describe "with valid url input" do
      let(:input) { {foo: "http://hanamirb.org"} }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with valid email input" do
      let(:input) { {foo: "foo@mailinator.com"} }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with invalid input" do
      let(:input) { {foo: "test"} }

      it "is not successful" do
        expect_not_successful result, ["must be an URL or must be an email"]
      end
    end
  end

  describe "with i18n" do
    before do
      @validator = Class.new do
        include Hanami::Validations

        def self.name
          "Validator"
        end

        messages :i18n

        predicate :url? do |current|
          current.start_with?("http")
        end

        validations do
          required(:foo) { url? }
        end
      end
    end

    describe "with valid input" do
      let(:input) { {foo: "http://hanamirb.org"} }

      it "is successful" do
        expect_successful result
      end
    end

    describe "with invalid input" do
      let(:input) { {foo: "test"} }

      it "is successful" do
        expect_not_successful result, ["must be an URL"]
      end
    end
  end

  describe "without custom predicate" do
    it "raises error if try to use an unknown predicate" do
      expect do
        Class.new do
          include Hanami::Validations

          def self.name
            "Validator"
          end

          validations do
            required(:foo) { email? }
          end
        end
      end.to raise_error(ArgumentError, "+email?+ is not a valid predicate name")
    end
  end

  # See: https://github.com/hanami/validations/issues/119
  describe "with custom predicate and error messages" do
    before do
      @validator = Class.new do
        include Hanami::Validations
        messages_path "spec/support/fixtures/messages.yml"

        predicate(:adult?, message: "not old enough") do |current|
          current > 18
        end

        validations do
          required(:name) { format?(/Frank/) }
          required(:age)  { adult? }
        end
      end
    end

    it "respects messages from configuration file" do
      result = @validator.new(name: "John", age: 15).validate

      expect(result).not_to be_success
      expect(result.messages[:name]).to eq ["must be frank"]
      expect(result.messages[:age]).to eq ["not old enough"]
    end
  end

  describe "with nested validations" do
    before do
      @validator = Class.new do
        include Hanami::Validations

        def self.name
          "Validator"
        end

        validations do
          required(:details).schema do
            configure do
              config.messages_file = "spec/support/fixtures/messages.yml"

              def odd?(current)
                current.odd?
              end
            end

            required(:foo) { odd? }
          end
        end
      end
    end

    it "allows groups to define their own custom predicates" do
      result = @validator.new(details: {foo: 2}).validate

      expect(result).not_to be_success
      expect(result.messages[:details][:foo]).to eq ["must be odd"]
    end
  end
end
