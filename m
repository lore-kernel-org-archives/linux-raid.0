From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 00/11] Series short description
Date: Fri, 16 Oct 2009 16:49:17 +1100
Message-ID: <20091016054316.24208.33818.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Hi,
 The following are a series of patches for 2.6.32-rc that I hope to
 ask Linus to pull mid next week.  They are already in my for-next tree.

 Review always welcome.

 Dan, I would particularly like you to check over 
      raid6/async_tx: handle holes in block list in async_syndrome_val
      md/async: don't pass a memory pointer as a page pointer.

 as they fix some issues with the recent conversion of raid6 to work
 with async offload.  Problems particularly occurred with 'ddf' style
 layouts where there the Q syndrome is calculated over data blocks and
 some 'zero' blocks.

 My mdadm test suite now has some tests that test every single RAID5
 and RAID6 layout and every combination of devices failing.  And also
 uses the new reshape functionality to transition an array through
 each different layout.  It has been very helpful at finding bugs.

 One particularly important bug is that thought 2.6.31 can reshape a
 RAID5 to have fewer devices, if the reshape is aborted in the middle,
 2.6.31 cannot restart that reshape.  With these patches 2.6.32 will
 be able to.  I suspect that when I release mdadm-3.1 it will refuse
 to reduce the number of devices on kernels earlier than 2.6.32.

Thanks,
NeilBrown
---

Dan Williams (2):
      md/raid456: downlevel multicore operations to raid_run_ops
      md/raid5: initialize conf->device_lock earlier

NeilBrown (8):
      raid6/async_tx: handle holes in block list in async_syndrome_val
      md/async: don't pass a memory pointer as a page pointer.
      md: Fix handling of raid5 array which is being reshaped to fewer devices.
      md: fix problems with RAID6 calculations for DDF.
      md: remove clumsy usage of do_sync_mapping_range from bitmap code
      md: raid1/raid10: handle allocation errors during array setup.
      md/raid1/raid10: add a cond_resched
      Revert "md: do not progress the resync process if the stripe was blocked"

Vladimir Dronnikov (1):
      md: drivers/md/unroll.pl replaced with awk analog


 crypto/async_tx/async_pq.c          |   40 +++++---
 crypto/async_tx/async_raid6_recov.c |   16 ++-
 crypto/async_tx/async_xor.c         |   18 ++--
 drivers/md/Makefile                 |   22 ++--
 drivers/md/bitmap.c                 |    9 +-
 drivers/md/md.c                     |    2 
 drivers/md/raid1.c                  |    6 +
 drivers/md/raid10.c                 |    5 +
 drivers/md/raid5.c                  |  180 ++++++++++++++++++-----------------
 drivers/md/raid5.h                  |   14 ++-
 drivers/md/raid6altivec.uc          |    2 
 drivers/md/raid6int.uc              |    2 
 drivers/md/raid6test/Makefile       |   42 ++++----
 drivers/md/unroll.awk               |   20 ++++
 drivers/md/unroll.pl                |   24 -----
 15 files changed, 217 insertions(+), 185 deletions(-)
 create mode 100644 drivers/md/unroll.awk
 delete mode 100644 drivers/md/unroll.pl

-- 
Signature

