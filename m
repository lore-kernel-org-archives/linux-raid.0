Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270ACC432BE
	for <linux-raid@archiver.kernel.org>; Thu,  2 Sep 2021 09:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0297D61041
	for <linux-raid@archiver.kernel.org>; Thu,  2 Sep 2021 09:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245455AbhIBJtT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Sep 2021 05:49:19 -0400
Received: from mga07.intel.com ([134.134.136.100]:63795 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245263AbhIBJtN (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 2 Sep 2021 05:49:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10094"; a="282764828"
X-IronPort-AV: E=Sophos;i="5.84,372,1620716400"; 
   d="scan'208";a="282764828"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 02:48:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,371,1620716400"; 
   d="scan'208";a="499667354"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.57])
  by fmsmga008.fm.intel.com with ESMTP; 02 Sep 2021 02:48:13 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] Refactor parse_num and use it to parse optarg.
Date:   Thu,  2 Sep 2021 11:48:12 +0200
Message-Id: <20210902094812.25818-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Use parse_num instead of atoi to parse optarg. Replace atoi by strtol.
Move inst to int conversion into manage_new. Add better error handling.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 lib.c         | 28 ++++++++++++++++++++++++++++
 managemon.c   | 32 ++++++++++++++++++++------------
 mdadm.c       | 50 ++++++++++++++++++--------------------------------
 mdadm.h       |  4 ++--
 super-ddf.c   | 17 ++++++++---------
 super-intel.c | 10 +++++-----
 util.c        | 13 ++-----------
 7 files changed, 83 insertions(+), 71 deletions(-)

diff --git a/lib.c b/lib.c
index 60890b95..76d1fbb9 100644
--- a/lib.c
+++ b/lib.c
@@ -25,6 +25,7 @@
 #include	"mdadm.h"
 #include	"dlink.h"
 #include	<ctype.h>
