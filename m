From: Alexander Schleifer <alexander.schleifer@googlemail.com>
Subject: RAID5 superblock and filesystem recovery after re-creation
Date: Sun, 8 Jul 2012 23:47:16 +0200
Message-ID: <CA+=meHXO02k4hSJihNFiYXb+LOjik_LX3n8UZbqERC2tYy+L-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

after a new installation of Ubuntu, my RAID5 device was set to
"inactive". All devices were set to spare device and the level was
unknown. So I tried to re-create the array by the following command.

mdadm --create /dev/md0 --assume-clean --level=5 --raid-disk=6
--chunk=512 --metadata=1.2 /dev/sde /dev/sdd /dev/sda /dev/sdc
/dev/sdg /dev/sdh

I have a backup of the mdadm -Evvvvs output, so I could recover the
chunk size, metadata and offset (2048) from this information.

The partially output of mdadm --create... shows this output:

...
mdadm: /dev/sde appears to be part of a raid array:
    level=raid5 devices=6 ctime=Sun Jul  8 23:02:51 2012
mdadm: partition table exists on /dev/sde but will be lost or
       meaningless after creating array
...

The array is recreated, but no valid filesystem is found on /dev/md0
(dumpe2fs: Filesystem revision too high while trying to open /dev/md0.
Couldn't find valid filesystem superblock.). Also fdisk /dev/sde shows
no partition.
My next step would be creating Linux RAID type partitions on the 6
devices with fdisk and call mdadm --create with /dev/sde1 /dev/sdd1
and so on.
Is this step a possible solution for recovering the filesystem?

Thanks for any help,
-Alex
