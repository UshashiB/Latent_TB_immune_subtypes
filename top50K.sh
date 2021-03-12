fname=$1
outfname="Top_50K"$fname
echo $fname
awk '{print $4}' $fname | sort -n > test.txt
head -50001 test.txt > test2.txt
max_pathscore=$(tail -1 test2.txt)
awk -vmax_pathscore="$max_pathscore" '{
if ($4 <= max_pathscore)          
print
}' $1> $outfname
rm test.txt
rm test2.txt
