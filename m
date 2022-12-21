Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D459C4332F
	for <linux-raid@archiver.kernel.org>; Wed, 21 Dec 2022 11:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234575AbiLULup (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Dec 2022 06:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiLULum (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Dec 2022 06:50:42 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD24E8
        for <linux-raid@vger.kernel.org>; Wed, 21 Dec 2022 03:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671623439; x=1703159439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dpzH/EFSmFu7rM7p8pCWzfbBt1nmvqXN5syNYQjno80=;
  b=gxur13xo7oQi/J59gloP4kdR3cioALpPxz3Vxyqfu28RFjNiwOpdWsoc
   J/64VZtujlHgyRKUaA4Aw6CvlpY04eSTOZWc4EUZMXWlUBtObSAi1+7kz
   z+wnVF5hcsGqlgbI4p3UrqI5J7vDgOTVwpXCN22dVqtVDW3AzL0JYkoDo
   mRIHe8ynVZUMjCGzxhcJI6gzdxHCGAloNxe9KymjwzaqQ1DUomSOap6zc
   Mo4dlZLkX9FmGbSm0PujalS62Oo98Gtm+nWSUYDP9sueuIDTuglq65tOM
   WCcNb846yCnq8ATmcfmLdoDx7Nc/AhtQx5GV/XUxbhCuhjHxr+LZKeCLG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="321765645"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="321765645"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 03:50:38 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="714799034"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="714799034"
Received: from mtkaczyk-devel.elements.local ([10.102.105.40])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 03:50:36 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, colyli@suse.de
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 3/3] Limit length and set of characters allowed of devname
Date:   Wed, 21 Dec 2022 12:50:19 +0100
Message-Id: <20221221115019.26276-4-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com>
References: <20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When the user creates a device with a name that contains whitespace,
mdadm timeouts and throws an error. This issue is caused by udev, which
truncates /dev/md link until the first whitespace.

This patch introduces prohibition of characters other than A-Za-z0-9.-_
in the device name. Also, it prohibits using leading "-" in device name,
so name won't be confused with cli parameter.
Set of allowed characters is taken from POSIX 3.280 Portable Character
Set. Also, device name length now is limited to NAME_MAX.

In some places there are other requirements for string length (e.g. size
up to MD_NAME_MAX for device name). This routine is made to follow POSIX
and other, more strict limitations should be checked separately.
We are aware of the risk of regression in exceptional cases (as
escape_devname function is removed) that should be fixed by updating
the array name.

The posix validation is added for:
- 'name' parameter in every mode.
- secondary device name (first devlist entry), only for create and
assembly.

To limit regression risk, config entries are excluded from POSIX
validation.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Detail.c        |  8 ++-----
 config.c        |  7 +++---
 lib.c           | 64 +++++++++++++++++++++++++++++++++++++------------
 mdadm.8.in      | 57 +++++++++++++++++++++----------------------
 mdadm.c         |  4 ++--
 mdadm.conf.5.in |  4 ----
 mdadm.h         |  8 ++++---
 super-intel.c   | 25 ++++++-------------
 super1.c        |  3 +--
 util.c          |  6 ++++-
 10 files changed, 102 insertions(+), 84 deletions(-)

diff --git a/Detail.c b/Detail.c
index ce7a8445..b206159e 100644
--- a/Detail.c
+++ b/Detail.c
@@ -256,9 +256,7 @@ int Detail(char *dev, struct context *c)
 			mp = map_by_uuid(&map, info->uuid);
 			if (mp && mp->path &&
 			    strncmp(mp->path, "/dev/md/", 8) == 0) {
-				printf("MD_DEVNAME=");
-				print_escape(mp->path + 8);
-				putchar('\n');
+				printf("MD_DEVNAME=%s\n", mp->path + 8);
 			}
 
 			if (st->ss->export_detail_super)
@@ -274,9 +272,7 @@ int Detail(char *dev, struct context *c)
 			}
 			if (mp && mp->path &&
 			    strncmp(mp->path, "/dev/md/", 8) == 0) {
-				printf("MD_DEVNAME=");
-				print_escape(mp->path+8);
-				putchar('\n');
+				printf("MD_DEVNAME=%s\n", mp->path + 8);
 			}
 			map_free(map);
 		}
diff --git a/config.c b/config.c
index 7d3eb6fc..3b7a0921 100644
--- a/config.c
+++ b/config.c
@@ -151,12 +151,13 @@ inline void ident_init(struct mddev_ident *ident)
  * ident_set_name()- set name in &mddev_ident.
  * @ident: pointer to &mddev_ident.
  * @name: name to be set.
