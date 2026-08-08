

# Test value https://datatracker.ietf.org/doc/html/rfc4226#page-32
test_case1=(
	755224
	287082
	359152
	969429
	338314
	254676
	287922
	162583
	399871
	520489
)

chk() {
	local case="$1" expected="$2" res="$3" explain="$4"
	printf "Test case \"$1\": "
	if [ "$res" = "$expected" ]; then
		echo "✅"
	else
		echo "❌ $explain"
	fi
}

for i in $(seq 0 9); do 
	case="${test_case1[$i]}"
	res="$(bash hotp.sh "$i" 3132333435363738393031323334353637383930)"
	chk "$i ($case)" "$case" "$res" "got $res"
done

if ! [ -f key.txt ]; then
	bash genkey.sh
fi

echo
echo "Encrypting..."
./ft_otp -g key.txt || echo "Failed to encrypt key.txt ⚠️" >&2
chk "Encrypting" "" "$(file ft_otp.key | grep "text")" "ft_otp.key is not encrypted"

echo
echo "Generating TOTP..."
shopt -s -o xtrace
expected="$(oathtool --totp @key.txt)" # <- is = `oathtool --totp $(cat key.txt)` but securyty reason`
res="$(bash ft_otp -k ft_otp.key)"
shopt -u -o xtrace

chk "Generate TOTP -> expected: $expected" "$expected" "$res" "got $res"
