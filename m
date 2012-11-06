From: Carabetta Giulio <g.carabetta@abi.it>
Subject: R: Data recovery after the failure of two disks of 4
Date: Tue, 6 Nov 2012 15:37:37 +0100
Message-ID: <4FDB990B62C2D849BA8EADBDD1C5928E1372444CE2@CCRMBX.abiad.abi.lan>
References: <4FDB990B62C2D849BA8EADBDD1C5928E13718F91D0@CCRMBX.abiad.abi.lan>
 <20120911110314.5c6cf245@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120911110314.5c6cf245@notabene.brown>
Content-Language: it-IT
Sender: linux-raid-owner@vger.kernel.org
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I just did as suggested. Ddrescue data to new disks and --assemble --fo=
rce did the job, I have all my data.

I did some check (xfs_repair -n / smart tests) and all seems to be ok.

I found only this:

#mdadm --examine-bitmap /dev/md0
	Filename : /dev/md0
	   Magic : 42534658
mdadm: invalid bitmap magic 0x42534658, the bitmap file appears to be c=
orrupted
	 Version : 1048576
mdadm: unknown bitmap version 1048576, either the bitmap file is corrup=
ted or you need to upgrade your tools


May be because I did the --assemble --force from a live cd newer than m=
y system. I'm on Ubuntu 11.04 (kernel 2.6.38-15 - mdadm v3.1.4) and the=
 live was PartedMagic (kernel 3.4.6 - mdadm v3.2.5).

But the same --examine-bitmap done with the live cd gave the same error=
=2E

I just need to recreate the bitmap?

Just curiosity: There whase a disk error (non-relocatable sector) and a=
 mobo error that loses some sata channels...


Giulio Carabetta=20



-----Messaggio originale-----
Da: NeilBrown [mailto:neilb@suse.de]=20
Inviato: marted=EC 11 settembre 2012 3.03
A: Carabetta Giulio
Cc: 'linux-raid@vger.kernel.org'
Oggetto: Re: Data recovery after the failure of two disks of 4

On Wed, 5 Sep 2012 15:34:00 +0200 Carabetta Giulio <g.carabetta@abi.it>=
 wrote:

> I'm trying to retrieve a raid 5 array after the failure of two disks =
of 4.
> "Simply", the controller has lost a disk, and after a couple of minut=
es, it lost another.
> The disappearance of the disk also happened to me while I was trying =
to pull out the data from the disk, so I guess it should be a problem w=
ith the control board of the disks...
>=20
> However, the server at the time of the fault was not doing anything s=
pecial, so the data "critics"  are still there, on the surface of the d=
isk ...
>=20
> Anyhow, I have two good disks and two faults.
>=20
> More specifically, the disks (4 identical 2TB WD20EARS) are all parti=
tioned in the same way: the first partition, about 250mb, the second wi=
th the rest of the free space.
> - sda1 and sdb1 as md0 (raid1) with /boot
> - sdc1 and sdd1 as md2 (raid1) with swaps
> - sd[abcd]2 as md1 (RAID5) with root partition.
>=20
> Swap is not a matter, and boot array has no problem. The first time I=
 found the problem it didn't boot just because the bios did not see the=
 disks (both with boot partition...), but was temporary error...
