#!/usr/bin/env python3
"""
fix_quiz_submissions.py

Scans Firestore collection `quiz_submissions` and updates documents where `facultyId` is missing/empty
but `quizData.createdBy` or `quizData.createdByName` exists. Runs in dry-run mode by default.

Usage:
  python fix_quiz_submissions.py --service-account /path/to/serviceAccount.json --project your-project-id --apply

Flags:
  --apply     Actually write updates. Without it, script will only print planned changes.

Be careful: backup data or run dry-run first.
"""

import argparse
import os
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--service-account', required=True,
                        help='Path to Firebase service account JSON')
    parser.add_argument('--apply', action='store_true',
                        help='Apply changes; default is dry-run')
    args = parser.parse_args()

    if not os.path.exists(args.service_account):
        print('Service account file not found:', args.service_account)
        return

    cred = credentials.Certificate(args.service_account)
    firebase_admin.initialize_app(cred)

    db = firestore.client()
    coll = db.collection('quiz_submissions')

    # Query submissions where facultyId is missing or empty
    docs = coll.where('facultyId', '==', '').stream()

    planned = []
    for doc in docs:
        data = doc.to_dict()
        quiz_data = data.get('quizData') or {}
        created_by = quiz_data.get('createdBy') if isinstance(
            quiz_data, dict) else None
        created_name = quiz_data.get('createdByName') if isinstance(
            quiz_data, dict) else None
        if created_by:
            planned.append((doc.id, created_by, created_name))

    print(f'Planned updates found: {len(planned)}')
    for docid, fid, fname in planned[:50]:
        print(docid, '->', fid, fname)

    if not planned:
        print('No submissions to fix. Exiting.')
        return

    if not args.apply:
        print('Dry-run complete. Re-run with --apply to perform updates.')
        return

    applied = 0
    for docid, fid, fname in planned:
        try:
            coll.document(docid).update(
                {'facultyId': fid, 'facultyName': fname or ''})
            applied += 1
            print('Updated', docid)
        except Exception as e:
            print('Failed to update', docid, e)

    print(f'Applied {applied}/{len(planned)} updates')


if __name__ == '__main__':
    main()