+ * @check_posix: if set, verify compatibility with POSIX.
  *
  * If criteria passed, set name in @ident.
  *
  * Return: %STATUS_SUCCESS or %STATUS_ERROR.
  */
-status_t ident_set_name(struct mddev_ident *ident, const char *name)
+status_t ident_set_name(struct mddev_ident *ident, const char *name, const bool check_posix)
 {
 	assert(name);
 	assert(ident);
@@ -166,7 +167,7 @@ status_t ident_set_name(struct mddev_ident *ident, const char *name)
 		return STATUS_ERROR;
 	}
 
-	if (check_mdname(name) == STATUS_ERROR)
+	if (check_mdname(name, check_posix) == STATUS_ERROR)
 		return STATUS_ERROR;
 
 	snprintf(ident->name, MD_NAME_MAX + 1, "%s", name);
@@ -471,7 +472,7 @@ void arrayline(char *line)
 					mis.super_minor = minor;
 			}
 		} else if (strncasecmp(w, "name=", 5) == 0) {
-			ident_set_name(&mis, w + 5);
+			ident_set_name(&mis, w + 5, false);
 		} else if (strncasecmp(w, "bitmap=", 7) == 0) {
 			if (mis.bitmap_file)
 				pr_err("only specify bitmap file once. %s ignored\n",
diff --git a/lib.c b/lib.c
index 624580e1..58ebfb83 100644
--- a/lib.c
+++ b/lib.c
@@ -481,24 +481,58 @@ void print_quoted(char *str)
 	putchar(q);
 }
 
-void print_escape(char *str)
+/**
+ * is_alphanum() - Check if sign is letter or digit.
+ * @c: char to analyze.
+ *
+ * Similar to isalnum() but additional locales are excluded.
+ *
+ * Return: 1 on success, 0 on fail, accordingly to isalnum().
+ */
+bool is_alphanum(const char c)
 {
-	/* print str, but change space and tab to '_'
-	 * as is suitable for device names
-	 */
-	for (; *str; str++) {
-		switch (*str) {
-		case ' ':
-		case '\t':
-			putchar('_');
-			break;
-		case '/':
-			putchar('-');
-			break;
-		default:
-			putchar(*str);
+	return isupper(c) || islower(c) || isdigit(c);
+}
+
+/**
+ * is_name_posix_compatible() - Check if name is POSIX compatible.
+ * @name: name to check.
+ *
+ *  POSIX portable file name character set contains ASCII letters,
+ *  digits, '_', '.', and '-'. Also forbid leading '-'.
+ *  The length of the name cannot exceed NAME_MAX - 1 (ensure NULL ending).
+ *
+ * Return: %true on success, %false otherwise.
+ */
+bool is_name_posix_compatible(const char * const name)
+{
+	assert(name);
+
+	char allowed_symbols[] = "-_.";
+	char *reason = NULL;
+	const char *n = name;
+
+	if (!is_strnlen_lq(name, NAME_MAX)) {
+		reason = "Wrong size";
+		goto err;
+	}
+	if (*name == '-') {
+		reason = "Leading '-' detected";
+		goto err;
+	}
+
+	while (*n != '\0') {
+		if (!is_alphanum(*n) && !strchr(allowed_symbols, *n)) {
+			reason = "Not allowed symbol detected";
+			goto err;
 		}
+
+		n++;
 	}
+	return true;
+err:
+	pr_err("Name \"%s\" in not POSIX compatible, reason: %s.\n", name, reason);
+	return false;
 }
 
 int check_env(char *name)
diff --git a/mdadm.8.in b/mdadm.8.in
index 70c79d1e..046fb71f 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -916,17 +916,19 @@ option will be ignored.
 .BR \-N ", " \-\-name=
 Set a
 .B name
-for the array.  This is currently only effective when creating an
-array with a version-1 superblock, or an array in a DDF container.
+for the array. This is currently only effective when creating an
+array with a version-1 superblock, or an array in a external container.
 The name is a simple textual string that can be used to identify array
-components when assembling.  If name is needed but not specified, it
-is taken from the basename of the device that is being created.
-e.g. when creating
-.I /dev/md/home
-the
-.B name
-will default to
-.IR home .
+components when assembling.
+
+A valid name can only consist of characters "A-Za-z0-9.-_".
+The name cannot start with a leading "-" and cannot exceed NAME_MAX.
+The long name could be truncated or rejected, it depends of strict checks for
+metadata type.
+
+If name is needed but not specified, it is taken from the basename of the device
+that is being created. See
+.BR "DEVICE NAMES"
 
 .TP
 .BR \-R ", " \-\-run
@@ -2163,14 +2165,17 @@ Usage:
 .I md-device
 .BI \-\-chunk= X
 .BI \-\-level= Y
-.br
 .BI \-\-raid\-devices= Z
 .I devices
 
 .PP
-This usage will initialise a new md array, associate some devices with
+This usage will initialize a new md array, associate some devices with
 it, and activate the array.
 
+.I md-device
+is a new device. This could be standard name or chosen name. For details see:
+.BR "DEVICE NAMES"
+
 The named device will normally not exist when
 .I "mdadm \-\-create"
 is run, but will be created by
@@ -2211,24 +2216,6 @@ array.  This feature can be overridden with the
 .B \-\-force
 option.
 
-When creating an array with version-1 metadata a name for the array is
-required.
-If this is not given with the
-.B \-\-name
-option,
-.I mdadm
-will choose a name based on the last component of the name of the
-device being created.  So if
-.B /dev/md3
-is being created, then the name
-.B 3
-will be chosen.
-If
-.B /dev/md/home
-is being created, then the name
-.B home
-will be used.
-
 When creating a partition based array, using
 .I mdadm
 with version-1.x metadata, the partition type should be set to
@@ -2420,6 +2407,11 @@ re\-assembled.  If updating
 would change the UUID of an active subarray this operation is blocked,
 and the command will end in an error.
 
+A valid name can only consist of characters "A-Za-z0-9.-_".
+The name cannot start with a leading "-" and cannot exceed NAME_MAX.
+The long name could be truncated or rejected, it depends of strict checks for
+metadata type.
+
 The
 .B ppl
 and
@@ -3366,6 +3358,11 @@ can be given, or just the suffix of the second sort of name, such as
 .I home
 can be given.
 
+A valid name can only consist of characters "A-Za-z0-9.-_".
+The name cannot start with a leading "-" and cannot exceed NAME_MAX.
+The long name could be truncated or rejected, it depends of strict checks for
+metadata type.
+
 When
 .I mdadm
 chooses device names during auto-assembly or incremental assembly, it
diff --git a/mdadm.c b/mdadm.c
index 5bd3d5a7..08754c15 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -691,7 +691,7 @@ int main(int argc, char *argv[])
 				exit(2);
 			}
 
-			if (ident_set_name(&ident, optarg) != STATUS_SUCCESS)
+			if (ident_set_name(&ident, optarg, true) != STATUS_SUCCESS)
 				exit(2);
 
 			continue;
@@ -1335,7 +1335,7 @@ int main(int argc, char *argv[])
 		} else {
 			char *bname = basename(devlist->devname);
 
-			if (check_mdname(bname))
+			if (check_mdname(bname, true))
 				exit(1);
 
 			ret = stat(devlist->devname, &stb);
diff --git a/mdadm.conf.5.in b/mdadm.conf.5.in
index bc2295c2..94e23dd0 100644
--- a/mdadm.conf.5.in
+++ b/mdadm.conf.5.in
@@ -717,10 +717,6 @@ ARRAY /dev/md/home UUID=9187a482:5dde19d9:eea3cc4a:d646ab8b
 .br
            auto=part
 .br
-# The name of this array contains a space.
-.br
-ARRAY /dev/md9 name='Data Storage'
-.sp
 POLICY domain=domain1 metadata=imsm path=pci-0000:00:1f.2-scsi-*
 .br
            action=spare
diff --git a/mdadm.h b/mdadm.h
index b68fa4bc..74628aaa 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1546,6 +1546,7 @@ extern int check_raid(int fd, char *name);
 extern int check_partitions(int fd, char *dname,
 			    unsigned long long freesize,
 			    unsigned long long size);
+extern bool is_name_posix_compatible(const char *path);
 extern int fstat_is_blkdev(int fd, char *devname, dev_t *rdev);
 extern int stat_is_blkdev(char *devname, dev_t *rdev);
 
@@ -1567,7 +1568,9 @@ extern void manage_fork_fds(int close_all);
 extern int continue_via_systemd(char *devnm, char *service_name);
 
 extern void ident_init(struct mddev_ident *ident);
-extern status_t ident_set_name(struct mddev_ident *ident, const char *name);
+extern status_t ident_set_name(struct mddev_ident *ident, const char *name,
+			       bool check_posix);
+
 
 extern int parse_auto(char *str, char *msg, int config);
 extern struct mddev_ident *conf_get_ident(char *dev);
@@ -1585,7 +1588,6 @@ extern int conf_get_monitor_delay(void);
 extern char *conf_line(FILE *file);
 extern char *conf_word(FILE *file, int allow_key);
 extern void print_quoted(char *str);
-extern void print_escape(char *str);
 extern int use_udev(void);
 extern unsigned long GCD(unsigned long a, unsigned long b);
 extern int conf_name_is_free(char *name);
@@ -1647,7 +1649,7 @@ extern void print_r10_layout(int layout);
 
 extern char *find_free_devnm(int use_partitions);
 
-extern error_t check_mdname(const char *name);
+extern error_t check_mdname(const char *name, const bool check_posix);
 extern void put_md_name(char *name);
 extern char *devid2kname(dev_t devid);
 extern char *devid2devnm(dev_t devid);
diff --git a/super-intel.c b/super-intel.c
index b0565610..da1e5062 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5480,26 +5480,14 @@ static void imsm_update_version_info(struct intel_super *super)
 	}
 }
 
