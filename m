From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH] imsm: platform capabilities are not validated during level
 migration
Date: Tue, 15 Nov 2011 13:49:36 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D405E476@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Subject: [PATCH] imsm: platform capabilities are not validated during level migration

Migration from RAID0 to RAID5 should be blocked on the system without
support for RAID5. No platform validation was performed in RAID
level migrations: verification for all level migrations added.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |   35 +++++++++++++++++++----------------
 1 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index f776be9..b64aa7a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5385,7 +5385,11 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 	}
 	
 	if (!dev) {
-		if (st->sb && freesize) {
+		if (st->sb) {
+			if (!validate_geometry_imsm_orom(st->sb, level, layout,
+							 raiddisks, chunk,
+							 verbose))
+				return 0;
 			/* we are being asked to automatically layout a
 			 * new volume based on the current contents of
 			 * the container.  If the the parameters can be
@@ -5394,12 +5398,9 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 			 * created.  add_to_super and getinfo_super
 			 * detect when autolayout is in progress.
 			 */
-			if (!validate_geometry_imsm_orom(st->sb, level, layout,
-							 raiddisks, chunk,
-							 verbose))
-				return 0;
-			return reserve_space(st, raiddisks, size,
-					     chunk?*chunk:0, freesize);
+			if (freesize)
+				return reserve_space(st, raiddisks, size,
+						     chunk?*chunk:0, freesize);
 		}
 		return 1;
 	}
@@ -8664,6 +8665,8 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 	int change = -1;
 	int check_devs = 0;
 	int chunk;
+	int devNumChange=0;
+	int layout = -1;
 
 	getinfo_super_imsm_volume(st, &info, NULL);
 	if ((geo->level != info.array.level) &&
@@ -8681,23 +8684,23 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 					change = -1;
 					goto analyse_change_exit;
 				}
+				layout =  geo->layout;
 				check_devs = 1;
-			}
-			if (geo->level == 10) {
+				devNumChange = 1; /* parity disk added */
+			} else if (geo->level == 10) {
 				change = CH_TAKEOVER;
 				check_devs = 1;
+				devNumChange = 2; /* two mirrors added */
+				layout = 0x102; /* imsm supported layout */
 			}
 			break;
 		case 1:
-			if (geo->level == 0) {
-				change = CH_TAKEOVER;
-				check_devs = 1;
-			}
-			break;
 		case 10:
 			if (geo->level == 0) {
 				change = CH_TAKEOVER;
 				check_devs = 1;
+				devNumChange = -(geo->raid_disks/2);
+				layout = 0; /* imsm raid0 layout */ 
 			}
 			break;
 		}
@@ -8744,8 +8747,8 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 	chunk = geo->chunksize / 1024;
 	if (!validate_geometry_imsm(st,
 				    geo->level,
-				    geo->layout,
-				    geo->raid_disks,
+				    layout,
+				    geo->raid_disks + devNumChange,
 				    &chunk,
 				    geo->size,
 				    0, 0, 1))
-- 
1.7.1

