From: NeilBrown <neilb@suse.de>
Subject: [GIT PULL REQUEST] md updates  for 3.20
Date: Thu, 12 Feb 2015 14:20:43 +1100
Message-ID: <20150212142043.477d42a2@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/1aBwC6w._3iqcTy47s71DzW"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux RAID <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>, Hannes Reinecke <hare@suse.de>, Jes Sorensen <Jes.Sorensen@redhat.com>, Jan Beulich <jbeulich@suse.com>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-raid.ids

--Sig_/1aBwC6w._3iqcTy47s71DzW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 20 is a big number ... is it time for 4.0 yet :-)

 anyway, herewith is my pull request for 3.20.   It has been sitting in
 -next for a while, and Dan's scripts only found 2 bugs - now fixed.

Thanks,
NeilBrown


The following changes since commit d95901433436aeb921eac58bfd8a2aa77f110384:

  md/bitmap: fix a might_sleep() warning. (2015-02-02 17:08:03 +1100)

are available in the git repository at:

  git://neil.brown.name/md tags/md/3.20

for you to fetch changes up to 53a6ab4d3f6d6dc87ec8f14998b4b5536ee2968c:

  md/raid10: fix conversion from RAID0 to RAID10 (2015-02-12 14:09:57 +1100)

----------------------------------------------------------------
md updates for 3.20

 - assorted locking changes so that access to /proc/mdstat
   and much of /sys/block/mdXX/md/* is protected by a spinlock
   rather than a mutex and will never block indefinitely.

 - Make an 'if' condition in RAID5 - which has been implicated
   in recent bugs - more readable.

 - misc minor fixes

----------------------------------------------------------------
Hannes Reinecke (1):
      md: wakeup thread upon rdev_dec_pending()

Jan Beulich (1):
      x86/raid6: correctly check for assembler capabilities

Jes Sorensen (1):
      md: do_release_stripe(): No need to call md_wakeup_thread() twice

NeilBrown (25):
      md/raid5: separate large if clause out of fetch_block().
      md/raid5: separate out the easy conditions in need_this_block.
      md/raid5: need_this_block: start simplifying the last two conditions.
      md/raid5: need_this_block: tidy/fix last condition.
      md: rename mddev->write_lock to mddev->lock
      md: make ->congested robust against personality changes.
      md: make merge_bvec_fn more robust in face of personality changes.
      md/linear: remove rcu protections in favour of suspend/resume
      md: split detach operation out from ->stop.
      md: rename ->stop to ->free
      md: level_store: group all important changes into one place.
      md: protect ->pers changes with mddev->lock
      md/bitmap: protect clearing of ->bitmap by mddev->lock
      md: remove need for mddev_lock() in md_seq_show()
      md/raid5: use ->lock to protect accessing raid5 sysfs attributes.
      md: remove mddev_lock() from md_attr_show()
      md: remove mddev_lock from rdev_attr_show()
      md: remove unnecessary 'buf' from get_bitmap_file.
      md: tidy up set_bitmap_file
      md: move GET_BITMAP_FILE ioctl out from mddev_lock.
      md: minor cleanup in safe_delay_store.
      md: use mddev->lock to protect updates to resync_{min,max}.
      md: move mddev_lock and related to md.h
      md: make reconfig_mutex optional for writes to md sysfs files.
      md/raid10: fix conversion from RAID0 to RAID10

 arch/x86/Makefile       |   1 +
 drivers/md/bitmap.c     |  15 +-
 drivers/md/dm-raid.c    |   8 +-
 drivers/md/faulty.c     |   8 +-
 drivers/md/linear.c     |  67 ++--
 drivers/md/md.c         | 816 ++++++++++++++++++++++++++++++--------------=
----
 drivers/md/md.h         |  57 +++-
 drivers/md/multipath.c  |  22 +-
 drivers/md/raid0.c      |  29 +-
 drivers/md/raid1.c      |  52 +--
 drivers/md/raid1.h      |   3 -
 drivers/md/raid10.c     |  49 +--
 drivers/md/raid10.h     |   3 -
 drivers/md/raid5.c      | 334 ++++++++++++--------
 drivers/md/raid5.h      |   1 -
 lib/raid6/algos.c       |   2 +-
 lib/raid6/recov_avx2.c  |   2 +-
 lib/raid6/recov_ssse3.c |   6 +
 18 files changed, 867 insertions(+), 608 deletions(-)

--Sig_/1aBwC6w._3iqcTy47s71DzW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVNwcCznsnt1WYoG5AQLKTQ//disuMZN9orpyG8clCzf5cbFFd0VyTS2Z
N6PDAY7EY17amuYPCsZR2qfrull13lqAWMZ6XLs5BjexBE7GaLlj4AohDuEr9kc0
6dg1P2QAfMRIedsk13EYzcJZEPVM/iyYRcZXINfBg+TNd3OVmEK5wz09O7cSraRF
afPD5VM142mskn9yBOaRPlmBfvIPEsnj05XeiOWFvuz/lZR6zyCmh2WHhcwiTxDP
JeX0PL8zWUqAC8+d3rqMZ6Us0lZZW+xjOEJ4+11g6ovcu6MjswgpPwhJAD/Cy0+Q
nWhlm7ae4Dx4zPp1f+pHsqFAXzyEd+aKVPkUgPDQNcs2mlIgQlFnEaMuuL/vWX7Q
bInWEr8NBYQKCNGcBIzxVPYeT6nRNROPjQzY9aZhO9RzgybLwy21VkY76Xy29YCe
qZUk7YOMmzXEQAY6EPNTKN8o25+WCmXLHvK5MldCD53zKG9IaQ0KLbGtcxjh3ReA
+UsbJRn0ordG7ZKEnrATkuySGilovyn88Os1Nm11LkygztE7LX+ns3GEFxqdrdVq
n6OcJQ/tNd+SZQtDMDYLkJdd1TOG43+sbaSrHSRGU2F0cqxGgj7lgpat/zKA/anu
HMF2LVaQlsnxdNtpTL/tzV1L92oWKwXAz8lc+EVNr6Htd66xvkAVcfowfmYmp0dt
pXFH26UuPoI=
=+7TH
-----END PGP SIGNATURE-----

--Sig_/1aBwC6w._3iqcTy47s71DzW--
