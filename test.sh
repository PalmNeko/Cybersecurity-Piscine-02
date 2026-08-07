

# Test value https://datatracker.ietf.org/doc/html/rfc4226#page-32
for i in $(seq 0 9); do echo -n "$i" | bash hotp.sh 3132333435363738393031323334353637383930; done

# 755224
# 287082
# 359152
# 969429
# 338314
# 254676
# 287922
# 162583
# 399871
# 520489

oathtool --totp -v - < key.txt ; bash ft_otp -k ft_otp.key
