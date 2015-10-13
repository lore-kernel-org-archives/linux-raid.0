From: rgoldwyn@suse.de
Subject: [PATCH 01/14] md-cluster: Wake up suspended process
Date: Tue, 13 Oct 2015 09:25:22 -0500
Message-ID: <1444746335-22624-2-git-send-email-rgoldwyn@suse.de>
References: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: gqjiang@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

When the suspended_area is deleted, the suspended processes
must be woken up in order to complete their I/O.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 51e8552..58eadc0 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -366,11 +366,13 @@ static void __remove_suspend_info(struct md_cluster_info *cinfo, int slot)
 		}
 }
 
-static void remove_suspend_info(struct md_cluster_info *cinfo, int slot)
+static void remove_suspend_info(struct mddev *mddev, int slot)
 {
+	struct md_cluster_info *cinfo = mddev->cluster_info;
 	spin_lock_irq(&cinfo->suspend_lock);
 	__remove_suspend_info(cinfo, slot);
 	spin_unlock_irq(&cinfo->suspend_lock);
+	mddev->pers->quiesce(mddev, 2);
 }
 
 
@@ -381,7 +383,7 @@ static void process_suspend_info(struct mddev *mddev,
 	struct suspend_info *s;
 
 	if (!hi) {
-		remove_suspend_info(cinfo, slot);
+		remove_suspend_info(mddev, slot);
 		return;
 	}
 	s = kzalloc(sizeof(struct suspend_info), GFP_KERNEL);
@@ -397,6 +399,7 @@ static void process_suspend_info(struct mddev *mddev,
 	__remove_suspend_info(cinfo, slot);
 	list_add(&s->list, &cinfo->suspend_list);
 	spin_unlock_irq(&cinfo->suspend_lock);
+	mddev->pers->quiesce(mddev, 2);
 }
 
 static void process_add_new_disk(struct mddev *mddev, struct cluster_msg *cmsg)
-- 
1.8.5.6

