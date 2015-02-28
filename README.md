trytond_accounting_ca
=====================

CA accounting basics (not chart) for Tryton ERP
===============================================

This module does NOT provides a chart of accounts or taxes.  The name
for this module is NOT trytond_account_ca to imply that it provides UK
Canadian accounting information, but not a chart of accounts.

We consider it to be a fundamental error in OpenERP and Tryton 
to name an account chart module `account_countrycode`.
They should be separated into accounting_ca which contains all
the non-chart country information including counties/postcodes and
currency conversions, and the chart in say `account_chart_ca_openlabs`.
That's because there could be thousands of different legal charts,
each made for a different business sector (service, manufacturing ...),
all sharing the same essential country-wide accounting information, and
only one in particular being made by say Openlabs.

This country module (trytond_accounting_ca) should contain 
non-chart information such as counties and postal codes, but also 
the official currency exchange rate information, and other legally mandated 
accounting information. For example in Canada, as in other countries, 
there are official government exchange rates that must be used if
your accounting is to pass with the government (CRA). The official
exchange rates also vary with  the periods between setting the rates (not always monthly).
These exchange rates should be in trytond_accounting_ca and each chart in
trytond_chart_ca_<source>, where each chart depends on trytond_accounting_ca.

** This module sets currency rates for the company assuming that
the company currency is CAD. It assumes that the GBP EUR USD and CAD
currencies are already defined.**

Medium term, it is likely that the Chart of Taxes (CoT) for VAT and tax
rules for the CA should also be refactored into this module from the
different CoA modules. Although there are an infinite number of ways
to do CoAs depending on the business, there's really only one way per
country of doing the chart of taxes: the governments' way!  Moreover,
the chart of taxes must be right or you're in trouble, and having
different CoAs using a common CoT will improve it. Also, the CoAs
often change with time in a company, whereas the CoTs change rarely,
and do so for every company in the country when they do.  Obviously
there is information the CoTs need from the CoAs, but this could use a
simple config file to specify the required interface information.

Long term, all Tryton CoAs should be refactored into these country
accounting modules trytond_accounting_??, with the CoTs pulled out of
the CoAs and unified, and the CoAs made to depend on the country
modules. Then in countries with regional taxes and reporting rules,
like Canada/Provinces or US/States, you could expect to see provincial
or state accounting modules like `trytond_accounting_ca_on`,
`trytond_accounting_ca_pq` etc. that each depend on `trytond_accounting_ca`
for the federal tax rules.  You will have to deal with this if Tryton
is ever to be used for legally acceptable accounting in those countries.

**THIS IS A WORK IN PROGRESS, UNRELEASED FOR NOW!**

The exchange rates in `currency_CAD_cra.xml` are from
http://www.bankofcanada.ca and copies are in `data/`
so you can check the numbers, or add more rates.

This module is provided as-is, without any warranties, under the GPLv3 license.
