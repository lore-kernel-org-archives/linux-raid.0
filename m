From: NeilBrown <neilb@suse.de>
Subject: [PULL REQUEST] md update for 3.6
Date: Wed, 1 Aug 2012 20:47:44 +1000
Message-ID: <20120801204744.61884ce9@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Sl03xx5kUKf_oXP_wq4DBoh"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Jonathan Brassow <jbrassow@redhat.com>, Alexander Lyakas <alex.bolshoy@gmail.com>, Shaohua Li <shli@kernel.org>, majianpeng <majianpeng@gmail.com>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-raid.ids

--Sig_/Sl03xx5kUKf_oXP_wq4DBoh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 please pull as follows.  Sorry it is late - I was hoping to sync up with J=
ens
as I have some patches which depend on some in his tree, but that doesn't
seem to have worked.
I'll probably send you another pull request once his tree has been included,
but I'll not be surprised if it has to wait for 3.7.

Thanks,
NeilBrown


The following changes since commit c039c332f23e794deb6d6f37b9f07ff3b27fb2cf:

  dm raid: move sectors_per_dev calculation (2012-07-27 15:08:04 +0100)

are available in the git repository at:

  git://neil.brown.name/md/ for-next

for you to fetch changes up to 63f33b8dda88923487004b20fba825486d009e7b:

  DM RAID: Add support for MD RAID10 (2012-08-01 20:41:20 +1000)

----------------------------------------------------------------
Alexander Lyakas (1):
      md/RAID1: Add missing case for attempting to repair known bad blocks.

Jonathan Brassow (6):
      MD RAID10: Fix compiler warning.
      MD RAID10: rename mirror_info structure
      MD RAID1: rename mirror_info structure
      MD: Move macros from raid1*.h to raid1*.c
      MD RAID10: Export md_raid10_congested
      DM RAID: Add support for MD RAID10

NeilBrown (3):
      md: remove duplicated test on ->openers when calling do_md_stop()
      md/raid1: don't abort a resync on the first badblock.
      Merge commit 'c039c332f23e794deb6d6f37b9f07ff3b27fb2cf' into md

Shaohua Li (7):
      raid5: reduce chance release_stripe() taking device_lock
      raid5: lockless access raid5 overrided bi_phys_segments
      raid5: remove unnecessary bitmap write optimization
      raid5: add a per-stripe lock
      md/raid1: make sequential read detection per disk based
      md/raid1: read balance chooses idlest disk for SSD
      md/raid1: prevent merging too large request

majianpeng (2):
      raid5: Add R5_ReadNoMerge flag which prevent bio from merging at bloc=
k layer
      md/raid5: For odirect-write performance, do not set STRIPE_PREREAD_AC=
TIVE.

 Documentation/device-mapper/dm-raid.txt |   26 ++++
 drivers/md/dm-raid.c                    |   95 +++++++++++++-
 drivers/md/md.c                         |    8 +-
 drivers/md/raid1.c                      |  164 ++++++++++++++++++-------
 drivers/md/raid1.h                      |   30 ++---
 drivers/md/raid10.c                     |   92 +++++++++-----
 drivers/md/raid10.h                     |   23 +---
 drivers/md/raid5.c                      |  205 +++++++++++++++++----------=
----
 drivers/md/raid5.h                      |    2 +
 9 files changed, 426 insertions(+), 219 deletions(-)

--Sig_/Sl03xx5kUKf_oXP_wq4DBoh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUBkJUDnsnt1WYoG5AQLgZRAAj1Jvh8NhS2I/1QEkJn5x12QnbtbrS9EO
JaHYqIRSUgkOuQBSBDFJHbn1FwHaXb8JVfFsovhMNeYVn7t1Ca5yJtyKSj24I7FK
0wuTfCjjpUcKuqF0VWXLc3EmBLl5C88m/DFlCe/KZxNjf5yHNMS8kggn9r+MY0b4
lfuf4WfV4S+eMPevkN8k+fqMddNmdqsRvPP97P9F+7GCg4YART1QkBnqIXCBH+LX
CZ8eX42aiIFClv3U9qNQObI4XuWcw+MgHTrDIe6lRhEDx6J37OFCc1IOhqJrxphG
PsKvIO7ksyTmJKSs92YNXrZMZkz9oqWhplvRmJHuInwfd9kesQNMHlm8WWqwrFHN
i7kWHLivZt1/IsIpKPsXBQtCNbbyM447Tv8pAPMtxx8VCqcjbmmgErl+fMIm8sJN
J7xY42Xq2JB1eMAyMoA8NpAsCYFvD/NS9IqeEf7oO+7mX/QCAHjkl6u0dvi/SqFo
iyy6jafAYefYuAqSnoyy/PwafEqInBTH+g89gQnzQG6HgCT0SEH4Q3A/0H5Gh9eG
S/5Wg9PtgTRr7nG5JwbogdsKX0rT/+t3VimQ96N30RzuDYBS+Hn4XwEqWPas6/kQ
KWH2S4jkQfbPj/ulYMO9pmx4cPIZhzp83ochUd3/q8wrNqPfi/CSDb0rQTZ8WhL3
r1eYvm7Pzkw=
=/EFu
-----END PGP SIGNATURE-----

--Sig_/Sl03xx5kUKf_oXP_wq4DBoh--
