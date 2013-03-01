From: mwilck@arcor.de
Subject: [PATCH 08/12] DDF: container_content_ddf: handle RAID layout for RAID10
Date: Fri,  1 Mar 2013 23:28:29 +0100
Message-ID: <1362176913-6804-9-git-send-email-mwilck@arcor.de>
References: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This patch adds basic handling for the special case of RAID10.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   79 +++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 66 insertions(+), 13 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 4186038..01aa7d5 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3121,12 +3121,45 @@ static int check_secondary(const struct vcl *vc)
 
 #define NO_SUCH_REFNUM (0xFFFFFFFF)
 static unsigned int get_pd_index_from_refnum(const struct vcl *vc,
-					     __u32 refnum, unsigned int nmax)
+					     __u32 refnum, unsigned int nmax,
+					     const struct vd_config **bvd,
+					     unsigned int *idx)
 {
-	unsigned int i;
-	for (i = 0 ; i < nmax ; i++)
-		if (vc->conf.phys_refnum[i] == refnum)
-			return i;
+	unsigned int i, j, n, sec, cnt;
+
+	cnt = __be16_to_cpu(vc->conf.prim_elmnt_count);
+	sec = (vc->conf.sec_elmnt_count == 1 ? 0 : vc->conf.sec_elmnt_seq);
+
+	for (i = 0, j = 0 ; i < nmax ; i++) {
+		/* j counts valid entries for this BVD */
+		if (vc->conf.phys_refnum[i] != 0xffffffff)
+			j++;
+		if (vc->conf.phys_refnum[i] == refnum) {
+			*bvd = &vc->conf;
+			*idx = i;
+			return sec * cnt + j - 1;
+		}
+	}
+	if (vc->other_bvds == NULL)
+		goto bad;
+
+	for (n = 1; n < vc->conf.sec_elmnt_count; n++) {
+		struct vd_config *vd = vc->other_bvds[n-1];
+		if (vd == NULL)
+			continue;
+		sec = vd->sec_elmnt_seq;
+		for (i = 0, j = 0 ; i < nmax ; i++) {
+			if (vd->phys_refnum[i] != 0xffffffff)
+				j++;
+			if (vd->phys_refnum[i] == refnum) {
+				*bvd = vd;
+				*idx = i;
+				return sec * cnt + j - 1;
+			}
+		}
+	}
+bad:
+	*bvd = NULL;
 	return NO_SUCH_REFNUM;
 }
 
@@ -3167,11 +3200,26 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 		this->next = rest;
 		rest = this;
 
-		this->array.level = map_num1(ddf_level_num, vc->conf.prl);
-		this->array.raid_disks =
-			__be16_to_cpu(vc->conf.prim_elmnt_count);
-		this->array.layout = rlq_to_layout(vc->conf.rlq, vc->conf.prl,
-						   this->array.raid_disks);
+		if (vc->conf.sec_elmnt_count == 1) {
+			this->array.level = map_num1(ddf_level_num,
+						     vc->conf.prl);
+			this->array.raid_disks =
+				__be16_to_cpu(vc->conf.prim_elmnt_count);
+			this->array.layout =
+				rlq_to_layout(vc->conf.rlq, vc->conf.prl,
+					      this->array.raid_disks);
+		} else {
+			/* The only supported layout is RAID 10.
+			 * Compatibility has been checked in check_secondary()
+			 * above.
+			 */
+			this->array.level = 10;
+			this->array.raid_disks =
+				__be16_to_cpu(vc->conf.prim_elmnt_count)
+				* vc->conf.sec_elmnt_count;
+			this->array.layout = 0x100 |
+				__be16_to_cpu(vc->conf.prim_elmnt_count);
+		}
 		this->array.md_minor      = -1;
 		this->array.major_version = -1;
 		this->array.minor_version = -2;
@@ -3213,6 +3261,9 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 		for (pd = 0; pd < __be16_to_cpu(ddf->phys->used_pdes); pd++) {
 			struct mdinfo *dev;
 			struct dl *d;
+			const struct vd_config *bvd;
+			unsigned int iphys;
+			__u64 *lba_offset;
 			int stt;
 
 			if (ddf->phys->entries[pd].refnum == 0xFFFFFFFF)
@@ -3224,7 +3275,8 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 				continue;
 
 			i = get_pd_index_from_refnum(
-				vc, ddf->phys->entries[pd].refnum, ddf->mppe);
+				vc, ddf->phys->entries[pd].refnum,
+				ddf->mppe, &bvd, &iphys);
 			if (i == NO_SUCH_REFNUM)
 				continue;
 
@@ -3250,8 +3302,9 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 			dev->recovery_start = MaxSector;
 
 			dev->events = __be32_to_cpu(ddf->primary.seq);
-			dev->data_offset = __be64_to_cpu(vc->lba_offset[i]);
-			dev->component_size = __be64_to_cpu(vc->conf.blocks);
+			lba_offset =  (__u64 *)&bvd->phys_refnum[ddf->mppe];
+			dev->data_offset = __be64_to_cpu(lba_offset[iphys]);
+			dev->component_size = __be64_to_cpu(bvd->blocks);
 			if (d->devname)
 				strcpy(dev->name, d->devname);
 		}
-- 
1.7.3.4
