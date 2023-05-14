#!/home/freundt/usr/bin/mawk -f

/^([\x1b]\[[0-9][0-9]*m)*@@/ {
	## hunk start
	if (not_only_pav) {
		print hunk
		not_only_pav = 0
	}
	hunk = ""
}
/^([\x1b]\[[0-9][0-9]*m)*[+-]/ {
	if ($0 ~ /pav:/ || $0 ~ /prov:/) {
		
	} else {
		not_only_pav = 1
	}
}
{
	hunk = hunk "\n" $0
}
END {
	if (not_only_pav) {
		print hunk
	}
}
