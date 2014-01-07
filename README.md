Cumulus
===

[![Gem Version](https://badge.fury.io/rb/cumulus.png)](http://badge.fury.io/rb/cumulus)

Simple CLI for analyzing cloud cost data through the Cloduability API, using the [cloudability gem](https://github.com/ColbyAley/cloudability). Caches your API key in your [.netrc](http://www.gnu.org/software/inetutils/manual/html_node/The-_002enetrc-File.html) file for convenience.

## Installation

    $ gem install cumulus

## Usage

    $ cumulus budgets # Get a list of your budgets.
    $ cumulus credentials # Get a list of your credentials.
    $ cumulus billing --by period --count 20
    $ cumulus billing # Get your 10 most recent billing reports.
    $ cumulus billing --count=20 # Get your 20(N) most recent billing reports.
    $ cumulus invites # Get a list of your organization user invites. (must be org admin)
    $ cumulus invites --role=user --state=pending # Get a list of pending user invites.

For a list of all the commands:

    $ cumulus help

And for help on a single command:

    $ cumulus help [COMMAND]

As always, email me at colby@cloudability.com if you have any questions.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
