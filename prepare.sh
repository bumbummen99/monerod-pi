#!/usr/bin/env bash

sudo chroot ~/mnt /bin/bash <<END
echo "Hello, world!"
ls -l
END


