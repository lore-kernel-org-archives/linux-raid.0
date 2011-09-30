From: Andre Noll <maan@systemlinux.org>
Subject: Re: Safely swapping a disk in a RAID456
Date: Fri, 30 Sep 2011 18:28:11 +0200
Message-ID: <20110930162811.GE30935@systemlinux.org>
References: <20110930154217.GA11732@albatross.gern.madduck.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IDYEmSnFhs3mNXr+"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110930154217.GA11732@albatross.gern.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--IDYEmSnFhs3mNXr+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 30, 17:42, martin f krafft wrote:
> Does anyone have any ideas?

Create a 2-disk Raid1 (with external metadata) containing the disk
you'd like to replace and the replacement disk.

And yes, it would be great if md provided an easier way to do this.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--IDYEmSnFhs3mNXr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk6F7hsACgkQWto1QDEAkw99ZgCZAQdgl3F4Zwial5jkFjMlJIue
RBEAnRIHH1bA3bG61C3SZTlLR9VBO/ir
=b1I3
-----END PGP SIGNATURE-----

--IDYEmSnFhs3mNXr+--
