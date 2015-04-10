From: Eduard Rozenberg <eduardr@pobox.com>
Subject: Personal insight - Re: Can't mount partitions after "mdadm --zero-superblock"
Date: Thu, 9 Apr 2015 19:53:36 -0700
Message-ID: <6A7078FB-BE9F-49AE-A327-6A049BA970B4@pobox.com>
References: <F271C907-A2A7-4132-BA11-D33353AE9FFF@pobox.com> <20150407105230.4ff9a97a@notabene.brown> <22789EEC-4F93-4B65-A93F-987DEE075C43@pobox.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22789EEC-4F93-4B65-A93F-987DEE075C43@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I finally figured out why I panicked and why things eventually worked=20
thanks to this very helpful post:

http://unix.stackexchange.com/questions/64889/how-to-mount-recover-data=
-on-a-disk-that-was-part-of-a-mdadm-raid-1-on-another-m

In particular this paragraph:

"Linux mdraid has several metadata formats. Formats 0.9 and 1.0 put the=
 metadata
at the end of the containing device, and the payload (the filesystem) s=
tarts at
the beginning of the device and can be accessed directly without going =
through
the raid layer. Formats 1.1 and 1.2 put the metadata at the middle and
beginning of the containing device respectively, so the payload is at a=
n offset."

I knew about the various metadata versions but I=E2=80=99d been working=
 under the false=20
assumption (based on my 0.9/1.0 metadata format mdadm experience) that
I would be able to directly mount an ext4 partition that had been previ=
ously part of
a RAID1 mdadm device.

According to the paragraph above this is clearly no longer true with me=
tadata
v1.1/1.2, and mounting a previously raid1 partition requires either the=
 decimal
offset to mount it directly or creating a new md device with the partit=
ion in question
(without of course formatting the new md device). Certainly not as conv=
enient
as it used to be but I'm sure there were good reasons to change the loc=
ation of
the metadata to the front of each partition.

Perhaps the mdadm wiki could include information to this effect, that m=
ounting
formerly raid1 mdadm partitions with metadata 1.1/1.2 requires these ex=
tra
steps and not to panic :).

Regards,
=E2=80=94Ed


> On Apr 6, 2015, at 20:31, Eduard Rozenberg <eduardr@pobox.com> wrote:
>=20
> Hello Neil,
>=20
> Success! This is stronger voodoo magic than I=E2=80=99ve ever=20
> had to perform so really didn=E2=80=99t have the faith to continue
> without the extra encouragement :). My initial mistake
> had been to use the octal value with losetup instead of
> getting the decimal value.
>=20
> Documenting my steps below for anybody else who
> might come here later.
>=20
> In the examples below, we are using partition "/dev/sdac2"
> Replace this with the appropriate partition you=E2=80=99re recovering=
=2E
>=20
> Step 1: find the decimal value for the start of the partition
> ---------------------------------------------------------------------=
-------
>=20
> Note:
> ext4 partitions have a =E2=80=9Cmagic" octal value of =E2=80=9Cef53"
> to indicate the start of the partition. Note that "ef53"
> may show more than once as you read further into
> the partition. We are interested in the location the=20
> very first occurrence of "ef53". Other types of
> partitions (ext2, ext3, etc) probably have other magic
> values to look for so this =E2=80=9Cef53" may not apply there.
>=20
> The "od" hex viewer command to search for =E2=80=9Cef53":
>=20
> 	od -x /dev/sdac2 | awk '$6 =3D=3D "ef53"'
>=20
> The results will look something like:
>=20
> 4002060 f3fd 5521 0004 0025 ef53 0001 0001 0000
> 1004000060 64be 4ec9 0000 0025 ef53 0000 0001 0000
> 1042630400 17f8 a7dd bb6e ee40 ef53 000d 3cfb 9e22
>=20
> We are only interested in the first line. So we now have
> the octal address of the ef53 magic value: it=E2=80=99s the first
> long number on the line: "4002060" (octal value!)
>=20
> According to Neil=E2=80=99s instructions then we have to subtract
> the octal value =E2=80=9C0002060" from this number we found.
> We then have to convert the octal result into decimal.
>=20
> Luckily an online calculator makes this easy:
>=20
> http://www.csgnetwork.com/octaddsubcalc.html
>=20
> "Enter a octal value" - Enter =E2=80=9C4002060" here
> "Enter Second Octal Value" - Enter =E2=80=9C0002060" here
>=20
> Then take the value from the line:
> "Calculated Decimal Subtraction" - 1048576
>=20
> This is the decimal value for the start of our partition.
>=20
>=20
> Step 2: use the decimal start value to mount partition
> =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=
=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=
=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=
=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=
=94=E2=80=94=E2=80=94=E2=80=94
>=20
> First create a loop device loop0 as a handle to the
> partition. We tell losetup where the start of the partition is:
>=20
> 	losetup -o 1048576 /dev/loop0 /dev/sdac2
>=20
> Next, try to mount loop0 read-only (hopefully it will work!)
>=20
> 	mount -o ro /dev/loop0 /mnt
>=20
> If the partition is unclean and needs to be fscked:
>=20
> 	fsck.ext4 /dev/loop0
>=20
>=20
> Thanks again Neil! Maybe a few years from now I=E2=80=99ll
> understand why this worked when nothing else did
> ( linux tools still have some ways to go to being
> intelligent enough to do this kind of recovery).
>=20
> Regards,
> =E2=80=94Ed
>=20
>=20
>> On Apr 6, 2015, at 17:52, NeilBrown <neilb@suse.de> wrote:
>>=20
>> On Mon, 6 Apr 2015 16:45:58 -0700 Eduard Rozenberg <eduardr@pobox.co=
m> wrote:
>>=20
>>> Hello folks,
>>>=20
>>> I previously had the following setup:
>>>=20
>>> sda & sdb partitioned w/ GPT, 7 partitions each (usr, opt, var etc.=
=2E.)
>>> 7 raid1=E2=80=99s with 2 devices for each pair of partitions (/dev/=
sda1 & /dev/sdab1, etc)
>>> They=E2=80=99d been created under Slackware 13.37.
>>>=20
>>> I was trying to clean out mdadm from those partitions but keep the =
data so I ran=20
>>> "mdadm --zero-superblock=E2=80=9D on each of those previously RAID1=
 mdadm 1.2 ext4=20
