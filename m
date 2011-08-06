From: Phil Turmel <philip@turmel.org>
Subject: Re: LUKS superblock damaged by `mdadm --create` or user error?
Date: Fri, 05 Aug 2011 22:24:52 -0400
Message-ID: <4E3CA5F4.1020603@turmel.org>
References: <CAOOH3ponHA=mWahdM3thfcWSkzVRhsOccMTjhso3dv1afuA_BA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOOH3ponHA=mWahdM3thfcWSkzVRhsOccMTjhso3dv1afuA_BA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Menzel <pm.debian@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Paul,

On 08/04/2011 03:27 PM, Paul Menzel wrote:
> Dear Linux RAID folks,
>=20
>=20
> I hope I did not annoy you too much on #linux-raid and I am contactin=
g
> this list to reach a broader audience for help and for archival
> purposes. My message to the list dm-crypt [1] was a little long and s=
o
> is this one. I am sorry.

Don't sweat it.  More information is usually better than less when deci=
phering these sorts of problems.

> After having grown `/dev/sda2` using `fdisk /dev/sda2` with mdadm not
> running I forgot to grow the RAID1 and probably overwrote the md
> metadata (0.90) or made it unavaible because it was not at the end of
> the partition anymore after growing the physical and logical LVM
> volumes and filesystems.

Yes.  Enlarging your filesystem to fit the new size of /dev/sda2 certai=
nly destroyed the metadata.  Even without the FS resize, the repartitio=
ning would have hidden the 0.90 metadata.

>     # blkid
>     /dev/sda1: UUID=3D"fb7f3dc5-d183-cab6-1212-31201a2207b9"
> TYPE=3D"linux_raid_member"
>     /dev/sda2: UUID=3D"cb6681b4-4dda-4548-8c59-3d9838de9c22"
> TYPE=3D"crypto_LUKS" # In `fdisk` I had set it to =C2=BBLinux raid
> autodetect=C2=AB (0xfd) though.
>=20
> I could not boot anymore because `/dev/md1` could not be assembled.
>=20
>         # mdadm --examine /dev/sda2
>         mdadm: No md superblock detected on /dev/sda2.
>=20
>         # mdadm --examine /dev/sda1
>         /dev/sda1:
>                   Magic : a92b4efc
>                 Version : 0.90.00
>                    UUID : fb7f3dc5:d183cab6:12123120:1a2207b9
>           Creation Time : Wed Mar 26 11:49:57 2008
>              Raid Level : raid1
>           Used Dev Size : 497856 (486.27 MiB 509.80 MB)
>              Array Size : 497856 (486.27 MiB 509.80 MB)
>            Raid Devices : 2
>           Total Devices : 1
>         Preferred Minor : 0
>=20
>             Update Time : Wed Aug  3 21:11:43 2011
>                   State : clean
>          Active Devices : 1
>         Working Devices : 1
>          Failed Devices : 1
>           Spare Devices : 0
>                Checksum : 388e903a - correct
>                  Events : 20332
>=20
>=20
>               Number   Major   Minor   RaidDevice State
>         this     0       8        1        0      active sync   /dev/=
sda1
>=20
>            0     0       8        1        0      active sync   /dev/=
sda1
>            1     1       0        0        1      faulty removed
>=20
>         # mdadm --verbose --assemble /dev/md1
> --uuid=3D52ff2cf2:40981859:e58d8dd6:5faec42c
>         mdadm: looking for devices for /dev/md1
>         mdadm: no recogniseable superblock on /dev/dm-8
>         mdadm: /dev/dm-8 has wrong uuid.
>         mdadm: no recogniseable superblock on /dev/dm-7
>         mdadm: /dev/dm-7 has wrong uuid.
>         mdadm: no recogniseable superblock on /dev/dm-6
>         mdadm: /dev/dm-6 has wrong uuid.
>         mdadm: no recogniseable superblock on /dev/dm-5
>         mdadm: /dev/dm-5 has wrong uuid.
>         mdadm: no recogniseable superblock on /dev/dm-4
>         mdadm: /dev/dm-4 has wrong uuid.
>         mdadm: no recogniseable superblock on /dev/dm-3
>         mdadm: /dev/dm-3 has wrong uuid.
>         mdadm: no recogniseable superblock on /dev/dm-2
>         mdadm: /dev/dm-2 has wrong uuid.
>         mdadm: no recogniseable superblock on /dev/dm-1
>         mdadm: /dev/dm-1 has wrong uuid.
>         mdadm: cannot open device /dev/dm-0: Device or resource busy
>         mdadm: /dev/dm-0 has wrong uuid.
>         mdadm: no recogniseable superblock on /dev/md0
>         mdadm: /dev/md0 has wrong uuid.
>         mdadm: cannot open device /dev/loop0: Device or resource busy
>         mdadm: /dev/loop0 has wrong uuid.
>         mdadm: cannot open device /dev/sdb4: Device or resource busy
>         mdadm: /dev/sdb4 has wrong uuid.
>         mdadm: cannot open device /dev/sdb: Device or resource busy
>         mdadm: /dev/sdb has wrong uuid.
>         mdadm: cannot open device /dev/sda2: Device or resource busy
>         mdadm: /dev/sda2 has wrong uuid.
>         mdadm: cannot open device /dev/sda1: Device or resource busy
>         mdadm: /dev/sda1 has wrong uuid.
>         mdadm: cannot open device /dev/sda: Device or resource busy
>         mdadm: /dev/sda has wrong uuid.
>=20
> and `mdadm --examine /dev/sda2` could not find any metadata.
> `/dev/sda2` could still be decrypted using `cryptsetup luksOpen
> /dev/sda2 sda2_crypt`. Not knowing about metadata and their storage
> (0.90) I read several Web resourses and joined IRC channels and came
> to the conclusion that I should just create a new (degraded) RAID1 an=
d
> everything would be fine, since I had only one disk.

