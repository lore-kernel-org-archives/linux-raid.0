From: NeilBrown <neilb@suse.de>
Subject: [PULL REQUEST] md fixes for 3.9
Date: Sat, 23 Mar 2013 07:46:54 +1100
Message-ID: <20130323074654.0504a06a@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DuhNWbmt226p5N6Ys_Eh420"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Paul Bolle <pebolle@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>, linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/DuhNWbmt226p5N6Ys_Eh420
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit f3378b48705154b9089affb2d2e939622aea68f1:

  md: expedite metadata update when switching  read-auto -> active (2013-02=
-28 11:59:03 +1100)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md-3.9-fixes

for you to fetch changes up to 238f5908bd48f9e2f4668e0289e88cba969d710c:

  md: remove CONFIG_MULTICORE_RAID456 entirely (2013-03-20 13:21:14 +1100)

----------------------------------------------------------------
A few bugfixes for md

 - recent regressions in raid5
 - recent regressions in dmraid
 - a few instances of CONFIG_MULTICORE_RAID456 linger

Several tagged for -stable

----------------------------------------------------------------
Jonathan Brassow (2):
      MD RAID5: Avoid accessing gendisk or queue structs when not available
      MD: Prevent sysfs operations on uninitialized kobjects

NeilBrown (2):
      md/raid5: schedule_construction should abort if nothing to do.
      md/raid5: ensure sync and DISCARD don't happen at the same time.

Paul Bolle (1):
      md: remove CONFIG_MULTICORE_RAID456 entirely

 arch/tile/configs/tilegx_defconfig  |   1 -
 arch/tile/configs/tilepro_defconfig |   1 -
 drivers/md/md.c                     |   6 +-
 drivers/md/md.h                     |   4 +-
 drivers/md/raid5.c                  | 116 +++++++++++++++++++++++++-------=
----
 drivers/md/raid5.h                  |   5 +-
 6 files changed, 86 insertions(+), 47 deletions(-)

--Sig_/DuhNWbmt226p5N6Ys_Eh420
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUUzDPjnsnt1WYoG5AQLbTA/+O5QnTcFyPCuoV+TCFmhcLDXuRH/gN+Kk
kwLbtvsd9d6B5XhQJUzjJuMbkWhWwxfxBNsl0JIKJmzlOXwj0LeohfGKclinL1Mo
40vhmpeIzri8WwZA09P2xZx7BTLVdNrPuTKKmoKATQSzDcsNKyoztanQbsYPr7eP
HtLzO6qyklN2AWbMLWdatOWJc9X5SdRs5MLQSwDsT7K35wNWP/GzlQAdfy4LtIvg
IGCdoiq/+LfzL2UdM6h/mstbv97zRH9Rs3+IccTaeqINPAkv8h6zzm5dEEshsF3p
jcYEFJWr9ko6uaKhPAOzLl/NT1yuXzkHYvEAykXOCX97Gt5ydL/0mSUxtNJce5N9
CRoSjSx8/aS+PZ6NwPbBAx8jdMgqBXdJrHXe+0mzY5JRhZDL9jEA70Xw5NA9+J4h
06IUV6x0JrBxoOUPmbdYoR7Xb/ThALjSBchx0NsEUaLUVh8e3/XqLAjOoc2X/7+w
CZInC83UAHN/Z3eXSsuf4IfO6eBInqEJgSzJtWwQZhpu7YG/nTzUyIDKi9OhXdTv
3tH/qAA+ja7Na2sICfDvhSCiW6SF82v3N6nMvvqWSltuTgCdOgUqwaZNOZWnpeBA
r/4KLmtx7ok7LZom6Lbd8HSgmIsLzx5T0njvPjWhQliLt31/c00PxLTeCtfbREjV
Gg+nnrfsoLw=
=ZJbZ
-----END PGP SIGNATURE-----

--Sig_/DuhNWbmt226p5N6Ys_Eh420--
