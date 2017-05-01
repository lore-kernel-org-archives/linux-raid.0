From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.12
Date: Mon, 1 May 2017 15:50:48 -0700
Message-ID: <20170501225048.whxlxsoebnxcfyto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hi,

Please pull MD update for 4.12. There are conflicts between MD tree and block
tree, so I did a merge before the pull request. This update includes:
- Add Partial Parity Log (ppl) feature found in Intel IMSM raid array by Artur
  Paszkiewicz. This feature is another way to close RAID5 writehole. The Linux
  implementation is also available for normal RAID5 array if specific superblock
  bit is set.
- A number of md-cluser fixes and enabling md-cluster array resize from Guoqing
  Jiang
- A bunch of patches from Ming Lei and Neil Brown to rewrite MD bio handling
  related code. Now MD doesn't directly access bio bvec, bi_phys_segments and
  uses modern bio API for bio split.
- Improve RAID5 IO pattern to improve performance for hard disk based RAID5/6
  from me.
- Several patches from Song Liu to speed up raid5-cache recovery and allow
  raid5 cache feature disabling in runtime.
- Fix a performance regression in raid1 resync from Xiao Ni.
- Other cleanup and fixes from various people.

Thanks,
Shaohua

The following changes since commit 85724edecbdc19f53ed4b902fc3a32e4d1b61c9b:

  Merge tag 'leds_for_4.12' of git://git.kernel.org/pub/scm/linux/kernel/git/j.anaszewski/linux-leds (2017-05-01 13:12:49 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git for-linus

for you to fetch changes up to e265eb3a30543a237b2ebc4e0422ac82e55b07e4:

  Merge branch 'md-next' into md-linus (2017-05-01 14:09:21 -0700)

----------------------------------------------------------------
Artur Paszkiewicz (12):
      md: superblock changes for PPL
      raid5: separate header for log functions
      raid5-ppl: Partial Parity Log write logging implementation
      md: add sysfs entries for PPL
      raid5-ppl: load and recover the log
      raid5-ppl: support disk hot add/remove with PPL
      raid5-ppl: runtime PPL enabling or disabling
      raid5-ppl: move no_mem_stripes to struct ppl_conf
      raid5-ppl: use resize_stripes() when enabling or disabling ppl
      raid5-ppl: partial parity calculation optimization
      raid5-ppl: use a single mempool for ppl_io_unit and header_page
      uapi: fix linux/raid/md_p.h userspace compilation error

Christophe JAILLET (1):
      md-cluster: Fix a memleak in an error handling path

Dan Carpenter (1):
      raid5-ppl: silence a misleading warning message

Dennis Yang (1):
      md: update slab_cache before releasing new stripes when stripes resizing

Guoqing Jiang (9):
      md-cluster: use sync way to handle METADATA_UPDATED msg
      md-cluster: add CHANGE_CAPACITY message type
      md-cluster: introduce cluster_check_sync_size
      md-cluster: add the support for resize
      md: move bitmap_destroy to the beginning of __md_stop
      md/raid10: refactor some codes from raid10_write_request
      md/raid10: reset the 'first' at the end of loop
      md/raid10: wait up frozen array in handle_write_completed
      md: clear WantReplacement once disk is removed

Jason Yan (1):
      md/raid5-cache: fix payload endianness problem in raid5-cache

Lidong Zhong (1):
      md/raid1/10: remove unused queue

Ming Lei (15):
      md: raid1/raid10: don't handle failure of bio_add_page()
      md: move two macros into md.h
      md: prepare for managing resync I/O pages in clean way
      md: raid1: simplify r1buf_pool_free()
      md: raid1: don't use bio's vec table to manage resync pages
      md: raid1: retrieve page from pre-allocated resync page array
      md: raid1: use bio helper in process_checks()
      block: introduce bio_copy_data_partial
      md: raid1: move 'offset' out of loop
      md: raid1: improve write behind
      md: raid10: refactor code of read reshape's .bi_end_io
      md: raid10: don't use bio's vec table to manage resync pages
      md: raid10: retrieve page from preallocated resync page array
      md: raid10: avoid direct access to bvec table in handle_reshape_read_error
      md: raid1: kill warning on powerpc_pseries

