# Neomutt

Read this [tutorial](https://mail.margiolis.net/w/mutt_gmail_outlook/) on how to
setup outlook mail.

## OAuth2 token for Outlook

```shell
/usr/share/neomutt/oauth2/mutt_oauth2.py \
        -v \
        -t \
        -d \
        --authorize \
        --authflow authcode \
        --client-id "9e5f94bc-e8a4-4e73-b8be-63364c29d753" \
        --client-secret "" \
        --email "christoph.ungricht@outlook.com" \
        --provider microsoft \
        ~/.config/neomutt/outlooktoken
```

The script prints an URL and then waits for the authorization code. Open the URL
in the browser. You need to sign in to Microsoft and then you will be redirected
to a page where you need to copy its url (contains the code). Then extract the
auth code:

```shell
python3 -c 'import sys,urllib.parse as u; print(u.parse_qs(u.urlparse(sys.argv[1]).query)["code"][0], end="")' \
        '<the_url>' | xclip -sel clip
```

### Gotchas

- The token file is written *before* the authorization completes. On a rerun
  with an existing file, `--client-id`, `--client-secret` and `--email` are
  ignored (the stored values win); only `--authflow` overrides. To truly start
  over, `rm ~/.config/neomutt/outlooktoken` first.
- If the run asks for a user ID and then crashes with
  `subprocess.CalledProcessError: Command '['gpg', '--encrypt',
  '--default-recipient-self']' returned non-zero exit status 2`, you are missing
  a GPG key:

  ```shell
  gpg --full-generate-key
  ```

- If somehow the sync still fails check if the gpg public key lock has to be deleted:

  ```
  rm ~/.gnupg/public-keys.d/pubring.db.lock
  ```

The configs have been taken from
[gideonwolfe/neomutt](https://gideonwolfe.com/posts/workflow/neomutt/intro/).

## isync/mbsync & goimapnotify

If you want to add new mailboxes you need to change `./home/dot-config/isyncrc`
and `./home/dot-config/goimapnotify/goimapnotify.yaml` too.

Checkout how to setup offline sync:

- [simondobson.org/gettiing-email](https://simondobson.org/2024/02/03/getting-email/)
- [futurile.net/neomutt-mirror-imap-mbsync-tutorial](https://www.futurile.net/2025/05/20/neomutt-mirror-imap-mbsync-tutorial/)
- [futurile.net/neomutt-goimapsync](https://www.futurile.net/2025/05/29/neomutt-goimapsync/)

### Bootstrapping

```shell
mkdir -p ~/Mail/Personal
mbsync -a
```
