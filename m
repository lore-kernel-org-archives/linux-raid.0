Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07F2C2D0E4
	for <linux-raid@archiver.kernel.org>; Tue, 24 Nov 2020 15:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69DD42067C
	for <linux-raid@archiver.kernel.org>; Tue, 24 Nov 2020 15:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389277AbgKXPlM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Nov 2020 10:41:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:5938 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730909AbgKXPlL (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 24 Nov 2020 10:41:11 -0500
IronPort-SDR: WdO2p7/qknhzXMSPrK04evBBevG/1nE8DqOecOP1aDZZvrepdzXMsP67Yopebfz0rLRUfpuWqk
 7nozJVLxAxOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9815"; a="168455751"
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="168455751"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 07:41:11 -0800
IronPort-SDR: PRLOk/LB9jSPorT4GGX7HZBkFcLCiyeXG5jcZ6EDi53yFt3SgLT4D6Fe6w+lQPtBAziLfK3zy5
 2kRkIdjJ8VKQ==
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="327619267"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 07:41:10 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] Monitor: don't use default modes when creating a file
Date:   Tue, 24 Nov 2020 16:41:01 +0100
Message-Id: <20201124154101.1836-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Replace fopen() calls by open() with creation mode directly specified.
This fixes the potential security issue. Use octal values instead masks.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Monitor.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 7fd4808..a82e99d 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -305,8 +305,11 @@ static int make_daemon(char *pidfile)
 		if (!pidfile)
 			printf("%d\n", pid);
 		else {
-			FILE *pid_file;
-			pid_file=fopen(pidfile, "w");
+			FILE *pid_file = NULL;
+			int fd = open(pidfile, O_WRONLY | O_CREAT | O_TRUNC,
+				      0644);
+			if (fd >= 0)
+				pid_file = fdopen(fd, "w");
 			if (!pid_file)
 				perror("cannot create pid file");
 			else {
@@ -368,13 +371,17 @@ static void write_autorebuild_pid()
 {
 	char path[PATH_MAX];
 	int pid;
-	FILE *fp;
+	FILE *fp = NULL;
 	sprintf(path, "%s/autorebuild.pid", MDMON_DIR);
 
-	if (mkdir(MDMON_DIR, S_IRWXU) < 0 && errno != EEXIST) {
+	if (mkdir(MDMON_DIR, 0700) < 0 && errno != EEXIST) {
 		pr_err("Can't create autorebuild.pid file\n");
 	} else {
-		fp = fopen(path, "w");
+		int fd = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0700);
+
+		if (fd >= 0)
+			fp = fdopen(fd, "w");
+
 		if (!fp)
 			pr_err("Can't create autorebuild.pid file\n");
 		else {
-- 
2.25.0

