
import pathlib
import re


def is_covis_file(filename):
    return re.match(r'APLUWCOVISMB.*', filename)

def make_basename(file):

    base = str(pathlib.PurePath(file).stem)

    base = re.sub(r'\.tar','',base)

    return base
