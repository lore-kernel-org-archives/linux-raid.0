Return-Path: <SRS0=aYZJ=CS=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D56C43461
	for <linux-raid@archiver.kernel.org>; Wed,  9 Sep 2020 08:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9123721532
	for <linux-raid@archiver.kernel.org>; Wed,  9 Sep 2020 08:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgIIIbx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Sep 2020 04:31:53 -0400
Received: from mga04.intel.com ([192.55.52.120]:56811 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgIIIbt (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 9 Sep 2020 04:31:49 -0400
IronPort-SDR: Z8XqorBZAKWnBQzMTv5EK9QM0GV335tQaoS6vcb732pdhBC3eDCWvOrAAVSy5lbgCf0Uu/wMJs
 qThmkOB7ojnw==
X-IronPort-AV: E=McAfee;i="6000,8403,9738"; a="155692153"
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="155692153"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 01:31:48 -0700
IronPort-SDR: 9O6jtZ0JX2qKnO1/SyfMixAqv/GDIZHj7QYLbLpsiNhj+l4Nqkm5/vtVls2VCeDwKa/ZyN7G5E
 vIw45JERS/Ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="449119051"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga004.jf.intel.com with ESMTP; 09 Sep 2020 01:31:48 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 3/4] mdmonitor: set small delay once
Date:   Wed,  9 Sep 2020 10:31:19 +0200
Message-Id: <20200909083120.10396-4-mariusz.tkaczyk@intel.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200909083120.10396-1-mariusz.tkaczyk@intel.com>
References: <20200909083120.10396-1-mariusz.tkaczyk@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Blazej Kucman <blazej.kucman@intel.com>

If mdmonitor is awakened by event, set small delay once
to deal with udev and mdadm.

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
---
 Monitor.c | 14 +++++++++++++-
 mdadm.h   |  2 +-
 mdstat.c  | 18 +++++++++++++++---
 3 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index aed7a692..0fb4f77d 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -128,6 +128,7 @@ int Monitor(struct mddev_dev *devlist,
 	char *mailfrom;
 	struct alert_info info;
 	struct mddev_ident *mdlist;
+	int delay_for_event = c->delay;
 
 	if (!mailaddr) {
 		mailaddr = conf_get_mailaddr();
@@ -249,7 +250,18 @@ int Monitor(struct mddev_dev *devlist,
 				break;
 			}
 			else {
-				mdstat_wait(c->delay);
+				int wait_result = mdstat_wait(delay_for_event);
+
+				/*
+				 * If mdmonitor is awaken by event, set small delay once
+				 * to deal with udev and mdadm.
+				 */
+				if (wait_result != 0) {
+					if (c->delay > 5)
+						delay_for_event = 5;
+				} else
+					delay_for_event = c->delay;
+
 				mdstat_close();
 			}
 		}
diff --git a/mdadm.h b/mdadm.h
index 399478b8..4961c0f9 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -628,7 +628,7 @@ struct mdstat_ent {
 extern struct mdstat_ent *mdstat_read(int hold, int start);
 extern void mdstat_close(void);
 extern void free_mdstat(struct mdstat_ent *ms);
-extern void mdstat_wait(int seconds);
+extern int mdstat_wait(int seconds);
 extern void mdstat_wait_fd(int fd, const sigset_t *sigmask);
 extern int mddev_busy(char *devnm);
 extern struct mdstat_ent *mdstat_by_component(char *name);
diff --git a/mdstat.c b/mdstat.c
index 48559e64..dd96cca7 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -302,7 +302,17 @@ void mdstat_close(void)
 	mdstat_fd = -1;
 }
 
-void mdstat_wait(int seconds)
+/*
+ * function: mdstat_wait
+ * Description: Function waits for event on mdstat.
+ * Parameters:
+ *		seconds - timeout for waiting
+ * Returns:
+ *		> 0 - detected event
+ *		0 - timeout
+ *		< 0 - detected error
+ */
+int mdstat_wait(int seconds)
 {
 	fd_set fds;
 	struct timeval tm;
@@ -312,10 +322,12 @@ void mdstat_wait(int seconds)
 		FD_SET(mdstat_fd, &fds);
 		maxfd = mdstat_fd;
 	} else
-		return;
+		return -1;
+
 	tm.tv_sec = seconds;
 	tm.tv_usec = 0;
-	select(maxfd + 1, NULL, NULL, &fds, &tm);
+
+	return select(maxfd + 1, NULL, NULL, &fds, &tm);
 }
 
 void mdstat_wait_fd(int fd, const sigset_t *sigmask)
-- 
2.25.0

