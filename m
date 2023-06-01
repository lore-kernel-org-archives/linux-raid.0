Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C614C77B7A
	for <linux-raid@archiver.kernel.org>; Thu,  1 Jun 2023 07:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbjFAH3i (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 1 Jun 2023 03:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbjFAH3c (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 1 Jun 2023 03:29:32 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BA512F
        for <linux-raid@vger.kernel.org>; Thu,  1 Jun 2023 00:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685604569; x=1717140569;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=45s30sJIVSJq31Iqm6D1ch7ZljDLD2A2+1jDCdvNBOo=;
  b=LRTB8F5Tlglcbpow22s+hvivGC/cBkopyHGkyw1FGkYs6Br0Izg4D5Gr
   W113wu5MIY5HXk3S+EfOKWBSjNS4MJWTUMz5WfkD3WrXjyD9GosLr4wer
   9XYlLzCdY80flTF1QZmFrubF3mw/lwXhAUcMwPap4Kzy1noVAc42oSPsr
   n7OhlxN4BO3Wa/9erJJy/b/C2YWfPmUKnBO9Q8x4kyKw/3nETZwkuTWnV
   8Bv1aN3RrD1ZbLDoj8YoiC6DtlpLFMuR/YBAbXc6q45uOeaeKQBWX+yJ1
   FcnQYiZafFFSUEe5Ar5CfVPDiXr5jxgN20tCTw8LgrxOKe7u4m+dkmQ64
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="345007155"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="345007155"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 00:28:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="707221133"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="707221133"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 00:28:42 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
Subject: [PATCH 4/6] mdadm: refactor ident->name handling
Date:   Thu,  1 Jun 2023 09:27:48 +0200
Message-Id: <20230601072750.20796-5-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230601072750.20796-1-mariusz.tkaczyk@linux.intel.com>
References: <20230601072750.20796-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Create dedicated setter for name in mddev_ident and propagate it.
Following changes are made:
- move duplicated code from  config.c and mdadm.c into new function.
- Add error enum in mdadm.h.
- Use MD_NAME_MAX instead of hardcoded value in mddev_ident.
- Use secure functions.
- Add more detailed verification of the name.
- make error messages reusable for cmdline and config:
    - for cmdline, these are errors so use pr_err().
    - for config, these are just warnings, so use pr_info().

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 config.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++++++------
 lib.c    | 18 +++++++++++++
 mdadm.c  | 12 +++------
 mdadm.h  | 20 ++++++++++-----
 4 files changed, 104 insertions(+), 23 deletions(-)

diff --git a/config.c b/config.c
index 450880e3..76a8384a 100644
--- a/config.c
+++ b/config.c
@@ -131,6 +131,34 @@ bool is_devname_ignore(char *devname)
 	return false;
 }
 
+/**
+ * ident_log() - generate and write message to the user.
+ * @param_name: name of the property.
+ * @value: value of the property.
+ * @reason: meaningful description.
+ * @cmdline: context dependent actions, see below.
+ *
+ * The function is made to provide similar error handling for both config and cmdline. The behavior
+ * is configurable via @cmdline. Message has following format:
+ * "Value "@value" cannot be set for @param_name. Reason: @reason."
+ *
+ * If cmdline is on:
+ * - message is written to stderr.
+ * otherwise:
+ * - message is written to stdout.
+ * - "Value ignored" is added at the end of the message.
+ */
+static void ident_log(const char *param_name, const char *value, const char *reason,
+		      const bool cmdline)
+{
+	if (cmdline == true)
+		pr_err("Value \"%s\" cannot be set as %s. Reason: %s.\n", value, param_name,
+		       reason);
+	else
+		pr_info("Value \"%s\" cannot be set as %s. Reason: %s. Value ignored.\n", value,
+			param_name, reason);
+}
+
 /**
  * ident_init() - Set defaults.
  * @ident: ident pointer, not NULL.
@@ -159,6 +187,46 @@ inline void ident_init(struct mddev_ident *ident)
 	ident->uuid_set = 0;
 }
 
+/**
+ * _ident_set_name()- set name in &mddev_ident.
+ * @ident: pointer to &mddev_ident.
+ * @name: name to be set.
+ * @cmdline: context dependent actions.
+ *
+ * If criteria passed, set name in @ident.
+ *
+ * Return: %MDADM_STATUS_SUCCESS or %MDADM_STATUS_ERROR.
+ */
+static mdadm_status_t _ident_set_name(struct mddev_ident *ident, const char *name,
+				      const bool cmdline)
+{
+	assert(name);
+	assert(ident);
+
+	const char *prop_name = "name";
+
+	if (ident->name[0]) {
+		ident_log(prop_name, name, "Already defined", cmdline);
+		return MDADM_STATUS_ERROR;
+	}
+
+	if (is_string_lq(name, MD_NAME_MAX + 1) == false) {
+		ident_log(prop_name, name, "Too long or empty", cmdline);
+		return MDADM_STATUS_ERROR;
+	}
+
+	snprintf(ident->name, MD_NAME_MAX + 1, "%s", name);
+	return MDADM_STATUS_SUCCESS;
+}
+
+/**
+ * ident_set_name()- exported, for cmdline.
+ */
+mdadm_status_t ident_set_name(struct mddev_ident *ident, const char *name)
+{
+	return _ident_set_name(ident, name, true);
+}
+
 struct conf_dev {
 	struct conf_dev *next;
 	char *name;
@@ -444,14 +512,7 @@ void arrayline(char *line)
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
+			_ident_set_name(&mis, w + 5, false);
 		} else if (strncasecmp(w, "bitmap=", 7) == 0) {
 			if (mis.bitmap_file)
 				pr_err("only specify bitmap file once. %s ignored\n",
diff --git a/lib.c b/lib.c
index fe5c8d2c..999cd520 100644
--- a/lib.c
+++ b/lib.c
@@ -27,6 +27,24 @@
 #include	<ctype.h>
 #include	<limits.h>
 
+/**
+ * is_string_lq() - Check if string length with NULL byte is lower or equal to requested.
+ * @str: string to check.
+ * @max_len: max length.
+ *
+ * @str length must be bigger than 0 and be lower or equal @max_len, including termination byte.
+ */
+bool is_string_lq(const char * const str, size_t max_len)
+{
+	assert(str);
+
+	size_t _len = strnlen(str, max_len);
+
+	if (_len > 0 && _len < max_len)
+		return true;
+	return false;
+}
+
 bool is_dev_alive(char *path)
 {
 	if (!path)
diff --git a/mdadm.c b/mdadm.c
index 14072ec1..5084c348 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -690,20 +690,14 @@ int main(int argc, char *argv[])
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
+			if (ident_set_name(&ident, optarg) != MDADM_STATUS_SUCCESS)
 				exit(2);
-			}
-			strcpy(ident.name, optarg);
+
 			continue;
 
 		case O(ASSEMBLE,'m'): /* super-minor for array */
diff --git a/mdadm.h b/mdadm.h
index 782d7996..62e15dfa 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -294,6 +294,11 @@ static inline void __put_unaligned32(__u32 val, void *p)
 #define KIB_TO_BYTES(x)	((x) << 10)
 #define SEC_TO_BYTES(x)	((x) << 9)
 
+/**
+ * This is true for native and DDF, IMSM allows 16.
+ */
+#define MD_NAME_MAX 32
+
 extern const char Name[];
 
 struct md_bb_entry {
@@ -425,6 +430,12 @@ struct spare_criteria {
 	unsigned int sector_size;
 };
 
+typedef enum mdadm_status {
+	MDADM_STATUS_SUCCESS = 0,
+	MDADM_STATUS_ERROR,
+	MDADM_STATUS_UNDEF,
+} mdadm_status_t;
+
 enum mode {
 	ASSEMBLE=1,
 	BUILD,
@@ -593,7 +604,7 @@ struct mddev_ident {
 
 	int	uuid_set;
 	int	uuid[4];
-	char	name[33];
+	char	name[MD_NAME_MAX + 1];
 
 	int super_minor;
 
@@ -1609,6 +1620,7 @@ extern int check_partitions(int fd, char *dname,
 extern int fstat_is_blkdev(int fd, char *devname, dev_t *rdev);
 extern int stat_is_blkdev(char *devname, dev_t *rdev);
 
+extern bool is_string_lq(const char * const str, size_t max_len);
 extern bool is_dev_alive(char *path);
 extern int get_mdp_major(void);
 extern int get_maj_min(char *dev, int *major, int *minor);
@@ -1626,6 +1638,7 @@ extern void manage_fork_fds(int close_all);
 extern int continue_via_systemd(char *devnm, char *service_name, char *prefix);
 
 extern void ident_init(struct mddev_ident *ident);
+extern mdadm_status_t ident_set_name(struct mddev_ident *ident, const char *name);
 
 extern int parse_auto(char *str, char *msg, int config);
 extern struct mddev_ident *conf_get_ident(char *dev);
@@ -2001,11 +2014,6 @@ enum r0layout {
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
-- 
2.26.2

