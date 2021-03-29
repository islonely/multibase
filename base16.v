module multibase

const(
	hex_table_upper = [
		`0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`,
		`8`, `9`, `A`, `B`, `C`, `D`, `E`, `F`
	]
)

// Encodes input string to hexadecimal string while also
// returning hex string length
pub fn hex_encode(input string) (string, int) {
	mut enc := []byte{len: input.len * 2}
	for i, val in input.bytes() {
		enc[i*2] = hex_table_upper[val >> 4]
		enc[i*2+1] = hex_table_upper[val & 0x0F]
	}

	return enc.bytestr(), input.len*2
}

// Encodes input string to hexadecimal string
pub fn hex_encode_string(input string) string {
	enc, _ := hex_encode(input)
	return enc
}