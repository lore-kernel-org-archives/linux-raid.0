From: Dave Gomboc <dave_gomboc@acm.org>
Subject: Re: raid10 recovery assistance requested
Date: Mon, 23 Sep 2013 04:55:45 +0000
Message-ID: <CA+dwz-2CMaoquRso8d=FZ1X5cEWE0vz7ceR6zhwzR2xM=1FM9A@mail.gmail.com>
References: <CA+dwz-3hWizOmbzBDBV3K4DPM1D3WUPRn_d63-FhS+5RZ-ffvQ@mail.gmail.com>
 <CA+dwz-2DUsx6JK=TYfKc8eGbAiHo2orhnBQv5HfOTNXAi9hv7g@mail.gmail.com>
 <523A7DB9.9070600@hardwarefreak.com> <CA+dwz-1=VQE1pgCctrdbvw99Qq2c_me1aYUJGU0E2sJ2Y-JdpA@mail.gmail.com>
 <CA+dwz-27furxUt=vQAhN8Va_gk3v545in3=kQVMG4eO5SqdCrQ@mail.gmail.com>
 <523F6692.9090407@turmel.org> <CA+dwz-36m6KDKbh9Gwxne8o-UyZuR2e5Z5-dKtOPS1XkA518yA@mail.gmail.com>
 <523F7C62.4040305@turmel.org> <CA+dwz-0eskPSQ44v0vgwfjwRpTbQaokQ3Q258Em1W2eRi1SO4w@mail.gmail.com>
 <523FAD81.9070005@turmel.org> <CA+dwz-2Me3g3udQh90k6EjCMjr+uqyoujCdMM9=tsKEnsmkzdA@mail.gmail.com>
 <523FB511.5070001@turmel.org> <CA+dwz-31yG3Y4xzmUoiMNtLw=q1pE_GTyNqSk5WBAsGDCGT9iw@mail.gmail.com>
 <523FBAB2.7070506@turmel.org> <CA+dwz-2qqYbL1uFmL+vnS=ht6ZHxMDkRRBUYPz0KFQZNZkeK-A@mail.gmail.com>
 <523FBFAA.3050705@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <523FBFAA.3050705@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> Should I be disconnecting sdb and sdc, disconnecting sda and sdd, or
>> does it matter?
>
> Actually, from that report, just do "mdadm /dev/md127 --run".

This didn't seem to work for me.  A subsequent mdadm --stop did affect
/proc/mdstat, though.

I then went on to verify which drive was providing what using mdadm --examine.

Rebooting with just one of each drive available, mdadm /dev/md127
--run again didn't work.  I then went to your earlier advice:

>>> Then use "mdadm -Af /dev/mdX /dev/sdY1 /dev/sdZ1"
>>>
>>> The "-f" will force the assembly without regard to the event counts.
>>> Then you can take a backup.  Finally you can add devices as "new" ones
>>> to rebuild back to full redundancy.  (Fix your timeouts before
>>> attempting the latter.)

The drives are now sda and sdb (instead of sda and sdd).

root@sysresccd /root % mdadm -Af /dev/md127 /dev/sda1 /dev/sdb1
mdadm: forcing event count in /dev/sda1(0) from 520 upto 599
mdadm: /dev/md127 has been started with 2 drives (out of 4).

The partition information seems to be visible:

root@sysresccd /root % cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md127 : active raid10 sda1[0] sdb1[3]
      3907020800 blocks super 1.2 512K chunks 2 near-copies [4/2] [U__U]

unused devices: <none>
root@sysresccd /root % pvdisplay
  --- Physical volume ---
  PV Name               /dev/md127
  VG Name               teramooch
  PV Size               3.64 TiB / not usable 2.00 MiB
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              953862
  Free PE               0
  Allocated PE          953862
  PV UUID               CPvNYY-28Dn-M96v-orps-1882-IOR3-fm7wHO

root@sysresccd /root % vgdisplay
  --- Volume group ---
  VG Name               teramooch
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  26
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                8
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               3.64 TiB
  PE Size               4.00 MiB
  Total PE              953862
  Alloc PE / Size       953862 / 3.64 TiB
  Free  PE / Size       0 / 0
  VG UUID               j4Svly-X1uO-OVL1-cfCd-eJ4s-sEQs-O50dGq

At first, lvdisplay showed the logical volumes as not available, so I
then invoked

root@sysresccd /root % vgchange -a y
  8 logical volume(s) in volume group "teramooch" now active