-static int check_name(struct intel_super *super, char *name, int quiet)
+static int imsm_check_name(struct intel_super *super, char *name, int quiet)
 {
 	struct imsm_super *mpb = super->anchor;
 	char *reason = NULL;
-	char *start = name;
-	size_t len = strlen(name);
 	int i;
 
-	if (len > 0) {
-		while (isspace(start[len - 1]))
-			start[--len] = 0;
-		while (*start && isspace(*start))
-			++start, --len;
-		memmove(name, start, len + 1);
-	}
-
-	if (len > MAX_RAID_SERIAL_LEN)
-		reason = "must be 16 characters or less";
-	else if (len == 0)
-		reason = "must be a non-empty string";
+	if (strnlen(name, MAX_RAID_SERIAL_LEN + 1) > MAX_RAID_SERIAL_LEN)
+		reason = "is too long";
 
 	for (i = 0; i < mpb->num_raid_devs; i++) {
 		struct imsm_dev *dev = get_imsm_dev(super, i);
@@ -5608,7 +5596,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 		}
 	}
 
-	if (!check_name(super, name, 0))
+	if (!imsm_check_name(super, name, 0))
 		return 0;
 	dv = xmalloc(sizeof(*dv));
 	dev = xcalloc(1, sizeof(*dev) + sizeof(__u32) * (info->raid_disks - 1));
