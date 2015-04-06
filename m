From: Eduard Rozenberg <eduardr@pobox.com>
Subject: Can't mount partitions after "mdadm --zero-superblock"
Date: Mon, 6 Apr 2015 16:45:58 -0700
Message-ID: <F271C907-A2A7-4132-BA11-D33353AE9FFF@pobox.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2097\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello folks,

I previously had the following setup:

sda & sdb partitioned w/ GPT, 7 partitions each (usr, opt, var etc...)
7 raid1=E2=80=99s with 2 devices for each pair of partitions (/dev/sda1=
 & /dev/sdab1, etc)
They=E2=80=99d been created under Slackware 13.37.

I was trying to clean out mdadm from those partitions but keep the data=
 so I ran=20
"mdadm --zero-superblock=E2=80=9D on each of those previously RAID1 mda=
dm 1.2 ext4=20
partitions.

As a result I am now currently unable to mount any partition after the =
first one on either
disk. The first partition does mount. The partition table is visible an=
d looks fine in gdisk.

mount -t ext4 /dev/sdac2 /mnt
mount: wrong fs type, bad option, bad superblock on /dev/sdac2,
missing codepage or helper program, or other error
In some cases useful info is found in syslog - try
dmesg | tail or so

I did try superblock recovery with each backup superblock that ext4 nor=
mally creates,
but none of the superblock locations worked.

=46or example:

fsck.ext4 -b 4096000 /dev/sdac2=20
e2fsck 1.42.8 (20-Jun-2013)
/sbin/e2fsck: Invalid argument while trying to open /dev/sdac2

The superblock could not be read or does not describe a correct ext2
filesystem. If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblo=
ck:
e2fsck -b 8193 <device>


Would be grateful for any advice on anything else I can try.

Regards,
=E2=80=94Ed--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
