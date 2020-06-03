# Downloading data on 1033 program transfers to state and local agencies

This script lets you easily automate downloading data on transfers of surplus
military equipment to law enforcement agencies in the US under the
[1033 program](https://en.wikipedia.org/wiki/1033_program).
The first time you run it, it will download the most recent version of the data.
On subsequent times it will download the most recent version of the data and save
the file if newer data have become available. It saves data with the present date
in the filename
to ensure that no data are lost if an update is released that removes any
previously-released data.

In addition to downloading the data, this script will also run an automated report.
It uses `1033.R` to generate a plot of the total number of
[Mine-Resistant Ambush Protected vehicles](https://en.wikipedia.org/wiki/MRAP)
transferred to US states from 1990 to the present. This script can be adapted to
generate any statistics you wish automatically.

## Automating

If you want to automate downloading the data, you can do so with `cron`. The
example below will set the script to download the data on the first day of every
month:

```bash
crontab -e
0 0 1 * * cd /path/to/script; ./1033.sh
```

I use a slightly modified version of `1033.sh` to update the
[`.Rmd` file](https://github.com/jayrobwilliams/jayrobwilliams.github.io/blob/master/_source/2020-06-03-visualizing-militarization.Rmd)
that generates my
[post on the transfer of MRAPs to police departments in the US](https://jayrobwilliams.com/posts/2020/06/visualizing-militarization/) whenever
newer data become available.
