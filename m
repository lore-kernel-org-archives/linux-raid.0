From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V2 00/10] The latest changes for md-cluster
Date: Fri, 12 Aug 2016 13:42:33 +0800
Message-ID: <1470980563-26062-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

This version addresses comments from Shaohua, and the 7th
patch is added as well.

Thanks,
Guoqing

Guoqing Jiang (10):
  md-cluster: call md_kick_rdev_from_array once ack failed
  md-cluster: use FORCEUNLOCK in lockres_free
  md-cluster: remove some unnecessary dlm_unlock_sync
  md: changes for MD_STILL_CLOSED flag
  md-cluster: clean related infos of cluster
  md-cluster: protect md_find_rdev_nr_rcu with rcu lock
  md: remove obsolete ret in md_start_sync
  md-cluster: convert the completion to wait queue
  md-cluster: introduce dlm_lock_sync_interruptible to fix tasks hang
  md-cluster: make resync lock also could be interruptted

 drivers/md/md-cluster.c | 93 +++++++++++++++++++++++++++++++++----------------
 drivers/md/md.c         | 34 ++++++++++--------
 drivers/md/md.h         |  5 ++-
 3 files changed, 85 insertions(+), 47 deletions(-)

-- 
2.6.2

