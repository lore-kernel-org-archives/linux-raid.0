From: Eduard Rozenberg <eduardr@pobox.com>
Subject: Re: Can't mount partitions after "mdadm --zero-superblock"
Date: Mon, 6 Apr 2015 18:33:36 -0700
Message-ID: <CE6323D1-485D-4951-9E99-CBE5A09AE7BD@pobox.com>
References: <F271C907-A2A7-4132-BA11-D33353AE9FFF@pobox.com> <20150407105230.4ff9a97a@notabene.brown>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2097\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150407105230.4ff9a97a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks very much Neil!

I never do anything forward thinking like mdadm =E2=80=94examine before
doing destructive things :). Unfortunately.

I couldn=E2=80=99t figure out how to make the offset work so I used

losetup -f --show -P /dev/sdac

which automatically creates:

/dev/loop0
/dev/loop0p1       =20
/dev/loop0p2
/dev/loop0p3 =20
/dev/loop0p4 =20
/dev/loop0p5
/dev/loop0p6=20
/dev/loop0p7
/dev/loop0p7 =20
/dev/loop0p8

But the errors are the same (below). No idea why it thinks
NTFS is involved. I=E2=80=99ll probably have to give up on=20
this and figure out how to get way better at backups because
my history of success with recovery once things get hosed
in some way is very poor.

[root@repo1 ~]# fsck.ext4 /dev/loop0p2=20
e2fsck 1.42.8 (20-Jun-2013)
ext2fs_open2: Bad magic number in super-block
/sbin/e2fsck: Superblock invalid, trying backup blocks...
/sbin/e2fsck: Bad magic number in super-block while trying to open /dev=
/loop0p2

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblo=
ck:
    e2fsck -b 8193 <device>

=3D=3D=3D=3D=3D=3D

mount -o ro /dev/loop0p2 /mnt

=46ailed to mount '/dev/loop0p2': Invalid argument
The device '/dev/loop0p2' doesn't seem to have a valid NTFS.
Maybe the wrong device is used? Or the whole disk instead of a
partition (e.g. /dev/sda, not /dev/sda1)? Or the other way around?

mount -o ro /dev/loop0p3 /mnt

NTFS signature is missing.
=46ailed to mount '/dev/loop0p3': Invalid argument
The device '/dev/loop0p3' doesn't seem to have a valid NTFS.
Maybe the wrong device is used? Or the whole disk instead of a
partition (e.g. /dev/sda, not /dev/sda1)? Or the other way around?

Regards,
=E2=80=94Ed

> On Apr 6, 2015, at 17:52, NeilBrown <neilb@suse.de> wrote:
>=20
> On Mon, 6 Apr 2015 16:45:58 -0700 Eduard Rozenberg <eduardr@pobox.com=
> wrote:
>=20
>> Hello folks,
>>=20
>> I previously had the following setup:
>>=20
>> sda & sdb partitioned w/ GPT, 7 partitions each (usr, opt, var etc..=
=2E)
>> 7 raid1=E2=80=99s with 2 devices for each pair of partitions (/dev/s=
da1 & /dev/sdab1, etc)
>> They=E2=80=99d been created under Slackware 13.37.
>>=20
>> I was trying to clean out mdadm from those partitions but keep the d=
ata so I ran=20
>> "mdadm --zero-superblock=E2=80=9D on each of those previously RAID1 =
mdadm 1.2 ext4=20
>> partitions.
>=20
> The "1.2" metadata is stored 4k from the start of the device.  The ac=
tual
> data is some megabytes further in.  I don't suppose you still have th=
e output
> of "mdadm --examine" from before you destroyed the superblocks??
>=20
>>=20
>> As a result I am now currently unable to mount any partition after t=
he first one on either
>> disk. The first partition does mount. The partition table is visible=
 and looks fine in gdisk.
>>=20
>> mount -t ext4 /dev/sdac2 /mnt
>> mount: wrong fs type, bad option, bad superblock on /dev/sdac2,
>> missing codepage or helper program, or other error
>> In some cases useful info is found in syslog - try
>> dmesg | tail or so
>>=20
>> I did try superblock recovery with each backup superblock that ext4 =
normally creates,
>> but none of the superblock locations worked.
>>=20
>> For example:
>>=20
>> fsck.ext4 -b 4096000 /dev/sdac2=20
>> e2fsck 1.42.8 (20-Jun-2013)
>> /sbin/e2fsck: Invalid argument while trying to open /dev/sdac2
>>=20
>> The superblock could not be read or does not describe a correct ext2
>> filesystem. If the device is valid and it really contains an ext2
>> filesystem (and not swap or ufs or something else), then the superbl=
ock
>> is corrupt, and you might try running e2fsck with an alternate super=
block:
>> e2fsck -b 8193 <device>
>>=20
>>=20
>> Would be grateful for any advice on anything else I can try.
>=20
> You need to find where the filesystem actually starts, then you need =
to
> create some way to access it as a block device, then it should "just =
work".
>=20
> An ext4 filesystem superblock has 0xef53 at an offset of 0x38, and th=
e
> superblock is typically 1K from the start of the partition.
>=20
> So you could:
>   od -x /dev/sdac2 | awk '$6 =3D=3D "ef53"'
>=20
> Then subtrace 0002060 (octal) from the leading number, and that might=
 be the
> start of the partition.
>=20
> Then
>  losetup -o "start in decimal" /dev/loop0 /dev/sdac2
>=20
> and try 'fsck' on /dev/loop0
>=20
> Good luck.
>=20
> NeilBrown
>=20
>=20
>=20
>>=20
>> Regards,
>> =E2=80=94Ed--
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