Here's where you started going wrong.  MD raid1 with end-of-device meta=
data has the handy property that its content appears to be equally acce=
ssible via direct access to the underlying device.  This is reliably tr=
ue only for *read*.  /dev/md1 would have a size shorter than /dev/sda2,=
 protecting the metadata from being overwritten.  Using the partition d=
irectly with luksOpen, without specifying "--readonly", put you on the =
path to destruction.

In particular, you now have the problem that the enlarged LVM PV inside=
 the luks encryption is too big, and its tail has been overwritten with=
 the MD v0.90 metadata.

> Booting from the live system Grml [3], which does *not* start `mdadm`
> or `lvm` during boot, I tried to create a new RAID1 using the
> following command (a).
>=20
>    # command (a)
>    mdadm --verbose --create /dev/md1 \
>    --assume-clean \
>    --level=3D1 \
>    --raid-devices=3D2 \
>    --uuid=3D52ff2cf2:40981859:e58d8dd6:5faec42c \
>    /dev/sda2 missing
>=20
> I ignored the warning about overwriting metadata because it only
> referred to booting. Unfortunately `cryptsetup luksOpen /dev/md1
> md1_crypt` did not find any LUKS superblock. Therefore I stopped
> `/dev/md1` and `cryptsetup luksOpen /dev/sda2 sda2_crypt` still
> worked. Then I remembered that the metadata version was originally
> 0.90 and added `--metadata=3D0.90` and executed the following (b).

Too late.  The v1.2 header (modern default) was written at this point, =
destroying the luks header.  This metadata is deliberately offset by 4k=
, so it didn't destroy the signature part of the luks header, but it de=
stroyed all or part of your key slot.

