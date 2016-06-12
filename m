From: Xiao Ni <xni@redhat.com>
Subject: [PATCH 1/1] MD:Update superblock when err == 0 in size_store
Date: Sun, 12 Jun 2016 17:18:00 +0800
Message-ID: <1465723080-9375-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

This is a simple check before updating the superblock. It should update
the superblock when update_size return 0.

Regards
Xiao

---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c068f17..0332a13 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4181,7 +4181,8 @@ size_store(struct mddev *mddev, const char *buf, size_t len)
 		return err;
 	if (mddev->pers) {
 		err = update_size(mddev, sectors);
-		md_update_sb(mddev, 1);
+		if (err == 0)
+			md_update_sb(mddev, 1);
 	} else {
 		if (mddev->dev_sectors == 0 ||
 		    mddev->dev_sectors > sectors)
-- 
2.4.3

