import sys
import re

ffile = open(sys.argv[1])
outputfilename = sys.argv[2]
unique_identifiers = []

for line in ffile:
	line_array = re.split('\s+', line)
	if line_array[1] != "Louse" and line_array[0] not in unique_identifiers:
		unique_identifiers.append(line_array[0])
	

end_results = ""

for name in unique_identifiers:
	end_results = end_results + name + "\n"

output = open(outputfilename, 'w')
output.write(end_results)

