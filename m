From: heinzm@redhat.com
Subject: [PATCH 2/3] dm core: export dm_disk to allow for dm-raid to pass it on to the MD raid0 personality
Date: Fri, 17 Apr 2015 14:40:18 +0200
Message-ID: <1429274419-16493-3-git-send-email-heinzm@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: linux-raid.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

This patch is a prerequisite for dm-raid "raid0" support to allow
dm-raid to set rs->md.gendisk, which is required by the MD RAID0
pesonality to set disk stacking limits.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>

---
 drivers/md/dm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8001fe9..f11e2f5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3206,6 +3206,7 @@ struct gendisk *dm_disk(struct mapped_device *md)
 {
 	return md->disk;
 }
+EXPORT_SYMBOL_GPL(dm_disk);
 
 struct kobject *dm_kobject(struct mapped_device *md)
 {
-- 
2.1.0

