{ secrets-directory }:

''
  #!/usr/bin/env bash

  function notify_commit() {
    notify-send \
      --expire-time=5000 \
      --app-name="Calcurse's post-save hook" \
      --icon="$(dirname $0)/calendar-icon.png" \
      "Automatic commit script" \
      "Pushing changes to GitHub..."
  }

  function commit_new_entries() {
    cd "${secrets-directory}/calcurse"
    git add .
    git commit -m \
      "$(date +%4Y-%b-%d@%T) Commit by post-save script"
    git push origin master
  }

  notify_commit
  commit_new_entries
''
