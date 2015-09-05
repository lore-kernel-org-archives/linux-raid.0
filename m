From: Neil Brown <neil@brown.name>
Subject: [GIT PULL REQUEST] md updates for 4.3
Date: Sat, 05 Sep 2015 11:37:10 +0200
Message-ID: <87si6t6wc9.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>, Guoqing Jiang <gqjiang@suse.com>, Lidong Zhong <ldzhong@suse.com>, Sasha Levin <sasha.levin@oracle.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Markus Stockhausen <stockhausen@collogia.de>, Yi Zhang <yizhan@redhat.com>, Benjamin Randazzo <benjamin@randazzo.fr>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain


Please pull these updates.  I've already merged with the 'block' tree
to resolve a few simple conflicts.

Thanks,
NeilBrown


The following changes since commit 1081230b748de8f03f37f80c53dfa89feda9b8de:

  Merge branch 'for-4.3/core' of git://git.kernel.dk/linux-block (2015-09-02 13:10:25 -0700)

are available in the git repository at:

  git://neil.brown.name/md tags/md/4.3

for you to fetch changes up to e89c6fdf9e0eb1b5a03574d4ca73e83eae8deb91:

  Merge linux-block/for-4.3/core into md/for-linux (2015-09-05 11:08:32 +0200)

----------------------------------------------------------------
md updates for 4.3

- An assortment of little fixes, several for minor races only likely
  to be hit during testing
- further cluster-md-raid1 development, not ready for real use yet.
- new RAID6 syndrome code for ARM NEON
- fix a race where a write can return before failure of one device
  is properly recorded in metadata, so an immediate crash might result
  in that write being lost.

----------------------------------------------------------------
Ard Biesheuvel (1):
      md/raid6: delta syndrome for ARM NEON

Benjamin Randazzo (1):
      md: simplify get_bitmap_file now that "file" is zeroed.

Guoqing Jiang (11):
      md-cluster: use %pU to print UUIDs
      md-cluster: split recover_slot for future code reuse
      md-cluster: transfer the resync ownership to another node
      md-cluster: fix deadlock issue on message lock
      md-cluster: init completion within lockres_init
      md-cluster: add the error check if failed to get dlm lock
      md-cluster: init suspend_list and suspend_lock early in join
      md-cluster: remove the unused sb_lock
      md-cluster: add missed lockres_free
      md-cluster: only call complete(&cinfo->completion) when node join cluster
      md-cluster: Read the disk bitmap sb and check if it needs recovery

NeilBrown (20):
      md/raid0: update queue parameter in a safer location.
      md: Keep /proc/mdstat reporting recovery until fully DONE.
      md: close some races between setting and checking sync_action.
      md/raid5: consider updating reshape_position at start of reshape.
      md/raid10: fix a few typos in comments
      md/raid5: always set conf->prev_chunk_sectors and ->prev_algo
      md/raid5: switch to use conf->chunk_sectors in place of mddev->chunk_sectors where possible
      md/raid5: strengthen check on reshape_position at run.
      md/raid5: remove incorrect "min_t()" when calculating writepos.
      md: set MD_RECOVERY_RECOVER when starting a degraded array.
      md: be careful when testing resync_max against curr_resync_completed.
      md: sync sync_completed has correct value as recovery finishes.
      md/raid5: handle possible race as reshape completes.
      md: extend spinlock protection in register_md_cluster_operations
      md-cluster: remove inappropriate try_module_get from join()
      md/raid1: ensure device failure recorded before write request returns.
      md/raid10: ensure device failure recorded before write request returns.
      md/raid5: use bio_list for the list of bios to return.
      md/raid5: ensure device failure recorded before write request returns.
      Merge linux-block/for-4.3/core into md/for-linux

Sasha Levin (1):
      md: setup safemode_timer before it's being used

 Documentation/md-cluster.txt |   4 +-
 drivers/md/md-cluster.c      | 159 ++++++++++++++++++++++++++++---------------
 drivers/md/md.c              | 110 +++++++++++++++++++-----------
 drivers/md/raid0.c           |  75 ++++++++++----------
 drivers/md/raid1.c           |  30 +++++++-
 drivers/md/raid1.h           |   5 ++
 drivers/md/raid10.c          |  33 ++++++++-
 drivers/md/raid10.h          |   6 ++
 drivers/md/raid5.c           | 140 ++++++++++++++++++++++---------------
 drivers/md/raid5.h           |   5 +-
 lib/raid6/neon.c             |  13 +++-
 lib/raid6/neon.uc            |  46 +++++++++++++
 12 files changed, 433 insertions(+), 193 deletions(-)

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJV6rfGAAoJEDnsnt1WYoG52pIP/RVTX0Adi4ITjW5ukYUQKq6a
et9PeoXzXT31oKyytFJIr4ocEoVhHmzEY1c3mKtRzaNomOkwFyM81hPV9voIbBwN
+6MqWPNCU6T9tGyUHC79t1Q6Ct/R6yDkjFrhTJSMYEYadhPV/33TgYYGQJJ/oWX7
XBFPyWTsF1V2pXeJRFXyG+z64pA8D9RBGuR4q78rpWIDfvc1IV5Zd5OS51GKXQCF
Z8qZpc53weXS93Fl1A5E5r7rsIwDE3BlNu8gOGsfp7nikcrcGrICOwIA8qeLo020
+rs8E4R4qGI6WucQa2bO5cPOSVuRACp9XuLGjgd4yYACgQqk22GBO+JVfu3gHILX
9J0Pv6IoF/JXSNsB1S0WAK75hwsAbRi1ETzK0qQNfgQbnTaHICM3VXhoSenk29yJ
XxyZJBqWrOTAeyGfC/Q128IOhx/P20znUHIyx4b43jQ6GNsuWOQr95poDM22NLxA
/0J44plxz4hD37F+GBD1oRZtidnltOYjRYrkWFewob/p7YdCieEh8XF+oyLoCUfx
LiAv+oRdIma95ihzLAiTDAXy6l0+0rwvWb7z51IRD0fdlWuRpLOQhx+GokA1noEj
oE7IXd/s8x2gEkiGTOHs7VwcntHaXopqd9qoGpufsxwyAxd9h0T6cNPKdJ9Ai6+9
eCsbvSEaZOQ3FRZANFYS
=pzu6
-----END PGP SIGNATURE-----
--=-=-=--
