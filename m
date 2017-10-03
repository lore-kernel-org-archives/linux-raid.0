From: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: [PATCH] imsm: Set disk slot number
Date: Tue,  3 Oct 2017 14:49:49 +0200
Message-ID: <1507034989-12264-1-git-send-email-mariusz.tkaczyk@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
List-Id: linux-raid.ids

If first disk of IMSM RAID1 is failed but still present in the system,
the array is not auto-assembled. Auto-assemble uses raid disk slot from
metadata to index disks. As it's not set, the valid disk is seen as a
replacement disk and its metadata is ignored. The problem is not
observed for other RAID levels as they have more than 2 disks -
replacement disks are only stored under uneven indexes so third disk
metadata is used in such scenario.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Reviewed-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 super-intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index 536cb61..b561fe2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3502,6 +3502,9 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 			__u32 ord = get_imsm_ord_tbl_ent(dev, j, MAP_0);
 			__u32 idx = ord_to_idx(ord);
 
+			if (super->disks && super->disks->index == (int)idx)
+				info->disk.raid_disk = j;
+
 			if (!(ord & IMSM_ORD_REBUILD) &&
 			    get_imsm_missing(super, idx)) {
 				missing = 1;
-- 
1.8.3.1

