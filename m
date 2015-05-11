From: NeilBrown <neilb@suse.de>
Subject: [GIT PULL REQUEST]
Date: Mon, 11 May 2015 13:27:04 +1000
Message-ID: <20150511132704.5bc50fa3@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/wca_sUaRaN5Q5sK8UwYDmHa"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Heinz Mauelshagen <heinzm@redhat.com>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

--Sig_/wca_sUaRaN5Q5sK8UwYDmHa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


hi Linus
 Please pull this collection of bugfixes.

Thanks,
NeilBrown


The following changes since commit 5ebe6afaf0057ac3eaeb98defd5456894b446d22:

  Linux 4.1-rc2 (2015-05-03 19:22:23 -0700)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md/4.1-rc3-fixes

for you to fetch changes up to bb27051f9fd7643f05d8f0babce3337f0b9b3087:

  md/raid5: fix handling of degraded stripes in batches. (2015-05-08 18:47:=
57 +1000)

----------------------------------------------------------------
A few fixes for md.

Most of these are related to the new "batched stripe writeout",
but there are a few others.

----------------------------------------------------------------
Heinz Mauelshagen (1):
      md-raid0: conditional mddev->queue access to suit dm-raid

NeilBrown (6):
      md/raid5: new alloc_stripe() to allocate an initialize a stripe.
      md/raid5: more incorrect BUG_ON in handle_stripe_fill.
      md/raid5: avoid reading parity blocks for full-stripe write to degrad=
ed array
      md/raid5: don't record new size if resize_stripes fails.
      md/raid5: fix allocation of 'scribble' array.
      md/raid5: fix handling of degraded stripes in batches.

 drivers/md/raid0.c |   5 ++-
 drivers/md/raid5.c | 123 ++++++++++++++++++++++++++++++-------------------=
----
 2 files changed, 73 insertions(+), 55 deletions(-)

--Sig_/wca_sUaRaN5Q5sK8UwYDmHa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVVAhiTnsnt1WYoG5AQIpmw/+KPMamQ+kVEFjCuQyhvlKEcDZBS/prc9/
bfBVPrGLvDGfElXEq3CKt3QKOcJwyo4K+YTxUXv6RqiZH+rNLAd9Aih8nnTw0aGx
xjiULRFIPMKax1vSMGa49Pw5iDOxONsN62uCsTVgWGeYApZ7nzmgGwq6sGlcjWlw
DtYHQJzKxEy1eYDCqCN1xbd9/82RWa+hPxckZ/sI28EQmkDM3vurot1GlXaR5oit
Dlhr7OSe7Cw8p81xKu6iwDUBa/KHK7PEEGQo2QFNV98se3HbHSCypzDYkgW07uML
bJcOR/14MXMGeJeQ1u6yBxsOqoN8pNFiTbwtYeiK4t6lF7pPcwlb6hW1ipH52v6b
WezjTuUXmSy5CWhp8ldqbxtzIh3eYiJrCx9JcwAAUcefMDPvU1IZqe2uIN3RwgeQ
Ud+Mcb3+ezPWFBnXD4yDsZoQWBSsUk8OiX4mO5lNEOQDuoUPoihE+3XHtUzgsuXG
KWtnk/2MCecQ//GruWfY8ds2zAWji01yh/aENBiDeRBBp5m0Idw0xwMe5z7Xqbeb
aOOZEiA/TNmsoM4zvhYzueA+xjt3BR3ABeuqAPPbPNVRQm5yg4AbNs3YUPWmh49q
5hbtH865A9HAgQ3PXyyERHyHWMOOc7fm9cWed92+v4BeMwFyNYkq1zotT/g3R3AQ
A4JpohtirKE=
=Z9gB
-----END PGP SIGNATURE-----

--Sig_/wca_sUaRaN5Q5sK8UwYDmHa--
