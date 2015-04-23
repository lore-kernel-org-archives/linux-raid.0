From: NeilBrown <neilb@suse.de>
Subject: [GIT PULL REQUEST] md updates for 4.1
Date: Thu, 23 Apr 2015 16:14:46 +1000
Message-ID: <20150423161446.095dfebb@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/gg_De3tbIT+9oGWBnnYGAbz"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux RAID <linux-raid@vger.kernel.org>, Eric Mei <eric.mei@seagate.com>, Fengguang Wu <fengguang.wu@intel.com>, Goldwyn Rodrigues <rgoldwyn@suse.de>, Guoqing Jiang <gqjiang@suse.com>, Heinz Mauelshagen <heinzm@redhat.com>, Lidong Zhong <lzhong@suse.com>, Markus Stockhausen <stockhausen@collogia.de>, Shaohua Li <shli@fusionio.com>, Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: linux-raid.ids

--Sig_/gg_De3tbIT+9oGWBnnYGAbz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 more updates that usual this time.  A few have performance impacts which
 should mostly be positive, but RAID5 (in particular) can be very work-load
 sensitive .... we'll have to wait and see.
 More detailed highlights below.

Thanks,
NeilBrown

The following changes since commit 47d68979cc968535cb87f3e5f2e6a3533ea48fbd:

  md/raid0: fix bug with chunksize not a power of 2. (2015-04-10 15:36:31 +=
1000)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md/4.1

for you to fetch changes up to 9ffc8f7cb9647b13dfe4d1ad0d5e1427bb8b46d6:

  md/raid5: don't do chunk aligned read on degraded array. (2015-04-22 08:0=
0:43 +1000)

----------------------------------------------------------------
md updates for 4.1

Highlights:

- "experimental" code for managing md/raid1 across a cluster using
  DLM.  Code is not ready for general use and triggers a WARNING if used.
  However it is looking good and mostly done and having in mainline
  will help co-ordinate development.
- RAID5/6 can now batch multiple (4K wide) stripe_heads so as to
  handle a full (chunk wide) stripe as a single unit.
- RAID6 can now perform read-modify-write cycles which should
  help performance on larger arrays: 6 or more devices.
- RAID5/6 stripe cache now grows and shrinks dynamically.  The value
  set is used as a minimum.
- Resync is now allowed to go a little faster than the 'mininum' when
  there is competing IO.  How much faster depends on the speed of the
  devices, so the effective minimum should scale with device speed to
  some extent.

----------------------------------------------------------------
Eric Mei (1):
      md/raid5: don't do chunk aligned read on degraded array.

Goldwyn Rodrigues (31):
      md-cluster: Design Documentation
      Add number of nodes to bitmap structure for clustering
      Create a separate module for clustering support
      DLM lock and unlock functions
      Introduce md_cluster_operations to handle cluster functions
      Introduce md_cluster_info
      Return MD_SB_CLUSTERED if mddev is clustered
      Add node recovery callbacks
      Use separate bitmaps for each nodes in the cluster
      Lock bitmap while joining the cluster
      Gather on-going resync information of other nodes
      bitmap_create returns bitmap pointer
      Copy set bits from another slot
      Initiate recovery on node failure
      Perform resync for cluster node failure
      Communication Framework: Receiving
      Communication Framework: Sending functions
      metadata_update sends message to other nodes
      Reload superblock if METADATA_UPDATED is received
      Send RESYNCING while performing resync start/stop
      Resync start/Finish actions
      Suspend writes in RAID1 if within range
      Read from the first device when an area is resyncing
      Add new disk to clustered array
      md: Fix stray --cluster-confirm crash
      md: Fix bitmap offset calculations
      md: Export and rename kick_rdev_from_array
      md: Export and rename find_rdev_nr_rcu
      md-cluster: remove capabilities
      md: re-add a failed disk
      md-cluster: re-add capabilities

Guoqing Jiang (1):
      md-cluster: correct the num for comparison

Heinz Mauelshagen (1):
      md raid0: access mddev->queue (request queue member) conditionally be=
cause it is not set when accessed from dm-raid

Markus Stockhausen (6):
      md/raid6 algorithms: delta syndrome functions
      md/raid6 algorithms: improve test program
      md/raid6 algorithms: xor_syndrome() for generic int
      md/raid6 algorithms: xor_syndrome() for SSE2
      md/raid5: activate raid6 rmw feature
      md/raid5: introduce configuration option rmw_level

NeilBrown (10):
      md: fix error paths from bitmap_create.
      md/bitmap: fix incorrect DIV_ROUND_UP usage.
      Merge branch 'cluster' into for-next
      md: don't require sync_min to be a multiple of chunk_size.
      md: remove 'go_faster' option from ->sync_request()
      md: allow resync to go faster when there is competing IO.
      md/raid5: pass gfp_t arg to grow_one_stripe()
      md/raid5: move max_nr_stripes management into grow_one_stripe and dro=
