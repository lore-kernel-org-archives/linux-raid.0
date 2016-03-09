From: Coly Li <colyli@suse.de>
Subject: [PATCH] Fix regression during add devices
Date: Wed,  9 Mar 2016 13:20:18 +0800
Message-ID: <1457500818-1586-1-git-send-email-colyli@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Coly Li <colyli@suse.de>, Neil Brown <neilb@suse.com>
List-Id: linux-raid.ids

From: Hannes Reinecke <hare@suse.de>

Commit d180d2aa2a17 ("Manage: fix test for 'is array failed'.")
introduced a regression which would not allow to re-add new
drivers to a failed array.

The patch is written by Hannes Reinecke, Neil Brown points out
the buggy commit ID is d180d2aa2a17. Coly helps to submit the
patch to mdadm upstream.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Coly Li <colyli@suse.de>
Cc: Neil Brown <neilb@suse.com>
---
 Manage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Manage.c b/Manage.c
index 7e1b94b..073ddb9 100644
--- a/Manage.c
+++ b/Manage.c
@@ -879,10 +879,10 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 					continue;
 				if (disc.major == 0 && disc.minor == 0)
 					continue;
-				found++;
 				if (!(disc.state & (1<<MD_DISK_SYNC)))
 					continue;
 				avail[disc.raid_disk] = 1;
+				found++;
 			}
 			array_failed = !enough(array->level, array->raid_disks,
 					       array->layout, 1, avail);
-- 
2.6.2

