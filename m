From: Forrest Taylor <ftaylor@redhat.com>
Subject: Re: Doubts about array size
Date: Tue, 17 Oct 2006 16:19:52 -0600
Message-ID: <1161123592.3931.3.camel@x1-6-00-0d-60-fd-e8-4c>
References: <200610172221.49080.pubmb02@skynet.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Vt//2FYa87H3TaFbbhaA"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200610172221.49080.pubmb02@skynet.be>
Sender: linux-raid-owner@vger.kernel.org
To: Bruno Costacurta <pubmb02@skynet.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-Vt//2FYa87H3TaFbbhaA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2006-10-17 at 22:21 +0200, Bruno Costacurta wrote:
> Hello,
>=20
> I built my first RAID with 2 disks.=20
>=20
> Array looks active (please see hereafter) but I'm confusing about size :=20
> having 2 disks of 160-Gb each I expect a size of 160-Gb (correct ?) but a=
rray=20
> size seems around 103-Gb.

Your array is not 103-Gb, but 103-Mb.

> Disk /dev/md0: 106 MB, 106823680 bytes
> 2 heads, 4 sectors/track, 26080 cylinders
> Units =3D cylinders of 8 * 512 =3D 4096 bytes
>=20
> 'mdadm --detail /dev/md0'  :
> -start-
> /dev/md0:
>         Version : 00.90.03
>   Creation Time : Tue Oct 17 21:26:43 2006
>      Raid Level : raid1
>      Array Size : 104320 (101.89 MiB 106.82 MB)
>     Device Size : 104320 (101.89 MiB 106.82 MB)

What did you do to create the device?  Did you change the disks
recently, or add new disks?

You could try to grow the RAID (mdadm -G /dev/md0 -z max), but I would
be wary of doing that until I knew why the disks showed the small size.

Forrest



--=-Vt//2FYa87H3TaFbbhaA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBFNVcIaUnzBifbsNQRAmNMAJ44dUiwxMWizD/GtrX4l1SIKwoX7ACgqv9g
L51I6Ej9gumLAKlTDMicO/A=
=3IjJ
-----END PGP SIGNATURE-----

--=-Vt//2FYa87H3TaFbbhaA--

