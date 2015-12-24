From: NeilBrown <neilb@suse.com>
Subject: [GIT PULL REQUEST] one more md fix for 4.4-rc
Date: Thu, 24 Dec 2015 14:16:56 +1100
Message-ID: <87mvt0zgbb.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Xiao Ni <xni@redhat.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain


The following changes since commit 9f7e43278605a0daf4edf7025c52c25e9ace6875:

  Merge tag 'rtc-4.4-3' of git://git.kernel.org/pub/scm/linux/kernel/git/abelloni/linux (2015-12-20 10:01:11 -0800)

are available in the git repository at:

  git://neil.brown.name/md tags/md/4.4-rc6-fix

for you to fetch changes up to 312045eef985b61d74c28047ecd8eca6719d9516:

  md: remove check for MD_RECOVERY_NEEDED in action_store. (2015-12-21 11:10:06 +1100)

----------------------------------------------------------------
One for md fix for 4.4-rc

Fix a regression which causes reshape to not start properly
sometimes.

----------------------------------------------------------------
NeilBrown (1):
      md: remove check for MD_RECOVERY_NEEDED in action_store.

 drivers/md/md.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWe2OoAAoJEDnsnt1WYoG5I5IQAKgR54NhNw8nOp6+EAXwa5X8
ldF0rpB5v9OEQ6cxV4Vr7gPx45HNuUj1mAvR5qkIfGZDokYdFBykaqqkkkrN9oHt
IcP3KNc/9cdiqzdjIZXHYNr+lY6hR9QPn8lZFQSCKT30Gbpc6mrkK6CesKZe6gPd
Bw2yqqj/gDdwt9KisS9vecPuVlhJTF0VbZL/aOpZVMq1+dI56WGah7IjS7n64vGe
+Pm3PPzgE1qCs8u8djjcrXcyGyhGVkiPC1YPUuD/woSs/VYFRIOZEmr2VN3771xM
enf/GaC329MgNRNBS78MdMxWVzlJ4X9KI3VjoB2Jwo9C0rnx8fnmluU7NiXtv2UM
SdhQPdcUnVhR87Og1bC9rXQtuAyimgotcp3BBcqv9+6kclIMG9ga5yfbwAbpuoov
/qrvhA43g0zO7ZbFCVt0vri1pRh0DPv0081BtyF46Qv8fg0/JnhXPB5rBqonm1Z+
sclftAhAMXpWJ6kw6SSY9CieRbYO1mRfhYxjAxvQnsHJtOtKItl15NBcyZmCytFh
laWfLtNNAHOUe2oZu/W/OKTzxZQ3uBljtF2RIYP6E7JSUEd2t8O3AHKnv1UELFBc
hCJJagumIicv3kBQAQpGQcqWtJkRZxmYxNbFpSDy9iaL+5t6XRotzOhIaILLK5WL
L2u+fucH98WWem8WjZFc
=YcTQ
-----END PGP SIGNATURE-----
--=-=-=--
