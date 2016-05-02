From: Guoqing Jiang <gqjiang@suse.com>
Subject: [V2 PATCH 00/13] The latest patches for md-cluster
Date: Mon,  2 May 2016 11:33:07 -0400
Message-ID: <1462203200-1375-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: neilb@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Changes:
1. delete no_hijack parameter from bitmap_get_counter
2. add one patch from kbuild test robot to remove checkpatch warning
3. md-set-MD_CHANGE_PENDING-in-a-spinlocked-region.patch is removed
from the patchset and it will be post later.

For cluster raid1, we found some issues and some codes need to be
improved during the past months, and all the patches are based on
for-next branch of md tree.

The patchset also available in github as follows:

https://github.com/GuoqingJiang/linux/tree/md-for-next

Thanks,
Guoqing

Guoqing Jiang (12):
  md-cluster: change resync lock from asynchronous to synchronous
  md-cluser: make resync_finish only called after pers->sync_request
  md-cluster: wake up thread to continue recovery
  md-cluster: unregister thread if err happened
  md-cluster: fix locking when node joins cluster during message
    broadcast
  md-cluster: change array_sectors and update size are not supported
  md-cluster: wakeup thread if activated a spare disk
  md-cluster: always setup in-memory bitmap
  md-cluster: sync bitmap when node received RESYNCING msg
  md-cluster/bitmap: fix wrong calcuation of offset
  md-cluster/bitmap: fix wrong page num in bitmap_file_clear_bit and
    bitmap_file_set_bit
  md-cluster/bitmap: unplug bitmap to sync dirty pages to disk

kbuild test robot (1):
  md-cluster: fix ifnullfree.cocci warnings

 Documentation/md-cluster.txt |  6 ++++
 drivers/md/bitmap.c          | 85 ++++++++++++++++++++++++++++++++++++++------
 drivers/md/bitmap.h          |  3 ++
 drivers/md/md-cluster.c      | 53 ++++++++++++++++++++++-----
 drivers/md/md.c              | 61 ++++++++++++++++++++-----------
 5 files changed, 168 insertions(+), 40 deletions(-)

-- 
2.6.6

