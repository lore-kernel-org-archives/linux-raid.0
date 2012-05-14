From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm 3.2.4 problem
Date: Tue, 15 May 2012 09:53:32 +1000
Message-ID: <20120515095332.3e600ec1@notabene.brown>
References: <1336829416.20535.10.camel@rybalov.eng.ttk.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0lcXeb5ZeHlsybu_BFoOBrH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1336829416.20535.10.camel@rybalov.eng.ttk.net>
Sender: linux-raid-owner@vger.kernel.org
To: nowhere <nowhere@hakkenden.ath.cx>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/0lcXeb5ZeHlsybu_BFoOBrH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 12 May 2012 17:30:16 +0400 nowhere <nowhere@hakkenden.ath.cx> wrote:

> Hello,
>=20
> I have a RAID5 array, which was created with mdadm 3.2.3
> Here is one of its member's superblock:
>=20
> /dev/sdl:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : cc0fbdd2:0feade15:963fe546:13a072fa
>            Name : heimdall:0  (local to host heimdall)
>   Creation Time : Sun May  6 10:58:30 2012
>      Raid Level : raid5
>    Raid Devices : 8
>=20
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 13674590720 (13041.11 GiB 14002.78 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 64962294:3699d869:510bef35:9d2fd78d
>=20
>     Update Time : Sat May 12 17:03:28 2012
>        Checksum : df1714ca - correct
>          Events : 96
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 6
>    Array State : AAAAAAA. ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> Some time ago mdadm have been upgraded to 3.2.4

That was probably about 1 day ago :-)  3.2.4 was only released on Wednesday.

>=20
> So, today I have replaced failed drive, but could not add it:
> mdadm --manage /dev/md0 --add /dev/sdm=20
> mdadm: add new device failed for /dev/sdm as 8: Invalid argument
>=20
> And there are lines in dmesg:
> md: sdm does not have a valid v1.2 superblock, not importing!
> md: md_import_device returned -22

That's bad.  Looks like I'll need to do a 3.2.5 fairly quickly as that will
affect lots of people.
I've pushed out a change that fixes it for me:
http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3Dd9751e06a601b5576b1=
b9e2c8126584083110ca5

Thanks for the report.

NeilBrown



>=20
> mdadm creates new superblock on sdm:
> /dev/sdm:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : cc0fbdd2:0feade15:963fe546:13a072fa
>            Name : heimdall:0  (local to host heimdall)
>   Creation Time : Sun May  6 10:58:30 2012
>      Raid Level : raid5
>    Raid Devices : 8
>=20
>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>      Array Size : 13674590720 (13041.11 GiB 14002.78 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : ecaaf8af:f41c6ca1:8190b6f8:37b53a06
>=20
>     Update Time : Sat May 12 16:46:20 2012
>        Checksum : 6dabb37a - correct
>          Events : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : spare
>    Array State : AAAAAAA. ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> New direve's size is equals to other drive's sizes (checked with
> blockdev --getsz)
>=20
> The only difference between superblocks created by diferent mdadm
> versions is data offset. Old one has 2048 sector offset, new one -
> 262144. I think, this leads to available device size to be smaller with
> new superblock and inability to add drive to the array.
>=20
> Downgrading mdadm allowed me to add device into array.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/0lcXeb5ZeHlsybu_BFoOBrH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7Ga/Dnsnt1WYoG5AQJ0Kw//dvwvDI9oPSlR6HiGzEeWAQEbSNgf7fiA
jmzZDOlKzqI3I2nE+rhE2I+YFkBISRbxdYiiGntA3Q0QLNVeoILWHpeWQAWVN3Kn
lvF0IxXAIjF9kqrx3CU8Qult4s/nsU2wDxrUUFwhZC3E3atDCN/6WGg2f+qeVfij
hm4i1T41qADr++7PKyVYvxuwJJpyTN9xO4IZupnwNEbab9b1Qgg77ako3b3OiN4s
8mXMOR5h2iYzr9ZxtQDYhS0t8PSjOHcuDHa0UdvSVJxb0eZolRn6lBqFLX+Ltzm2
Ryg6jRoojz2tyV3eXeiu5u/0lJMDUvVV7RvdNGZ8pv9Fvs0V5VwdhpDnVKvJlAwr
fBGi/0OcXOBicAE0TNPWCtrdWOkWRLq5i2xaqhec624TEL+VcnWMgJmtk2wTVMIm
mF2e/eYGIm+2+FBcHHvwHhj7k6kBkewn0+raNevMb2dNF11AjPg8AjIXuwG4JHl8
g73dFMn0Mw2tpbXswC8BlMU3yUYP97yX5Dus2a0Nn5dT3D8R91hzPIlLtAFvF4Uf
d1YTZZ2uOo6W29Amd4ATrQRPZgZQHyNACwqyhWGb/w6IsG8TX1w6OpyOXkBDRVud
NcOZoC5po98XXIBXhnL9zAFzTCxgHK3Z1OjDJaX5qGUhhe6bNAKF8E6t4W20hwNC
+g6Z6Ewv4CM=
=jlr5
-----END PGP SIGNATURE-----

--Sig_/0lcXeb5ZeHlsybu_BFoOBrH--
