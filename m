From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH] md: md.c: Return -ENODEV when mddev is NULL in rdev_attr_show
Date: Thu, 23 May 2019 23:44:59 -0300
Message-ID: <20190524024459.6875-1-marcos.souza.org@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: liu.song.a23@gmail.com, Marcos Paulo de Souza <marcos.souza.org@gmail.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID Multiple Disks
        SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Commit c42d3240990814eec1e4b2b93fa0487fc4873aed
("md: return -ENODEV if rdev has no mddev assigned") changed rdev_attr_store to
return -ENODEV when rdev->mddev is NULL, now do the same to rdev_attr_show.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 45ffa23fa85d..0b391e7e063b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3363,7 +3363,7 @@ rdev_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
 	if (!entry->show)
 		return -EIO;
 	if (!rdev->mddev)
-		return -EBUSY;
+		return -ENODEV;
 	return entry->show(rdev, page);
 }
 
-- 
2.21.0
