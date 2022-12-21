Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B12C10F1B
	for <linux-raid@archiver.kernel.org>; Wed, 21 Dec 2022 11:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbiLULul (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Dec 2022 06:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiLULuh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Dec 2022 06:50:37 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CF61DA46
        for <linux-raid@vger.kernel.org>; Wed, 21 Dec 2022 03:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671623436; x=1703159436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sQVmX50NpgyI/svMM610+cYaFzfQ0g+qo7Xh8k7ylVg=;
  b=gfO8TYTMi2X+F/csiN4wCMMa9fsjYhnOqlpmCftfrf9GsOan3EtaGhe+
   kvPhN1ZWVYDKDprWY1U8T8Z4+VaiOPHehb02pAGq+tOd5VBGoGkFNP36z
   booEu52PwLd/uWfflD6yMTbeHrwaW0+edQ8GZZgS42YxNoTLqNEm0AVsC
   5vkHJbrk+946OtzszCY3zu52yEPgD0YihpakX4hAL72du99LCuEgbJgHF
   LYwCupx89A9ZdMMiMrmdIcN91+iF6QAnmvbEMPJzWZK4GxUpxSbiduUSY
   osQ6DwfwTQZAB/f/drjneLf7V8/2qs5YCbMni5LwX96lBKSZJpnYOIY1l
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="321765635"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="321765635"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 03:50:35 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="714799030"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="714799030"
Received: from mtkaczyk-devel.elements.local ([10.102.105.40])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 03:50:34 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, colyli@suse.de
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 2/3] mdadm: refactor ident->name handling
Date:   Wed, 21 Dec 2022 12:50:18 +0100
Message-Id: <20221221115019.26276-3-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com>
References: <20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Move duplicated code for both config.c and mdadm.c to new functions.
Add error enum in mdadm.h. Use MD_NAME_MAX instead hardcoded value
in mddev_ident. Use secure functions.

In next patch POSIX validation is added.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 config.c | 35 +++++++++++++++++++++++++++--------
 lib.c    | 16 ++++++++++++++++
 mdadm.c  | 16 ++++------------
 mdadm.h  | 21 +++++++++++++++------
 util.c   | 20 ++++++++++++++++++++
 5 files changed, 82 insertions(+), 26 deletions(-)

diff --git a/config.c b/config.c
index eeedd0c6..7d3eb6fc 100644
--- a/config.c
+++ b/config.c
@@ -147,6 +147,32 @@ inline void ident_init(struct mddev_ident *ident)
 	ident->uuid_set = 0;
 }
 
