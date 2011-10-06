From: NeilBrown <neilb@suse.de>
Subject: [PULLREQUEST] md bugfix for 3.1
Date: Thu, 6 Oct 2011 16:18:19 +1100
Message-ID: <20111006161819.543e98ce@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.bsfETT7NGpbVNsVHx.B5fG"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/.bsfETT7NGpbVNsVHx.B5fG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 please pull this one patch which fixes a race in md thread wakeup at the
 same time as shutdown.  This is also a case where it isn't a race but a
 definite "will try to wake up a non-existent thread" when trying to start
 RAID10 that doesn't have enough working disks.

 This is tagged for -stable.

Thanks,
NeilBrown


The following changes since commit 976d167615b64e14bc1491ca51d424e2ba9a5e84:

  Linux 3.1-rc9 (2011-10-04 18:11:50 -0700)

are available in the git repository at:
  git://neil.brown.name/md/ for-linus

  last commit being 01f96c0a9922cd9919baf9d16febdf7016177a12

NeilBrown (1):
      md: Avoid waking up a thread after it has been freed.

 drivers/md/md.c        |   22 +++++++++++++++++++---
 drivers/md/md.h        |    2 +-
 drivers/md/multipath.c |    3 +--
 drivers/md/raid1.c     |    3 +--
 drivers/md/raid10.c    |    5 ++---
 drivers/md/raid5.c     |    6 ++----
 6 files changed, 26 insertions(+), 15 deletions(-)

--Sig_/.bsfETT7NGpbVNsVHx.B5fG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTo06Gznsnt1WYoG5AQKvbxAAvzpO46HTx8XtQaKXdioMcI4GFaEzDsfy
+h9GHKKQX6B39Fmf1FTK5daxmnAz18rAsCYoqV9xmxeGdhj+OWrhze53NvzdVXV4
nVVZnCKm814fpM3OmFe67VXf1C4c/g036TVtnlNroeKhjJzXxl/ge/j1cqY/4IGX
ylGuvZsaEEMefyFUuQiSjWjhXS2YL4QWlXIhbyHQV87RZv2+izMv2oGWZPPUmAp4
JociarHvgJ5PjrGBmoYun9qaP2DweFFz4bCI2VRFISWPxv/Ty96lmqaLim+wa8Rg
V+DCo0uT/lMONbFX8121Z7kakzR4QVsKgZM8a/SBCjDjN/3qEx7UqJJ0+eFbCRYu
hyLm5B0XvbwKkiSb8ARGwY+dJXYQzehlqTjT73PHgfE7eCtuYUPRh169sFmzWYpV
H4OHi5nrA/bARo1YccpmjKe5XoinFcqocuneS4XEdZD1EVUua8Avl8rZu0jvNAKp
Li/h8D8lRh3gEy9s5scPEf7raddalTh6Br1WcLJY5w8pMcOtL1P9dOr0369qGzSf
f3c+itXvEC3CQgu+J1QpvEP8OK+ncJLaRWIvAV+/tTgKjIE8HwafObKu38Uzfiek
FtKqC0PZS3PY/T44p51gSFtu8zzROPwZHoaxgrRwn0jwY5ndA6ZMfuKmkM8SWl5C
mOUaGkoPS5s=
=uf2X
-----END PGP SIGNATURE-----

--Sig_/.bsfETT7NGpbVNsVHx.B5fG--