root@sysresccd /root % lvdisplay
  --- Logical volume ---
  LV Path                /dev/teramooch/root
  LV Name                root
  VG Name                teramooch
  LV UUID                914ouu-RIan-58j9-HU8x-lL1r-shjr-BFupPn
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 0
  LV Size                5.00 GiB
  Current LE             1280
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     4096
  Block device           253:0

  --- Logical volume ---
  LV Path                /dev/teramooch/usr
  LV Name                usr
  VG Name                teramooch
  LV UUID                ah8CFq-r946-GRxW-q1yv-vcVH-S341-AoJmBH
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 0
  LV Size                5.00 GiB
  Current LE             1280
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     4096
  Block device           253:1

  --- Logical volume ---
  LV Path                /dev/teramooch/var
  LV Name                var
  VG Name                teramooch
  LV UUID                eybfZ0-Vy8N-P5XG-S0C1-dXzw-gaCG-TCry0d
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 0
  LV Size                5.00 GiB
  Current LE             1280
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     4096
  Block device           253:2

  --- Logical volume ---
  LV Path                /dev/teramooch/tmp
  LV Name                tmp
  VG Name                teramooch
  LV UUID                2SSk0A-Mv2b-gI5X-37TE-1zoX-9afj-wUbvkT
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 0
  LV Size                1.00 GiB
  Current LE             256
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     4096
  Block device           253:3

  --- Logical volume ---
  LV Path                /dev/teramooch/opt
  LV Name                opt
  VG Name                teramooch
  LV UUID                0HN60s-NOr9-qQ5m-Kgds-Y7i0-jDHl-RlpEhg
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 0
  LV Size                1.00 GiB
  Current LE             256
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     4096
  Block device           253:4

  --- Logical volume ---
  LV Path                /dev/teramooch/home
  LV Name                home
  VG Name                teramooch
  LV UUID                j1Vtft-WRg8-yBIM-fhjb-6EP4-Df56-4lTHz7
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 0
  LV Size                5.00 GiB
  Current LE             1280
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     4096
  Block device           253:5

  --- Logical volume ---
  LV Path                /dev/teramooch/srv
  LV Name                srv
  VG Name                teramooch
  LV UUID                L3n5AZ-XgTa-7uV8-GzCG-82oX-JqrJ-VugwT6
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 0
  LV Size                2.91 TiB
  Current LE             762123
  Segments               7
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     4096
  Block device           253:6

  --- Logical volume ---
  LV Path                /dev/teramooch/backupduffycapemay
  LV Name                backupduffycapemay
  VG Name                teramooch
  LV UUID                83RVKO-txsd-q1oE-2p9n-z0dk-zIQe-Sx3Eol
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 0
  LV Size                726.98 GiB
  Current LE             186107
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     4096
  Block device           253:7

I made /mnt/root, /mnt/home, etc., then

[Actually, I mounted these rw first, then realized that I shouldn't
have, unmounted them, and re-mounted them read-only.]

root@sysresccd /mnt % mount -o ro -t ext3 /dev/mapper/teramooch-root /mnt/root
root@sysresccd /mnt % mount -o ro -t ext3 /dev/mapper/teramooch-home /mnt/home
root@sysresccd /mnt % mount -o ro -t ext3 /dev/mapper/teramooch-tmp /mnt/tmp
root@sysresccd /mnt % mount -o ro -t ext3 /dev/mapper/teramooch-usr /mnt/usr
root@sysresccd /mnt % mount -o ro -t ext3 /dev/mapper/teramooch-var /mnt/var
root@sysresccd /mnt % mount -o ro -t ext3 /dev/mapper/teramooch-opt /mnt/opt

These mount attempts returned without error, and ls within the
directories is possible.

However, the large, important one doesn't mount:

root@sysresccd /mnt % mount -o ro -t ext3 /dev/mapper/teramooch-srv /mnt/srv
mount: wrong fs type, bad option, bad superblock on /dev/mapper/teramooch-srv,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so

root@sysresccd /mnt % mount -o ro /dev/mapper/teramooch-srv /mnt/srv
NTFS signature is missing.
Failed to mount '/dev/mapper/teramooch-srv': Invalid argument
The device '/dev/mapper/teramooch-srv' doesn't seem to have a valid NTFS.
Maybe the wrong device is used? Or the whole disk instead of a
partition (e.g. /dev/sda, not /dev/sda1)? Or the other way around?

It should be ext3, not NTFS.

Yikes.

Dave