+/**
+ * ident_set_name()- set name in &mddev_ident.
+ * @ident: pointer to &mddev_ident.
+ * @name: name to be set.
+ *
+ * If criteria passed, set name in @ident.
+ *
+ * Return: %STATUS_SUCCESS or %STATUS_ERROR.
+ */
+status_t ident_set_name(struct mddev_ident *ident, const char *name)
+{
+	assert(name);
+	assert(ident);
+
+	if (ident->name[0]) {
+		pr_err("Name can be specified once, second value is '%s'.\n", name);
+		return STATUS_ERROR;
+	}
+
+	if (check_mdname(name) == STATUS_ERROR)
+		return STATUS_ERROR;
+
+	snprintf(ident->name, MD_NAME_MAX + 1, "%s", name);
+	return STATUS_SUCCESS;
+}
+
 struct conf_dev {
 	struct conf_dev *next;
 	char *name;
@@ -445,14 +471,7 @@ void arrayline(char *line)
 					mis.super_minor = minor;
 			}
 		} else if (strncasecmp(w, "name=", 5) == 0) {
-			if (mis.name[0])
-				pr_err("only specify name once, %s ignored.\n",
-					w);
-			else if (strlen(w + 5) > 32)
-				pr_err("name too long, ignoring %s\n", w);
-			else
-				strcpy(mis.name, w + 5);
-
+			ident_set_name(&mis, w + 5);
 		} else if (strncasecmp(w, "bitmap=", 7) == 0) {
 			if (mis.bitmap_file)
 				pr_err("only specify bitmap file once. %s ignored\n",
diff --git a/lib.c b/lib.c
index e395b28d..624580e1 100644
--- a/lib.c
+++ b/lib.c
@@ -27,6 +27,22 @@
 #include	<ctype.h>
 #include	<limits.h>
 
+/**
+ * is_strnlen_lq() - Check if string length is lower or equal to requested.
+ * @str: string to check.
+ * @max_len: max length.
+ *
+ * @str length must be bigger than 0 and be lower or equal @max_len, including termination byte.
+ */
+bool is_strnlen_lq(const char * const str, size_t max_len)
+{
+	assert(str);
+
+	size_t _len = strnlen(str, max_len);
+
+	return (_len < max_len && _len != 0);
+}
+
 bool is_dev_alive(char *path)
 {
 	if (!path)
diff --git a/mdadm.c b/mdadm.c
index 74fdec31..5bd3d5a7 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -686,20 +686,14 @@ int main(int argc, char *argv[])
 		case O(CREATE,'N'):
 		case O(ASSEMBLE,'N'):
 		case O(MISC,'N'):
-			if (ident.name[0]) {
-				pr_err("name cannot be set twice.   Second value %s.\n", optarg);
-				exit(2);
-			}
 			if (mode == MISC && !c.subarray) {
 				pr_err("-N/--name only valid with --update-subarray in misc mode\n");
 				exit(2);
 			}
-			if (strlen(optarg) > 32) {
-				pr_err("name '%s' is too long, 32 chars max.\n",
-					optarg);
+
+			if (ident_set_name(&ident, optarg) != STATUS_SUCCESS)
 				exit(2);
-			}
-			strcpy(ident.name, optarg);
+
 			continue;
 
 		case O(ASSEMBLE,'m'): /* super-minor for array */
@@ -1341,10 +1335,8 @@ int main(int argc, char *argv[])
 		} else {
 			char *bname = basename(devlist->devname);
 
-			if (strlen(bname) > MD_NAME_MAX) {
-				pr_err("Name %s is too long.\n", devlist->devname);
+			if (check_mdname(bname))
 				exit(1);
-			}
 
 			ret = stat(devlist->devname, &stb);
 			if (ident.super_minor == -2 && ret != 0) {
diff --git a/mdadm.h b/mdadm.h
index 23ffe977..b68fa4bc 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -275,6 +275,11 @@ static inline void __put_unaligned32(__u32 val, void *p)
 
 #define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))
 
+/**
+ * This is true for native and DDF, IMSM allows 16.
+ */
+#define MD_NAME_MAX 32
+
 extern const char Name[];
 
 struct md_bb_entry {
@@ -406,6 +411,12 @@ struct spare_criteria {
 	unsigned int sector_size;
 };
 
+typedef enum status {
+	STATUS_SUCCESS = 0,
+	STATUS_ERROR,
+	STATUS_UNDEF,
+} status_t;
+
 enum mode {
 	ASSEMBLE=1,
 	BUILD,
@@ -528,7 +539,7 @@ struct mddev_ident {
 
 	int	uuid_set;
 	int	uuid[4];
-	char	name[33];
+	char	name[MD_NAME_MAX + 1];
 
 	int super_minor;
 
@@ -1538,6 +1549,7 @@ extern int check_partitions(int fd, char *dname,
 extern int fstat_is_blkdev(int fd, char *devname, dev_t *rdev);
 extern int stat_is_blkdev(char *devname, dev_t *rdev);
 
+extern bool is_strnlen_lq(const char * const str, size_t max_len);
 extern bool is_dev_alive(char *path);
 extern int get_mdp_major(void);
 extern int get_maj_min(char *dev, int *major, int *minor);
@@ -1555,6 +1567,7 @@ extern void manage_fork_fds(int close_all);
 extern int continue_via_systemd(char *devnm, char *service_name);
 
 extern void ident_init(struct mddev_ident *ident);
+extern status_t ident_set_name(struct mddev_ident *ident, const char *name);
 
 extern int parse_auto(char *str, char *msg, int config);
 extern struct mddev_ident *conf_get_ident(char *dev);
@@ -1634,6 +1647,7 @@ extern void print_r10_layout(int layout);
 
 extern char *find_free_devnm(int use_partitions);
 
+extern error_t check_mdname(const char *name);
 extern void put_md_name(char *name);
 extern char *devid2kname(dev_t devid);
 extern char *devid2devnm(dev_t devid);
@@ -1923,11 +1937,6 @@ enum r0layout {
 /* And another special number needed for --data_offset=variable */
 #define VARIABLE_OFFSET 3
 
-/**
- * This is true for native and DDF, IMSM allows 16.
- */
-#define MD_NAME_MAX 32
-
 /**
  * is_container() - check if @level is &LEVEL_CONTAINER
  * @level: level value
diff --git a/util.c b/util.c
index 26ffdcea..b2a4ea21 100644
--- a/util.c
+++ b/util.c
@@ -932,6 +932,26 @@ int get_data_disks(int level, int layout, int raid_disks)
 	return data_disks;
 }
 
+/**
+ * check_md_name()- check if MD device name is correct.
+ * @name: name to check.
+ *
+ * In case of error, message is printed.
+ *
+ * Return: %STATUS_SUCCESS or %STATUS_ERROR.
+ */
+error_t check_mdname(const char * const name)
+{
+	assert(name);
+
+	if (!is_strnlen_lq(name, MD_NAME_MAX + 1)) {
+		pr_err("Name '%s' is too long or empty, %d characters max.\n", name, MD_NAME_MAX);
+		return STATUS_ERROR;
+	}
+
+	return STATUS_SUCCESS;
+}
+
 dev_t devnm2devid(char *devnm)
 {
 	/* First look in /sys/block/$DEVNM/dev for %d:%d
-- 
2.26.2

