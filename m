From: Yi Zhang <yizhan@redhat.com>
Subject: [PATCH] Grow: analyse_change add notification about only 2-device can be convert from RAID1 to RAID5
Date: Fri, 11 Mar 2016 17:26:40 +0800
Message-ID: <1457688400-12666-1-git-send-email-yizhan@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, neilb@suse.com, shli@kernel.org, xni@redhat.com, Yi Zhang <yizhan@redhat.com>
List-Id: linux-raid.ids

Notify "Can only convert a 2-device array to RAID5" instead of
"Impossibly level change request for RAID1" when convert from
RAID1 to RAID5 if the disk num is not equal two like RAID4/5->RAID1
did.

Signed-off-by: Yi Zhang <yizhan@redhat.com>
---
 Grow.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Grow.c b/Grow.c
index cf2750a..4e2fc08 100755
--- a/Grow.c
+++ b/Grow.c
@@ -1077,6 +1077,9 @@ char *analyse_change(char *devname, struct mdinfo *info, struct reshape *re)
 			re->level = 1;
 			return NULL;
 		}
+		if (info->array.raid_disks != 2 &&
+		    info->new_level == 5)
+			return "Can only convert a 2-device array to RAID5";
 		if (info->array.raid_disks == 2 &&
 		    info->new_level == 5) {
 
-- 
2.5.0

