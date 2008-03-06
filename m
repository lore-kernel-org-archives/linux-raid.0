From: Andre Noll <maan@systemlinux.org>
Subject: Re: 16 HDDs too much for RAID6?
Date: Thu, 6 Mar 2008 17:16:21 +0100
Message-ID: <20080306161621.GD32242@skl-net.de>
References: <20080306100128.8daad6bd.taeuber@bbaw.de> <20080306094559.GA29734@skl-net.de> <20080306115559.63ac361d.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BRE3mIcgqKzpedwo"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080306115559.63ac361d.taeuber@bbaw.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars =?iso-8859-1?Q?T=E4uber?= <taeuber@bbaw.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--BRE3mIcgqKzpedwo
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11:55, Lars T=E4uber wrote:
> monosan:~ # cat /etc/mdadm.conf=20
> DEVICE partitions
> ARRAY /dev/md2 level=3Draid1 UUID=3Dd9d31de2:e6dbd3c3:37c7ea09:882a64e5
> ARRAY /dev/md3 level=3Draid1 UUID=3Da8687183:a79e514c:ca492c4b:ffd4384f
> ARRAY /dev/md4 level=3Draid6 num-devices=3D16 UUID=3D8d596319:4d21dba3:38=
71bccf:5b90a66d

Does it help to list only the 16 devices that are used for the array,
i.e. something like

	DEVICE /dev/sd[a-p]
=09
> sdz and sdj are the same physical device with serial 5QJ02461 called /dev=
/dm-8:
> rename: mpath9 (SATA_ST31000340NS_5QJ02461) dm-8 ATA     ,ST31000340NS =
=20
> [size=3D932G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 6:0:24:0 sdz  65:144 [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 6:0:7:0  sdj  8:144  [active][ready]
>=20
> similar to sdy and sdi with serial 5QJ013GW called /dev/dm-9
> reload: mpath10 (SATA_ST31000340NS_5QJ013GW) dm-9 ATA     ,ST31000340NS =
=20
> [size=3D932G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 6:0:23:0 sdy  65:128 [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 6:0:6:0  sdi  8:128  [active][ready]

I think this is what is confusing mdadm. Your "DEVICE partitions"
line instructs mdadm to consider all devices in /proc/partitions,
so it finds both sdy and sdi.

> Is there a way to get more verbose infos or debug this anyhow?

There's the --detail and --verbose command line options to mdadm.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--BRE3mIcgqKzpedwo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH0BjVWto1QDEAkw8RAvljAJ0YjPtnnG2IdV6h5yPouSkhLA3quACeNppZ
VW7v3RYep76ScUg8MyY8rXI=
=UXTn
-----END PGP SIGNATURE-----

--BRE3mIcgqKzpedwo--
