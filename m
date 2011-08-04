From: Paul Menzel <pm.debian@googlemail.com>
Subject: Re: LUKS superblock damaged by `mdadm --create` or user error?
Date: Fri, 5 Aug 2011 00:25:01 +0200
Message-ID: <CAOOH3po4xRX8W1pkJexdVx2hMYiGZ12SXNsWU1Vt1vA3YFt_ug@mail.gmail.com>
References: <CAOOH3ponHA=mWahdM3thfcWSkzVRhsOccMTjhso3dv1afuA_BA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOOH3ponHA=mWahdM3thfcWSkzVRhsOccMTjhso3dv1afuA_BA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011/8/4 Paul Menzel <pm.debian@googlemail.com>:

[=E2=80=A6]

> After having grown `/dev/sda2` using `fdisk /dev/sda2` with mdadm not
> running I forgot to grow the RAID1 and probably overwrote the md
> metadata (0.90) or made it unavaible because it was not at the end of
> the partition anymore after growing the physical and logical LVM
> volumes and filesystems.
>
> =C2=A0 =C2=A0# blkid
> =C2=A0 =C2=A0/dev/sda1: UUID=3D"fb7f3dc5-d183-cab6-1212-31201a2207b9"
> TYPE=3D"linux_raid_member"
> =C2=A0 =C2=A0/dev/sda2: UUID=3D"cb6681b4-4dda-4548-8c59-3d9838de9c22"
> TYPE=3D"crypto_LUKS" # In `fdisk` I had set it to =C2=BBLinux raid
> autodetect=C2=AB (0xfd) though.

It looks like `fdisk` did a bad/incomplete job. `sfdisk` shows a warnin=
g(?).

--- 8< --- sfdisk output --- >8 ---
% sudo sfdisk -l /dev/sda

Disk /dev/sda: 243201 cylinders, 255 heads, 63 sectors/track
Units =3D cylinders of 8225280 bytes, blocks of 1024 bytes, counting fr=
om 0

   Device Boot Start     End   #cyls    #blocks   Id  System
/dev/sda1   *      0+     61      62-    497983+  fd  Linux raid autode=
tect
/dev/sda2         62  243200  243139  1953014017+  fd  Linux raid autod=
etect
                end: (c,h,s) expected (1023,254,63) found (512,254,63)
/dev/sda3          0       -       0          0    0  Empty
/dev/sda4          0       -       0          0    0  Empty
% sudo sfdisk -V /dev/sda
partition 2: end: (c,h,s) expected (1023,254,63) found (512,254,63)
/dev/sda: OK
--- 8< --- sfdisk output --- >8 ---

Could that be related? Tomorrow I will look into this.

[=E2=80=A6]


Thanks,

Paul


> [1] http://www.saout.de/pipermail/dm-crypt/2011-August/001857.html
> [2] http://www.hermann-uwe.de/blog/resizing-a-dm-crypt-lvm-ext3-parti=
tion
> [3] http://grml.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
