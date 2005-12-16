From: Hendrik Naumann <hn75@gmx.de>
Subject: recorvery from Raid5 multiple disk failture
Date: Fri, 16 Dec 2005 13:45:32 +0100
Message-ID: <200512161345.33159.hn75@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1498640.PL0efqytk7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--nextPart1498640.PL0efqytk7
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

I have a Linux-Software-Raid5 consisting of three partitions (hda2,
hde2 and hdf2). After a failure of hdf I replaced the disk and added
hdf2 into the raid again. During the resynchronization process hda
broke down.=20

I am not completely shure how much of the synchronization
was already done, but I think it was quite at the end, because the=20
gzipped dd-image of hdf2 and hde2 have very similar sizes.=20

mdadm shows hde2 as a active, clean disk within the raid and hdf2 as a
clean spare disk. In the Software-Raid-Howto it was stated that
rewriting the superblocks (I suspect hdf2 to clean active) could be a
possibility to regain some data from the Raid.=20

How is this possible with mdadm? Or is there some other tool for
manipulation the superblocks?

Many thanks in advance

Hendrik Naummann=20

PS. Please add a CC hn75@gmx.de because up to now I am no subscriber=20
to this list.
=2D-=20
PGP ID 65C92061

--nextPart1498640.PL0efqytk7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBDorbsIfCsAmXJIGERAu1nAJ9YhBQUtW2ygFu+JKpGR3jehOIVLQCfdwiU
ZQ21AryKxfd3DY1Qlqfd56k=
=tIMj
-----END PGP SIGNATURE-----

--nextPart1498640.PL0efqytk7--
