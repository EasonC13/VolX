#!/usr/bin/env python3
"""Static UI inventory: only pre-existing device-name matching may contain CJK."""
from pathlib import Path
import re
root = Path(__file__).resolve().parent.parent
allowed = {'AudioDevice.swift', 'InterfaceCheckCommand.swift'}
violations = []
for path in [*root.glob('Sources/**/*.swift'), root / 'Info.plist']:
    for number, line in enumerate(path.read_text().splitlines(), 1):
        if re.search(r'[㐀-鿿]', line) and path.name not in allowed and 'let preferredGroupName =' not in line:
            violations.append(f'{path.relative_to(root)}:{number}: {line.strip()}')
assert not violations, '\n'.join(violations)
print('PASS English UI inventory (device names preserved)')
