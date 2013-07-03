From: mwilck@arcor.de
Subject: [PATCH 11/27] DDF: layout_ddf2md: new DDF->md RAID layout conversion
Date: Wed,  3 Jul 2013 22:27:51 +0200
Message-ID: <1372883287-8859-12-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

layout_ddf2md() is a new RAID layout conversion routine.
It obsoletes the previous separate routines for obtaining
md level and layout (map_num1, rlq_to_layout).

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |  197 ++++++++++++++++++++++++++++++-----------------------------
 1 files changed, 100 insertions(+), 97 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 0f955be..a43401e 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -484,6 +484,102 @@ static unsigned int calc_crc(void *buf, int len)
 	return __cpu_to_be32(newcrc);
 }
 
+static int err_bad_ddf_layout(const struct vd_config *conf)
+{
+	pr_err("DDF RAID %u qualifier %u with %u disks is unsupported\n",
+	       conf->prl, conf->rlq, __be16_to_cpu(conf->prim_elmnt_count));
+	return -1;
+}
+
+static int layout_ddf2md(const struct vd_config *conf,
+			 mdu_array_info_t *array)
+{
+	int level = LEVEL_UNSUPPORTED;
+	int layout = 0;
+	int raiddisks = __be16_to_cpu(conf->prim_elmnt_count);
+
+	if (conf->sec_elmnt_count > 1) {
+		/* see also check_secondary() */
+		if (conf->prl != DDF_RAID1 ||
+		    (conf->srl != DDF_2STRIPED && conf->srl != DDF_2SPANNED)) {
+			pr_err("Unsupported secondary RAID level %u/%u\n",
+			       conf->prl, conf->srl);
+			return -1;
+		}
+		if (raiddisks == 2 && conf->rlq == DDF_RAID1_SIMPLE)
+			layout = 0x102;
+		else if  (raiddisks == 3 && conf->rlq == DDF_RAID1_MULTI)
+			layout = 0x103;
+		else
+			return err_bad_ddf_layout(conf);
+		raiddisks *= conf->sec_elmnt_count;
+		level = 10;
+		goto good;
+	}
+
+	switch (conf->prl) {
+	case DDF_CONCAT:
+		level = LEVEL_LINEAR;
+		break;
+	case DDF_RAID0:
+		if (conf->rlq != DDF_RAID0_SIMPLE)
+			return err_bad_ddf_layout(conf);
+		level = 0;
+		break;
+	case DDF_RAID1:
+		if (!((conf->rlq == DDF_RAID1_SIMPLE && raiddisks == 2) ||
+		      (conf->rlq == DDF_RAID1_MULTI && raiddisks == 3)))
+			return err_bad_ddf_layout(conf);
+		level = 1;
+		break;
+	case DDF_RAID4:
+		if (conf->rlq != DDF_RAID4_N)
+			return err_bad_ddf_layout(conf);
+		level = 4;
+		break;
+	case DDF_RAID5:
+		switch (conf->rlq) {
+		case DDF_RAID5_N_RESTART:
+			layout = ALGORITHM_LEFT_ASYMMETRIC;
+			break;
+		case DDF_RAID5_0_RESTART:
+			layout = ALGORITHM_RIGHT_ASYMMETRIC;
+			break;
+		case DDF_RAID5_N_CONTINUE:
+			layout = ALGORITHM_LEFT_SYMMETRIC;
+			break;
+		default:
+			return err_bad_ddf_layout(conf);
+		}
+		level = 5;
+		break;
+	case DDF_RAID6:
+		switch (conf->rlq) {
+		case DDF_RAID5_N_RESTART:
+			layout = ALGORITHM_ROTATING_N_RESTART;
+			break;
+		case DDF_RAID6_0_RESTART:
+			layout = ALGORITHM_ROTATING_ZERO_RESTART;
+			break;
+		case DDF_RAID5_N_CONTINUE:
+			layout = ALGORITHM_ROTATING_N_CONTINUE;
+			break;
+		default:
+			return err_bad_ddf_layout(conf);
+		}
+		level = 6;
+		break;
+	default:
+		return err_bad_ddf_layout(conf);
+	};
+
+good:
+	array->level = level;
+	array->layout = layout;
+	array->raid_disks = raiddisks;
+	return 0;
+}
+
 static int load_ddf_header(int fd, unsigned long long lba,
 			   unsigned long long size,
 			   int type,
@@ -1032,33 +1128,6 @@ static mapping_t ddf_sec_level[] = {
 };
 #endif
 
-struct num_mapping {
-	int num1, num2;
-};
-static struct num_mapping ddf_level_num[] = {
-	{ DDF_RAID0, 0 },
-	{ DDF_RAID1, 1 },
-	{ DDF_RAID3, LEVEL_UNSUPPORTED },
-	{ DDF_RAID4, 4 },
-	{ DDF_RAID5, 5 },
-	{ DDF_RAID1E, LEVEL_UNSUPPORTED },
-	{ DDF_JBOD, LEVEL_UNSUPPORTED },
-	{ DDF_CONCAT, LEVEL_LINEAR },
-	{ DDF_RAID5E, LEVEL_UNSUPPORTED },
-	{ DDF_RAID5EE, LEVEL_UNSUPPORTED },
-	{ DDF_RAID6, 6},
-	{ MAXINT, MAXINT }
-};
-
-static int map_num1(struct num_mapping *map, int num)
-{
-	int i;
-	for (i=0 ; map[i].num1 != MAXINT; i++)
-		if (map[i].num1 == num)
-			break;
-	return map[i].num2;
-}
-
 static int all_ff(const char *guid)
 {
 	int i;
@@ -1638,8 +1707,6 @@ static void getinfo_super_ddf(struct supertype *st, struct mdinfo *info, char *m
 	}
 }
 
-static int rlq_to_layout(int rlq, int prl, int raiddisks);
-
 static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, char *map)
 {
 	struct ddf_super *ddf = st->sb;
@@ -1651,12 +1718,8 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 	__u32 *cptr;
 
 	memset(info, 0, sizeof(*info));
-	/* FIXME this returns BVD info - what if we want SVD ?? */
-
-	info->array.raid_disks    = __be16_to_cpu(vc->conf.prim_elmnt_count);
-	info->array.level	  = map_num1(ddf_level_num, vc->conf.prl);
-	info->array.layout	  = rlq_to_layout(vc->conf.rlq, vc->conf.prl,
-						  info->array.raid_disks);
+	if (layout_ddf2md(&vc->conf, &info->array) == -1)
+		return;
 	info->array.md_minor	  = -1;
 	cptr = (__u32 *)(vc->conf.guid + 16);
 	info->array.ctime	  = DECADE + __be32_to_cpu(*cptr);
@@ -2140,48 +2203,6 @@ static int layout_to_rlq(int level, int layout, int raiddisks)
 	return -1;
 }
 
