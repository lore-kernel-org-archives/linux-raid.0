Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F14BC433E0
	for <linux-raid@archiver.kernel.org>; Thu, 18 Mar 2021 16:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 312A164F01
	for <linux-raid@archiver.kernel.org>; Thu, 18 Mar 2021 16:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhCRQMu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Mar 2021 12:12:50 -0400
Received: from mga05.intel.com ([192.55.52.43]:46370 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231593AbhCRQMp (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 18 Mar 2021 12:12:45 -0400
IronPort-SDR: HHE7aeOGpTRnmw8uA9rf58KNnExLa81q3AlrT3qqNCxDY0T8ZjrrregqePJjHTnYuLopxsUdBN
 u+k09TflkWbQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="274773950"
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="274773950"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 09:12:44 -0700
IronPort-SDR: beQCx2TsKrTIVgzX9y3NpB7hZkXSnAawesLMEoYiUyMyVrC5oQQs/gs0Z5cMbk1JzaOm6WW34t
 /KyGUeX/xyRQ==
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="413144583"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 09:12:43 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] Monitor: make libudev dependency optional
Date:   Thu, 18 Mar 2021 17:12:35 +0100
Message-Id: <20210318161235.23168-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Make -ludev configurable, enabled by default.
To disable it, -DNO_LIBUDEV has to be set explicitly in CXFALGS.

This patch restores commit cab9c67d461c ("mdmonitor: set small delay
once") for configuration without libudev to bring minimal support in
such case.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Makefile  |  7 ++++++-
 Monitor.c | 28 +++++++++++++++++++++++-----
 2 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 1e6e1e12..2a51d813 100644
--- a/Makefile
+++ b/Makefile
@@ -119,7 +119,12 @@ endif
 # If you want a static binary, you might uncomment these
 # LDFLAGS = -static
 # STRIP = -s
-LDLIBS=-ldl -ludev
+LDLIBS = -ldl
+
+# To explicitly disable libudev, set -DNO_LIBUDEV in CXFLAGS
+ifeq (, $(findstring -DNO_LIBUDEV,  $(CXFLAGS)))
+	LDLIBS += -ludev
+endif
 
 INSTALL = /usr/bin/install
 DESTDIR =
diff --git a/Monitor.c b/Monitor.c
index 4c39145b..d68c3b42 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -29,7 +29,9 @@
 #include	<signal.h>
 #include	<limits.h>
 #include	<syslog.h>
+#ifndef NO_LIBUDEV
 #include	<libudev.h>
+#endif
 
 struct state {
 	char *devname;
@@ -73,7 +75,9 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 			  int test, struct alert_info *info);
 static void try_spare_migration(struct state *statelist, struct alert_info *info);
 static void link_containers_with_subarrays(struct state *list);
+#ifndef NO_LIBUDEV
 static int check_udev_activity(void);
+#endif
 
 int Monitor(struct mddev_dev *devlist,
 	    char *mailaddr, char *alert_cmd,
@@ -131,6 +135,7 @@ int Monitor(struct mddev_dev *devlist,
 	char *mailfrom;
 	struct alert_info info;
 	struct mddev_ident *mdlist;
+	int delay_for_event = c->delay;
 
 	if (!mailaddr) {
 		mailaddr = conf_get_mailaddr();
@@ -256,13 +261,25 @@ int Monitor(struct mddev_dev *devlist,
 				break;
 			}
 			else {
+#ifndef NO_LIBUDEV
 				/*
-				 * If mdmonitor is awaken by event, check for udev activity
-				 * to wait for udev to finish new devices processing.
+				 * Wait for udevd to finish new devices
+				 * processing.
 				 */
-				if (mdstat_wait(c->delay) && check_udev_activity())
+				if (mdstat_wait(delay_for_event) &&
+				    check_udev_activity())
 					pr_err("Error while waiting for UDEV to complete new devices processing\n");
-
+#else
+				int wait_result = mdstat_wait(delay_for_event);
+				/*
+				 * Give chance to process new device
+				 */
+				if (wait_result != 0) {
+					if (c->delay > 5)
+						delay_for_event = 5;
+				} else
+					delay_for_event = c->delay;
+#endif
 				mdstat_close();
 			}
 		}
@@ -1033,7 +1050,7 @@ static void link_containers_with_subarrays(struct state *list)
 				}
 }
 
-
+#ifndef NO_LIBUDEV
 /* function: check_udev_activity
  * Description: Function waits for udev to finish
  * events processing.
@@ -1087,6 +1104,7 @@ out:
 		udev_unref(udev);
 	return rc;
 }
+#endif
 
 /* Not really Monitor but ... */
 int Wait(char *dev)
-- 
2.26.2

