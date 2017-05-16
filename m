From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] md-cluster: fix potential lock issue in add_new_disk
Date: Tue, 16 May 2017 14:01:25 +0800
Message-ID: <1494914485-16288-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, Guoqing Jiang <gqjiang@suse.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

The add_new_disk returns with communication locked if
__sendmsg returns failure, fix it with call unlock_comm
before return.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
CC: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 7299ce2..03082e1 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1311,8 +1311,10 @@ static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
 	cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
 	lock_comm(cinfo, 1);
 	ret = __sendmsg(cinfo, &cmsg);
-	if (ret)
+	if (ret) {
+		unlock_comm(cinfo);
 		return ret;
+	}
 	cinfo->no_new_dev_lockres->flags |= DLM_LKF_NOQUEUE;
 	ret = dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_EX);
 	cinfo->no_new_dev_lockres->flags &= ~DLM_LKF_NOQUEUE;
-- 
2.6.6

