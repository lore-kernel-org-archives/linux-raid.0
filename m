From: Shaohua Li <shli@kernel.org>
Subject: [PATCH] md/raid5: cap worker count
Date: Thu, 21 Sep 2017 11:08:00 -0700
Message-ID: <ac12db2da2c12a58a39a6a16d56538653432aeab.1506017165.git.shli@fb.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dan.carpenter@oracle.com, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

From: Shaohua Li <shli@fb.com>

static checker reports a potential integer overflow. Cap the worker count to
avoid the overflow.

Reported:-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 076409455b60..928e24a07133 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6575,14 +6575,17 @@ static ssize_t
 raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
 {
 	struct r5conf *conf;
-	unsigned long new;
+	unsigned int new;
 	int err;
 	struct r5worker_group *new_groups, *old_groups;
 	int group_cnt, worker_cnt_per_group;
 
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
-	if (kstrtoul(page, 10, &new))
+	if (kstrtouint(page, 10, &new))
+		return -EINVAL;
+	/* 8192 should be big enough */
+	if (new > 8192)
 		return -EINVAL;
 
 	err = mddev_lock(mddev);
-- 
2.11.0

