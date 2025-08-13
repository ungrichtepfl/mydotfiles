# Neomutt

Read this [tutorial](https://mail.margiolis.net/w/mutt_gmail_outlook/) on how to
setup outlook mail.

**TLDR:**

```shell
/usr/share/neomutt/oauth2/mutt_oauth2.py  \
        -v \
        -t \
        --authorize \
        --client-id "9e5f94bc-e8a4-4e73-b8be-63364c29d753" \
        --client-secret "" \
        --email "christoph.ungricht@outlook.com" \
        --provider microsoft \
        ~/.config/neomutt/outlooktoken
```

Choose `authcode`, leave the secret empty and after authentication use
`echo <the_url> | sed 's/.*code=//;s/\&.*//'` to extract the code from the url.

The configs have been taken from
[gideonwolfe/neomutt](https://gideonwolfe.com/posts/workflow/neomutt/intro/).

## isync/mbsync & goimapnotify

If you want to add new mailboxes you need to change `./home/dot-config/isyncrc`
and `./home/dot-config/goimapnotify/goimapnotify.yaml` too.

Checkout how to setup offline sync:

- [simondobson.org/gettiing-email](https://simondobson.org/2024/02/03/getting-email/)
- [futurile.net/neomutt-mirror-imap-mbsync-tutorial](https://www.futurile.net/2025/05/20/neomutt-mirror-imap-mbsync-tutorial/)
- [futurile.net/neomutt-goimapsync](https://www.futurile.net/2025/05/29/neomutt-goimapsync/)
