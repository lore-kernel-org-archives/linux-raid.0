From: Andre Noll <maan@systemlinux.org>
Subject: Re: 16 HDDs too much for RAID6?
Date: Thu, 6 Mar 2008 10:45:59 +0100
Message-ID: <20080306094559.GA29734@skl-net.de>
References: <20080306100128.8daad6bd.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080306100128.8daad6bd.taeuber@bbaw.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars =?iso-8859-1?Q?T=E4uber?= <taeuber@bbaw.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10:01, Lars T=E4uber wrote:
> Here we have another problem with our RAID6 and 16 HDDs:
>=20
> monosan:~ # mdadm -V
> mdadm - v2.6.2 - 21st May 2007
> monosan:~ # mdadm -C /dev/md4 -l6 -n 16 -x 0 /dev/dm-*
> mdadm: /dev/dm-0 appears to be part of a raid array:

Run
	mdadm --zero-superblock /dev/dm-0

before creating the array to get rid of these.

> monosan:~ # mdadm --detail --scan| fgrep md4 >> /etc/mdadm.conf=20

Please post your /etc/mdadm.conf

> monosan:~ # mdadm -A /dev/md4
> mdadm: WARNING /dev/dm-9 and /dev/dm-8 appear to have very similar superb=
locks.
>       If they are really different, please --zero the superblock on one
>       If they are the same or overlap, please remove one from the
>       DEVICE list in mdadm.conf.

Are you sure dm-8 and dm-9 are different devices?

	pvdisplay /dev/dm-9; pvdisplay /dev/dm-8

should tell you.

> This happens _always_ when the arreay is reassembled. The actual
> devices with the duplicated superblocks differ sometimes.

If I read the code correctly it means that the two devices have
identical superblocks, the same event count and the same minor number,
so mdadm thinks dm-8 and dm-9 are overlapping partitions.

> Are 16 drivesmda too much for RAID6?

No, raid6 supports up to 254 devices (there are other reasons for
not using too many devices for raid6 though).

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHz71XWto1QDEAkw8RAh39AJwKErj+JjcSsFS6UeWK8PhSCj0KzgCdG4y7
+rF82AKSXfEQ0bxzvvH6jxQ=
=wRZv
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
