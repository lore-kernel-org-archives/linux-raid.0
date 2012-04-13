From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 11/14] imsm: Support setting max size for size change operation
Date: Fri, 13 Apr 2012 16:52:05 +0200
Message-ID: <1334328728-12544-12-git-send-email-adam.kwolek@intel.com>
References: <1334328728-12544-1-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-2-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-3-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-4-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-5-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-6-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-7-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-8-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-9-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-10-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-11-git-send-email-adam.kwolek@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334328728-12544-11-git-send-email-adam.kwolek@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, grzegorz.grabowski@intel.com, maciej.patelczyk@intel.com, anna.czarnowska@intel.com, Adam Kwolek <adam.kwolek@intel.com>
List-Id: linux-raid.ids

Add support for setting max size for size change operation using
imsm_get_free_size() function for computing maximum available space.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 super-intel.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 7161fc5..d9c293c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -9955,7 +9955,7 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 	 */
 	current_size = info.custom_array_size / 2 / data_disks;
 
-	if ((current_size != geo->size) && (geo->size > 0)) {
+	if ((current_size != geo->size) && (geo->size >= 0)) {
 		if (change != -1) {
 			fprintf(stderr,
 				Name " Error. Size change should be the only "
@@ -9970,7 +9970,27 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 				super->current_vol, st->devnum);
 			goto analyse_change_exit;
 		}
-		geo->size *= 2;
+		if (geo->size == 0) {
+			/* requested size change to the maximum available size
+			 */
+			unsigned long long freesize;
+			int rv;
+
+			rv =  imsm_get_free_size(st, dev->vol.map->num_members,
+						 0, chunk, &freesize);
+			if (rv == 0) {
+				fprintf(stderr, Name " Error. Cannot find "
+					"maximum available space.\n");
+				change = -1;
+				goto analyse_change_exit;
+			}
+			geo->size = freesize + current_size;
+
+			/* round to chunk size */
+			geo->size &= ~(chunk-1);
+		} else
+			geo->size *= 2;
+
 		if ((direction == ROLLBACK_METADATA_CHANGES)) {
 			/* accept size for rollback only
 			*/
-- 
1.6.4.2