>=20
> The first disk to fail was sdb, and the second was sda: I'm guessing=20
> by looking at the differences between the superblocks: (the full dump=
=20
> of superblocks is queued to the message)
>=20
> ---
> sda2:
>         Update Time: Mon Aug 27 20:46:05 2012
>              Events: 622
>        Array State: A.AA ('A' =3D=3D active, '.' =3D=3D Missing)
>=20
> sdb2:
>         Update Time: Mon Aug 27 20:44:22 2012
>              Events: 600
>        Array State: AAAA ('A' =3D=3D active, '.' =3D=3D Missing)
>=20
> SdC2:
>         Update Time: Mon Aug 27 20:46:33 2012
>              Events: 625
>        Array State: ..AA ('A' =3D=3D active, '.' =3D=3D Missing)
>=20
> sdd2:
>         Update Time: Mon Aug 27 20:46:33 2012
>              Events: 625
>        Array State: ..AA ('A' =3D=3D active, '.' =3D=3D Missing)
> ---
>=20
> Now I'm copying partitions elsewhere, with ddrescue, to replace the f=
aulty disks and rebuild everything.
>=20
> In the meantime, I did a first test on the array md1 (root partition,=
=20
> the one with all my data...)
>=20
> Trying to reassemble the array I got:
>=20
> # Mdadm --assemble --force --verbose /dev/md11 /dev/sda2 /dev/sdb2=20
> /dev/sdc2 /dev/sdd2
> mdadm: forcing event count in /dev/sda2(o) from 622 upto 625
> mdadm: Marking array /dev/md11 as 'clean'
> mdadm: added /dev/sdb2 to /dev/md11 as 1 (possibly out of date)
> mdadm: /dev/md11 has been started with 3 drives (out of 4).
>=20
>=20
> Then I mounted the array and I saw the correct file system.
> To avoid a new fault (with disks very unstable), I stopped and remove=
d the array very quickly, so I didn't tryed to read a file, I simply di=
d few ls...

Use --assemble --force is the correct thing to do.  It gives you the be=
st chance of getting all your data.
If you don't trust the drives, you should get replacements and use ddre=
scue to copy the data from the bad device to the new device.  Then asse=
mble the array using the new device.

>=20
> Now the question.
>=20
> I was copying only 3 disks, sdd, sdc, and the "freshest" faulty: sda.=
 With 3 out of 4 disks in raid5 should be sufficient...
> But while copying the data, I got a read error on sda. I lost just 4K=
byte, but I do not know what piece of data is part of what...

You might be lucky and it is a block that isn't used.  You might be unl=
ucky and it is some critical data.  There isn't a lot you can do about =
that though
- the data appears to be gone.