>    # command (b)
>    mdadm --verbose --create /dev/md1 \
>    --assume-clean \
>    --level=3D1 \
>    --raid-devices=3D2 \
>    --uuid=3D52ff2cf2:40981859:e58d8dd6:5faec42c \
>    --metadata=3D0.90
>    /dev/sda2 missing
>=20
> Lucky me I thought, `cryptsetup luksOpen /dev/md1 md1_crypt` asked me
> for the passphrase but I entered it three times and it would not
> unlock. Instead of trying it again =E2=80=93 I do not know if it woul=
d have
> worked =E2=80=93 I tried `cryptsetup luksOpen /dev/sda2 sda2_crypt` a=
nd it
> asked me for the passphrase too. The third time I seem to have entere=
d
> it correctly, but I got an error message that it could not be mapped.
>=20
> --- dmesg ---
> Aug  4 00:16:01 grml kernel: [ 7964.786362] device-mapper:
> table: 253:0: crypt: Device lookup failed
>        Aug  4 00:16:01 grml kernel: [ 7964.786367] device-mapper:
> ioctl: error adding target to table
>        Aug  4 00:16:01 grml udevd[2409]: inotify_add_watch(6,
> /dev/dm-0, 10) failed: No such file or directory
>        Aug  4 00:16:01 grml udevd[2409]: inotify_add_watch(6,
> /dev/dm-0, 10) failed: No such file or directory
>=20
>        Aug  4 00:17:14 grml kernel: [ 8038.196371] md1: detected
> capacity change from 1999886286848 to 0
>        Aug  4 00:17:14 grml kernel: [ 8038.196395] md: md1 stopped.
>        Aug  4 00:17:14 grml kernel: [ 8038.196407] md: unbind<sda2>
>        Aug  4 00:17:14 grml kernel: [ 8038.212653] md: export_rdev(sd=
a2)
> --- dmesg ---
>=20
> Then I realized that I had probably forgotten to stop `/dev/md1`.
> After stopping it, `cryptsetup luksOpen /dev/sda2 sda2_crypt` did not
> succeed anymore and I cannot access my data.

You probably keyed it in correctly every time.

> 1. Does the `dmesg` output suggest that accessing `/dev/sda2` while
> assembled caused any breakage?

No.

> 2. On #lvm and #linux-raid the common explanation was that command (a=
)
> had overwritten the LUKS superblock and damaged it. Is that possible?
> I could not find the magic number 0xa92b4efc in the first megabyte of
> `/dev/sda2`. Did `--assume-clean` prevent that?

Command (a) destroyed one or more luks keyslots.

> 3. Is command (b) to blame, or did it probably work and I had a typo
> in the passphrase?

Command (b) worked, but the damage was already done.

> I am thankful for any hint to get my data back.

Restoring the keyslot, or the entire luks header should do the trick.

> Thanks and sorry for the long message. Any hints on how to shorten it
> next time are much appreciated.
>=20
> Paul
>=20
>=20
> PS: A month ago I head `dd` the content of a 500 GB drive to this one=
=2E
> That is why I wanted to resize the partitions. The old drive is still
> functional and I am attaching several outputs from commands from the
> current 2 TB drive and the old drive. The `luksDump` output is from
> the current drive but with the LUKS header from the 500 GB drive. I
> know that I am publishing the key to access my drive, but if it helps
> to get my data back I will encrypt from scratch again afterward. I
> also have the dump of the first MB (in this case) of the partition
> (`luksHeaderBackup`) from the old and new drive. But attaching them
> would be over the message size limit.

I recommend you dd the first 16 sectors (8k) of your old /dev/sda2 to t=
he new /dev/sda2.  This should give you access to the encrypted content=
s again, via direct decryption of /dev/sda2.  You can try assembling /d=
ev/md1 and decrypting it, but I doubt LVM will tolerate the truncated P=
V.

Either way, take a backup.

You can try to shrink the LVM PV if you haven't already resized your LV=
(s) to use it all.  Then assembling /dev/md1 and decrypting should work=
=2E

However, I recommend you start over with this array, and use modern v1.=
2 metadata.  Create a new luks device inside it, then the LVM pieces, a=
nd then restore from your fresh backup.

The v1.2 metadata will protect you from this sort of failure in the fut=
ure.  (luksOpen will no longer work on the bare partition.)

> [1] http://www.saout.de/pipermail/dm-crypt/2011-August/001857.html
> [2] http://www.hermann-uwe.de/blog/resizing-a-dm-crypt-lvm-ext3-parti=
tion
> [3] http://grml.org/

Reference #2, with an assumption on your part, led you astray, as its e=
xample wasn't layered on top of MD raid.  You assumed that luksOpen wit=
h /dev/sda2 was OK.  It appears to work, and is *readable*, but it does=
 not maintain the integrity of the raid layer.

HTH,

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
