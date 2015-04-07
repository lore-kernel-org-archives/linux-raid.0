From: Eduard Rozenberg <eduardr@pobox.com>
Subject: Re: Can't mount partitions after "mdadm --zero-superblock"
Date: Mon, 6 Apr 2015 20:31:39 -0700
Message-ID: <22789EEC-4F93-4B65-A93F-987DEE075C43@pobox.com>
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

Hello Neil,

Success! This is stronger voodoo magic than I=E2=80=99ve ever=20
had to perform so really didn=E2=80=99t have the faith to continue
without the extra encouragement :). My initial mistake
had been to use the octal value with losetup instead of
getting the decimal value.

Documenting my steps below for anybody else who
might come here later.

In the examples below, we are using partition "/dev/sdac2"
Replace this with the appropriate partition you=E2=80=99re recovering.

Step 1: find the decimal value for the start of the partition
-----------------------------------------------------------------------=
-----

Note:
ext4 partitions have a =E2=80=9Cmagic" octal value of =E2=80=9Cef53"
to indicate the start of the partition. Note that "ef53"
may show more than once as you read further into
the partition. We are interested in the location the=20
very first occurrence of "ef53". Other types of
partitions (ext2, ext3, etc) probably have other magic
values to look for so this =E2=80=9Cef53" may not apply there.

The "od" hex viewer command to search for =E2=80=9Cef53":

	od -x /dev/sdac2 | awk '$6 =3D=3D "ef53"'

The results will look something like:

4002060 f3fd 5521 0004 0025 ef53 0001 0001 0000
1004000060 64be 4ec9 0000 0025 ef53 0000 0001 0000
1042630400 17f8 a7dd bb6e ee40 ef53 000d 3cfb 9e22

We are only interested in the first line. So we now have
the octal address of the ef53 magic value: it=E2=80=99s the first
long number on the line: "4002060" (octal value!)

According to Neil=E2=80=99s instructions then we have to subtract
the octal value =E2=80=9C0002060" from this number we found.
We then have to convert the octal result into decimal.

Luckily an online calculator makes this easy:

http://www.csgnetwork.com/octaddsubcalc.html

"Enter a octal value" - Enter =E2=80=9C4002060" here
"Enter Second Octal Value" - Enter =E2=80=9C0002060" here

Then take the value from the line:
"Calculated Decimal Subtraction" - 1048576

This is the decimal value for the start of our partition.


Step 2: use the decimal start value to mount partition
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=
=E2=80=94=E2=80=94=E2=80=94

=46irst create a loop device loop0 as a handle to the
partition. We tell losetup where the start of the partition is:

	losetup -o 1048576 /dev/loop0 /dev/sdac2

Next, try to mount loop0 read-only (hopefully it will work!)

	mount -o ro /dev/loop0 /mnt

If the partition is unclean and needs to be fscked:

	fsck.ext4 /dev/loop0


Thanks again Neil! Maybe a few years from now I=E2=80=99ll
understand why this worked when nothing else did
( linux tools still have some ways to go to being
intelligent enough to do this kind of recovery).

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
