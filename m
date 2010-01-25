From: Andre Noll <maan@systemlinux.org>
Subject: Re: Zeroing multiple superblocks
Date: Mon, 25 Jan 2010 10:52:21 +0100
Message-ID: <20100125095221.GV21495@skl-net.de>
References: <20100122200924.GA29183@psychosis.jim.sh>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fH+ug0VWbLbTAXDy"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100122200924.GA29183@psychosis.jim.sh>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Paris <jim@jtan.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--fH+ug0VWbLbTAXDy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15:09, Jim Paris wrote:

> I guess the only way to be fully safe with the current approach is to
> do a zero-superblock over and over until it complains.

mdadm --zero-superblock tries to guess the location of the superblock.
If more than one superblock is found, the one with the latest creation
time is being zeroed. So yes, the method you describe works and I think
it is the most reliable way to remove all superblocks of a device.

Maybe we could teach mdadm --zero-superblock to honor the --metadata=3Dx
option which would zero-out the region of the device where the
version-x superblock is located.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--fH+ug0VWbLbTAXDy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLXWnVWto1QDEAkw8RArwiAJ0W+OgaUjJQa0K6ykaeyQ26G++JZACgqXXF
6kfq6qBVJXLXLZXdxT5h888=
=GBcA
-----END PGP SIGNATURE-----

--fH+ug0VWbLbTAXDy--
