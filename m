From: Andre Noll <maan@systemlinux.org>
Subject: Re: How to avoid complete rebuild of RAID 6 array (6/8 active devices)
Date: Wed, 25 Jun 2008 18:13:57 +0200
Message-ID: <20080625161357.GH23944@skl-net.de>
References: <41931C59-9A91-47A6-A81C-EC14001DA95B@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TBNym+cBXeFsS4Vs"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41931C59-9A91-47A6-A81C-EC14001DA95B@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Moon <p.b.w.tortilla@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--TBNym+cBXeFsS4Vs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15:37, Dave Moon wrote:

> 1. If mdadm encounters a bit error during a RAID 6 rebuild, will it =20
> just give up on that particular file and move on to recover other data =
=20
> on the array? Or will it trash the entire array?

The kernel will stop the array and give up.

> 2. Is it possible to cheat mdadm by somehow replacing the new "raid =20
> metadata" on the 6 drives with the old data on the 2 drives? Will it =20
> make mdadm think the array is clean, consistent and nothing ever =20
> happened?

> Please do note that I did not write ANY new data onto the RAID 6 array =
=20
> from the time it was degraded until the time I brought it down with (--=
=20
> stop).

Use --force, Luke. Man mdadm(8):

	-f, --force Assemble the array even if some superblocks
	appear out-of-date

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--TBNym+cBXeFsS4Vs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIYm7FWto1QDEAkw8RAkYhAJ4u2T//+4g89QZmEUHxh89IWBpCjgCfZenT
tjn+nggzup9QbY1Xu+aV8JA=
=WPRj
-----END PGP SIGNATURE-----

--TBNym+cBXeFsS4Vs--
