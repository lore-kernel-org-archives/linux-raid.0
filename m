From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 13/36] md,rcu: convert call_rcu(free_conf) to kfree_rcu()
Date: Fri, 18 Mar 2011 11:59:14 +0800
Message-ID: <4D82D892.5000908@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



The rcu callback free_conf() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(free_conf).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 drivers/md/linear.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 0ed7f6b..a5b9e53 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -231,12 +231,6 @@ static int linear_run (mddev_t *mddev)
 	return 0;
 }
 
-static void free_conf(struct rcu_head *head)
-{
-	linear_conf_t *conf = container_of(head, linear_conf_t, rcu);
-	kfree(conf);
-}
-
 static int linear_add(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	/* Adding a drive to a linear array allows the array to grow.
@@ -265,7 +259,7 @@ static int linear_add(mddev_t *mddev, mdk_rdev_t *rdev)
 	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	revalidate_disk(mddev->gendisk);
-	call_rcu(&oldconf->rcu, free_conf);
+	kfree_rcu(oldconf, rcu);
 	return 0;
 }
 
-- 
1.7.4