NeilBrown (30):
      md/raid5: use md_write_start to count stripes, not bios
      md/raid5: simplfy delaying of writes while metadata is updated.
      md/raid5: call bio_endio() directly rather than queueing for later.
      md/raid5: use bio_inc_remaining() instead of repurposing bi_phys_segments as a counter
      md/raid5: remove over-loading of ->bi_phys_segments.
      Revert "md/raid5: limit request size according to implementation limits"
      md/raid1, raid10: move rXbio accounting closer to allocation.
      md/raid10: stop using bi_phys_segments
      md/raid1: stop using bi_phys_segment
      md/raid5: don't test ->writes_pending in raid5_remove_disk
      md: factor out set_in_sync()
      md: close a race with setting mddev->in_sync
      percpu-refcount: support synchronous switch to atomic mode.
      MD: use per-cpu counter for writes_pending
      md/raid6: Fix anomily when recovering a single device in RAID6.
      md: MD_CLOSING needs to be cleared after called md_set_readonly or do_md_stop
      md/raid1: avoid reusing a resync bio after error handling.
      md/raid1: simplify the splitting of requests.
      md/raid1: simplify alloc_behind_master_bio()
      Revert "block: introduce bio_copy_data_partial"
      md/raid1: simplify handle_read_error().
      md/raid1: factor out flush_bio_list()
      md/raid10: simplify the splitting of requests.
      md/raid10: simplify handle_read_error()
      md/raid5: make chunk_aligned_read() split bios more cleanly.
      md/linear: improve bio splitting.
      md/raid0: fix up bio splitting.
      md: allow creation of mdNNN arrays via md_mod/parameters/new_array
      md: support disabling of create-on-open semantics.
      md: handle read-only member devices better.

Shaohua Li (7):
      md/raid5: prioritize stripes for writeback
      md/raid5-cache: bump flush stripe batch size
      md/raid5: sort bios
      block: remove bio_clone_bioset_partial()
      md/raid1: skip data copy for behind io for discard request
      md/raid10: skip spare disk as 'first' disk
      Merge branch 'md-next' into md-linus

Song Liu (4):
      md/r5cache: improve recovery with read ahead page pool
      md/r5cache: handle R5LOG_PAYLOAD_FLUSH in recovery
      md/r5cache: generate R5LOG_PAYLOAD_FLUSH
      md/raid5: use consistency_policy to remove journal feature

Xiao Ni (1):
      md/raid1: Use a new variable to count flighting sync requests

Zhilong Liu (2):
      md: fix several trivial typos in comments
      md.c:didn't unlock the mddev before return EINVAL in array_size_store

 Documentation/admin-guide/md.rst |   32 +-
 Documentation/md/md-cluster.txt  |    2 +-
 Documentation/md/raid5-ppl.txt   |   44 ++
 block/bio.c                      |   61 +-
 drivers/md/Makefile              |    2 +-
 drivers/md/bitmap.c              |   59 +-
 drivers/md/bitmap.h              |    3 +
 drivers/md/linear.c              |   75 ++-
 drivers/md/md-cluster.c          |  223 ++++++-
 drivers/md/md-cluster.h          |    1 +
 drivers/md/md.c                  |  414 ++++++++++---
 drivers/md/md.h                  |   71 ++-
 drivers/md/raid0.c               |   78 +--
 drivers/md/raid1.c               |  679 +++++++++-----------
 drivers/md/raid1.h               |   13 +-
 drivers/md/raid10.c              |  736 +++++++++-------------
 drivers/md/raid10.h              |    1 +
 drivers/md/raid5-cache.c         |  362 ++++++++---
 drivers/md/raid5-log.h           |  115 ++++
 drivers/md/raid5-ppl.c           | 1271 ++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c               |  643 ++++++++++++-------
 drivers/md/raid5.h               |  106 +---
 include/linux/bio.h              |   11 +-
 include/linux/percpu-refcount.h  |    1 +
 include/uapi/linux/raid/md_p.h   |   45 +-
 lib/percpu-refcount.c            |   17 +
 26 files changed, 3582 insertions(+), 1483 deletions(-)
 create mode 100644 Documentation/md/raid5-ppl.txt
 create mode 100644 drivers/md/raid5-log.h
 create mode 100644 drivers/md/raid5-ppl.c
