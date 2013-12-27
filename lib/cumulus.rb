require 'cumulus/version'
require 'terminal-table'
require 'cloudability'
require 'netrc'
require 'thor'

module Cumulus
  class CLI < Thor
    include Cloudability

    method_options type: :string
    desc 'budgets', 'Displays a table of budgets'
    def budgets
      budgets = Client.new(auth_token: token).budgets

      budgets.select!{|b| b.type.downcase == options[:type] } if options[:type]

      rows = []
      budgets.each do |budget|
        if budget.is_active
          rows << [c_to_d(budget.predicted_monthly_spend.cents),
            '$' + number_with_delimiter(budget.threshold.to_i).to_s,
            budget.type, budget.subject]
        end
      end
      puts Terminal::Table.new(headings: ['Predicted spend', 'Budget threshold', 'Type', 'Subject'], rows: rows)
    end

    desc 'credentials', 'Displays a table of your connected credentials'
    def credentials
      credentials = Client.new(auth_token: token).credentials
      rows = []
      credentials.each do |cred|
        rows << [cred.vendor_key, cred.nickname]
      end
      puts Terminal::Table.new(headings: ['Vendor key', 'Nickname'], rows: rows)
    end

    method_options count: :numeric
    desc 'billing', 'Displays a table of recent billing reports'
    def billing
      count = options[:count] || 10
      reports = Client.new(auth_token: token).billing_report(by: :period).reverse[0..count]
      rows = []
      reports.each do |report|
        rows << [report.period, '$' + number_with_delimiter(report.spend).to_s]
      end
      puts Terminal::Table.new(headings: ['Period', 'Spend'], rows: rows)
    end

    method_options state: :string
    method_options role: :string
    desc 'invites', 'Displays a table of organization invitations'
    def invites
      invites = Client.new(auth_token: token).organization_invitations

      invites.select!{|i| i.organization_role.label.downcase == options[:role] } if options[:role]
      invites.select!{|i| i.state.downcase == options[:state] } if options[:state]

      rows = []
      invites.each do |invite|
        rows << [invite.user.full_name, invite.user.email, invite.organization_role.label, invite.state]
      end
      puts Terminal::Table.new(headings: ['Name', 'Email', 'Role', 'State'], rows: rows)
    end

    method_options token: :string
    desc 'set_token', 'Reset your API token'
    def set_token
      n = Netrc.read

      if options[:token]
        n.new_item_prefix = "# Added by the Cumulus gem\n"
        n["app.cloudability.com"] = options[:token], options[:token]
        n.save
        puts "Your token has been saved."
      else
        puts "Please enter your Cloudability API token and hit enter: "
        token = STDIN.gets.chomp
        n.new_item_prefix = "# Added by the Cumulus gem\n"
        n["app.cloudability.com"] = token, token
        n.save
        puts "Your token has been saved."
      end
    end

  private

    def token
      n = Netrc.read
      if !n["app.cloudability.com"].nil? && token = n["app.cloudability.com"][0]
        return token
      else
        get_token
      end
    end

    def get_token
      puts "Please enter your Cloudability API token and hit enter: "
      token = STDIN.gets.chomp
      n = Netrc.read
      n.new_item_prefix = "# Added by the Cumulus gem\n"
      n["app.cloudability.com"] = token, token
      n.save
      token
    end

    # Convert cents to dollars
    def c_to_d(cents)
      dollars = number_with_delimiter(cents.to_i / 100)
      '$' + dollars.to_s
    end

    # Source: https://gist.github.com/jpemberthy/484764
    def number_with_delimiter(number, delimiter=",", separator=".")
      begin
        parts = number.to_s.split('.')
        parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
        parts.join separator
      rescue
       number
      end
    end

  end
end