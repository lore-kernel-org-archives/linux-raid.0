From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 00/26] Pending md patches.
Date: Wed, 04 Feb 2015 08:42:28 +1100
Message-ID: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I probably don't post my pending patches as often as I
should ... I think I got out of the habit somewhere there.
So I'll try to do better.

Following are a collection of patches that I hope to submit
for 3.20.  There is lots of clean-up and some re-arranging
of locking to make sure that accesses to /proc/mdstat and
most accesses to sysfs files never block.

Review and testing most welcome.

All of these are in my "for-next" branch, and so are in
linux-next.

Thanks,
NeilBrown


---

Hannes Reinecke (1):
      md: wakeup thread upon rdev_dec_pending()

Jes Sorensen (1):
      md: do_release_stripe(): No need to call md_wakeup_thread() twice

NeilBrown (24):
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


 drivers/md/bitmap.c    |   15 +
 drivers/md/dm-raid.c   |    8 
 drivers/md/faulty.c    |    8 
 drivers/md/linear.c    |   67 +---
 drivers/md/md.c        |  814 ++++++++++++++++++++++++++++++------------------
 drivers/md/md.h        |   57 +++
 drivers/md/multipath.c |   22 -
 drivers/md/raid0.c     |   29 +-
 drivers/md/raid1.c     |   52 +--
 drivers/md/raid1.h     |    3 
 drivers/md/raid10.c    |   37 --
 drivers/md/raid10.h    |    3 
 drivers/md/raid5.c     |  334 ++++++++++++--------
 drivers/md/raid5.h     |    1 
 14 files changed, 848 insertions(+), 602 deletions(-)

--
Signature

