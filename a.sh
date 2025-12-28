# A task
cnt_lines=`wc --lines < "input.txt"`
cnt_words=`wc --word < "input.txt"`
cnt_letters=`grep -o "[a-zA-Z]" "input.txt" | wc -l`

echo "Input file contains:" >"output.txt"
echo "$cnt_letters letters" >>"output.txt"
echo "$cnt_words words" >>"output.txt"
echo "$cnt_lines lines" >>"output.txt"


# B task
read n < "input.txt"
type=$( sed '$!d' <input.txt)
sed -i '1d;$d' input.txt

if [[ $type == "date" ]]; then
	LC_ALL=C sort --output="output.txt" -k5n -k4n -k3n -k2 -k1 input.txt
else
	LC_ALL=C sort --output="output.txt" -k2,2 -k1,1 -k5n -k4n -k3n input.txt
fi

sed -i 's/\([a-zA-Z]*\) \([a-zA-Z]*\) \([0-9]*\) \([0-9]*\) \([0-9]*\)/\1 \2 \3.\4.\5/g' output.txt


# C task
x=-1
res=0
my_pow=1
while read a
do
	if [[ $x == "-1" ]]; then
		x=$a
	else
		add=$((my_pow*a))
		add=$((add%1000000007))
		res=$((res+add))
		res=$((res%1000000007))
		my_pow=$((my_pow*x))
		my_pow=$((my_pow%1000000007))
	fi
done < "input.txt"
echo "$res" > "output.txt"


# D task
sed -i 's/google/yandex/g' input.txt
echo -n  >output.txt

while read url
do
	http="$(cut -d'/' -f1 <<<"$url")"
	if [[ $http == "http:" || $http == "https:" ]]; then
		echo "Scheme: $http//" >>output.txt
		url=${url#"$http//"}
	fi
	host_port="$(cut -d'/' -f1 <<<"$url")"
	port="$(cut -d':' -f2 <<<"$host_port")"
	host="$(cut -d":" -f1 <<<"$host_port")"
	echo "Host: $host" >>output.txt
	if [[ $host != $host_port ]]; then
		echo "Port: $port" >>output.txt
	fi
	args=${url#"$host_port"}
	if [[ $args != "" ]]; then
		args=${args#"/?"}
		echo "Args:" >>output.txt
		while [ "$args" != "" ]
		do
			key_value="$(cut -d'&' -f1 <<<"$args")"
			key="$(cut -d'=' -f1 <<<"$key_value")"
			value="$(cut -d'=' -f2 <<<"$key_value")"
			echo "  Key: $key; Value: $value" >>output.txt
			if [[ $key_value == $args ]]; then
				args=""
			else
				args="$(cut -d'&' -f2 <<<"$args")"
			fi
		done	
	fi
	echo "" >>output.txt
done < "input.txt"


