#!/usr/bin/env python3
"""Renumber ordered (numbered) lists in Quarto/Markdown files.

Why this exists: it's convenient to type every list item as "1." and let
the renderer auto-increment. But Pandoc/Quarto only auto-increments within
one contiguous list block -- a heading, a code chunk, an image, or any
other block content in between starts a *new* block that restarts at 1.
That's the "1, 2, 3 ... 1, 2, 3" bug.

This script rewrites the literal number on every ordered-list item so the
count keeps climbing across headers, code chunks, images, etc. Nested
lists (indented more than their parent) get their own counter that resets
each time a new nested block starts. You can still just type "1." for
every new item -- rerun this script afterward and it fixes the numbers.

Usage:
    python renumber_lists.py FILE.qmd [FILE2.qmd ...]
    python renumber_lists.py --check FILE.qmd     # show a diff, don't write
    python renumber_lists.py *.qmd                # process every file given

To force a fresh count to restart partway through a document (rare), add
a line containing only:
    <!-- renumber: reset -->
That line is removed from the output.
"""
import difflib
import re
import sys
from pathlib import Path

LIST_RE = re.compile(r'^(?P<indent>[ \t]*)(?P<num>\d+)(?P<sep>[.)])(?P<space>\s+)(?P<rest>.*)$')
FENCE_RE = re.compile(r'^\s*(```+|~~~+)')
RESET_MARKER = '<!-- renumber: reset -->'


def renumber(lines):
    out = []
    stack = []  # [[indent, next_number], ...] outermost first
    in_code = False
    fence_char = None
    in_frontmatter = False

    for i, raw_line in enumerate(lines):
        line = raw_line.rstrip('\n')
        newline = raw_line[len(line):]  # preserve '\n' or '' (last line)

        if i == 0 and line.strip() == '---':
            in_frontmatter = True
            out.append(raw_line)
            continue
        if in_frontmatter:
            out.append(raw_line)
            if line.strip() == '---':
                in_frontmatter = False
            continue

        fence = FENCE_RE.match(line)
        if fence:
            char = fence.group(1)[0]
            if not in_code:
                in_code, fence_char = True, char
            elif char == fence_char:
                in_code = False
            out.append(raw_line)
            continue
        if in_code:
            out.append(raw_line)
            continue

        if line.strip() == RESET_MARKER:
            stack = []
            continue

        m = LIST_RE.match(line)
        if m:
            indent = len(m.group('indent').expandtabs())
            while stack and stack[-1][0] > indent:
                stack.pop()
            if not stack or stack[-1][0] < indent:
                stack.append([indent, 1])
            number = stack[-1][1]
            stack[-1][1] += 1
            out.append(
                f"{m.group('indent')}{number}{m.group('sep')}{m.group('space')}{m.group('rest')}{newline}"
            )
            continue

        out.append(raw_line)

    return out


def process_file(path: Path, check: bool):
    text = path.read_text()
    lines = text.splitlines(keepends=True)
    new_text = ''.join(renumber(lines))

    if new_text == text:
        print(f'{path}: already correct')
        return

    if check:
        sys.stdout.writelines(difflib.unified_diff(
            text.splitlines(keepends=True),
            new_text.splitlines(keepends=True),
            fromfile=str(path),
            tofile=f'{path} (renumbered)',
        ))
    else:
        path.write_text(new_text)
        print(f'{path}: renumbered')


def main():
    args = sys.argv[1:]
    check = '--check' in args
    if check:
        args.remove('--check')
    if not args:
        print(__doc__)
        sys.exit(1)
    for arg in args:
        process_file(Path(arg), check=check)


if __name__ == '__main__':
    main()
