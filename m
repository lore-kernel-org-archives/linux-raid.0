From: martin f krafft <madduck@madduck.net>
Subject: RAID10: near, far, offset -- which one?
Date: Thu, 5 Oct 2006 17:23:21 +0200
Message-ID: <20061005152321.GA32017@piper.madduck.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I am trying to compare the three RADI10 layouts with each other.
Assuming a simple 4 drive setup with 2 copies of each block,
I understand that a "near" layout makes RAID10 resemble RAID1+0
(although it's not 1+0).

I also understand that the "far" layout trades some read performance
for some write performance, so it's best for read-intensive
operations, like read-only file servers.

I don't really understand the "offset" layout. Am I right in
asserting that like "near" it keeps stripes together and thus
requires less seeking, but stores the blocks at different offsets
wrt the disks?

If A,B,C are data blocks, a,b their parts, and 1,2 denote their
copies, the following would be a classic RAID1+0 where 1,2 and 3,4
are RAID0 pairs combined into a RAID1:

  hdd1  Aa1 Ba1 Ca1
  hdd2  Ab1 Bb1 Cb1
  hdd3  Aa2 Ba2 Ca2
  hdd4  Ab2 Bb2 Cb2

How would this look with the three different layouts? I think "near"
is pretty much the same as above, but I can't figure out "far" and
"offset" from the md(4) manpage.

Also, what are their respective advantages and disadvantages?

Thanks,

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
spamtraps: madduck.bogus@madduck.net
=20
"a woman begins by resisting a man's advances and ends by blocking
 his retreat."
                                                        -- oscar wilde

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature (GPG/PGP)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFJSNpIgvIgzMMSnURAkqDAJ9XThRBPTKTUfxNHen4X9IV/OKyBQCePuhz
SnSUryEWf1Q1mt/Tycw53WQ=
=noOy
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
