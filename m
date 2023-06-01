Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F106C77B7E
	for <linux-raid@archiver.kernel.org>; Thu,  1 Jun 2023 07:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbjFAH3k (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 1 Jun 2023 03:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbjFAH3g (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 1 Jun 2023 03:29:36 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B72136
        for <linux-raid@vger.kernel.org>; Thu,  1 Jun 2023 00:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685604570; x=1717140570;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sUJfoCvGu6zYyaYMefMVRMe3X4WR/umkU0lLzswG95I=;
  b=H9ZdrMJ8gPnTK8t9+nAQG/Bs5h0uk9VKs6j7NOZ35KMAvxJstRc197jo
   jLmFHKUWqLRMfUJO5sfU+/E+3oLwhqt8XMflw8V2FsKX3lPi1g1r/QIdF
   tMvQd9KadIo8Y9SV9KuKuXMEGs0gfDFwxenleBmdu4BLK+I5UXYdPgqf4
   cEkSgNtkpdRdM36WLX8ds/DduiVzYhAAXvZw1U1RF+a5+BAwTXalv3Fmx
   NgeKGH0WrqnZ0Ap+gN+o/B1im660TwFl31AHPdqg6SIJpxnAH2H4fgLA7
   Wll1CklWwiztg81Mrsa28OgzYumgRLmFI6HaMvSyyqkpmz4+HB2VJovwV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="345007172"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="345007172"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 00:28:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="707221137"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="707221137"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 00:28:44 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
Subject: [PATCH 5/6] mdadm: define ident_set_devname()
Date:   Thu,  1 Jun 2023 09:27:49 +0200
Message-Id: <20230601072750.20796-6-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230601072750.20796-1-mariusz.tkaczyk@linux.intel.com>
References: <20230601072750.20796-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Use dedicated set method for ident->devname. Now, devname validation
is done early for modes where device is created (Build, Create and
Assemble). The rules, used for devname validation are derived from
config file.

It could cause regression with execeptional cases where existing device
has name which doesn't match criteria for Manage and Grow modes. It is
low risk and those modes are not omitted from early devname validation.
Use can used main numbered devnode to avoid this problem.
Messages exposed to user are changed so it might cause a regression
in negative scenarios. Error codes are not changed.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 config.c                       | 102 +++++++++++++++++++++++++--------
 mdadm.c                        |  10 +---
 mdadm.h                        |   3 +-
 tests/00createnames            |   3 +
 tests/templates/names_template |   7 +++
 5 files changed, 92 insertions(+), 33 deletions(-)

diff --git a/config.c b/config.c
index 76a8384a..d80747a2 100644
--- a/config.c
+++ b/config.c
@@ -122,7 +122,7 @@ int match_keyword(char *word)
 /**
  * is_devname_ignore() - check if &devname is a special "<ignore>" keyword.
  */
-bool is_devname_ignore(char *devname)
+bool is_devname_ignore(const char *devname)
 {
 	static const char keyword[] = "<ignore>";
 
@@ -187,6 +187,74 @@ inline void ident_init(struct mddev_ident *ident)
 	ident->uuid_set = 0;
 }
 
+/**
+ * _ident_set_devname()- verify devname and set it in &mddev_ident.
+ * @ident: pointer to &mddev_ident.
+ * @devname: devname to be set.
+ * @cmdline: context dependent actions. If set, ignore keyword is not allowed.
+ *
+ * @devname can have following forms:
+ *	'<ignore>' keyword (if allowed)
+ *	/dev/md{number}
+ *	/dev/md_d{number} (legacy)
+ *	/dev/md_{name}
+ *	/dev/md/{name}
+ *	{name} - anything that doesn't start from '/' or '<'.
+ *
+ * {name} must follow name's criteria.
+ * If criteria passed, duplicate memory and set devname in @ident.
+ *
+ * Return: %MDADM_STATUS_SUCCESS or %MDADM_STATUS_ERROR.
+ */
+mdadm_status_t _ident_set_devname(struct mddev_ident *ident, const char *devname,
+				  const bool cmdline)
+{
+	assert(ident);
+	assert(devname);
+
+	static const char named_dev_pref[] = DEV_NUM_PREF "_";
+	static const int named_dev_pref_size = sizeof(named_dev_pref) - 1;
+	const char *prop_name = "devname";
+	const char *name;
+
+	if (ident->devname) {
+		ident_log(prop_name, devname, "Already defined", cmdline);
+		return MDADM_STATUS_ERROR;
+	}
+
+	if (is_devname_ignore(devname) == true) {
+		if (!cmdline)
+			goto pass;
+
+		ident_log(prop_name, devname, "Special keyword is invalid in this context",
+			  cmdline);
+		return MDADM_STATUS_ERROR;
+	}
+
+	if (is_devname_md_numbered(devname) == true || is_devname_md_d_numbered(devname) == true)
+		goto pass;
+
+	if (strncmp(devname, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0)
+		name = devname + DEV_MD_DIR_LEN;
+	else if (strncmp(devname, named_dev_pref, named_dev_pref_size) == 0)
+		name = devname + named_dev_pref_size;
+	else
+		name = devname;
+
+	if (*name == '/' || *name == '<') {
+		ident_log(prop_name, devname, "Cannot be started from \'/\' or \'<\'", cmdline);
+		return MDADM_STATUS_ERROR;
+	}
+
+	if (is_string_lq(name, MD_NAME_MAX + 1) == false) {
+		ident_log(prop_name, devname, "Invalid length", cmdline);
+		return MDADM_STATUS_ERROR;
+	}
+pass:
+	ident->devname = xstrdup(devname);
+	return MDADM_STATUS_SUCCESS;
+}
+
 /**
  * _ident_set_name()- set name in &mddev_ident.
  * @ident: pointer to &mddev_ident.
@@ -219,6 +287,14 @@ static mdadm_status_t _ident_set_name(struct mddev_ident *ident, const char *nam
 	return MDADM_STATUS_SUCCESS;
 }
 
+/**
+ * ident_set_devname()- exported, for cmdline.
+ */
+mdadm_status_t ident_set_devname(struct mddev_ident *ident, const char *name)
+{
+	return _ident_set_devname(ident, name, true);
+}
+
 /**
  * ident_set_name()- exported, for cmdline.
  */
@@ -464,29 +540,7 @@ void arrayline(char *line)
 
 	for (w = dl_next(line); w != line; w = dl_next(w)) {
 		if (w[0] == '/' || strchr(w, '=') == NULL) {
-			/* This names the device, or is '<ignore>'.
-			 * The rules match those in create_mddev.
-			 * 'w' must be:
-			 *  /dev/md/{anything}
-			 *  /dev/mdNN
-			 *  /dev/md_dNN
-			 *  <ignore>
-			 *  or anything that doesn't start '/' or '<'
-			 */
-			if (is_devname_ignore(w) == true ||
-			    strncmp(w, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0 ||
-			    (w[0] != '/' && w[0] != '<') ||
-			    is_devname_md_numbered(w) == true ||
-			    is_devname_md_d_numbered(w) == true) {
-				/* This is acceptable */;
-				if (mis.devname)
-					pr_err("only give one device per ARRAY line: %s and %s\n",
-						mis.devname, w);
-				else
-					mis.devname = w;
-			}else {
-				pr_err("%s is an invalid name for an md device - ignored.\n", w);
-			}
+			_ident_set_devname(&mis, w, false);
 		} else if (strncasecmp(w, "uuid=", 5) == 0) {
 			if (mis.uuid_set)
 				pr_err("only specify uuid once, %s ignored.\n",
diff --git a/mdadm.c b/mdadm.c
index 5084c348..5f8dc1a6 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1284,7 +1284,8 @@ int main(int argc, char *argv[])
 			pr_err("an md device must be given in this mode\n");
 			exit(2);
 		}
-		ident.devname = devlist->devname;
+		if (ident_set_devname(&ident, devlist->devname) != MDADM_STATUS_SUCCESS)
+			exit(1);
 
 		if ((int)ident.super_minor == -2 && c.autof) {
 			pr_err("--super-minor=dev is incompatible with --auto\n");
@@ -1301,13 +1302,6 @@ int main(int argc, char *argv[])
 				exit(1);
 			}
 		} else {
-			char *bname = basename(ident.devname);
-
-			if (strlen(bname) > MD_NAME_MAX) {
-				pr_err("Name %s is too long.\n", ident.devname);
-				exit(1);
-			}
-
 			ret = stat(ident.devname, &stb);
 			if (ident.super_minor == -2 && ret != 0) {
 				pr_err("--super-minor=dev given, and listed device %s doesn't exist.\n",
diff --git a/mdadm.h b/mdadm.h
index 62e15dfa..92a0beb5 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1638,6 +1638,7 @@ extern void manage_fork_fds(int close_all);
 extern int continue_via_systemd(char *devnm, char *service_name, char *prefix);
 
 extern void ident_init(struct mddev_ident *ident);
+extern mdadm_status_t ident_set_devname(struct mddev_ident *ident, const char *devname);
 extern mdadm_status_t ident_set_name(struct mddev_ident *ident, const char *name);
 
 extern int parse_auto(char *str, char *msg, int config);
@@ -1660,7 +1661,7 @@ extern void print_escape(char *str);
 extern int use_udev(void);
 extern unsigned long GCD(unsigned long a, unsigned long b);
 extern int conf_name_is_free(char *name);
-extern bool is_devname_ignore(char *devname);
+extern bool is_devname_ignore(const char *devname);
 extern bool is_devname_md_numbered(const char *devname);
 extern bool is_devname_md_d_numbered(const char *devname);
 extern int conf_verify_devnames(struct mddev_ident *array_list);
diff --git a/tests/00createnames b/tests/00createnames
index 064eeef2..a95e7d2b 100644
--- a/tests/00createnames
+++ b/tests/00createnames
@@ -39,3 +39,6 @@ mdadm -S "/dev/md0"
 names_create "/dev/md0" "name"
 names_verify "/dev/md0" "empty" "name"
 mdadm -S "/dev/md0"
+
+# Devnode is a special ignore keyword. Should be rejected.
+names_create "<ignore>" "name", "true"
diff --git a/tests/templates/names_template b/tests/templates/names_template
index 8d2b5c81..6181bfaa 100644
--- a/tests/templates/names_template
+++ b/tests/templates/names_template
@@ -2,6 +2,7 @@
 function names_create() {
 	local DEVNAME=$1
 	local NAME=$2
+	local NEG_TEST=$3
 
 	if [[ -z "$NAME" ]]; then
 		mdadm -CR "$DEVNAME" -l0 -n 1 $dev0 --force
@@ -9,6 +10,12 @@ function names_create() {
 		mdadm -CR "$DEVNAME" --name="$NAME" --metadata=1.2 -l0 -n 1 $dev0 --force
 	fi
 
+	if [[ "$NEG_TEST" == "true" ]]; then
+		[[ "$?" == "0" ]] && return 0
+		echo "Negative verification failed"
+		exit 1
+	fi
+
 	if [[ "$?" != "0" ]]; then
 		echo "Cannot create device."
 		exit 1
-- 
2.26.2

