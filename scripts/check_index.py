import sqlite3
from argparse import ArgumentParser

parser = ArgumentParser("check_index")
parser.add_argument("--index", required=False)
parser.add_argument("--digest", required=True)
args = parser.parse_args()

exists = False
if args.index:
    db = sqlite3.connect(args.index)
    check = db.execute("SELECT 1 FROM images WHERE digest = ?", (args.digest,))
    exists = check.fetchone() is not None
    db.close()

print("true" if exists else "false")
