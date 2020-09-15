#! python3
'''
Concate all the .txt files in the folder into one txt file, with an optional seperator
'''

import logging, os, re

## Set up logging file
# logging.basicConfig(level=logging.INFO
#                     , filename='txt_logging.log'
#                     , format=' %(asctime)s - %(name)s - %(levelname)s - %(message)s')
# logging.info('Start main.py')

# ## Set up standard out file
# sdpath = os.path.join('txt_stdout.log')
# sys.stdout = open(sdpath, 'w')
# sys.stderr = open(sdpath, 'a')
#
# ## Set up a second handler for output to stdout
# root = logging.getLogger()
# root.setLevel(logging.INFO)
# ch = logging.StreamHandler(sys.stdout)
# ch.setLevel(logging.INFO)
# formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
# ch.setFormatter(formatter)
# root.addHandler(ch)

##

scan_folder = os.getcwd()
fl = os.listdir(scan_folder)
# Set up a regular expression for finding .csv files with the right station_id
regex = re.compile(r'.*[.]txt$')
fl = [m.group(0) for l in fl for m in [regex.match(l)] if m]
fl.sort()


outfile = os.path.join(os.getcwd(),'combined.txt')

# If the outfile already exists, stop
if os.path.isfile(outfile):
    raise FileExistsError('Output file should not exist: ' + outfile)

with open(outfile, 'w') as outfile:
    for fname in fl:
        outfile.write('Filename: ' + fname + '\n\n')
        with open(fname) as infile:
            outfile.write(infile.read())
        outfile.write('\n')
        outfile.write('\n')
        line = '/*******************************************************************/'
        outfile.write(line)
        outfile.write('\n')
        outfile.write('\n')