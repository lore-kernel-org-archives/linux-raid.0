Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BFDDC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 13 May 2022 07:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377750AbiEMHTu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 May 2022 03:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356223AbiEMHTs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 May 2022 03:19:48 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9470B2AACC0
        for <linux-raid@vger.kernel.org>; Fri, 13 May 2022 00:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652426387; x=1683962387;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tKs5jGD79BfrqS2TrkEMw7XbLYq7N8IzaNQQyctc7VI=;
  b=OXHYRAjAyffSbb+Xv0dBqGMKLJskpeQ+vCaP5l09KxayHP62hM/Y7Qd1
   3sxpZhR20kJKzgt6YA/Psht+P9pgmgYItgPFBrlYwO+q/O+zBx/oduyl8
   qCcCg6R9eKuPjhMVUVIyLyKQG9TkxBjQKWojP8uPips9qnqj3ILqmdXbK
   0z4UlHXnGFRY0TW6xyoZYs5cpZhrlMOeeP9oMDc/NshjO0nnXRCmzoQ3o
   UjOMjmym7QkljXxHEMRgmmoG/9LSyGDyzP55UVgsBqq/OxoTfWw1HYWb7
   OzyElSIXGDxJtOdbIl5rlhXFgeEmzV0lEqULRYvxwFPHFCv90tsaC02+T
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="270174987"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="270174987"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 00:19:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="698387116"
Received: from unknown (HELO gklab-109-9.igk.intel.com) ([10.102.109.9])
  by orsmga004.jf.intel.com with ESMTP; 13 May 2022 00:19:46 -0700
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH] mdmon: Stop parsing duplicate options
Date:   Fri, 13 May 2022 09:19:42 +0200
Message-Id: <20220513071942.27850-1-lukasz.florczak@linux.intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Introduce new function is_duplicate_opt() to check if given option
was already used and prevent setting it again along with an error
message.

Move parsing above in_initrd() check to be able to detect --offroot
option duplicates.

Now help option is executed after parsing to prevent executing commands
like: 'mdmon --help --ndlksnlksajndfjksndafasj'.

Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
---
 mdmon.c | 44 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index c71e62c6..3da9043f 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -289,6 +289,15 @@ void usage(void)
 	exit(2);
 }
 
+static bool is_duplicate_opt(const int opt, const int set_val, const char *long_name)
+{
+	if (opt == set_val) {
+		pr_err("--%s option duplicated!\n", long_name);
+		return true;
+	}
+	return false;
+}
+
 static int mdmon(char *devnm, int must_fork, int takeover);
 
 int main(int argc, char *argv[])
@@ -300,6 +309,7 @@ int main(int argc, char *argv[])
 	int all = 0;
 	int takeover = 0;
 	int dofork = 1;
+	bool help = false;
 	static struct option options[] = {
 		{"all", 0, NULL, 'a'},
 		{"takeover", 0, NULL, 't'},
@@ -309,37 +319,50 @@ int main(int argc, char *argv[])
 		{NULL, 0, NULL, 0}
 	};
 
-	if (in_initrd()) {
-		/*
-		 * set first char of argv[0] to @. This is used by
-		 * systemd to signal that the task was launched from
-		 * initrd/initramfs and should be preserved during shutdown
-		 */
-		argv[0][0] = '@';
-	}
-
 	while ((opt = getopt_long(argc, argv, "thaF", options, NULL)) != -1) {
 		switch (opt) {
 		case 'a':
+			if (is_duplicate_opt(all, 1, "all"))
+				exit(1);
 			container_name = argv[optind-1];
 			all = 1;
 			break;
 		case 't':
+			if (is_duplicate_opt(takeover, 1, "takeover"))
+				exit(1);
 			takeover = 1;
 			break;
 		case 'F':
+			if (is_duplicate_opt(dofork, 0, "foreground"))
+				exit(1);
 			dofork = 0;
 			break;
 		case OffRootOpt:
+			if (is_duplicate_opt(argv[0][0], '@', "offroot"))
+				exit(1);
 			argv[0][0] = '@';
 			break;
 		case 'h':
+			if (is_duplicate_opt(help, true, "help"))
+				exit(1);
+			help = true;
+			break;
 		default:
 			usage();
 			break;
 		}
 	}
 
+
+	if (in_initrd()) {
+		/*
+		 * set first char of argv[0] to @. This is used by
+		 * systemd to signal that the task was launched from
+		 * initrd/initramfs and should be preserved during shutdown
+		 */
+		argv[0][0] = '@';
+	}
+
 	if (all == 0 && container_name == NULL) {
 		if (argv[optind])
 			container_name = argv[optind];
@@ -354,6 +377,9 @@ int main(int argc, char *argv[])
 	if (strcmp(container_name, "/proc/mdstat") == 0)
 		all = 1;
 
+	if (help)
+		usage();
+
 	if (all) {
 		struct mdstat_ent *mdstat, *e;
 		int container_len = strlen(container_name);
-- 
2.27.0

