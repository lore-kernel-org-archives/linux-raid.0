From: martin f krafft <madduck@madduck.net>
Subject: why partition arrays?
Date: Wed, 18 Oct 2006 14:42:25 +0200
Message-ID: <20061018124225.GA23653@piper.madduck.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

As the Debian mdadm maintainer, I am often subjected to questions
about partitionable arrays; people seem to want to use them in
favour of normal arrays. I don't understand why.

There's possibly an argument to be made about flexibility when it
comes to resizing partitions within the array, but even most MD
array types can be resized now.

There's possibly an argument about saving space because of fewer
sectors used/wasted with superblock information, but I am not going
to buy that.

Why would anyone want to create a partitionable array and put
partitions in it, rather than creating separate arrays for each
filesystem? Intuitively, this makes way more sense as then the
partitions are independent of each other; one array can fail and the
rest still works -- part of the reason why you partition in the
first place.

Would anyone help me answer this FAQ?

(btw: [0] and [1] are obviously for public consumption; they are
available under the terms of the artistic licence 2.0)

0. http://svn.debian.org/wsvn/pkg-mdadm/mdadm/trunk/debian/FAQ?op=3Dfile&re=
v=3D0&sc=3D0
1. http://svn.debian.org/wsvn/pkg-mdadm/mdadm/trunk/debian/README.recipes?o=
p=3Dfile&rev=3D0&sc=3D0

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
spamtraps: madduck.bogus@madduck.net
=20
"the liar at any rate recognises that recreation, not instruction, is
 the aim of conversation, and is a far more civilised being than the
 blockhead who loudly expresses his disbelief in a story which is told
 simply for the amusement of the company."
                                                        -- oscar wilde

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature (GPG/PGP)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD4DBQFFNiExIgvIgzMMSnURAqljAJwKda8zrCEr0IQxoE5tw/9kx78k+wCXe80J
hEh9u6swmY3Pwl6Or060wQ==
=1p45
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
