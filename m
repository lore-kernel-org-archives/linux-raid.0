From: NeilBrown <neilb@suse.de>
Subject: Re: 2 disk raid 5 failure
Date: Sun, 5 Oct 2014 19:41:05 +1100
Message-ID: <20141005194105.4377c295@notabene.brown>
References: <CANuKpt=QJsham0TQWR1Cu1EC8GLyc0aSdU4p3DOznBRrEea11A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/WFmGwRF81mA_lYsIXpA4c6E"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANuKpt=QJsham0TQWR1Cu1EC8GLyc0aSdU4p3DOznBRrEea11A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jean-Paul Sergent <jpsergent@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WFmGwRF81mA_lYsIXpA4c6E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 4 Oct 2014 22:43:01 -0700 Jean-Paul Sergent <jpsergent@gmail.com>
wrote:

> Greetings,
>=20
> Recently I lost 2 disks, out of 5, in my raid 5 array from a bad SATA pow=
er
> cable. It was a Y splitter and it shorted... it was cheap. I was wondering
> if there was any chance in getting my data back.
>=20
> Of the 2 disks that blew out, one actually had bad/unreadable sectors on
> the disk and the other disk seems fine. I have cloned both disks with DD =
to
> 2 new disks and forced the one disk to clone even with errors. The
> remaining 3 disks are in tact. The events number on the array for all 5
> disks are very close to each other:
>=20
>          Events : 201636
>          Events : 201636
>          Events : 201636
>          Events : 201630
>          Events : 201633
>=20
> Which from my reading gives me some hope, but I'm not sure. I have not do=
ne
> "recovering a failed software raid" on the wiki yet, the part about
> using a loop device to protect your array. I thought I would send a
> message out to this list first before going down
> that route.
>=20
> I did try to do a mdadm --force --assemble on the array but is says that =
it
> only has 3 disks which isn't enough to start the array. I don't want to do
> anything else before consulting the mailing list first.

--force --assemble really is what you want.  It should work.
What does=20
   mdadm -A /dev/md1 --force -vv /dev/sdb /dev/sdc /dev/sde /dev/sdf /dev/s=
dg

report??
What version of mdadm (mdadm -V) do you have?

NeilBrown