>>> partitions.
>>=20
>> The "1.2" metadata is stored 4k from the start of the device.  The a=
ctual
>> data is some megabytes further in.  I don't suppose you still have t=
he output
>> of "mdadm --examine" from before you destroyed the superblocks??
>>=20
>>>=20
>>> As a result I am now currently unable to mount any partition after =
the first one on either
>>> disk. The first partition does mount. The partition table is visibl=
e and looks fine in gdisk.
>>>=20
>>> mount -t ext4 /dev/sdac2 /mnt
>>> mount: wrong fs type, bad option, bad superblock on /dev/sdac2,
>>> missing codepage or helper program, or other error
>>> In some cases useful info is found in syslog - try
>>> dmesg | tail or so
>>>=20
>>> I did try superblock recovery with each backup superblock that ext4=
 normally creates,
>>> but none of the superblock locations worked.
>>>=20
>>> For example:
>>>=20
>>> fsck.ext4 -b 4096000 /dev/sdac2=20
>>> e2fsck 1.42.8 (20-Jun-2013)
>>> /sbin/e2fsck: Invalid argument while trying to open /dev/sdac2
>>>=20
>>> The superblock could not be read or does not describe a correct ext=
2
>>> filesystem. If the device is valid and it really contains an ext2
>>> filesystem (and not swap or ufs or something else), then the superb=
lock
>>> is corrupt, and you might try running e2fsck with an alternate supe=
rblock:
>>> e2fsck -b 8193 <device>
>>>=20
>>>=20
>>> Would be grateful for any advice on anything else I can try.
>>=20
>> You need to find where the filesystem actually starts, then you need=
 to
>> create some way to access it as a block device, then it should "just=
 work".
>>=20
>> An ext4 filesystem superblock has 0xef53 at an offset of 0x38, and t=
he
>> superblock is typically 1K from the start of the partition.
>>=20
>> So you could:
>>  od -x /dev/sdac2 | awk '$6 =3D=3D "ef53"'
>>=20
>> Then subtrace 0002060 (octal) from the leading number, and that migh=
t be the
>> start of the partition.
>>=20
>> Then
>> losetup -o "start in decimal" /dev/loop0 /dev/sdac2
>>=20
>> and try 'fsck' on /dev/loop0
>>=20
>> Good luck.
>>=20
>> NeilBrown
>>=20
>>=20
>>=20
>>>=20
>>> Regards,
>>> =E2=80=94Ed--
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
