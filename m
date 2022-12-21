Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BBD0C4332F
	for <linux-raid@archiver.kernel.org>; Wed, 21 Dec 2022 11:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbiLULui (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Dec 2022 06:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbiLULug (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Dec 2022 06:50:36 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16281DDD4
        for <linux-raid@vger.kernel.org>; Wed, 21 Dec 2022 03:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671623433; x=1703159433;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eR68ta8NQaTyMJGWPLQBXxnE0h+AIX426SW4U2KMXqo=;
  b=nHniagOpwPp/+WC3ltPyn/+tAwazVKN0KBthb4eCifDaSMVq9SuZ5WIc
   +c9GJRzsMj/7moCwaq5KdUmd3BkkzutcHmm8dzQw5KXZtFb3rON9kveol
   qKHXas9KuPa0d/q/TtVFqVcB+a4h2ZOApuhyfOHGqELmTg5liOBuzBjSj
   99n4DX/YqqrNdIotNdGzMP/dga9IM2SEKk0BA4BRRpZaSWsjHvbaUPEFf
   M0gE/LnHHY9RZofPzZU3ZxxlCRaYJMKkR7g4UQ+bwLglo0BQ434gpWOvP
   qRycEZekjh28lLz+ReqcH9YC96/M+lUjmLlasT93n4m1EhoAZSpmyj5a5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="321765628"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="321765628"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 03:50:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="714799027"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="714799027"
Received: from mtkaczyk-devel.elements.local ([10.102.105.40])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 03:50:32 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, colyli@suse.de
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/3] mdadm: create ident_init()
Date:   Wed, 21 Dec 2022 12:50:17 +0100
Message-Id: <20221221115019.26276-2-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com>
References: <20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Add a wrapper for repeated initializations in mdadm.c and config.c.
Move includes up.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 config.c | 45 +++++++++++++++++++++++++++++----------------
 mdadm.c  | 16 ++--------------
 mdadm.h  |  7 +++++--
 3 files changed, 36 insertions(+), 32 deletions(-)

diff --git a/config.c b/config.c
index dc1620c1..eeedd0c6 100644
--- a/config.c
+++ b/config.c
@@ -119,6 +119,34 @@ int match_keyword(char *word)
 	return -1;
 }
 
+/**
+ * ident_init() - Set defaults.
+ * @ident: ident pointer, not NULL.
+ */
+inline void ident_init(struct mddev_ident *ident)
+{
+	assert(ident);
+
+	ident->assembled = false;
+	ident->autof = 0;
+	ident->bitmap_fd = -1;
+	ident->bitmap_file = NULL;
+	ident->container = NULL;
+	ident->devices = NULL;
+	ident->devname = NULL;
+	ident->level = UnSet;
+	ident->member = NULL;
+	ident->name[0] = 0;
+	ident->next = NULL;
+	ident->raid_disks = UnSet;
+	ident->spare_group = NULL;
+	ident->spare_disks = 0;
+	ident->st = NULL;
+	ident->super_minor = UnSet;
+	ident->uuid[0] = 0;
+	ident->uuid_set = 0;
+}
+
 struct conf_dev {
 	struct conf_dev *next;
 	char *name;
@@ -363,22 +391,7 @@ void arrayline(char *line)
 	struct mddev_ident mis;
 	struct mddev_ident *mi;
 
-	mis.uuid_set = 0;
-	mis.super_minor = UnSet;
-	mis.level = UnSet;
-	mis.raid_disks = UnSet;
-	mis.spare_disks = 0;
-	mis.devices = NULL;
-	mis.devname = NULL;
-	mis.spare_group = NULL;
-	mis.autof = 0;
-	mis.next = NULL;
-	mis.st = NULL;
-	mis.bitmap_fd = -1;
-	mis.bitmap_file = NULL;
-	mis.name[0] = 0;
-	mis.container = NULL;
-	mis.member = NULL;
+	ident_init(&mis);
 
 	for (w = dl_next(line); w != line; w = dl_next(w)) {
 		if (w[0] == '/' || strchr(w, '=') == NULL) {
diff --git a/mdadm.c b/mdadm.c
index 972adb52..74fdec31 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -107,25 +107,13 @@ int main(int argc, char *argv[])
 
 	srandom(time(0) ^ getpid());
 
-	ident.uuid_set = 0;
-	ident.level = UnSet;
-	ident.raid_disks = UnSet;
-	ident.super_minor = UnSet;
-	ident.devices = 0;
-	ident.spare_group = NULL;
-	ident.autof = 0;
-	ident.st = NULL;
-	ident.bitmap_fd = -1;
-	ident.bitmap_file = NULL;
-	ident.name[0] = 0;
-	ident.container = NULL;
-	ident.member = NULL;
-
 	if (get_linux_version() < 2006015) {
 		pr_err("This version of mdadm does not support kernels older than 2.6.15\n");
 		exit(1);
 	}
 
+	ident_init(&ident);
+
 	while ((option_index = -1),
 	       (opt = getopt_long(argc, argv, shortopt, long_options,
 				  &option_index)) != -1) {
diff --git a/mdadm.h b/mdadm.h
index 3673494e..23ffe977 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -33,8 +33,10 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 # endif
 #endif
 
+#include	<assert.h>
 #include	<sys/types.h>
 #include	<sys/stat.h>
+#include	<stdarg.h>
 #include	<stdint.h>
 #include	<stdlib.h>
 #include	<time.h>
@@ -1552,6 +1554,8 @@ extern void enable_fds(int devices);
 extern void manage_fork_fds(int close_all);
 extern int continue_via_systemd(char *devnm, char *service_name);
 
+extern void ident_init(struct mddev_ident *ident);
+
 extern int parse_auto(char *str, char *msg, int config);
 extern struct mddev_ident *conf_get_ident(char *dev);
 extern struct mddev_dev *conf_get_devs(void);
@@ -1779,8 +1783,7 @@ static inline sighandler_t signal_s(int sig, sighandler_t handler)
 #define dprintf_cont(fmt, arg...) \
         ({ if (0) fprintf(stderr, fmt, ##arg); 0; })
 #endif
-#include <assert.h>
-#include <stdarg.h>
+
 static inline int xasprintf(char **strp, const char *fmt, ...) {
 	va_list ap;
 	int ret;
-- 
2.26.2

