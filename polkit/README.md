# Polkit

This config file is needed such that a file manager can automatically mount
removable storage (e.g. USB sticks)

For it to work polkit must be installed and the service must be running:

```shell
sudo xbps-install -S polkit
```

Then you need to **copy** the file to `/etc/polkit-1/rules.d`.
Symlinking seems not to work:

```shell
sudo copy 50-udiskie.rules /etc/polkit-1/rules.d
```

Also, you need to be added to the storage group:

```shell
usermod -aG storage <user>
```

If it does not exist create one (should already exist):

```shell
sudo groupadd storage
```
