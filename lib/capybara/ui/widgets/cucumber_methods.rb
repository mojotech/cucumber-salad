module Capybara
  module UI
    module CucumberMethods
      begin
        require 'cucumber/multiline_argument/data_table'

        # Compares this widget with the given Cucumber +table+.
        #
        # === Example
        #
        #   Then(/^some step that takes in a cucumber table$/) do |table|
        #     widget(:my_widget).diff table
        #   end
        #
        # Pass +ignore_case: true+, for a case-insensitive table match
        #
        # === Example
        #
        #   Then(/^some step that takes in a cucumber table$/) do |table|
        #     widget(:my_widget).diff table, ignore_case: true
        #   end
        #
        def diff(table, wait_time = Capybara.default_max_wait_time, ignore_case: false)
          to_table = self.to_table

          if ignore_case == true
            table = Cucumber::MultilineArgument::DataTable.from(downcase_array(table.raw))
            to_table = downcase_array(to_table)
          end

          table.diff!(to_table) || true
        end

        private

        def downcase_array(array)
          array.map do |item|
            case item
            when String
              item.downcase
            when Array
              downcase_array(item)
            when Hash
              downcase_hash(item)
            end
          end
        end

        def downcase_hash(hash)
          hash.each do |k, v|
            case v
            when String
              hash[k] = v.downcase
            when Array
              downcase_array(v)
            when Hash
              downcase_hash(v)
            end
          end
        end

      rescue LoadError
        # *crickets*
      end
    end
  end
end
