# Sudoers.d rules

You need to copy not symlink the file, because it needs specify permissions. Run:

```shell
sudo cp z_chrigi /etc/sudoers.d
sudo chmod 0440 /etc/sudoers.d/z_chrigi
sudo chown root:root /etc/sudoers.d/z_chrigi
```

This file enables you to run `shutdown`, `poweroff`, etc. without passwd you
need to add a sudoer rule. Symlink this to `/etc/sudoers.d`. The `z` prefix
ensures that the rule is loaded at the end as the system is hierarchic. For
example if there is a `wheel` file containing

```text
%wheel ALL=(ALL) ALL
```

If this rule would be loaded after your rule, the NOPASSWD will not work.
Check that the output of `sudo -l` contains:

```text
User chrigi may run the following commands on surface-pro4:
    (ALL : ALL) ALL
    (ALL) NOPASSWD: /usr/bin/halt, /usr/bin/poweroff, /usr/bin/reboot,
        /usr/bin/shutdown
```

## Visudo

Use `visudo` to edit file:

```shell
sudo visudo -f z_chrigi
```

Check if the syntax of all files are correct:

```shell
sudo visudo -c
```
