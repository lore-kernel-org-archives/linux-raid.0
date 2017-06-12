From: Lidong Zhong <lzhong@suse.com>
Subject: [PATCH] md: change the initialization value for a spare device spot to MD_DISK_ROLE_SPARE
Date: Mon, 12 Jun 2017 10:45:55 +0800
Message-ID: <20170612024555.1120-1-lzhong@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The value for spare spot of sb->dev_roles is changed from
MD_DISK_ROLE_FAULTY to MD_DISK_ROLE_SPARE to keep align
with the value when the superblock is firstly created in
userspace.

Signed-off-by: Lidong Zhong <lzhong@suse.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 87edc342ccb3..a9aacedefbca 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1852,7 +1852,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 		max_dev = le32_to_cpu(sb->max_dev);
 
 	for (i=0; i<max_dev;i++)
-		sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_FAULTY);
+		sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_SPARE);
 
 	if (test_bit(MD_HAS_JOURNAL, &mddev->flags))
 		sb->feature_map |= cpu_to_le32(MD_FEATURE_JOURNAL);
-- 
2.12.0

