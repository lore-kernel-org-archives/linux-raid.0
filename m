From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] md: add missing sysfs_notify on array_state update
Date: Thu, 30 Jun 2016 10:47:09 +0200
Message-ID: <1467276429-9359-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Changeset 6791875e2e53 has added early return from a function so there is no
sysfs notification for 'active' and 'clean' state change.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 drivers/md/md.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c068f17..8d52f44 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3930,6 +3930,8 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 			} else
 				err = -EBUSY;
 		}
+		if (!err)
+			sysfs_notify_dirent_safe(mddev->sysfs_state);
 		spin_unlock(&mddev->lock);
 		return err ?: len;
 	}
-- 
1.8.3.1