>=20
> below I have pasted the mdadm --examine from each member drive. Any help =
would
> be greatly appreciated.
>=20
> Thanks,
> -JP
>=20
> /dev/sdb:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 7de100f5:4f30f751:62456293:fe98f735
>            Name : b1ackb0x:1
>   Creation Time : Sun Jan 13 00:01:44 2013
>      Raid Level : raid5
>    Raid Devices : 5
>=20
>  Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
>      Array Size : 5860548608 (5589.05 GiB 6001.20 GB)
>   Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D1968 sectors, after=3D816 sectors
>           State : clean
>     Device UUID : 71d7c3d7:7b232399:51571715:711da6f6
>=20
>     Update Time : Tue Apr 29 02:49:21 2014
>        Checksum : cd29f83c - correct
>          Events : 201636
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 2
>    Array State : AAA.. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
> /dev/sdc:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 7de100f5:4f30f751:62456293:fe98f735
>            Name : b1ackb0x:1
>   Creation Time : Sun Jan 13 00:01:44 2013
>      Raid Level : raid5
>    Raid Devices : 5
>=20
>  Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
>      Array Size : 5860548608 (5589.05 GiB 6001.20 GB)
>   Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D1968 sectors, after=3D816 sectors
>           State : clean
>     Device UUID : b47c32b5:b2f9e81a:37150c33:8e3fa6ca
>=20
>     Update Time : Tue Apr 29 02:49:21 2014
>        Checksum : 1e5353af - correct
>          Events : 201636
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 1
>    Array State : AAA.. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
> /dev/sde:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 7de100f5:4f30f751:62456293:fe98f735
>            Name : b1ackb0x:1
>   Creation Time : Sun Jan 13 00:01:44 2013
>      Raid Level : raid5
>    Raid Devices : 5
>=20
>  Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
>      Array Size : 5860548608 (5589.05 GiB 6001.20 GB)
>   Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D1968 sectors, after=3D816 sectors
>           State : clean
>     Device UUID : 0398da5b:0bcddd81:8f7e77e9:6689ee0c
>=20
>     Update Time : Tue Apr 29 02:49:21 2014
>        Checksum : 24a3f586 - correct
>          Events : 201636
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 0
>    Array State : AAA.. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
> /dev/sdf:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 7de100f5:4f30f751:62456293:fe98f735
>            Name : b1ackb0x:1
>   Creation Time : Sun Jan 13 00:01:44 2013
>      Raid Level : raid5
>    Raid Devices : 5
>=20
>  Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
>      Array Size : 5860548608 (5589.05 GiB 6001.20 GB)
>   Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D1968 sectors, after=3D976752816 sectors
>           State : clean
>     Device UUID : 356c6d85:627a994f:753dec0d:db4fa4f2
>=20
>     Update Time : Tue Apr 29 02:37:38 2014
>        Checksum : 2621f9d5 - correct
>          Events : 201630
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 3
>    Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
> /dev/sdg:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 7de100f5:4f30f751:62456293:fe98f735
>            Name : b1ackb0x:1
>   Creation Time : Sun Jan 13 00:01:44 2013
>      Raid Level : raid5
>    Raid Devices : 5
>=20
>  Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
>      Array Size : 5860548608 (5589.05 GiB 6001.20 GB)
>   Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D1968 sectors, after=3D976752816 sectors
>           State : clean
>     Device UUID : 3dc152d8:832dd43a:a6d638e3:6e12b394
>=20
>     Update Time : Tue Apr 29 02:48:01 2014
>        Checksum : db9e6008 - correct
>          Events : 201633
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 4
>    Array State : AAA.A ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/WFmGwRF81mA_lYsIXpA4c6E
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVDEEITnsnt1WYoG5AQLoNQ//fLbhYdvtHRYcRQ5T0qBTVj6SBZPWNN+k
4pFEsBr7wLkyAymrcJfhzP082UU4H23T/iSK23tSOk99Rk+aYuj+iqvrlvp9kQw+
T2I9RSWr5K7P4f7hEsP6cHzyiAToTyVpqGFk/QBMHjFzw1curUitduCZabBiNtIX
8T9l+n82wmN4oEbWhaY87DY5I8Yuj1xoYiodFifwG0wovi8KXXqQFWJLvrMOBSHW
PPJAFudOHl0iFUndts4DxiubYYirNz2z/eAFBhNdp7BQQ4SUIRf4YKqPRss7sqXD
KD1dZzoMgiKQAsIUSr6iJD8phRbTOwaPSbYLQPppPbXkEBrx4GAYQQM+Fy0g/m76
BcMDvBCh8pI4zOL+2vnuh03eAYQAMzSNfaxqKrN9SiIx/vfkIQeeSvXLxU6odJdd
2LIj/eLExUZ9I+4eAuPnLsGDugD4/+9ZS/cDkFeFnSLsqqVpAnR5lkPOIPYRXXYs
Esg7MmjHMsj+jNxyISZC889Zp6MU2Q2qE8n6IqRRNgmdDNO6Ktt9NZwLKUxIvGhu
FyQZQWD9baaZf2GxET4prRTCQioHa9BohXXk5ezWJiYcCVkWm/btolvZDUcroaGG
81hGRKz7NIM6ttBZMFsMB2MW42Kq7o3oH5tSuFn11uEZ1MoFWcnUTBH+nJbMtESP
fqHVaCjv0x4=
=QsVI
-----END PGP SIGNATURE-----

--Sig_/WFmGwRF81mA_lYsIXpA4c6E--
