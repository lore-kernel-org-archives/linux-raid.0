Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE513C74A5B
	for <linux-raid@archiver.kernel.org>; Thu, 23 Mar 2023 16:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbjCWQu6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Mar 2023 12:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbjCWQuz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Mar 2023 12:50:55 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9CE86AA
        for <linux-raid@vger.kernel.org>; Thu, 23 Mar 2023 09:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679590253; x=1711126253;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=btmcJ75KvpWdSDdxdDyCwnUitbmfJYMuQ1sCKOps1yc=;
  b=JrLO1WpewgPc24y5LUN5OfBOa2H6aR4TNzVtpYcB22A1L/1YGKM4DZl7
   5FjVFJuKNdSk5PJTw2GwVpsFOkz9qk5A2byLz6q0h1DvCGq1jsTnQSoCs
   Johy7pPzq73CaSFVSBQLsmsYNJavK7Z78AUbXbCBRKxkw5s4uumeOH685
   2iNobeh0131O0Vo+EtYEgWM6LkwRAEcFihcQO9jSqbovTlSMwld4gg1sF
   yl1V6pURIlZ0/EkoORI1BEOccBxSqsqyFFgScjSwckYnR3+3IW55By311
   iRb9SEC7s6tSCeUz/bGMlUdlFu5yn/KwHeO4E+5mvoMFAAuMA4+nzzbaE
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="339588458"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="339588458"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 09:50:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="682374220"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="682374220"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 09:50:51 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de, xni@redhat.com
Subject: [PATCH 4/4] mdadm: numbered names verification
Date:   Thu, 23 Mar 2023 17:50:17 +0100
Message-Id: <20230323165017.27121-5-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230323165017.27121-1-mariusz.tkaczyk@linux.intel.com>
References: <20230323165017.27121-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

New functions added to remove literals and make the code reusable.
Use parse_num() instead of is_numer().

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 config.c | 17 ++---------------
 lib.c    |  2 +-
 mdadm.h  |  4 +++-
 util.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 50 insertions(+), 17 deletions(-)

diff --git a/config.c b/config.c
index e61c0496..450880e3 100644
--- a/config.c
+++ b/config.c
@@ -385,17 +385,6 @@ void devline(char *line)
 struct mddev_ident *mddevlist = NULL;
 struct mddev_ident **mddevlp = &mddevlist;
 
-static int is_number(char *w)
-{
-	/* check if there are 1 or more digits and nothing else */
-	int digits = 0;
-	while (*w && isdigit(*w)) {
-		digits++;
-		w++;
-	}
-	return (digits && ! *w);
-}
-
 void arrayline(char *line)
 {
 	char *w;
@@ -419,10 +408,8 @@ void arrayline(char *line)
 			if (is_devname_ignore(w) == true ||
 			    strncmp(w, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0 ||
 			    (w[0] != '/' && w[0] != '<') ||
-			    (strncmp(w, DEV_NUM_PREF, DEV_NUM_PREF_LEN) == 0 &&
-			     is_number(w + DEV_NUM_PREF_LEN)) ||
-			    (strncmp(w, "/dev/md_d", 9) == 0 &&
-			     is_number(w + 9))) {
+			    is_devname_md_numbered(w) == true ||
+			    is_devname_md_d_numbered(w) == true) {
 				/* This is acceptable */;
 				if (mis.devname)
 					pr_err("only give one device per ARRAY line: %s and %s\n",
diff --git a/lib.c b/lib.c
index 65ea51e0..fe5c8d2c 100644
--- a/lib.c
+++ b/lib.c
@@ -570,7 +570,7 @@ void free_line(char *line)
  *
  * Return: 0 on success, 1 otherwise.
  */
-int parse_num(int *dest, char *num)
+int parse_num(int *dest, const char *num)
 {
 	char *c = NULL;
 	long temp;
diff --git a/mdadm.h b/mdadm.h
index 87fd4a57..b5d58448 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1599,7 +1599,7 @@ int default_layout(struct supertype *st, int level, int verbose);
 extern int is_near_layout_10(int layout);
 extern int parse_layout_10(char *layout);
 extern int parse_layout_faulty(char *layout);
-extern int parse_num(int *dest, char *num);
+extern int parse_num(int *dest, const char *num);
 extern int parse_cluster_confirm_arg(char *inp, char **devname, int *slot);
 extern int check_ext2(int fd, char *name);
 extern int check_reiser(int fd, char *name);
@@ -1649,6 +1649,8 @@ extern int use_udev(void);
 extern unsigned long GCD(unsigned long a, unsigned long b);
 extern int conf_name_is_free(char *name);
 extern bool is_devname_ignore(char *devname);
+extern bool is_devname_md_numbered(const char *devname);
+extern bool is_devname_md_d_numbered(const char *devname);
 extern int conf_verify_devnames(struct mddev_ident *array_list);
 extern int devname_matches(char *name, char *match);
 extern struct mddev_ident *conf_match(struct supertype *st,
diff --git a/util.c b/util.c
index 9f1e1f7c..23372b7e 100644
--- a/util.c
+++ b/util.c
@@ -973,6 +973,50 @@ dev_t devnm2devid(char *devnm)
 	return 0;
 }
 
+/**
+ * is_devname_numbered() - helper for numbered devname verification.
+ * @devname: path or name to check.
+ * @pref: expected devname prefix.
+ * @pref_len: prefix len.
+ */
+static bool is_devname_numbered(const char *devname, const char *pref, const int pref_len)
+{
+	int val;
+
+	assert(devname && pref);
+
+	if (strncmp(devname, pref, pref_len) != 0)
+		return false;
+
+	if (parse_num(&val, devname + pref_len) != 0)
+		return false;
+
+	if (val > 127)
+		return false;
+
+	return true;
+}
+
+/**
+ * is_devname_md_numbered() - check if &devname is numbered MD device (md).
+ * @devname: path or name to check.
+ */
+bool is_devname_md_numbered(const char *devname)
+{
+	return is_devname_numbered(devname, DEV_NUM_PREF, DEV_NUM_PREF_LEN);
+}
+
+/**
+ * is_devname_md_d_numbered() - check if &devname is secondary numbered MD device (md_d).
+ * @devname: path or name to check.
+ */
+bool is_devname_md_d_numbered(const char *devname)
+{
+	static const char d_dev[] = DEV_NUM_PREF "_d";
+
+	return is_devname_numbered(devname, d_dev, sizeof(d_dev) - 1);
+}
+
 /**
  * get_md_name() - Get main dev node of the md device.
  * @devnm: Md device name or path.
-- 
2.26.2

