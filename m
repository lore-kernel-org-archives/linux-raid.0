From: NeilBrown <neilb@suse.de>
Subject: [PULL REQUEST]  two bugfixes for md.
Date: Wed, 11 Jan 2012 09:27:35 +1100
Message-ID: <20120111092735.01fe9de2@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yfC=H=.qNeHO2V=l4O03tBI"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Art -kwaak- van Breemen <ard@telegraafnet.nl>, Mikhail Balabin <mbalabin@gmail.com>
List-Id: linux-raid.ids

--Sig_/yfC=H=.qNeHO2V=l4O03tBI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit 19d671695e1931ebfd75b2b888778201aefe35ca:

  md/raid1: Mark device want_replacement when we see a write error. (2011-1=
2-23 10:17:57 +1100)

are available in the git repository at:

  git://neil.brown.name/md md-3.3-fixes

for you to fetch changes up to 307729c8bc5b5a41361af8af95906eee7552acb1:

  md/raid1: perform bad-block tests for WriteMostly devices too. (2012-01-1=
1 08:35:17 +1100)

----------------------------------------------------------------
(from the branch description for md-scratch local branch)

for-linus
Two bugfixes for md.

One is a recently introduced regression that affects an unusual
configuration with a guaranteed BUG_ON.  Has been tagged for -stable.
The other is minor missing functionality.

----------------------------------------------------------------
NeilBrown (2):
      md: notify the 'degraded' sysfs attribute on failure.
      md/raid1: perform bad-block tests for WriteMostly devices too.

 drivers/md/md.c    |    6 ++++++
 drivers/md/raid1.c |   11 ++++++++++-
 2 files changed, 16 insertions(+), 1 deletions(-)

--Sig_/yfC=H=.qNeHO2V=l4O03tBI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwy7Vznsnt1WYoG5AQJXpBAAtLgSdfBm+iD4l9u8kVcgbPXJhGS1V171
/w0W811Glzt8eG0dQGe7RMEHlxYhFQsTvZPxXsX4H2qxMafxjHKThwflE5vobJd2
d3DjhtfV3f+WNCPezkuzK3ecx88Otw4GyPEuy6FSz+zS/rB65NiNHnqYibGX7+7+
T1Hm5a8/hrT8MyC/+2GWF+YZaVPOfW+cH4cNeAotiBe6m5lA5k95z/K0q4chYSZn
gKU+IV4mHZYVc9IQp4dq/8ezjbChMn4zWcUqIY1r4YeTPSYzbxOoe6Ai1xfGWuQe
AWq0ZJRmX2eVpO12YLLQS3oyJANUxPzRTr0r8m2jJqGXQKqAJBpsJu1ih1QPIIuA
NJRRPj1n7Nnouy+MFXbllVB+otfPXDxnSa/YlIMumYZ3eQvTzfFuonFoNKqc/ebc
gOJRlSaNyR1zHUirc7yrmiNRqorKeQzPnCVbwX3e0zW2NkC+Xan5mue/KV0yoZ5W
nIbTQ1xzqrAK6gdyAcY3qnXYHvJ6c0KT/pXtIpb8DOKHCiAUZg5DlV/7jdfUpS1w
lQlTs/fcN50q5lEZpBm/wDZNlFKEvIKJctS77GnrrAGAq/fCfLhC8zBilQIrNsAN
dP0bVu0Ao2WglPCgC2beGqwPEbn8UJjo8qda/D61UqbjPbKIuhAuebQI0qV17ViJ
GRrEWAcZk6Y=
=mngm
-----END PGP SIGNATURE-----

--Sig_/yfC=H=.qNeHO2V=l4O03tBI--
