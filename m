From: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Subject: [PATCH] imsm: set generation number when reading superblock
Date: Thu,  8 Dec 2016 12:12:48 +0100
Message-ID: <1481195568-12973-1-git-send-email-mariusz.dabrowski@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@redhat.com, Mariusz Dabrowski <mariusz.dabrowski@intel.com>
List-Id: linux-raid.ids

IMSM doesn't set 'events' field with generation number, so sometimes mdadm
tries to re-assembly container using metadata which isn't most recent (e. g.
from spare disk).

Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
---
 super-intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/super-intel.c b/super-intel.c
index 0407d43..06b199a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3381,6 +3381,7 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 
 	/* do we have the all the insync disks that we expect? */
 	mpb = super->anchor;
+	info->events = __le32_to_cpu(mpb->generation_num);
 
 	for (i = 0; i < mpb->num_raid_devs; i++) {
 		struct imsm_dev *dev = get_imsm_dev(super, i);
-- 
1.8.3.1

