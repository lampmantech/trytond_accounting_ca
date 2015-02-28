#!/bin/sh

# Revenue Canada says get the exchange rates from the
# Exchange Rates page of the Bank of Canada Web site.
# Http://www.cra-arc.gc.ca/tx/ndvdls/fq/xchng_rt-eng.html

[ -d net/Http ] || mkdir -p net/Http

# download the years that you want into net/Http: e.g.
[ -f net/Http/www.bankofcanada.ca/stats/assets/pdf/nraa-2014-en.pdf ] ||
    wget -xc -P net/Http/ http://www.bankofcanada.ca/stats/assets/pdf/nraa-2014-en.pdf

# convert the pdf to text
for file in net/Http/www.bankofcanada.ca/stats/assets/pdf/nraa-*pdf ; do
    basename=`basename $file .pdf`
    [ -f data/$basename.txt ] && continue
    # careful - BOC is using windows codepages in the pdf
    pdftotext -layout -nopgbrk -enc UTF-8 - < $file data/$basename.txt
done

OUTFILE='currency_CAD_boc.xml'
cat > $OUTFILE << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<tryton>
    <data>
	<!-- this should be the default instead of the current year -->
        <record id="CAD197101" model="currency.currency.rate">
            <field name="rate" eval="Decimal('1.0000')"/>
            <field name="currency"
		   model="currency.currency" search="[('code', '=', 'CAD')]"/>
            <field name="date">1971-01-01</field>
            </record>
EOF

for CUR in USD GBP EUR ; do
    if [ $CUR = 'GBP' ] ; then
	ELT='United Kingdom'
    elif [ $CUR = 'USD' ] ; then
	ELT='United States'
    elif [ $CUR = 'EUR' ] ; then
	ELT='Europe'
    fi
    # careful - maximum of 6 digits on rate
    grep -a "^ *$ELT" data/*txt \
	| sed -e 's@data/nraa-\([12][0-9][0-9][0-9]\)-.*\([0-9][.][0-9][0-9][0-9][0-9]*\)[^.]*$@\1 \2@' \
	| sed -e 's@\(\.......\).*$@\1@' \
	| while read year rate ; do
	      echo $CUR $year $rate
	      cat >> $OUTFILE << EOF
        <record id="$CUR$year" model="currency.currency.rate">
            <field name="rate" eval="Decimal('$rate')"/>
            <field name="currency"
		   model="currency.currency" search="[('code', '=', '$CUR')]"/>
            <field name="date">$year-01-01</field>
            </record>
EOF
		done
  done

cat >> $OUTFILE << 'EOF'
    </data>
</tryton>
EOF
