import json
import sys
import subprocess

def get_commit_hash(source_dir):
    result = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=source_dir)
    return result.decode("utf-8").replace('\n', '')

def generate(source_dir, target_dir):
    data = {
        "cura_version": "3.2",
        "cura": get_commit_hash(source_dir),
    }

    with open(target_dir + "/version.json", 'w') as output_file:
        output_file.write(json.dumps(data, indent=4))

if __name__ == '__main__':
    generate(sys.argv[1], sys.argv[2])
