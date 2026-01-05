# Environment

If you for example use lightdm on a hdpi system you need to set
some environment variables before they can be set in `.xsession`.

Otherwise lightdm is too tiny.

```shell
sudo cp ./environment/environment-hdpi /etc/environment
```

If the file already exists append this one and don't symlink it.