+#include	<limits.h>
 
 /* This fill contains various 'library' style function.  They
  * have no dependency on anything outside this file.
@@ -534,3 +535,30 @@ void free_line(char *line)
 	}
 	dl_free(line);
 }
+
+/**
+ * parse_num() - Parse int from string.
+ * @dest: Pointer to destination.
+ * @num: Pointer to string that is going to be parsed.
+ *
+ * If string contains anything after a number, error code is returned.
+ * The same happens when number is bigger than INT_MAX or smaller than 0.
+ * Writes to destination only if successfully read the number.
+ *
+ * Return: 0 on success, 1 otherwise.
+ */
+int parse_num(int *dest, char *num)
+{
+	char *c = NULL;
+	long temp;
+
+	if (!num)
+		return 1;
+
+	errno = 0;
+	temp = strtol(num, &c, 10);
+	if (temp < 0 || temp > INT_MAX || *c || errno != 0 || num == c)
+		return 1;
+	*dest = temp;
+	return 0;
+}
diff --git a/managemon.c b/managemon.c
index 200cf83e..bb7334cf 100644
--- a/managemon.c
+++ b/managemon.c
@@ -661,18 +661,17 @@ static void manage_new(struct mdstat_ent *mdstat,
 	 * the monitor.
 	 */
 
-	struct active_array *new;
-	struct mdinfo *mdi, *di;
-	char *inst;
-	int i;
+	struct active_array *new = NULL;
+	struct mdinfo *mdi = NULL, *di;
+	int i, inst;
 	int failed = 0;
 	char buf[40];
 
 	/* check if array is ready to be monitored */
 	if (!mdstat->active || !mdstat->level)
 		return;
-	if (strcmp(mdstat->level, "raid0") == 0 ||
-	    strcmp(mdstat->level, "linear") == 0)
+	if (strncmp(mdstat->level, "raid0", strlen("raid0")) == 0 ||
+	    strncmp(mdstat->level, "linear", strlen("linear")) == 0)
 		return;
 
 	mdi = sysfs_read(-1, mdstat->devnm,
@@ -691,7 +690,8 @@ static void manage_new(struct mdstat_ent *mdstat,
 
 	new->container = container;
 
-	inst = to_subarray(mdstat, container->devnm);
+	if (parse_num(&inst, to_subarray(mdstat, container->devnm)) != 0)
+		goto error;
 
 	new->info.array = mdi->array;
 	new->info.component_size = mdi->component_size;
@@ -724,7 +724,7 @@ static void manage_new(struct mdstat_ent *mdstat,
 	new->safe_mode_delay_fd = sysfs_open2(new->info.sys_name, NULL,
 					      "safe_mode_delay");
 
-	dprintf("inst: %s action: %d state: %d\n", inst,
+	dprintf("inst: %d action: %d state: %d\n", inst,
 		new->action_fd, new->info.state_fd);
 
 	if (mdi->safe_mode_delay >= 50)
@@ -759,15 +759,13 @@ static void manage_new(struct mdstat_ent *mdstat,
 	}
 
 	sysfs_free(mdi);
+	mdi = NULL;
 
 	/* if everything checks out tell the metadata handler we want to
 	 * manage this instance
 	 */
 	if (!aa_ready(new) || container->ss->open_new(container, new, inst) < 0) {
-		pr_err("failed to monitor %s\n",
-			mdstat->metadata_version);
-		new->container = NULL;
-		free_aa(new);
+		goto error;
 	} else {
 		replace_array(container, victim, new);
 		if (failed) {
@@ -775,6 +773,16 @@ static void manage_new(struct mdstat_ent *mdstat,
 			manage_member(mdstat, new);
 		}
 	}
+	return;
+
+error:
+	pr_err("failed to monitor %s\n", mdstat->metadata_version);
+	if (new) {
+		new->container = NULL;
+		free_aa(new);
+	}
+	if (mdi)
+		sysfs_free(mdi);
 }
 
 void manage(struct mdstat_ent *mdstat, struct supertype *container)
diff --git a/mdadm.c b/mdadm.c
index 073b7241..a31ab99c 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -610,8 +610,7 @@ int main(int argc, char *argv[])
 					s.raiddisks, optarg);
 				exit(2);
 			}
-			s.raiddisks = parse_num(optarg);
-			if (s.raiddisks <= 0) {
+			if (parse_num(&s.raiddisks, optarg) != 0 || s.raiddisks <= 0) {
 				pr_err("invalid number of raid devices: %s\n",
 					optarg);
 				exit(2);
@@ -621,8 +620,7 @@ int main(int argc, char *argv[])
 		case O(ASSEMBLE, Nodes):
 		case O(GROW, Nodes):
 		case O(CREATE, Nodes):
-			c.nodes = parse_num(optarg);
-			if (c.nodes < 2) {
+			if (parse_num(&c.nodes, optarg) != 0 || c.nodes < 2) {
 				pr_err("clustered array needs two nodes at least: %s\n",
 					optarg);
 				exit(2);
@@ -647,8 +645,7 @@ int main(int argc, char *argv[])
 					s.level);
 				exit(2);
 			}
-			s.sparedisks = parse_num(optarg);
-			if (s.sparedisks < 0) {
+			if (parse_num(&s.sparedisks, optarg) != 0 || s.sparedisks < 0) {
 				pr_err("invalid number of spare-devices: %s\n",
 					optarg);
 				exit(2);
@@ -732,12 +729,9 @@ int main(int argc, char *argv[])
 			}
 			if (strcmp(optarg, "dev") == 0)
 				ident.super_minor = -2;
-			else {
-				ident.super_minor = parse_num(optarg);
-				if (ident.super_minor < 0) {
-					pr_err("Bad super-minor number: %s.\n", optarg);
-					exit(2);
-				}
+			else if (parse_num(&ident.super_minor, optarg) != 0 || ident.super_minor < 0) {
+				pr_err("Bad super-minor number: %s.\n", optarg);
+				exit(2);
 			}
 			continue;
 
@@ -907,8 +901,8 @@ int main(int argc, char *argv[])
 
 		case O(MONITOR,'r'): /* rebuild increments */
 		case O(MONITOR,Increment):
-			increments = atoi(optarg);
-			if (increments > 99 || increments < 1) {
+			if (parse_num(&increments, optarg) != 0
+				|| increments > 99 || increments < 1) {
 				pr_err("please specify positive integer between 1 and 99 as rebuild increments.\n");
 				exit(2);
 			}
@@ -919,15 +913,10 @@ int main(int argc, char *argv[])
 		case O(BUILD,'d'): /* delay for bitmap updates */
 		case O(CREATE,'d'):
 			if (c.delay)
-				pr_err("only specify delay once. %s ignored.\n",
-					optarg);
-			else {
-				c.delay = parse_num(optarg);
-				if (c.delay < 1) {
-					pr_err("invalid delay: %s\n",
-						optarg);
-					exit(2);
-				}
+				pr_err("only specify delay once. %s ignored.\n", optarg);
+			else if (parse_num(&c.delay, optarg) != 0 || c.delay < 1) {
+				pr_err("invalid delay: %s\n", optarg);
+				exit(2);
 			}
 			continue;
 		case O(MONITOR,'f'): /* daemonise */
@@ -1209,18 +1198,15 @@ int main(int argc, char *argv[])
 
 		case O(GROW, WriteBehind):
 		case O(BUILD, WriteBehind):
-		case O(CREATE, WriteBehind): /* write-behind mode */
+		case O(CREATE, WriteBehind):
 			s.write_behind = DEFAULT_MAX_WRITE_BEHIND;
-			if (optarg) {
-				s.write_behind = parse_num(optarg);
-				if (s.write_behind < 0 ||
-				    s.write_behind > 16383) {
-					pr_err("Invalid value for maximum outstanding write-behind writes: %s.\n\tMust be between 0 and 16383.\n", optarg);
-					exit(2);
-				}
+			if (parse_num(&s.write_behind, optarg) != 0 ||
+			s.write_behind < 0 || s.write_behind > 16383) {
+				pr_err("Invalid value for maximum outstanding write-behind writes: %s.\n\tMust be between 0 and 16383.\n",
+						optarg);
+				exit(2);
 			}
 			continue;
-
 		case O(INCREMENTAL, 'r'):
 		case O(INCREMENTAL, RebuildMapOpt):
 			rebuild_map = 1;
diff --git a/mdadm.h b/mdadm.h
index 8f8841d8..53ea0de6 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1077,7 +1077,7 @@ extern struct superswitch {
 
 /* for mdmon */
 	int (*open_new)(struct supertype *c, struct active_array *a,
-			char *inst);
+			int inst);
 
 	/* Tell the metadata handler the current state of the array.
 	 * This covers whether it is known to be consistent (no pending writes)
@@ -1488,7 +1488,7 @@ extern int parse_uuid(char *str, int uuid[4]);
 extern int is_near_layout_10(int layout);
 extern int parse_layout_10(char *layout);
 extern int parse_layout_faulty(char *layout);
-extern long parse_num(char *num);
+extern int parse_num(int *dest, char *num);
 extern int parse_cluster_confirm_arg(char *inp, char **devname, int *slot);
 extern int check_ext2(int fd, char *name);
 extern int check_reiser(int fd, char *name);
diff --git a/super-ddf.c b/super-ddf.c
index dc8e512f..afbe3b73 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4057,20 +4057,19 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst,
  * We need to confirm that the array matches the metadata in 'c' so
  * that we don't corrupt any metadata.
  */
-static int ddf_open_new(struct supertype *c, struct active_array *a, char *inst)
+static int ddf_open_new(struct supertype *c, struct active_array *a, int inst)
 {
 	struct ddf_super *ddf = c->sb;
-	int n = atoi(inst);
 	struct mdinfo *dev;
 	struct dl *dl;
 	static const char faulty[] = "faulty";
 
-	if (all_ff(ddf->virt->entries[n].guid)) {
-		pr_err("subarray %d doesn't exist\n", n);
+	if (all_ff(ddf->virt->entries[inst].guid)) {
+		pr_err("subarray %d doesn't exist\n", inst);
 		return -ENODEV;
 	}
-	dprintf("new subarray %d, GUID: %s\n", n,
-		guid_str(ddf->virt->entries[n].guid));
+	dprintf("new subarray %d, GUID: %s\n", inst,
+		guid_str(ddf->virt->entries[inst].guid));
 	for (dev = a->info.devs; dev; dev = dev->next) {
 		for (dl = ddf->dlist; dl; dl = dl->next)
 			if (dl->major == dev->disk.major &&
@@ -4078,13 +4077,13 @@ static int ddf_open_new(struct supertype *c, struct active_array *a, char *inst)
 				break;
 		if (!dl || dl->pdnum < 0) {
 			pr_err("device %d/%d of subarray %d not found in meta data\n",
-				dev->disk.major, dev->disk.minor, n);
+				dev->disk.major, dev->disk.minor, inst);
 			return -1;
 		}
 		if ((be16_to_cpu(ddf->phys->entries[dl->pdnum].state) &
 			(DDF_Online|DDF_Missing|DDF_Failed)) != DDF_Online) {
 			pr_err("new subarray %d contains broken device %d/%d (%02x)\n",
-			       n, dl->major, dl->minor,
+			       inst, dl->major, dl->minor,
 			       be16_to_cpu(ddf->phys->entries[dl->pdnum].state));
 			if (write(dev->state_fd, faulty, sizeof(faulty)-1) !=
 			    sizeof(faulty) - 1)
@@ -4092,7 +4091,7 @@ static int ddf_open_new(struct supertype *c, struct active_array *a, char *inst)
 			dev->curr_state = DS_FAULTY;
 		}
 	}
-	a->info.container_member = n;
+	a->info.container_member = inst;
 	return 0;
 }
 
diff --git a/super-intel.c b/super-intel.c
index 83ddc000..08c64409 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8263,19 +8263,19 @@ static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev,
 }
 
 static int imsm_open_new(struct supertype *c, struct active_array *a,
-			 char *inst)
+			 int inst)
 {
 	struct intel_super *super = c->sb;
 	struct imsm_super *mpb = super->anchor;
 	struct imsm_update_prealloc_bb_mem u;
 
-	if (atoi(inst) >= mpb->num_raid_devs) {
-		pr_err("subarry index %d, out of range\n", atoi(inst));
+	if (inst >= mpb->num_raid_devs) {
+		pr_err("subarry index %d, out of range\n", inst);
 		return -ENODEV;
 	}
 
-	dprintf("imsm: open_new %s\n", inst);
-	a->info.container_member = atoi(inst);
+	dprintf("imsm: open_new %d\n", inst);
+	a->info.container_member = inst;
 
 	u.type = update_prealloc_badblocks_mem;
 	imsm_update_metadata_locally(c, &u, sizeof(u));
diff --git a/util.c b/util.c
index cdf1da24..263e074a 100644
--- a/util.c
+++ b/util.c
@@ -422,6 +422,8 @@ int parse_layout_10(char *layout)
 
 int parse_layout_faulty(char *layout)
 {
+	if (!layout)
+		return -1;
 	/* Parse the layout string for 'faulty' */
 	int ln = strcspn(layout, "0123456789");
 	char *m = xstrdup(layout);
@@ -434,17 +436,6 @@ int parse_layout_faulty(char *layout)
 	return mode | (atoi(layout+ln)<< ModeShift);
 }
 
-long parse_num(char *num)
-{
-	/* Either return a valid number, or -1 */
-	char *c;
-	long rv = strtol(num, &c, 10);
-	if (rv < 0 || *c || !num[0])
-		return -1;
-	else
-		return rv;
-}
-
 int parse_cluster_confirm_arg(char *input, char **devname, int *slot)
 {
 	char *dev;
-- 
2.26.2

