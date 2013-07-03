From: mwilck@arcor.de
Subject: [PATCH 21/27] DDF: add_to_super_ddf_bvd: use get_svd_state()
Date: Wed,  3 Jul 2013 22:28:01 +0200
Message-ID: <1372883287-8859-22-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Reuse get_svd_state() rather than own state algorithm.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   30 +++++++-----------------------
 1 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 96d13ae..0247ca5 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2437,6 +2437,8 @@ static int init_super_ddf_bvd(struct supertype *st,
 	return 1;
 }
 
+static int get_svd_state(const struct ddf_super *, const struct vcl *);
+
 #ifndef MDASSEMBLE
 static void add_to_super_ddf_bvd(struct supertype *st,
 				 mdu_disk_info_t *dk, int fd, char *devname)
@@ -2454,7 +2456,6 @@ static void add_to_super_ddf_bvd(struct supertype *st,
 	struct dl *dl;
 	struct ddf_super *ddf = st->sb;
 	struct vd_config *vc;
-	unsigned int working;
 	unsigned int i;
 	unsigned long long blocks, pos, esize;
 	struct extent *ex;
@@ -2475,7 +2476,7 @@ static void add_to_super_ddf_bvd(struct supertype *st,
 
 	vc = &ddf->currentconf->conf;
 	if (vc->sec_elmnt_count > 1) {
-		int n = __be16_to_cpu(vc->prim_elmnt_count);
+		unsigned int n = __be16_to_cpu(vc->prim_elmnt_count);
 		if (raid_disk >= n)
 			vc = ddf->currentconf->other_bvds[raid_disk / n - 1];
 		raid_disk %= n;
@@ -2518,28 +2519,11 @@ static void add_to_super_ddf_bvd(struct supertype *st,
 	if (devname)
 		dl->devname = devname;
 
-	/* Check how many working raid_disks, and if we can mark
-	 * array as optimal yet
-	 */
-	working = 0;
-
-	for (i = 0; i < __be16_to_cpu(vc->prim_elmnt_count); i++)
-		if (vc->phys_refnum[i] != 0xffffffff)
-			working++;
-
-	/* Find which virtual_entry */
+	/* Check if we can mark array as optimal yet */
 	i = ddf->currentconf->vcnum;
-	if (working == __be16_to_cpu(vc->prim_elmnt_count))
-		ddf->virt->entries[i].state =
-			(ddf->virt->entries[i].state & ~DDF_state_mask)
-			| DDF_state_optimal;
-
-	if (vc->prl == DDF_RAID6 &&
-	    working+1 == __be16_to_cpu(vc->prim_elmnt_count))
-		ddf->virt->entries[i].state =
-			(ddf->virt->entries[i].state & ~DDF_state_mask)
-			| DDF_state_part_optimal;
-
+	ddf->virt->entries[i].state =
+		(ddf->virt->entries[i].state & ~DDF_state_mask)
+		| get_svd_state(ddf, ddf->currentconf);
 	ddf->phys->entries[dl->pdnum].type &= ~__cpu_to_be16(DDF_Global_Spare);
 	ddf->phys->entries[dl->pdnum].type |= __cpu_to_be16(DDF_Active_in_VD);
 	ddf_set_updates_pending(ddf);
-- 
1.7.1
