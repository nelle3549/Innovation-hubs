#!/usr/bin/env bash
# One-shot: push this production/ folder to GitHub (repo "Innovation-hubs") and enable Pages.
# Run in Terminal:  bash push.sh
set -e

REPO="Innovation-hubs"
VISIBILITY="public"          # GitHub Pages on the free plan needs "public"

cd "$(dirname "$0")"

git init -q
git add .
git commit -q -m "Innovation Hub — 17 opportunities + 142 centers (verified, WebP, iframe-ready)"
git branch -M main

if command -v gh >/dev/null 2>&1; then
  gh repo create "$REPO" --"$VISIBILITY" --source=. --remote=origin --push
  OWNER=$(gh api user -q .login)
  gh api -X POST "repos/$OWNER/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
    && echo "Pages enabled." \
    || echo "Enable Pages manually: repo -> Settings -> Pages -> Branch: main / root."
  echo
  echo "BASE URL:  https://$OWNER.github.io/$REPO"
else
  echo "GitHub CLI (gh) not installed. Do it manually:"
  echo "  1) Create an EMPTY public repo named '$REPO' at https://github.com/new (no README)"
  echo "  2) git remote add origin https://github.com/<your-username>/$REPO.git"
  echo "  3) git push -u origin main"
  echo "  4) repo -> Settings -> Pages -> Branch: main / root -> Save"
  echo "  BASE URL: https://<your-username>.github.io/$REPO"
fi
