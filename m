From: mwilck@arcor.de
Subject: [PATCH 10/27] DDF: allow empty slots in virt disk table
Date: Wed,  3 Jul 2013 22:27:50 +0200
Message-ID: <1372883287-8859-11-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

The DDF code was assuming that the VD slots 0..populated_vdes
were used and the rest was unused. Remove this assumption and
deal with empty slots instead.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |  100 +++++++++++++++++++++++++++++++++-------------------------
 1 files changed, 57 insertions(+), 43 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 8b7a621..0f955be 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -447,7 +447,7 @@ struct ddf_super {
 #endif
 
 #if DEBUG
-static int all_ff(char *guid);
+static int all_ff(const char *guid);
 static void pr_state(struct ddf_super *ddf, const char *msg)
 {
 	unsigned int i;
@@ -1059,7 +1059,7 @@ static int map_num1(struct num_mapping *map, int num)
 	return map[i].num2;
 }
 
-static int all_ff(char *guid)
+static int all_ff(const char *guid)
 {
 	int i;
 	for (i = 0; i < DDF_GUID_LEN; i++)
@@ -1156,11 +1156,13 @@ static void examine_vd(int n, struct ddf_super *sb, char *guid)
 static void examine_vds(struct ddf_super *sb)
 {
 	int cnt = __be16_to_cpu(sb->virt->populated_vdes);
-	int i;
+	unsigned int i;
 	printf("  Virtual Disks : %d\n", cnt);
 
-	for (i=0; i<cnt; i++) {
+	for (i = 0; i < __be16_to_cpu(sb->virt->max_vdes); i++) {
 		struct virtual_entry *ve = &sb->virt->entries[i];
+		if (all_ff(ve->guid))
+			continue;
 		printf("\n");
 		printf("      VD GUID[%d] : ", i); print_guid(ve->guid, 1);
 		printf("\n");
@@ -1816,6 +1818,44 @@ static void make_header_guid(char *guid)
 	memcpy(guid+20, &stamp, 4);
 }
 
+static unsigned int find_unused_vde(const struct ddf_super *ddf)
+{
+	unsigned int i;
+	for (i = 0; i < __be16_to_cpu(ddf->virt->max_vdes); i++) {
+		if (all_ff(ddf->virt->entries[i].guid))
+			return i;
+	}
+	return DDF_NOTFOUND;
+}
+
+static unsigned int find_vde_by_name(const struct ddf_super *ddf,
+				     const char *name)
+{
+	unsigned int i;
+	if (name == NULL)
+		return DDF_NOTFOUND;
+	for (i = 0; i < __be16_to_cpu(ddf->virt->max_vdes); i++) {
+		if (all_ff(ddf->virt->entries[i].guid))
+			continue;
+		if (!strncmp(name, ddf->virt->entries[i].name,
+			     sizeof(ddf->virt->entries[i].name)))
+			return i;
+	}
+	return DDF_NOTFOUND;
+}
+
+static unsigned int find_vde_by_guid(const struct ddf_super *ddf,
+				     const char *guid)
+{
+	unsigned int i;
+	if (guid == NULL || all_ff(guid))
+		return DDF_NOTFOUND;
+	for (i = 0; i < __be16_to_cpu(ddf->virt->max_vdes); i++)
+		if (!memcmp(ddf->virt->entries[i].guid, guid, DDF_GUID_LEN))
+			return i;
+	return DDF_NOTFOUND;
+}
+
 static int init_super_ddf_bvd(struct supertype *st,
 			      mdu_array_info_t *info,
 			      unsigned long long size,
@@ -2209,33 +2249,13 @@ static int init_super_ddf_bvd(struct supertype *st,
 	struct vcl *vcl;
 	struct vd_config *vc;
 
-	if (__be16_to_cpu(ddf->virt->populated_vdes)
-	    >= __be16_to_cpu(ddf->virt->max_vdes)) {
-		pr_err("This ddf already has the "
-		       "maximum of %d virtual devices\n",
-		       __be16_to_cpu(ddf->virt->max_vdes));
+	if (find_vde_by_name(ddf, name) != DDF_NOTFOUND) {
+		pr_err("This ddf already has an array called %s\n", name);
 		return 0;
 	}
-
-	if (name)
-		for (venum = 0; venum < __be16_to_cpu(ddf->virt->max_vdes); venum++)
-			if (!all_ff(ddf->virt->entries[venum].guid)) {
-				char *n = ddf->virt->entries[venum].name;
-
-				if (strncmp(name, n, 16) == 0) {
-					pr_err("This ddf already"
-					       " has an array called %s\n",
-					       name);
-					return 0;
-				}
-			}
-
-	for (venum = 0; venum < __be16_to_cpu(ddf->virt->max_vdes); venum++)
-		if (all_ff(ddf->virt->entries[venum].guid))
-			break;
-	if (venum == __be16_to_cpu(ddf->virt->max_vdes)) {
-		pr_err("Cannot find spare slot for "
-		       "virtual disk - DDF is corrupt\n");
+	venum = find_unused_vde(ddf);
+	if (venum == DDF_NOTFOUND) {
+		pr_err("Cannot find spare slot for virtual disk\n");
 		return 0;
 	}
 	ve = &ddf->virt->entries[venum];
@@ -3760,8 +3780,8 @@ static int ddf_open_new(struct supertype *c, struct active_array *a, char *inst)
 {
 	struct ddf_super *ddf = c->sb;
 	int n = atoi(inst);
-	if (n >= (int)__be16_to_cpu(ddf->virt->populated_vdes)) {
-		pr_err("%s: subarray index %d out of range\n", __func__, n);
+	if (all_ff(ddf->virt->entries[n].guid)) {
+		pr_err("%s: subarray %d doesn't exist\n", __func__, n);
 		return -ENODEV;
 	}
 	dprintf("ddf: open_new %d\n", n);
@@ -4112,10 +4132,8 @@ static void ddf_process_update(struct supertype *st,
 			return;
 		vd = (struct virtual_disk*)update->buf;
 
-		ent = __be16_to_cpu(vd->populated_vdes);
-		if (ent >= __be16_to_cpu(ddf->virt->max_vdes))
-			return;
-		if (!all_ff(ddf->virt->entries[ent].guid))
+		ent = find_unused_vde(ddf);
+		if (ent == DDF_NOTFOUND)
 			return;
 		ddf->virt->entries[ent] = vd->entries[0];
 		ddf->virt->populated_vdes = __cpu_to_be16(1 +
@@ -4150,14 +4168,10 @@ static void ddf_process_update(struct supertype *st,
 			memcpy(&vcl->conf, vc, update->len);
 			vcl->lba_offset = (__u64*)
 				&vcl->conf.phys_refnum[mppe];
-			for (ent = 0;
-			     ent < __be16_to_cpu(ddf->virt->populated_vdes);
-			     ent++)
-				if (memcmp(vc->guid, ddf->virt->entries[ent].guid,
-					   DDF_GUID_LEN) == 0) {
-					vcl->vcnum = ent;
-					break;
-				}
+			ent = find_vde_by_guid(ddf, vc->guid);
+			if (ent == DDF_NOTFOUND)
+				return;
+			vcl->vcnum = ent;
 			ddf->conflist = vcl;
 		}
 		/* Set DDF_Transition on all Failed devices - to help
-- 
1.7.1
