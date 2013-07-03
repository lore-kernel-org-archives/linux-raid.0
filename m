From: mwilck@arcor.de
Subject: [PATCH 20/27] DDF: add_to_super_ddf: RAID10 changes
Date: Wed,  3 Jul 2013 22:28:00 +0200
Message-ID: <1372883287-8859-21-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

The index in the BVD may be different in the RAID10 case.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 040a965..96d13ae 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2454,11 +2454,11 @@ static void add_to_super_ddf_bvd(struct supertype *st,
 	struct dl *dl;
 	struct ddf_super *ddf = st->sb;
 	struct vd_config *vc;
-	__u64 *lba_offset;
 	unsigned int working;
 	unsigned int i;
 	unsigned long long blocks, pos, esize;
 	struct extent *ex;
+	unsigned int raid_disk = dk->raid_disk;
 
 	if (fd == -1) {
 		for (dl = ddf->dlist; dl ; dl = dl->next)
@@ -2474,7 +2474,12 @@ static void add_to_super_ddf_bvd(struct supertype *st,
 		return;
 
 	vc = &ddf->currentconf->conf;
-	lba_offset = LBA_OFFSET(ddf, &ddf->currentconf->conf);
+	if (vc->sec_elmnt_count > 1) {
+		int n = __be16_to_cpu(vc->prim_elmnt_count);
+		if (raid_disk >= n)
+			vc = ddf->currentconf->other_bvds[raid_disk / n - 1];
+		raid_disk %= n;
+	}
 
 	ex = get_extents(ddf, dl);
 	if (!ex)
@@ -2498,8 +2503,8 @@ static void add_to_super_ddf_bvd(struct supertype *st,
 		return;
 
 	ddf->currentdev = dk->raid_disk;
-	vc->phys_refnum[dk->raid_disk] = dl->disk.refnum;
-	lba_offset[dk->raid_disk] = __cpu_to_be64(pos);
+	vc->phys_refnum[raid_disk] = dl->disk.refnum;
+	LBA_OFFSET(ddf, vc)[raid_disk] = __cpu_to_be64(pos);
 
 	for (i = 0; i < ddf->max_part ; i++)
 		if (dl->vlist[i] == NULL)
-- 
1.7.1
