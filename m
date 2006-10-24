From: martin f krafft <madduck@madduck.net>
Subject: RAID5/10 chunk size and ext2/3 stride parameter
Date: Tue, 24 Oct 2006 18:03:06 +0200
Message-ID: <20061024160306.GA15393@lapse.madduck.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I cannot find authoritative information about the relation between
the RAID chunk size and the correct stride parameter to use when
creating an ext2/3 filesystem.

My understanding is that (block * stride) =3D=3D (chunk). So if I create
a default RAID5/10 with 64k chunks, and create a filesystem with 4k
blocks on it, I should choose stride 64k/4k =3D 16.

Is the chunk size of an array equal to the stripe size? Or is it
(n-1)*chunk size for RAID5 and (n/2)*chunk size for a plain near=3D2
RAID10?

Also, I understand that it makes no sense to use stride for RAID1 as
there are no stripes in that sense. But for RAID10 it makes sense,
right?

Thanks,

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
spamtraps: madduck.bogus@madduck.net
=20
"i like wagner's music better than anybody's. it is so loud that one
 can talk the whole time without other people hearing what one says."
                                                        -- oscar wilde

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature (GPG/PGP)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFPjk6IgvIgzMMSnURAgQMAKCRtsZ4PvYxtQiGtTlFjO/+jqpscACgruJn
1pCQM+rmC36NPLBBNyYi2Bc=
=lPn4
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
