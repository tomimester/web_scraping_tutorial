#!/usr/bin/env bash

for i in {1..107}
do
    curl "https://www.ted.com/talks?language=en&page=$i&sort=popular" |
    grep "href='/talks/" |
    sed "s/^.*href='/https\:\/\/www\.ted\.com/" |
    sed "s/?.*$/\/transcript/" |
    uniq
done > ted_links.csv

counter=1
for i in $(cat ted_links.csv)
do
    curl $i |
    html2text |
    sed -n '/Details About the talk/,$p' |
    sed -n '/Programs &amp. initiatives/q;p' |
    head -n-1 |
    tail -n+2 > ted_transcripts/talk$counter.csv
    counter=$((counter+1))
done