>=20
> So now I'm ddrescue'ing the fourth disk.
>=20
> And then what?
>=20
> While I wait for the replacement disks (luckily under warranty, at le=
ast that ...), I need some suggestions.
>=20
> I supposed to copy the images on the new disk, and then try to assemb=
le the array, but not know what could be the best approach (and if ther=
e's another one over a simple "mdadm --assemble").

Yes, just copy from bad disk to good disk with ddrescue, then assemble =
with mdadm.

NeilBrown


>=20
> Keeping hold sdc and sdd as they are intact (at the moment ...): on t=
he one hand we have a data disk "old" (sdb, the first to break ...) but=
 without surface errors, and on the other hand, we have the other disk =
with the newest data (sda, the last to break), but with a 4k hole.
> Moreover sda has been forced as "good"...
>=20
> Which options I have?
>=20
> Thanks
>=20
> Giulio Carabetta
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>     root@PartedMagic:/mnt# mdadm --examine /dev/sda2
>     /dev/sda2:
>               Magic : a92b4efc
>             Version : 1.2
>         Feature Map : 0x0
>          Array UUID : 4e7bb63f:74d1ac58:b01b1b48:44c7b7d7
>                Name : ubuntu:0
>       Creation Time : Sun Sep 25 09:10:23 2011
>          Raid Level : raid5
>        Raid Devices : 4
>     =20
>      Avail Dev Size : 3906539520 (1862.78 GiB 2000.15 GB)
>          Array Size : 5859807744 (5588.35 GiB 6000.44 GB)
>       Used Dev Size : 3906538496 (1862.78 GiB 2000.15 GB)
>         Data Offset : 2048 sectors
>        Super Offset : 8 sectors
>               State : active
>         Device UUID : 3d01cfa9:6313d51c:402b3ca5:815a84e9
>     =20
>         Update Time : Mon Aug 27 20:46:05 2012
>            Checksum : c51fe8dc - correct
>              Events : 622
>     =20
>              Layout : left-symmetric
>          Chunk Size : 512K
>     =20
>        Device Role : Active device 0
>        Array State : A.AA ('A' =3D=3D active, '.' =3D=3D missing)
>     =20
>     =20
>     root@PartedMagic:/mnt# mdadm --examine /dev/sdb2
>     /dev/sdb2:
>               Magic : a92b4efc
>             Version : 1.2
>         Feature Map : 0x0
>          Array UUID : 4e7bb63f:74d1ac58:b01b1b48:44c7b7d7
>                Name : ubuntu:0
>       Creation Time : Sun Sep 25 09:10:23 2011
>          Raid Level : raid5
>        Raid Devices : 4
>     =20
>      Avail Dev Size : 3906539520 (1862.78 GiB 2000.15 GB)
>          Array Size : 5859807744 (5588.35 GiB 6000.44 GB)
>       Used Dev Size : 3906538496 (1862.78 GiB 2000.15 GB)
>         Data Offset : 2048 sectors
>        Super Offset : 8 sectors
>               State : clean
>         Device UUID : 0c64fdf8:c55ee450:01f05a3c:57b87308
>     =20
>         Update Time : Mon Aug 27 20:44:22 2012
>            Checksum : fe6eb926 - correct
>              Events : 600
>     =20
>              Layout : left-symmetric
>          Chunk Size : 512K
>     =20
>        Device Role : Active device 1
>        Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)
>     =20
>     =20
>     root@PartedMagic:/mnt# mdadm --examine /dev/sdc2
>     /dev/sdc2:
>               Magic : a92b4efc
>             Version : 1.2
>         Feature Map : 0x0
>          Array UUID : 4e7bb63f:74d1ac58:b01b1b48:44c7b7d7
>                Name : ubuntu:0
>       Creation Time : Sun Sep 25 09:10:23 2011
>          Raid Level : raid5
>        Raid Devices : 4
>     =20
>      Avail Dev Size : 3906539520 (1862.78 GiB 2000.15 GB)
>          Array Size : 5859807744 (5588.35 GiB 6000.44 GB)
>       Used Dev Size : 3906538496 (1862.78 GiB 2000.15 GB)
>         Data Offset : 2048 sectors
>        Super Offset : 8 sectors
>               State : clean
>         Device UUID : 0bb6c440:a2e47ae9:50eee929:fee9fa5e
>     =20
>         Update Time : Mon Aug 27 20:46:33 2012
>            Checksum : 22e0c195 - correct
>              Events : 625
>     =20
>              Layout : left-symmetric
>          Chunk Size : 512K
>     =20
>        Device Role : Active device 2
>        Array State : ..AA ('A' =3D=3D active, '.' =3D=3D missing)
>     =20
>     =20
>     root@PartedMagic:/mnt# mdadm --examine /dev/sdd2
>     /dev/sdd2:
>               Magic : a92b4efc
>             Version : 1.2
>         Feature Map : 0x0
>          Array UUID : 4e7bb63f:74d1ac58:b01b1b48:44c7b7d7
>                Name : ubuntu:0
>       Creation Time : Sun Sep 25 09:10:23 2011
>          Raid Level : raid5
>        Raid Devices : 4
>     =20
>      Avail Dev Size : 3906539520 (1862.78 GiB 2000.15 GB)
>          Array Size : 5859807744 (5588.35 GiB 6000.44 GB)
>       Used Dev Size : 3906538496 (1862.78 GiB 2000.15 GB)
>         Data Offset : 2048 sectors
>        Super Offset : 8 sectors
>               State : clean
>         Device UUID : 1f06610d:379589ed:db2a719b:82419b35
>     =20
>         Update Time : Mon Aug 27 20:46:33 2012
>            Checksum : 3bb3564f - correct
>              Events : 625
>     =20
>              Layout : left-symmetric
>          Chunk Size : 512K
>     =20
>        Device Role : Active device 3
>        Array State : ..AA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D--
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
=20
> in the body of a message to majordomo@vger.kernel.org More majordomo=20
> info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
