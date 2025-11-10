#!/usr/bin/env python3
"""
migrate_quizzes.py

Usage:
  python migrate_quizzes.py --service-account /path/to/serviceAccount.json --database-url https://<PROJECT>.firebaseio.com --apply --default-faculty-id <UID> --default-faculty-name "Prof Name"

This script scans the Realtime Database under /quizzes and sets a `createdBy` and optional `createdByName` field
for quizzes that are missing it. It supports a mapping CSV to set specific creators per quiz.

Mapping CSV format (optional): subject,unit,quizKey,facultyId,facultyName

By default the script runs in dry-run mode and will only print the intended updates. Use --apply to perform writes.

Requires: firebase-admin, python-dotenv (optional)
pip install firebase-admin python-dotenv

Be careful and backup your DB before running with --apply.
"""

import argparse
import csv
import json
import os
from typing import Dict, Tuple

import firebase_admin
from firebase_admin import credentials
from firebase_admin import db


def load_mapping_csv(path: str) -> Dict[Tuple[str, str, str], Tuple[str, str]]:
    mapping = {}
    with open(path, newline='') as f:
        reader = csv.DictReader(f)
        for row in reader:
            subject = row.get('subject', '')
            unit = row.get('unit', '')
            quiz = row.get('quizKey', '')
            faculty_id = row.get('facultyId', '')
            faculty_name = row.get('facultyName', '')
            if subject and quiz and faculty_id:
                mapping[(subject, unit, quiz)] = (faculty_id, faculty_name)
    return mapping


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--service-account', required=True,
                        help='Path to Firebase service account JSON')
    parser.add_argument('--database-url', required=True,
                        help='Realtime DB URL (https://<project>.firebaseio.com)')
    parser.add_argument(
        '--mapping-csv', help='Optional mapping CSV file (subject,unit,quizKey,facultyId,facultyName)')
    parser.add_argument(
        '--export-mapping', help='If provided, write planned mappings to this CSV path (dry-run csv)')
    parser.add_argument('--default-faculty-id',
                        help='Default faculty UID to set when missing')
    parser.add_argument('--default-faculty-name',
                        help='Default faculty name to set when missing')
    parser.add_argument('--apply', action='store_true',
                        help='Apply changes. Without this the script is dry-run only')
    args = parser.parse_args()

    if not os.path.exists(args.service_account):
        print('Service account file not found:', args.service_account)
        return

    cred = credentials.Certificate(args.service_account)
    firebase_admin.initialize_app(cred, {
        'databaseURL': args.database_url
    })

    mapping = {}
    if args.mapping_csv:
        mapping = load_mapping_csv(args.mapping_csv)
        print(f'Loaded {len(mapping)} mapping entries from {args.mapping_csv}')

        export_rows = []

    root_ref = db.reference('quizzes')
    all_data = root_ref.get() or {}

    updates = []

    def plan_update(path, quiz_key, faculty_id, faculty_name):
        updates.append((path, quiz_key, faculty_id, faculty_name))

    # Iterate subjects
    for subject_key, subject_val in (all_data.items() if isinstance(all_data, dict) else []):
        if not isinstance(subject_val, dict):
            continue

        # Determine if this subject contains unit nodes or direct quizzes
        for unit_key, unit_val in subject_val.items():
            if isinstance(unit_val, dict):
                # If unit_val looks like a quiz (contains title and questions) treat as direct quiz
                if 'title' in unit_val and 'questions' in unit_val:
                    quiz_key = unit_key
                    created_by = unit_val.get('createdBy')
                    created_name = unit_val.get('createdByName', '')
                    if not created_by:
                        # mapping lookup
                        mapped = mapping.get((subject_key, '', quiz_key)) or mapping.get(
                            (subject_key, None, quiz_key))
                        faculty_id = mapped[0] if mapped else args.default_faculty_id
                        faculty_name = mapped[1] if mapped and mapped[1] else args.default_faculty_name or ''
                        if faculty_id:
                            plan_update(f"/{subject_key}/{quiz_key}",
                                        quiz_key, faculty_id, faculty_name)
                else:
                    # unit_key appears to be a unit; iterate quizzes inside
                    for quiz_key, quiz_val in (unit_val.items() if isinstance(unit_val, dict) else []):
                        if not isinstance(quiz_val, dict):
                            continue
                        if 'title' in quiz_val:
                            created_by = quiz_val.get('createdBy')
                            if not created_by:
                                mapped = mapping.get((subject_key, unit_key, quiz_key)) or mapping.get(
                                    (subject_key, unit_key, None))
                                faculty_id = mapped[0] if mapped else args.default_faculty_id
                                faculty_name = mapped[1] if mapped and mapped[1] else args.default_faculty_name or ''
                                if faculty_id:
                                    plan_update(
                                        f"/{subject_key}/{unit_key}/{quiz_key}", quiz_key, faculty_id, faculty_name)

    print(f'Planned updates: {len(updates)}')
    for p, qk, fid, fname in updates[:50]:
        print('Will set createdBy on', p, '->', fid, fname)

        # Optionally write planned updates to CSV for review
        if args.export_mapping:
            try:
                with open(args.export_mapping, 'w', newline='') as f:
                    writer = csv.writer(f)
                    writer.writerow(
                        ['path', 'quizKey', 'facultyId', 'facultyName'])
                    for p, qk, fid, fname in updates:
                        writer.writerow([p, qk, fid, fname])
                print('Exported planned mappings to', args.export_mapping)
            except Exception as e:
                print('Failed to write export mapping CSV:', e)

    if not updates:
        print('No updates planned. Exiting.')
        return

    if not args.apply:
        print('Dry-run mode. No changes applied. Re-run with --apply to apply changes.')
        return

    # Apply updates
    applied = 0
    for path, quiz_key, faculty_id, faculty_name in updates:
        # path is like /subject/unit/quizKey or /subject/quizKey
        rel_path = path.lstrip('/')
        ref = db.reference(rel_path)
        try:
            ref.update({'createdBy': faculty_id,
                       'createdByName': faculty_name})
            applied += 1
            print('Updated', rel_path)
        except Exception as e:
            print('Failed to update', rel_path, e)

    print(f'Applied {applied}/{len(updates)} updates')


if __name__ == '__main__':
    main()
