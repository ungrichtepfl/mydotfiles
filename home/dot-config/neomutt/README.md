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

The configs have been taken from [here](https://gideonwolfe.com/posts/workflow/neomutt/intro/).
