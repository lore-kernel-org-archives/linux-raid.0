From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/2] imsm: FIX: Do not allow for spare disk activation during
	reshape
Date: Thu, 29 Sep 2011 17:45:36 +0200
Message-ID: <20110929154536.22094.87434.stgit@gklab-128-013.igk.intel.com>
References: <20110929154250.22094.48754.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110929154250.22094.48754.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Spare disk activation or starting repair for one array while on second
reshape is in progress, will lead to IMSM incompatible situation when
2 arrays in container shares different disks sets.
This can cause that 2 processes in container /reshape and rebuild/
are in progress in parallel. This is IMSM incompatible situation also.

Block spare disk activation and starting resync if any reshape in container
is in progress.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 07d47b5..5504c17 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2237,6 +2237,33 @@ static int write_imsm_migr_rec(struct supertype *st)
 }
 #endif /* MDASSEMBLE */
 
+/* spare/missing disks activations are not allowe when
+ * array/container performs reshape operation, because
+ * all arrays in container works on the same disks set
+ */
+int imsm_reshape_blocks_arrays_changes(struct intel_super *super)
+{
+	int rv = 0;
+	struct intel_dev *i_dev = super->devlist;
+	struct imsm_dev *dev;
+
+	/* check whole container
+	 */
+	while (i_dev) {
+		dev = i_dev->dev;
+		if (dev->vol.migr_state &&
+		    dev->vol.migr_type == MIGR_GEN_MIGR) {
+			/* No repair during any migration in container
+			 */
+			rv = 1;
+			break;
+		}
+		i_dev = i_dev->next;
+	}
+
+	return rv;
+}
+
 static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info, char *dmap)
 {
 	struct intel_super *super = st->sb;
@@ -6592,10 +6619,8 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 	dprintf("imsm: activate spare: inst=%d failed=%d (%d) level=%d\n",
 		inst, failed, a->info.array.raid_disks, a->info.array.level);
 
-	if (dev->vol.migr_state &&
-	    dev->vol.migr_type == MIGR_GEN_MIGR)
-		/* No repair during migration */
-		return NULL;
+	if (imsm_reshape_blocks_arrays_changes(super))
+			return NULL;
 
 	if (a->info.array.level == 4)
 		/* No repair for takeovered array

