From: Andy Smith <andy@lug.org.uk>
Subject: Re: Replacement disk is slightly smaller
Date: Wed, 9 Nov 2005 23:45:30 +0000
Message-ID: <20051109234530.GX7163@strugglers.net>
References: <20051109024211.GS7163@strugglers.net> <17265.42228.180657.810453@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2zA4LJh4oP98rPVr"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17265.42228.180657.810453@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--2zA4LJh4oP98rPVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 09, 2005 at 06:27:48PM +1100, Neil Brown wrote:
> You can create partitions in any way you like.  cfdisk is quite good
> at making this ... not trivial, but not hard.
> Create a tiny "1s" partition at the Beginning of the device.  This will be
> sdb1.  Create another tiny partition - sdb2
> Change the Units to 'sectors'.  Create another partition - sdb3 of the
> desired size at the End. - put an 's' at the end of the number to
> indicate sectors
>    218837432s
>=20
> Then delete sdb2 and create a new sdb2 using all the space.

Thanks Neil, this is pretty much exactly what I wanted.  I had some
difficulties:

- Fedora doesn't seem to have cfdisk in its yum repositories, nor in
  dag's respository, and rpmfind only found 1 RPM that had broken
  dependencies.  I had to download the source from Debian and
  compile that.  Come on Fedora!
=20
- The first time I left sdb1 as 1 sector long cfdisk complained
  about illegal overlapping logical partitions when I tried to load
  it again.  In the end I kept sdb1 and sdb3 the corect matching
  sizes and made sdb2 fill the middle.

Thanks for your help.  Everything is up and running redundantly
again now.

--2zA4LJh4oP98rPVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDcooaIJm2TL8VSQsRAmK0AJ0ZkMLeubDVtQ2p4Vb2IMh1torm/wCgoO88
e5Flxuu422+x62NaZjgy46M=
=QrLr
-----END PGP SIGNATURE-----

--2zA4LJh4oP98rPVr--
