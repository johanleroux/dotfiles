# Recovery

## Limine - Invalid Config
1. Boot into an Arch boot drive

2. List all partitions
```sh
lsblk
```

3. Mount the boot partition
```sh
mkdir /mnt/boot
mount /dev/{boot partition} /mnt/boot
```

4. Backup the current and old limine config
```sh
cp /mnt/boot/limine.conf /mnt/boot/limine.conf.bak
cp /mnt/boot/limine.conf.old /mnt/boot/limine.conf.old.bak
```

5. Restore the old limine config
```sh
cp /mnt/boot/limine.conf.old /mnt/boot/limine.conf
```

6. Reboot
