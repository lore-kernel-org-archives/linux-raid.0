From: NeilBrown <neilb@suse.de>
Subject: Re: Data recovery after the failure of two disks of 4
Date: Tue, 11 Sep 2012 11:03:14 +1000
Message-ID: <20120911110314.5c6cf245@notabene.brown>
References: <4FDB990B62C2D849BA8EADBDD1C5928E13718F91D0@CCRMBX.abiad.abi.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/280SzcIscGFa/TgC4GxeVZK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FDB990B62C2D849BA8EADBDD1C5928E13718F91D0@CCRMBX.abiad.abi.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Carabetta Giulio <g.carabetta@abi.it>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/280SzcIscGFa/TgC4GxeVZK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 5 Sep 2012 15:34:00 +0200 Carabetta Giulio <g.carabetta@abi.it> wro=
te:

> I'm trying to retrieve a raid 5 array after the failure of two disks of 4.
> "Simply", the controller has lost a disk, and after a couple of minutes, =
it lost another.
> The disappearance of the disk also happened to me while I was trying to p=
ull out the data from the disk, so I guess it should be a problem with the =
control board of the disks...
>=20
> However, the server at the time of the fault was not doing anything speci=
al, so the data "critics"  are still there, on the surface of the disk ...
>=20
> Anyhow, I have two good disks and two faults.
>=20
> More specifically, the disks (4 identical 2TB WD20EARS) are all partition=
ed in the same way: the first partition, about 250mb, the second with the r=
est of the free space.
> - sda1 and sdb1 as md0 (raid1) with /boot
> - sdc1 and sdd1 as md2 (raid1) with swaps=20
> - sd[abcd]2 as md1 (RAID5) with root partition.
>=20
> Swap is not a matter, and boot array has no problem. The first time I fou=
nd the problem it didn't boot just because the bios did not see the disks (=
both with boot partition...), but was temporary error...
>=20
> The first disk to fail was sdb, and the second was sda: I'm guessing by l=
ooking at the differences between the superblocks: (the full dump of superb=
locks is queued to the message)
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
> Now I'm copying partitions elsewhere, with ddrescue, to replace the fault=
y disks and rebuild everything.
>=20
> In the meantime, I did a first test on the array md1 (root partition, the=
 one with all my data...)
>=20
> Trying to reassemble the array I got:
>=20
> # Mdadm --assemble --force --verbose /dev/md11 /dev/sda2 /dev/sdb2 /dev/s=
dc2 /dev/sdd2
> mdadm: forcing event count in /dev/sda2(o) from 622 upto 625
> mdadm: Marking array /dev/md11 as 'clean'
> mdadm: added /dev/sdb2 to /dev/md11 as 1 (possibly out of date)
> mdadm: /dev/md11 has been started with 3 drives (out of 4).
>=20
>=20
> Then I mounted the array and I saw the correct file system.
> To avoid a new fault (with disks very unstable), I stopped and removed th=
e array very quickly, so I didn't tryed to read a file, I simply did few ls=
...

Use --assemble --force is the correct thing to do.  It gives you the best
chance of getting all your data.
If you don't trust the drives, you should get replacements and use ddrescue
to copy the data from the bad device to the new device.  Then assemble the
array using the new device.

>=20
> Now the question.
>=20
> I was copying only 3 disks, sdd, sdc, and the "freshest" faulty: sda. Wit=
h 3 out of 4 disks in raid5 should be sufficient...
> But while copying the data, I got a read error on sda. I lost just 4Kbyte=
, but I do not know what piece of data is part of what...

You might be lucky and it is a block that isn't used.  You might be unlucky
and it is some critical data.  There isn't a lot you can do about that thou=
gh
- the data appears to be gone.

>=20
> So now I'm ddrescue'ing the fourth disk.
>=20
> And then what?
>=20
> While I wait for the replacement disks (luckily under warranty, at least =
that ...), I need some suggestions.
>=20
> I supposed to copy the images on the new disk, and then try to assemble t=
he array, but not know what could be the best approach (and if there's anot=
her one over a simple "mdadm --assemble").

Yes, just copy from bad disk to good disk with ddrescue, then assemble with
mdadm.

NeilBrown


>=20
> Keeping hold sdc and sdd as they are intact (at the moment ...): on the o=
ne hand we have a data disk "old" (sdb, the first to break ...) but without=
 surface errors, and on the other hand, we have the other disk with the new=
est data (sda, the last to break), but with a 4k hole.
> Moreover sda has been forced as "good"...
>=20
> Which options I have?
>=20
> Thanks
>=20
> Giulio Carabetta
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
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
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/280SzcIscGFa/TgC4GxeVZK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE6N0jnsnt1WYoG5AQJa6BAAkds5ABIS36dtSnFgLuR375DprrTH/Ykw
9QRS/BTgg8K+3hE3/7a4S/8u+bLo10L+crt44/ygxe14r4txl6qr2qIHx8C5gY/K
yybrFaCpP5wyAn9nVSu9ICP0BrQAuQ4Q+x9HeZm1ylK//lhc9q8VO2wiE0u5xYk8
+YrvdMVFE8NPkDAXvil7Qywgdcm1vNjAcYgt3kobSJi1QVM+jJnKnPZfsbOea8D1
DnAU+4jlo3/A9t+3JzAq0ZhilE7IxBc38tu0V4RIU+VDn8JeI+2HX994nmDcnhiZ
bLrAch6Bt3aipKsIOZISziW4kC+povVPAWdYVwk+UW7SAzF2eGZPYN6+bzocTylk
loginkk3odAaUd2y+IGwCtsfZ0HayyPa+a4HND3EVvle/6PH+esvQ+6Vtmdyo9C4
pdtR5dECNraJpkHg2p0jIUEiXAOUb0HYoYOHWzmRUpMa3a7dBsvJfI6i1zUixkNE
PS7EbY50mysHIyv6Wh06l3pe/9B9A191ApF/D/aoLP4Bz3qw6RlzTXGM6Jww2Wel
VgfalpWNIkFKjkELxffDRXyjPWocgqCcBnd3J3UR02Awe1X6mGgdkslsnE296UyJ
gCOHpXSDJLSsqKM419x5Fgx9XDCX3wvoqyqc1P0OXT6o9EGhjNhLu5QFf0h/Jtap
fwlNB5zgkJY=
=LVLR
-----END PGP SIGNATURE-----

--Sig_/280SzcIscGFa/TgC4GxeVZK--
