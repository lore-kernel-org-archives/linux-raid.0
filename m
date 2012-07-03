From: NeilBrown <neilb@suse.de>
Subject: [PULL REQUEST] md fixes for 3.5-rc
Date: Tue, 3 Jul 2012 17:53:47 +1000
Message-ID: <20120703175347.4d11f8e0@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/IsUVnqj.gwyRDVpUDbh1hyE"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Shaohua Li <shli@fusionio.com>, Alexander Lyakas <alex.bolshoy@gmail.com>, majianpeng <majianpeng@gmail.com>, Christian Balzer <chibi@gol.com>
List-Id: linux-raid.ids

--Sig_/IsUVnqj.gwyRDVpUDbh1hyE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 please pull a pile of patches.

Thanks,
NeilBrown

The following changes since commit 6b16351acbd415e66ba16bf7d473ece1574cf0bc:

  Linux 3.5-rc4 (2012-06-24 12:53:04 -0700)

are available in the git repository at:

  git://neil.brown.name/md tags/md-3.5-fixes

for you to fetch changes up to b357f04a67c2aeee828b240863cd3f21d6cb3179:

  md: fix up plugging (again). (2012-07-03 17:45:31 +1000)

----------------------------------------------------------------
md: collection of bug fixes for 3.5

You go away for 2 weeks vacation and what do you get when you come back?
Piles of bugs :-)

Some found by inspection, some by testing, some during use in the field,
and some while developing for the next window...

----------------------------------------------------------------
NeilBrown (8):
      md/raid10: Don't try to recovery unmatched (and unused) chunks.
      md/raid5: prefer replacing failed devices over want-replacement devic=
es.
      md/raid5: fix refcount problem when blocked_rdev is set.
      md/raid10: fix failure when trying to repair a read error.
      md: make 'name' arg to md_register_thread non-optional.
      md/raid1: fix bug in read_balance introduced by hot-replace
      md: support re-add of recovering devices.
      md: fix up plugging (again).

Shaohua Li (1):
      raid5: delayed stripe fix

majianpeng (4):
      md/raid5: Do not add data_offset before call to is_badblock
      md/raid5: In ops_run_io, inc nr_pending before calling md_wait_for_bl=
ocked_rdev
      md:Add blk_plug in sync_thread.
      md/raid456: When read error cannot be recovered, record bad block

 drivers/md/md.c        |    8 +++---
 drivers/md/multipath.c |    3 ++-
 drivers/md/raid1.c     |   13 ++++------
 drivers/md/raid10.c    |   26 +++++++++++--------
 drivers/md/raid5.c     |   67 +++++++++++++++++++++++++++++++++-----------=
----
 5 files changed, 75 insertions(+), 42 deletions(-)

--Sig_/IsUVnqj.gwyRDVpUDbh1hyE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/KlCznsnt1WYoG5AQJozw//ZhFh5uFw6tmWoxzseGUtzSIt/E+aLWKg
jS78wWBkAGJ86HSdB9S2BVJTOnRs7Y7tUnQbok6Y53duPelxS9EpTc5MU3fwrx2o
wUpNHrdk6BHVaJHgiORCbW7H+GeP/FELQ8W4ULbalfBlxidTirqkbJcdrExleRQi
3iNl0LqS6llVaU1KTcriSzv/RmCKHcLr7v/je+evQ5fe70uYtDid65scj5L5UeWi
dHLyRRi2rrzctzmkDaD3FGBMGPyLWL8ywyTq23yqkTFn2yMcXXI7lKkWbfe0i75b
hGlYpWMo53HAjDnE7n/m/Y09RK/eJHDf5rvRV/ikJfaxNVOlHcMbgANG1DDzyKNk
/KZy3XG9Est8r/xLNmbZrdWCybCKPhEzZtgwq15s441r3e8IUpSEBG1X79nPyTOd
q3xxhivxvy01yTlfBrywhGQhomcz5Sya9iMUizErAIKTtftIow7brHR7AAG7K6Nc
MVpN948fi/lhLkf+YrmGijoorZ4qQrWJSMsA1hDJMHrrjIuz1tcTTcpiQpkQp57o
nE2H/ZPyO81bY7ltn4wZrm4yAJdmTTn15clckmWhcWIDx4isDkwMot0Ns2G/PweJ
xoe9G/UOFTuIkOJGqaf13526bQGUVXz1lnQT6O4tAGQgp0aRzSfBvzeLmv9HFJcR
ScVWQROh8rk=
=h/C2
-----END PGP SIGNATURE-----

--Sig_/IsUVnqj.gwyRDVpUDbh1hyE--
