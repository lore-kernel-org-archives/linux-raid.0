From: NeilBrown <neilb@suse.de>
Subject: Re: MD RAID Bug 7/15/12
Date: Mon, 1 Oct 2012 13:02:42 +1000
Message-ID: <20121001130242.745b7ca3@notabene.brown>
References: <022FFCA9-5D0E-41DB-9617-202C6FAADD06@rightthisminute.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Mc3q4J7.uHTOrFJL1+0biWz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <022FFCA9-5D0E-41DB-9617-202C6FAADD06@rightthisminute.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Munoz <mark.munoz@rightthisminute.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Mc3q4J7.uHTOrFJL1+0biWz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 29 Sep 2012 17:12:40 -0700 Mark Munoz
<mark.munoz@rightthisminute.com> wrote:

> Hi I appear to have been affected by the bug you found on 7/15/12.  The d=
ata I have on this array is really important and I want to make sure I get =
this correct before I actually make changes.
>=20
> Configuration:
> md0 is a RAID 6 volume with 24 devices and 1 spare.  It is working fine a=
nd was unaffected.
> md1 is a RAID 6 volume with 19 devices and 1 spare.  It was affected.  Al=
l the drives show as unknown raid level and 0 devices.  With the exception =
of device 5.  It has all the information.
>=20
> Here is the output from that drive:
>=20
> serveradmin@hulk:/etc/mdadm$ sudo mdadm --examine /dev/sdaf
> /dev/sdaf:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 6afb3306:144cec30:1b2d1a19:3a56f0d3
>            Name : hulk:1  (local to host hulk)
>   Creation Time : Wed Aug 15 16:25:30 2012
>      Raid Level : raid6
>    Raid Devices : 19
>=20
>  Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
>      Array Size : 99629024416 (47506.82 GiB 51010.06 GB)
>   Used Dev Size : 5860530848 (2794.52 GiB 3000.59 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 205dfd9f:9be2b9ca:1f775974:fb1b742c
>=20
>     Update Time : Sat Sep 29 12:22:51 2012
>        Checksum : 9f164d8e - correct
>          Events : 38
>=20
>          Layout : left-symmetric
>      Chunk Size : 4K
>=20
>    Device Role : Active device 5
>    Array State : AAAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng)
>=20
> Now I also have md2 which is a striped RAID of both md0 and md1.
>=20
> When I type:
>=20
> sudo mdadm --create --assume-clean /dev/md1 --level=3D6 --chunk=3D4 --met=
adata=3D1.2 --raid-devices=3D19 /dev/sdaa /dev/sdab /dev/sdac /dev/sdad /de=
v/sdae /dev/sdaf /dev/sdag /dev/sdah /dev/sdai /dev/sdaj /dev/sdak /dev/sda=
l /dev/sdam /dev/sdan /dev/sdao /dev/sdap /dev/sdaq /dev/sdar /dev/sdas
>=20
> the following error for each device.
>=20
> mdadm: /dev/sdaa appears to be part of a raid array:
>     level=3D-unknown- devices=3D0 ctime=3DWed Aug 15 16:25:30 2012
> mdadm: partition table exists on /dev/sdaa but will be lost or
>        meaningless after creating array
>=20
> I want to make sure by running this above command that I won't affect any=
 of the data of md2 when I assemble that array after creating md1.  Any hel=
p on this issue would be greatly appreciated.  I would normally just DD cop=
ies but as you can see I would have to buy 19 more 3TB hard drives as well =
as the time to DD each drive.  It is a production server and that kind of d=
own time would really rather be avoided. =20

Running this command will only overwrite the 4K of metadata, 4K from the
start of the devices.  It will not write anything else to any device.

so yes, it is safe.

NeilBrown



>=20
> Thank you so much for your time.
>=20
> Mark Munoz
> 623.523.3201--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/Mc3q4J7.uHTOrFJL1+0biWz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGkH0jnsnt1WYoG5AQJfKw/9HdEZB9AdFScP94w7+3hZDeb91Bt8NJ0j
MCcpXrX1QwW583KMT9i6HmIMRO5sBymjzJYVC1JOOI5X7OuK0aPnGf99S1tlhHZJ
LTJW8gpZvLesbIg7DAEEXfS6OSyzHiaKSiPHhNRPaJwBu5cCVp2A1qNVNqyFWiyK
j+plDXhCMg2n/KKPlACcvmh+ZILJJZA4c0+c+NBG7Nutyru+8drjbEBOvZbLUdSI
NioXGihgPFjN4MetBO/GDV4ZyZapaQK3NxPzjwgOxg69xKZMCIs7naIB5hJqS2FU
Kn/9sw+7kANGmc5T4ibUSfHLV7etquBvmAdqIF9WVlH/g2f4YZdBO3y4+RVehfQa
NsbyTOlMXTK2nQpqchXZThmSCfxyatePLoBVgEBl61wevlpzcJSvcYWDpRexabtm
THLjIlSRMezRs5EasLkE++OHFq1Y3rWqKbd6X4RBZQg9fE1H2zEwyf7ZtGQ3ZEiD
8HFI4D65BNCxJ3hWsicY60i9u3U1vdcypMyf4pB99r5PDtfTNI2AFyKyLUN26hvd
SGfOzZc4ueMjYhP+EoKrt8yj7VobUy7QUD2Sq6c99xeHEmksbueBWDqn2gBRAJIk
zW3CHQqxRHxAOwwFk5CislomSsxXgYhYm9UprbasUgJPqq/1twN8CC8NlJ8pRDUw
43RxErxNYOk=
=vNof
-----END PGP SIGNATURE-----

--Sig_/Mc3q4J7.uHTOrFJL1+0biWz--
