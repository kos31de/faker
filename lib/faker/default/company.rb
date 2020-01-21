# frozen_string_literal: true

module Faker
  class Company < Base
    flexible :company

    class << self
      ##
      # Produces a company name.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.name #=> "Roberts Inc"
      #
      # @faker.version 1.9.2
      def name
        parse('company.name')
      end

      ##
      # Produces a company suffix.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.suffix #=> "LLC"
      #
      # @faker.version 1.9.2
      def suffix
        fetch('company.suffix')
      end

      ##
      # Produces a company industry.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.industry #=> "Food & Beverages"
      #
      # @faker.version 1.9.2
      def industry
        fetch('company.industry')
      end

      ##
      # Produces a company catch phrase.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.catch_phrase #=> "Grass-roots grid-enabled portal"
      #
      # @faker.version 1.9.2
      def catch_phrase
        translate('faker.company.buzzwords').collect { |list| sample(list) }.join(' ')
      end

      ##
      # Produces a company buzzword.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.buzzword #=> "flexibility"
      #
      # @faker.version 1.9.2
      def buzzword
        sample(translate('faker.company.buzzwords').flatten)
      end

      ##
      # Produces a company bs.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.bs #=> "empower customized functionalities"
      #
      # @faker.version 1.9.2
      # When a straight answer won't do, BS to the rescue!   
      def bs
        translate('faker.company.bs').collect { |list| sample(list) }.join(' ')
      end

      ##
      # Produces a company ein.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.ein #=> "07-4009024"
      #
      # @faker.version 1.9.2
      def ein
        format('%09d', rand(10**9)).gsub(/(\d{2})(\d{7})/, '\\1-\\2')
      end

      ##
      # Produces a company duns_number.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.duns_number #=> "70-655-5105"
      #
      # @faker.version 1.9.2
      def duns_number
        format('%09d', rand(10**9)).gsub(/(\d{2})(\d{3})(\d{4})/, '\\1-\\2-\\3')
      end

      ##
      # Produces a company logo.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.logo #=> "https://pigment.github.io/fake-logos/logos/medium/color/12.png"
      #
      # @faker.version 1.9.2
      # Get a random company logo url in PNG format.
      def logo
        rand_num = rand(1..13)
        "https://pigment.github.io/fake-logos/logos/medium/color/#{rand_num}.png"
      end

      ##
      # Produces a company type.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.type #=> "Partnership"
      #
      # @faker.version 1.9.2
      def type
        fetch('company.type')
      end

      ##
      # Produces a company profession.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.profession #=> "factory worker"
      #
      # @faker.version 1.9.2
      def profession
        fetch('company.profession')
      end

      # rubocop:disable Style/AsciiComments
      # Get a random Spanish organization number. See more here https://es.wikipedia.org/wiki/Número_de_identificación_fiscal
      # rubocop:enable Style/AsciiComments
      ##
      # Produces a company spanish_organisation_number.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.spanish_organisation_number #=> "D6819358"
      #
      # @faker.version 1.9.2
      def spanish_organisation_number
        # Valid leading character: A, B, C, D, E, F, G, H, J, N, P, Q, R, S, U, V, W
        # 7 digit numbers
        letters = %w[A B C D E F G H J N P Q R S U V W]
        base = [sample(letters), format('%07d', rand(10**7))].join
        base
      end

      ##
      # Produces a company swedish_organisation_number.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.swedish_organisation_number #=> "3866029808"
      #
      # @faker.version 1.9.2
      # Get a random Swedish organization number. See more here https://sv.wikipedia.org/wiki/Organisationsnummer
      def swedish_organisation_number
        # Valid leading digit: 1, 2, 3, 5, 6, 7, 8, 9
        # Valid third digit: >= 2
        # Last digit is a control digit
        base = [sample([1, 2, 3, 5, 6, 7, 8, 9]), sample((0..9).to_a), sample((2..9).to_a), format('%06d', rand(10**6))].join
        base + luhn_algorithm(base).to_s
      end

      ##
      # Produces a company swedish_organisation_number.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.czech_organisation_number #=> "90642741"
      #
      # @faker.version 1.9.2
      def czech_organisation_number
        sum = 0
        base = []
        [8, 7, 6, 5, 4, 3, 2].each do |weight|
          base << sample((0..9).to_a)
          sum += (weight * base.last)
        end
        base << (11 - (sum % 11)) % 10
        base.join
      end

      ##
      # Produces a company french_siren_number.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.french_siren_number #=> "163417827"
      #
      # @faker.version 1.9.2
      # Get a random French SIREN number. See more here https://fr.wikipedia.org/wiki/Syst%C3%A8me_d%27identification_du_r%C3%A9pertoire_des_entreprises
      def french_siren_number
        base = (1..8).map { rand(10) }.join
        base + luhn_algorithm(base).to_s
      end

      ##
      # Produces a company french_siret_number.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.french_siret_number #=> "76430067900496"
      #
      # @faker.version 1.9.2
      def french_siret_number
        location = rand(100).to_s.rjust(4, '0')
        org_no = french_siren_number + location
        org_no + luhn_algorithm(org_no).to_s
      end

      ##
      # Produces a company norwegian_organisation_number.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.norwegian_organisation_number #=> "842457173"
      #
      # @faker.version 1.9.2
      # Get a random Norwegian organization number. Info: https://www.brreg.no/om-oss/samfunnsoppdraget-vart/registera-vare/einingsregisteret/organisasjonsnummeret/
      def norwegian_organisation_number
        # Valid leading digit: 8, 9
        mod11_check = nil
        while mod11_check.nil?
          base = [sample([8, 9]), format('%07d', rand(10**7))].join
          mod11_check = mod11(base)
        end
        base + mod11_check.to_s
      end

      ##
      # Produces a company australian_business_number.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.australian_business_number #=> "93579396170"
      #
      # @faker.version 1.9.2
      def australian_business_number
        base = format('%09d', rand(10**9))
        abn = "00#{base}"

        (99 - (abn_checksum(abn) % 89)).to_s + base
      end

      ##
      # Produces a company polish_taxpayer_identification_number.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.polish_taxpayer_identification_number #=> "2767549463"
      #
      # @faker.version 1.9.2
      # Get a random Polish taxpayer identification number More info https://pl.wikipedia.org/wiki/NIP
      def polish_taxpayer_identification_number
        result = []
        weights = [6, 5, 7, 2, 3, 4, 5, 6, 7]
        loop do
          result = Array.new(3) { rand(1..9) } + Array.new(7) { rand(10) }
          break if (weight_sum(result, weights) % 11) == result[9]
        end
        result.join('')
      end

      ##
      # Produces a company polish_register_of_national_economy.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.polish_register_of_national_economy #=> "788435970"
      #
      # @faker.version 1.9.2
      # Get a random Polish register of national economy number. More info https://pl.wikipedia.org/wiki/REGON
      def polish_register_of_national_economy(legacy_length = NOT_GIVEN, length: 9)
        warn_for_deprecated_arguments do |keywords|
          keywords << :length if legacy_length != NOT_GIVEN
        end

        raise ArgumentError, 'Length should be 9 or 14' unless [9, 14].include? length

        random_digits = []
        loop do
          random_digits = Array.new(length) { rand(10) }
          break if collect_regon_sum(random_digits) == random_digits.last
        end
        random_digits.join('')
      end

      ##
      # Produces a company south_african_pty_ltd_registration_number.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.south_african_pty_ltd_registration_number #=> "7043/2400717902/07"
      #
      # @faker.version 1.9.2
      def south_african_pty_ltd_registration_number
        regexify(/\d{4}\/\d{4,10}\/07/)
      end

      ##
      # Produces a company south_african_close_corporation_registration_number.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.south_african_close_corporation_registration_number #=> "CK38/5739937418/23"
      #
      # @faker.version 1.9.2
      def south_african_close_corporation_registration_number
        regexify(/(CK\d{2}|\d{4})\/\d{4,10}\/23/)
      end

      ##
      # Produces a company south_african_listed_company_registration_number.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.south_african_listed_company_registration_number #=> "2512/87676/06"
      #
      # @faker.version 1.9.2
      def south_african_listed_company_registration_number
        regexify(/\d{4}\/\d{4,10}\/06/)
      end

      ##
      # Produces a company south_african_trust_registration_number.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.south_african_trust_registration_number #=> "IT5673/937519896"
      #
      # @faker.version 1.9.2
      def south_african_trust_registration_number
        regexify(/IT\d{2,4}\/\d{2,10}/)
      end

      ##
      # Produces a company brazilian_company_number.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.brazilian_company_number #=> "37205322000500"
      #
      # @faker.version 1.9.2
      def brazilian_company_number(legacy_formatted = NOT_GIVEN, formatted: false)
        warn_for_deprecated_arguments do |keywords|
          keywords << :formatted if legacy_formatted != NOT_GIVEN
        end

        digits = Array.new(8) { Faker::Number.digit.to_i } + [0, 0, 0, Faker::Number.non_zero_digit.to_i]

        factors = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2, 6].cycle

        2.times do
          checksum = digits.inject(0) { |acc, digit| acc + digit * factors.next } % 11
          digits << (checksum < 2 ? 0 : 11 - checksum)
        end

        number = digits.join

        formatted ? format('%s.%s.%s/%s-%s', *number.scan(/(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/).flatten) : number
      end

      ##
      # Produces a company sic_code.
      #
      # @return [String]
      #
      # @example
      #   Faker::Company.sic_code #=> "7383" 
      #
      # @faker.version 2.0.0
      def sic_code
        fetch('company.sic_code')
      end

      private

      # Mod11 functionality from https://github.com/badmanski/mod11/blob/master/lib/mod11.rb
      def mod11(number)
        weight = [2, 3, 4, 5, 6, 7,
                  2, 3, 4, 5, 6, 7,
                  2, 3, 4, 5, 6, 7]

        sum = 0

        number.to_s.reverse.chars.each_with_index do |char, i|
          sum += char.to_i * weight[i]
        end

        remainder = sum % 11

        case remainder
        when 0 then remainder
        when 1 then nil
        else 11 - remainder
        end
      end

      def luhn_algorithm(number)
        multiplications = []

        number.to_s.reverse.split(//).each_with_index do |digit, i|
          multiplications << if i.even?
                               digit.to_i * 2
                             else
                               digit.to_i
                             end
        end

        sum = 0

        multiplications.each do |num|
          num.to_s.each_byte do |character|
            sum += character.chr.to_i
          end
        end

        control_digit = if (sum % 10).zero?
                          0
                        else
                          (sum / 10 + 1) * 10 - sum
                        end

        control_digit
      end

      def abn_checksum(abn)
        abn_weights = [10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
        sum = 0

        abn_weights.each_with_index do |weight, i|
          sum += weight * abn[i].to_i
        end

        sum
      end

      def collect_regon_sum(array)
        weights = if array.size == 9
                    [8, 9, 2, 3, 4, 5, 6, 7]
                  else
                    [2, 4, 8, 5, 0, 9, 7, 3, 6, 1, 2, 4, 8]
                  end
        sum = weight_sum(array, weights) % 11
        sum == 10 ? 0 : sum
      end

      def weight_sum(array, weights)
        sum = 0
        (0..weights.size - 1).each do |index|
          sum += (array[index] * weights[index])
        end
        sum
      end
    end
  end
end
