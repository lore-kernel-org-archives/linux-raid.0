From: NeilBrown <neilb@suse.de>
Subject: PULL REQUEST - md bugfixes for 3.2-rc
Date: Wed, 9 Nov 2011 11:44:05 +1100
Message-ID: <20111109114405.3be330b0@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lQNOjratqd+_s=5TDC2ZU+D"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/lQNOjratqd+_s=5TDC2ZU+D
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,
 a couple of new bugfixes for md.

Thanks,
NeilBrown


The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:

  Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)

are available in the git repository at:
  git://neil.brown.name/md for-linus

  last commit being e15ce4ccc5cab3c590d2443a50b6de01e9b38b32

Dan Williams (1):
      md/raid5: STRIPE_ACTIVE has lock semantics, add barriers

NeilBrown (1):
      md/raid5: abort any pending parity operations when array fails.

 drivers/md/raid5.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

--Sig_/lQNOjratqd+_s=5TDC2ZU+D
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrnM2znsnt1WYoG5AQLYEw/+K04kjxaubXBHZFDwbYF1qz8LIk19oOtI
zB3oK7FwQ12JcvknjL1iymPv++MEgKc9arLUu491GFKOgwCedZ/d/GDELGFJsMT6
L9hWzr99YdElJNBWeuq8VzP+ZNNbksDkF6SDYt/PlDeUrmtTaG0n63NIrfhurzQs
f5Hx9GMY386Uqy/yanaurzHqVj0qdlTaIeGSRflWfqIhUAykwsDxWPZZCWmH6RjE
AE1BEAfay15IQYSlT5VUVJcdR3VLNdK1GCXh0cLJFjPoR0M5GTsw48IY+1F8DOST
rldHLYdAtEc3aisPYnLrEsLFp8F2/eRxUkSH9iRh3IEfkO26SG2vLOoUG0vdcLc/
kA7njL9TVcbWweBFM0cEMa1vE/6kbmwicd3TcxAmzab1H7anyX9q4AKHrYXRPBv9
vOb3Aqrayu9XeaKzh3gntY1rP2OboLUIpRDVx6s5DTUiVyDzyCuMvPrPXv/RwPJ+
tY9zdVH2J27vpUvsG4FJE2BF6zrN34fSBQ7RnkMN1+kDgT04RXZ/VOvACSGYer+T
9W2QnWJotVwZpaWZ0P2H3X4EAFejcG70yfClVGcw0VUanoQCBT3BFGiAo2TxGMCL
Se8hPYhAA1rvfj8SJRkEFeaLaNdCsHOtI5UhB0cOGsKMuizxz/DZtlqHWf0LSk2O
G4nVpG7hQtw=
=H5CU
-----END PGP SIGNATURE-----

--Sig_/lQNOjratqd+_s=5TDC2ZU+D--
