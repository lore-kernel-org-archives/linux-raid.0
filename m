From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm expanded 8 disk raid 6 fails in new server, 5 original
 devices show no md superblock
Date: Sat, 11 Jan 2014 12:47:33 -0500
Message-ID: <52D183B5.3060006@turmel.org>
References: <1389422546.11328.15.camel@achilles.aeskuladis.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1389422546.11328.15.camel@achilles.aeskuladis.de>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?Ikdyb8Ofa3JldXR6LCBKdWxpYW4i?= <Julian.Grosskreutz@med.uni-jena.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "neilb@suse.de" <neilb@suse.de>
List-Id: linux-raid.ids

Hi Julian,

Very good report.  I think we can help.

On 01/11/2014 01:42 AM, Gro=C3=9Fkreutz, Julian wrote:
> Dear all, dear Neil (thanks for pointing me to this list),
>=20
> I am in desperate need of help. mdadm is fantastic work, and I have
> relied on mdadm for years to run very stable server systems, never ha=
d
> major problems I could not solve.
>=20
> This time its different:
>=20
> On a Centos 6.x (can't remember) initially in 2012:
>=20
> parted to create GPT partitions on 5 Seagate drives 3TB each
>=20
> Model: ATA ST3000DM001-9YN1 (scsi)
> Disk /dev/sda: 5860533168s  # sd[bcde] identical
> Sector size (logical/physical): 512B/4096B
> Partition Table: gpt
>=20
> Number  Start     End          Size         File system  Name     Fla=
gs
> 1      2048s     1953791s     1951744s     ext4                  boot
> 2      1955840s  5860532223s  5858576384s               primary  raid

Ok.

Please also show the partition tables for the /dev/sd[fgh].

> I used an unknown mdadm version including unknown offset parameters f=
or
> 4k alignment to create
>=20
> /dev/sd[abcde]1 as /dev/md0 raid 1 for booting (1 GB)
> /dev/sd[abcde]2 as /dev/md1 raid 6 for data (9 TB) lvm physical drive
>=20
> Later added 3 more 3T identical Seagate drives with identical partiti=
on
> layout, but later firmware.
>=20
> Using likely a different newer version of mdadm I expanded RAID 6 by =
2
> drives and added 1 spare.
>=20
> /dev/md1 was at 15 TB gross, 13 TB usable, expanded pv
>=20
> Ran fine

Ok.  Your evidence below has some evidence suggesting you created the
larger array from scratch instead of using --grow.  Do you remember?

> Then I moved the 8 disks to a new server with an hba and backplane,
> array did not start because mdadm did not find the superblocks on the
> original 5 devices /dev/sd[abcde]2. Moving the disks back to the old
> server the error did not vanish. Using a centos 6.3 livecd, I got the
> following:
>=20
> [root@livecd ~]# mdadm -Evvvvs /dev/sd[abcdefgh]2
> mdadm: No md superblock detected on /dev/sda2.
> mdadm: No md superblock detected on /dev/sdb2.
> mdadm: No md superblock detected on /dev/sdc2.
> mdadm: No md superblock detected on /dev/sdd2.
> mdadm: No md superblock detected on /dev/sde2.
>=20
> /dev/sdf2:
>               Magic : a92b4efc
>             Version : 1.2
>         Feature Map : 0x0
>          Array UUID : 32d82f84:fe30ac2e:f589aaef:bdd3e4c7
>                Name : 1
>       Creation Time : Wed Jul 31 18:24:38 2013

Note this creation time...  would have been 2012 if you had used --grow=
=2E

>          Raid Level : raid6
>        Raid Devices : 7
>=20
>      Avail Dev Size : 5858314240 (2793.46 GiB 2999.46 GB)
>          Array Size : 29285793280 (13964.55 GiB 14994.33 GB)
>       Used Dev Size : 5857158656 (2792.91 GiB 2998.87 GB)

This used dev size is very odd.  The unused space after the data area i=
s
1155584 sectors (>500MiB).

>         Data Offset : 262144 sectors
>        Super Offset : 8 sectors
>               State : active
>         Device UUID : d5a16cb2:ff41b9a5:cbbf12b7:3750026d
>=20
>         Update Time : Mon Dec 16 01:16:26 2013
>            Checksum : ee921c43 - correct
>              Events : 327
>=20
>              Layout : left-symmetric
>          Chunk Size : 256K
>=20
>       Device Role : Active device 5
>       Array State : A.AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sdg2:
>               Magic : a92b4efc
>             Version : 1.2
>         Feature Map : 0x0
>          Array UUID : 32d82f84:fe30ac2e:f589aaef:bdd3e4c7
>                Name : 1
>       Creation Time : Wed Jul 31 18:24:38 2013
>          Raid Level : raid6
>        Raid Devices : 7
>=20
>      Avail Dev Size : 5858314240 (2793.46 GiB 2999.46 GB)
>          Array Size : 29285793280 (13964.55 GiB 14994.33 GB)
>       Used Dev Size : 5857158656 (2792.91 GiB 2998.87 GB)
>         Data Offset : 262144 sectors
>        Super Offset : 8 sectors
>               State : active
>         Device UUID : a1e1e51b:d8912985:e51207a9:1d718292
>=20
>         Update Time : Mon Dec 16 01:16:26 2013
>            Checksum : 4ef01fe9 - correct
>              Events : 327
>=20
>              Layout : left-symmetric
>          Chunk Size : 256K
>=20
>         Device Role : Active device 6
>         Array State : A.AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sdh2:
>               Magic : a92b4efc
>             Version : 1.2
>         Feature Map : 0x0
>          Array UUID : 32d82f84:fe30ac2e:f589aaef:bdd3e4c7
>                Name : 1
>       Creation Time : Wed Jul 31 18:24:38 2013
>          Raid Level : raid6
>        Raid Devices : 7
>=20
>      Avail Dev Size : 5858314240 (2793.46 GiB 2999.46 GB)
>          Array Size : 29285793280 (13964.55 GiB 14994.33 GB)
>       Used Dev Size : 5857158656 (2792.91 GiB 2998.87 GB)
>         Data Offset : 262144 sectors
>        Super Offset : 8 sectors
>               State : active
>         Device UUID : 030cb9a7:76a48b3c:b3448369:fcf013e1
>=20
>         Update Time : Mon Dec 16 01:16:26 2013
>            Checksum : a1330e97 - correct
>              Events : 327
>=20
>              Layout : left-symmetric
>          Chunk Size : 256K
>=20
>        Device Role : spare
>        Array State : A.AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
>=20
> I suspect that the superblock of the original 5 devices is at a
> different location, possibly because they where created with a differ=
ent
> mdadm version, i.e. at the end of the partitions. Booting the drives
> with the hba in IT (non-raid) mode on the new server may have introdu=
ced
> an initialization on the first five drive at the end of the partition=
s
> because I can hexdump something with "EFI PART" in the last 64 kb in =
all
> 8 partitions used for the raid 6, which may not have affected the 3
> added drives which show metadata 1.2.

The "EFI PART" is part of the backup copy of the GPT.  All the drives i=
n
a working array will have the same metadata version (superblock
location) even if the data offsets are different.

I would suggest hexdumping entire devices looking for the MD superblock
magic value, which will always be at the start of a 4k-aligned block.

Show (will take a long time, even with the big block size):

for x in /dev/sd[a-e]2 ; echo -e "\nDevice $x" ; dd if=3D$x bs=3D1M |he=
xdump
-C |grep "000  fc 4e 2b a9" ; done

=46or any candidates found, hexdump the whole 4k block for us.

> If any of You can help me sort this I would greatly appreciate it. I
> guess I need the mdadm version where I can set the data offset
> differently for each device, but it doesn't compile with an error in
> sha1.c:
>=20
> sha1.h:29:22: Fehler: ansidecl.h: Datei oder Verzeichnis nicht gefund=
en
> (didn't find ansidecl.h, error in German)

You probably need some *-dev packages.  I don't use the RHEL platform,
so I'm not sure what you'd need.  In the ubuntu world, it'd be the
"build-essentials" meta-package.

> What would be the best way to proceed? There is critical data on this
> raid, not fully backed up.
>=20
> (UPD'T)
>=20
> Thanks for getting back.
>=20
> Yes, it's bad, I know, also tweaking without keeping exact records of
> versions and offsets.
>=20
> I am, however, rather sure that nothing was written to the disks when=
 I
> plugged them into the NEW server, unless starting up a live cd causes=
 an
> automatic assemble attempt with an update to the superblocks. That I
> cannot exclude.
>=20
> What I did so far w/o writing to the disks
>=20
> get non-00 data at the beginning of sda2:
>=20
> dd if=3D/dev/sda skip=3D1955840 bs=3D512 count=3D10 | hexdump -C | gr=
ep [^00]

=46WIW, you could have combined "if=3D/dev/sda skip=3D1955840" into
"if=3D/dev/sda2" . . . :-)

> gives me
>=20
> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> |................|
>         *
> 00001000  1e b5 54 51 20 4c 56 4d  32 20 78 5b 35 41 25 72  |..TQ LVM=
2
> x[5A%r|
> 00001010  30 4e 2a 3e 01 00 00 00  00 10 00 00 00 00 00 00  |
> 0N*>............|
> 00001020  00 00 02 00 00 00 00 00  00 00 00 00 00 00 00 00
> |................|
> 00001030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> |................|
> *
> 00001200  76 67 5f 6e 65 64 69 67  73 30 32 20 7b 0a 69 64  |vg_nedig=
s02
> {.id|
> 00001210  20 3d 20 22 32 4c 62 48  71 64 2d 72 67 42 74 2d  | =3D
> "2LbHqd-rgBt-|
> 00001220  45 4a 75 31 2d 32 52 36  31 2d 41 35 7a 74 2d 6e  |
> EJu1-2R61-A5zt-n|
> 00001230  49 58 53 2d 66 79 4f 36  33 73 22 0a 73 65 71 6e  |
> IXS-fyO63s".seqn|
> 00001240  6f 20 3d 20 37 0a 66 6f  72 6d 61 74 20 3d 20 22  |o =3D
> 7.format =3D "|
> 00001250  6c 76 6d 32 22 20 23 20  69 6e 66 6f 72 6d 61 74  |lvm2" #
> informat|
> (cont'd)

This implies that /dev/sda2 is the first device in a raid5/6 that uses
metadata 0.9 or 1.0.  You've found the LVM PV signature, which starts a=
t
4k into a PV.  Theoretically, this could be a stray, abandoned signatur=
e
from the original array, with the real LVM signature at the 262144
offset.  Show:

dd if=3D/dev/sda2 skip=3D262144 count=3D16 |hexdump -C

>=20
> but on /dev/sdb
>=20
> 00000000  5f 80 00 00 5f 80 01 00  5f 80 02 00 5f 80 03 00  |
> _..._..._..._...|
> 00000010  5f 80 04 00 5f 80 0c 00  5f 80 0d 00 00 00 00 00  |
> _..._..._.......|
> 00000020  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> |................|
> *
> 00001000  60 80 00 00 60 80 01 00  60 80 02 00 60 80 03 00  |
> `...`...`...`...|
> 00001010  60 80 04 00 60 80 0c 00  60 80 0d 00 00 00 00 00  |
> `...`...`.......|
> 00001020  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> |................|
> *
> 00001400
>=20
> so my initial guess that the data may start at 00001000 did not pan o=
ut.

No, but with parity raid scattering data amongst the participating
devices, the report on /dev/sdb2 is expected.

> Does anybody have an idea of how to reliably identify an mdadm
> superblock in a hexdump of the drive ?

Above.

> And second, have I got my numbers right ? In parted I see the block
> count, and when I multiply 512 (not 4096!) with the total count I get=
 3
> TB, so I think I have to use bs=3D512 in dd to get teh partition
> boundaries correct.

dd uses bs=3D512 as the default.  And it can access the partitions dire=
ctly.

> As for the last state: one drive was set faulty, apparently, but the
> spare had not been integrated. I may have gotten caught in a bug
> described by Neil Brown, where on shutdown disk were wrongly reported=
,
> and subsequently superblock information was overwritten.

Possible.  If so, you may not find any superblocks with the grep above.

> I don't have NAS/SAN storage space to make identical copies of 5x3 TB=
,
> but maybe I should buy 5 more disks and do a dd mirror so I have a
> backup of the current state.

We can do some more non-destructive investigation first.

Regards,

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