@@ -7919,7 +7907,7 @@ static int update_subarray_imsm(struct supertype *st, char *subarray,
 			return 2;
 		}
 
-		if (!check_name(super, name, 0))
+		if (!imsm_check_name(super, name, 0))
 			return 2;
 
 		vol = strtoul(subarray, &ep, 10);
@@ -10246,7 +10234,8 @@ static void imsm_process_update(struct supertype *st,
 			if (a->info.container_member == target)
 				break;
 		dev = get_imsm_dev(super, u->dev_idx);
-		if (a || !check_name(super, name, 1)) {
+
+		if (a || !dev || !imsm_check_name(super, name, 1)) {
 			dprintf("failed to rename subarray-%d\n", target);
 			break;
 		}
diff --git a/super1.c b/super1.c
index 0b505a7e..11cffc75 100644
--- a/super1.c
+++ b/super1.c
@@ -642,8 +642,7 @@ static void brief_examine_super1(struct supertype *st, int verbose)
 
 	printf("ARRAY ");
 	if (nm) {
-		printf("/dev/md/");
-		print_escape(nm);
+		printf("/dev/md/%s", nm);
 		putchar(' ');
 	}
 	if (verbose && c)
diff --git a/util.c b/util.c
index b2a4ea21..1de1eddc 100644
--- a/util.c
+++ b/util.c
@@ -935,12 +935,13 @@ int get_data_disks(int level, int layout, int raid_disks)
 /**
  * check_md_name()- check if MD device name is correct.
  * @name: name to check.
+ * @check_posix: if set, verify compatibility with POSIX.
  *
  * In case of error, message is printed.
  *
  * Return: %STATUS_SUCCESS or %STATUS_ERROR.
  */
-error_t check_mdname(const char * const name)
+error_t check_mdname(const char * const name, const bool check_posix)
 {
 	assert(name);
 
@@ -949,6 +950,9 @@ error_t check_mdname(const char * const name)
 		return STATUS_ERROR;
 	}
 
+	if (check_posix && !is_name_posix_compatible(name))
+		return STATUS_ERROR;
+
 	return STATUS_SUCCESS;
 }
 
-- 
2.26.2