p_one_stripe
      md/raid5: change ->inactive_blocked to a bit-flag.
      md/raid5: allow the stripe_cache to grow and shrink.

Stephen Rothwell (1):
      md/bitmap: use sector_div for sector_t divisions

kbuild test robot (2):
      md: recover_bitmaps() can be static
      md/cluster: Communication Framework: fix semicolon.cocci warnings

shli@kernel.org (6):
      raid5: use flex_array for scribble data
      raid5: add a new flag to track if a stripe can be batched
      raid5: track overwrite disk count
      RAID5: batch adjacent full stripe write
      raid5: handle io error of batch list
      raid5: handle expansion/resync case with stripe batching

 Documentation/md-cluster.txt   | 176 ++++++++
 crypto/async_tx/async_pq.c     |  19 +-
 drivers/md/Kconfig             |  16 +
 drivers/md/Makefile            |   1 +
 drivers/md/bitmap.c            | 189 +++++++-
 drivers/md/bitmap.h            |  10 +-
 drivers/md/md-cluster.c        | 965 +++++++++++++++++++++++++++++++++++++=
++++
 drivers/md/md-cluster.h        |  29 ++
 drivers/md/md.c                | 382 +++++++++++++---
 drivers/md/md.h                |  26 +-
 drivers/md/raid0.c             |  48 +-
 drivers/md/raid1.c             |  29 +-
 drivers/md/raid10.c            |   8 +-
 drivers/md/raid5.c             | 826 +++++++++++++++++++++++++++++------
 drivers/md/raid5.h             |  59 ++-
 include/linux/async_tx.h       |   3 +
 include/linux/raid/pq.h        |   1 +
 include/uapi/linux/raid/md_p.h |   7 +
 include/uapi/linux/raid/md_u.h |   1 +
 lib/raid6/algos.c              |  41 +-
 lib/raid6/altivec.uc           |   1 +
 lib/raid6/avx2.c               |   3 +
 lib/raid6/int.uc               |  41 +-
 lib/raid6/mmx.c                |   2 +
 lib/raid6/neon.c               |   1 +
 lib/raid6/sse1.c               |   2 +
 lib/raid6/sse2.c               | 227 ++++++++++
 lib/raid6/test/test.c          |  51 ++-
 lib/raid6/tilegx.uc            |   1 +
 29 files changed, 2860 insertions(+), 305 deletions(-)
 create mode 100644 Documentation/md-cluster.txt
 create mode 100644 drivers/md/md-cluster.c
 create mode 100644 drivers/md/md-cluster.h

--Sig_/gg_De3tbIT+9oGWBnnYGAbz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVTiN1jnsnt1WYoG5AQII/w//UUBfUexwInufGe7DAjeNUAJHwTcZgl8V
g57DblcRk7ePfN3Bth/oH0fdT1AF9ENc7/YlZ8NaK5dghijtibI9TrPiSNUNfmVD
OQd6XxGJsuhGDWejSJU0ykXh6kyR5W16GC2HwWwGm8KEkbWffd8ufrTIGy+AB5Wy
qK/3hY+mB+K9Hqv48FeHdb1bbyeoVnqCaYJDm8j554bv97Aw1VnWvQY408Nh993y
8b5bpLMX+xYimHWkS6EOdGfVf+6kf3ZoDm7YpHy8637DLBmN9ECsCGQBCSyz+oQY
CfPv/ZIZQQS5wmlS8vnyKJQNuWTZA0TSqKLCoFZpD1GvHGOONr3SU5hvNX/THGWs
xsNUYbuWlTuAHJWFkDcg8feIhK+7nA5t18Bt97uXwRGRIqWBMbGgSSatK7aFa1AE
zUy/pWSy7YkCAU17c55TzwO+eNHLMQ8WEwFrpV2i3afz3h7MFnobeT6HcHXa1rUa
bUkO+W4yXqjJMOdryRw5N4fq2BwB86CtCI+HivBljIV3ZJH9qz5pguRFOh+gQR76
2y7ot7rdeoZFAM++7jr5ofYCKrEHXHgMzq0WBCETRQW+90IszEZ2sOVoK343f7Lb
hGliBItzh0CXrx6RyI1x8AyFpq3cj2rXXHytN/rITGrDaB/PeBVHYLyIbviwKqfW
JZOkkFo3dNg=
=f/qq
-----END PGP SIGNATURE-----

--Sig_/gg_De3tbIT+9oGWBnnYGAbz--
