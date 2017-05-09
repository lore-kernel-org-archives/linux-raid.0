From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 1/5] imsm: allow drives in a container regardless of sector size
Date: Tue,  9 May 2017 12:25:43 +0200
Message-ID: <1494325547-3028-2-git-send-email-tomasz.majchrzak@intel.com>
References: <1494325547-3028-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1494325547-3028-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, Alexey Obitotskiy <aleksey.obitotskiy@intel.com>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

From: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>

IMSM doesn't allow to create arrays including drives with different
sector sizes. The initial idea was not to permit to combine drives
with different sector size in the same container. The problem is it
only worked for array creation. On array assemble there are no
calls to metadata handlers to see if drive is suitable for a container
(e.g. as a spare) and it leads to wrong configuration.

Revert the change and allow adding drives with different sector size
to the container.

Signed-off-by: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 super-intel.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e13c940..2a5d848 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5716,12 +5716,6 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	if (super->sector_size == 0) {
 		/* this a first device, so sector_size is not set yet */
 		super->sector_size = member_sector_size;
-	} else if (member_sector_size != super->sector_size) {
-		pr_err("Mixing between different sector size is forbidden, aborting...\n");
-		if (dd->devname)
-			free(dd->devname);
-		free(dd);
-		return 1;
 	}
 
 	/* clear migr_rec when adding disk to container */
-- 
1.8.3.1

