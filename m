From: NeilBrown <neilb@suse.de>
Subject: [GIT PULL REQUEST] md fixes for 4.1-rc
Date: Fri, 22 May 2015 15:27:16 +1000
Message-ID: <20150522152716.4fa77795@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/oRZsnycUglX1KQFSuisfhGh"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux RAID <linux-raid@vger.kernel.org>, Patrick Marlier <patrick.marlier@gmail.com>, Eric Work <work.eric@gmail.com>, Shaohua Li <shli@kernel.org>, Maxime Ripard <maxime.ripard@free-electrons.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Holger Kiehl <Holger.Kiehl@dwd.de>
List-Id: linux-raid.ids

--Sig_/oRZsnycUglX1KQFSuisfhGh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 please pull following bugfixes.
 I have a few more raid5 bugfixes pending, but I want to get a bit more
 review first.

Thanks,
NeilBrown


The following changes since commit bb27051f9fd7643f05d8f0babce3337f0b9b3087:

  md/raid5: fix handling of degraded stripes in batches. (2015-05-08 18:47:=
57 +1000)

are available in the git repository at:

  git://neil.brown.name/md tags/md/4.1-rc4-fixes

for you to fetch changes up to 8532e3439087de69bb1b71fd6be2baa6fc196a55:

  md/bitmap: remove rcu annotation from pointer arithmetic. (2015-05-21 09:=
14:41 +1000)

----------------------------------------------------------------
md fixes for 4.1-rc4

- one serious RAID0 data corruption - caused by recent bugfix that wasn't
  reviewed properly.
- one raid5 fix in new code (a couple more of those to come).
- one little fix to stop static analysis complaining about silly rcu
  annotation.

----------------------------------------------------------------
Eric Work (1):
      md/raid0: fix restore to sector variable in raid0_make_request

NeilBrown (1):
      md/bitmap: remove rcu annotation from pointer arithmetic.

Shaohua Li (1):
      raid5: fix broken async operation chain

 drivers/md/bitmap.c | 7 ++++++-
 drivers/md/raid0.c  | 4 +++-
 drivers/md/raid5.c  | 2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)

--Sig_/oRZsnycUglX1KQFSuisfhGh
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVV6+NTnsnt1WYoG5AQILFBAAiOQeeHknpXnZaRmYvtSw+jU1OQLpnPhl
MtSC3873GEHFOo4OS+q4+67bmxE0vBRWTDNGehS0+pZDNvKNlVhG4XjtowkTCKum
VEaHxTNzaO+nOiPhSzdJVvYH6mxjrgBSEefLA0CHSVSH7AbSGCClOR1vB4d3SuYp
ZS91SRqYLXVsBKsFaR7KmOsfieX+HCXiMpGEW/iv+vmuyeiMLWUQbxs9YNuI1EyY
XygAND3fPyd9JpXb5Won0a/NjxqNExtXf6oLA3qCrfirFwBisiPDrfj7Su0vMEUU
5RQo4C/6bAbIqtik0/7bxLh7rbNQpClqzQy+bDQ82j00ZBsTk6/qKta7Xdvkw1TN
QEfrBegbDNNor/8DByYDDNsyXKQDSmsvooVqLn/yqz0YdzOmkS7vodsOOAxVuPH4
zK/dLlGBDnwY+DXrc/1MEpYGEkkx8Wq4gOAl7wC1X2X2ZII4nZDK/1/yo26a61Q6
LcCmIL/wa0G0DaqKFd8MXEuOMGc2PwWcijcgPQmC5wHJHotrtV0RUo+i/XXb+sdx
JcYD2G2csbmziobNmJOaJOsVbKjUKMeijO2mtTRWhlFoAC57EFpCU7XFM3qei8vm
qCCV8v4KCw19+DUVdLXfLLxvmTsK/ZnxHrzV1mKRwOJtw+iH7pMSKEjPAOsQ/nnn
K1pRv/vT+wM=
=MVgf
-----END PGP SIGNATURE-----

--Sig_/oRZsnycUglX1KQFSuisfhGh--
