From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/5] FIX: Remove delta_parity concept
Date: Tue, 08 Mar 2011 14:25:03 +0100
Message-ID: <20110308132503.9578.38588.stgit@gklab-128-013.igk.intel.com>
References: <20110308132228.9578.34611.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110308132228.9578.34611.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When metadata reports level/raid_disks correct for level transition
delta_parity concept is in conflict with such approach.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/Grow.c b/Grow.c
index 5c5a3a3..a05bcef 100644
--- a/Grow.c
+++ b/Grow.c
@@ -893,10 +893,6 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 	 * when assembling an array that is undergoing reshape.
 	 */
 	int new_disks;
-	/* delta_parity records change in number of devices
-	 * caused by level change
-	 */
-	int delta_parity = 0;
 
 	/* If a new level not explicitly given, we assume no-change */
 	if (info->new_level == UnSet)
@@ -1045,18 +1041,15 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 		 */
 		switch (info->new_level) {
 		case 4:
-			delta_parity = 1;
 		case 0:
 			re->level = 4;
 			re->before.layout = 0;
 			break;
 		case 5:
-			delta_parity = 1;
 			re->level = 5;
 			re->before.layout = ALGORITHM_PARITY_N;
 			break;
 		case 6:
-			delta_parity = 2;
 			re->level = 6;
 			re->before.layout = ALGORITHM_PARITY_N;
 			break;
@@ -1072,7 +1065,6 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 	case 5:
 		switch (info->new_level) {
 		case 0:
-			delta_parity = -1;
 		case 4:
 			re->level = info->array.level;
 			re->before.data_disks = info->array.raid_disks - 1;
@@ -1084,7 +1076,6 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 			re->before.layout = info->array.layout;
 			break;
 		case 6:
-			delta_parity = 1;
 			re->level = 6;
 			re->before.data_disks = info->array.raid_disks - 1;
 			switch (info->array.layout) {
@@ -1127,7 +1118,6 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 		switch (info->new_level) {
 		case 4:
 		case 5:
-			delta_parity = -1;
 		case 6:
 			re->level = 6;
 			re->before.data_disks = info->array.raid_disks - 2;
@@ -1221,11 +1211,9 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 		return "Impossible level change requested";
 	}
 	if (info->delta_disks == UnSet)
-		info->delta_disks = delta_parity;
+		info->delta_disks = 0;
 
-	re->after.data_disks = (re->before.data_disks
-				+ info->delta_disks
-				- delta_parity);
+	re->after.data_disks = re->before.data_disks + info->delta_disks;
 	switch (re->level) {
 	case 6: re->parity = 2; break;
 	case 4:

