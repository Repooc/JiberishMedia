"""Check font/license coverage and unchanged reviewed binaries, including release ZIPs."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import zipfile


FONT_EXTENSIONS = {'.ttf', '.otf', '.ttc', '.woff', '.woff2'}


def text_content(content):
    # BigWigs packages text with CRLF by default. The wording must still match
    # the reviewed LF source; font binary checksums remain byte-for-byte exact.
    return content.decode('utf-8').replace('\r\n', '\n')


def check(files, label):
    manifest = json.loads(files['licenses/fonts.json'])
    assert manifest['schema_version'] == 1, 'Unsupported font inventory version'
    entries = manifest['fonts']
    paths = {entry['file'] for entry in entries}
    assert entries and len(paths) == len(entries), 'Empty or duplicate font inventory'
    actual = {name for name in files if Path(name).suffix.lower() in FONT_EXTENSIONS}
    assert actual == paths, 'Unreviewed or missing fonts: ' + str(sorted(actual ^ paths))
    license_paths = manifest['license_files']
    for path, expected in license_paths.items():
        normalized = text_content(files[path]).encode('utf-8')
        assert hashlib.sha256(normalized).hexdigest() == expected, 'Changed license text: ' + path
    notices = text_content(files['licenses/FONT-NOTICES.txt'])
    for entry in entries:
        path = entry['file']
        assert hashlib.sha256(files[path]).hexdigest() == entry['sha256'], 'Font needs review: ' + path
        assert entry['license'] in {'OFL-1.1', 'Apache-2.0'}, 'Unreviewed font license: ' + path
        assert entry['license_file'] == 'licenses/' + entry['license'] + '.txt'
        assert entry['license_file'] in license_paths, 'License missing from inventory: ' + path
        assert path in notices, 'Missing font notice: ' + path
        assert entry['copyright'] and entry['copyright'] in notices, 'Missing copyright: ' + path

    registrations = re.findall(
        r'^\s*LSM:Register\("font", "([^"]+)", \[\[(.*?)\]\]\)',
        files['Media.lua'].decode('utf-8'), re.MULTILINE)
    names = [name for name, _ in registrations]
    assert len(names) == len(set(names)), 'Duplicate font media name'
    registered = set()
    prefix = 'interface/addons/jiberishmedia/'
    for _, path in registrations:
        path = path.replace('\\', '/')
        assert path.lower().startswith(prefix), 'Unexpected font location: ' + path
        registered.add(path[len(prefix):])
    assert registered == paths, 'Unregistered or missing font assets: ' + str(sorted(registered ^ paths))
    print('PASS: ' + label + ' (' + str(len(entries)) + ' fonts with matching licenses and notices)')


def check_directory(root):
    files = {p.relative_to(root).as_posix(): p.read_bytes() for p in root.rglob('*')
             if p.is_file() and '.git' not in p.relative_to(root).parts}
    check(files, str(root))


def check_archive(path):
    prefix = 'JiberishMedia/'
    with zipfile.ZipFile(path) as archive:
        names = archive.namelist()
        assert len(names) == len(set(names)), 'Duplicate ZIP members'
        assert all(name.startswith(prefix) for name in names
                   if Path(name).suffix.lower() in FONT_EXTENSIONS), 'Font outside addon folder'
        files = {name[len(prefix):]: archive.read(name) for name in names
                 if name.startswith(prefix) and not name.endswith('/')}
    check(files, str(path))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('root', nargs='?', type=Path, default=Path('JiberishMedia'))
    parser.add_argument('--archives', type=Path, help='Check every package ZIP in this directory')
    args = parser.parse_args()
    if args.archives:
        archives = sorted(args.archives.glob('*.zip'))
        assert archives, 'No package ZIPs found in ' + str(args.archives)
        for archive in archives:
            check_archive(archive)
    else:
        check_directory(args.root)
