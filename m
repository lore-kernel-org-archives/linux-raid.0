From: Andre Noll <maan@systemlinux.org>
Subject: Re: md devices disappearing on system reboot
Date: Mon, 7 Jul 2008 15:23:19 +0200
Message-ID: <20080707132319.GR23944@skl-net.de>
References: <8CAA9B1F81B8E21-614-D2D@webmail-nc09.sysops.aol.com> <20080702162108.GF4981@skl-net.de> <8CAAD37CC87F1BD-FD8-4A21@webmail-stg-d08.sysops.aol.com> <20080707093004.GQ23944@skl-net.de> <8CAAE4763AEB341-2F6C-570@webmailbeta-m07.sysops.aol.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j3zO+32zXj6UcJCE"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8CAAE4763AEB341-2F6C-570@webmailbeta-m07.sysops.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--j3zO+32zXj6UcJCE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08:52, thomas62186218@aol.com wrote:

> Thank you for the response. When running:  mdadm -A /dev/md0   I get:
>=20
> mdadm: no devices found for /dev/md0
>=20
> But fdisk -l  shows all the devices present on the system...

Try to specify all component devices manually:

	devices=3D/dev/sd[abcd]
	mdadm -A --run /dev/md0 $devices

You'll probably need to modify the content of the above devices
variable.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--j3zO+32zXj6UcJCE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIchjHWto1QDEAkw8RAogBAJ0byb2tpPD9AV1GO3Icp0nVo8XhpQCePrnm
oMZWPW+xQmC0kdJO/6B00Nw=
=NwMb
-----END PGP SIGNATURE-----

--j3zO+32zXj6UcJCE--