-static int rlq_to_layout(int rlq, int prl, int raiddisks)
-{
-	switch(prl) {
-	case DDF_RAID0:
-		return 0; /* hopefully rlq == DDF_RAID0_SIMPLE */
-	case DDF_RAID1:
-		return 0; /* hopefully rlq == SIMPLE or MULTI depending
-			     on raiddisks*/
-	case DDF_RAID4:
-		switch(rlq) {
-		case DDF_RAID4_N:
-			return 0;
-		default:
-			/* not supported */
-			return -1; /* FIXME this isn't checked */
-		}
-	case DDF_RAID5:
-		switch(rlq) {
-		case DDF_RAID5_N_RESTART:
-			return ALGORITHM_LEFT_ASYMMETRIC;
-		case DDF_RAID5_0_RESTART:
-			return ALGORITHM_RIGHT_ASYMMETRIC;
-		case DDF_RAID5_N_CONTINUE:
-			return ALGORITHM_LEFT_SYMMETRIC;
-		default:
-			return -1;
-		}
-	case DDF_RAID6:
-		switch(rlq) {
-		case DDF_RAID5_N_RESTART:
-			return ALGORITHM_ROTATING_N_RESTART;
-		case DDF_RAID6_0_RESTART:
-			return ALGORITHM_ROTATING_ZERO_RESTART;
-		case DDF_RAID5_N_CONTINUE:
-			return ALGORITHM_ROTATING_N_CONTINUE;
-		default:
-			return -1;
-		}
-	}
-	return -1;
-}
-
 #ifndef MDASSEMBLE
 struct extent {
 	unsigned long long start, size;
@@ -3433,26 +3454,8 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 		this->next = rest;
 		rest = this;
 
-		if (vc->conf.sec_elmnt_count == 1) {
-			this->array.level = map_num1(ddf_level_num,
-						     vc->conf.prl);
-			this->array.raid_disks =
-				__be16_to_cpu(vc->conf.prim_elmnt_count);
-			this->array.layout =
-				rlq_to_layout(vc->conf.rlq, vc->conf.prl,
-					      this->array.raid_disks);
-		} else {
-			/* The only supported layout is RAID 10.
-			 * Compatibility has been checked in check_secondary()
-			 * above.
-			 */
-			this->array.level = 10;
-			this->array.raid_disks =
-				__be16_to_cpu(vc->conf.prim_elmnt_count)
-				* vc->conf.sec_elmnt_count;
-			this->array.layout = 0x100 |
-				__be16_to_cpu(vc->conf.prim_elmnt_count);
-		}
+		if (layout_ddf2md(&vc->conf, &this->array))
+			continue;
 		this->array.md_minor      = -1;
 		this->array.major_version = -1;
 		this->array.minor_version = -2;
-- 
1.7.1
