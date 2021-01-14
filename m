Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4264BC433E6
	for <linux-raid@archiver.kernel.org>; Thu, 14 Jan 2021 14:15:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AC7623A6A
	for <linux-raid@archiver.kernel.org>; Thu, 14 Jan 2021 14:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbhANOPU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Jan 2021 09:15:20 -0500
Received: from mga18.intel.com ([134.134.136.126]:20172 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbhANOPU (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 14 Jan 2021 09:15:20 -0500
IronPort-SDR: LCwkfUtwYpM3W5wVokq9Z/41LpjxNDJK3uh/RpdW3nrXe3h0fEGOShQeqcMTdh0n01PP+oK+NS
 Vac7w+qLfkpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9863"; a="166042596"
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="166042596"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 06:14:38 -0800
IronPort-SDR: ljW9OHlTw71YzcZ6SyDBAfnZUecM1T4ycV9vAtQ+tY+DvShboj+OtC1EthzTVATOUSRr492KeC
 TIeoIKuPQP5Q==
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="382278768"
Received: from unknown (HELO gklab-109-123.igk.intel.com) ([10.102.109.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 06:14:37 -0800
From:   Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] mdmonitor: check if udev has finished events processing
Date:   Thu, 14 Jan 2021 15:14:16 +0100
Message-Id: <20210114141416.42934-1-oleksandr.shchirskyi@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If mdmonitor is awaken by event, wait for udev to finish
events processing, to eliminate the race between udev and mdadm
when spare has been added and need to be moved by mdmonitor

Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
---
 Makefile  |  2 +-
 Monitor.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 63 insertions(+), 12 deletions(-)

diff --git a/Makefile b/Makefile
index 4cd4c9d8..1e6e1e12 100644
--- a/Makefile
+++ b/Makefile
@@ -119,7 +119,7 @@ endif
 # If you want a static binary, you might uncomment these
 # LDFLAGS = -static
 # STRIP = -s
-LDLIBS=-ldl
+LDLIBS=-ldl -ludev
 
 INSTALL = /usr/bin/install
 DESTDIR =
diff --git a/Monitor.c b/Monitor.c
index 3f3005b8..4c39145b 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -29,6 +29,7 @@
 #include	<signal.h>
 #include	<limits.h>
 #include	<syslog.h>
+#include	<libudev.h>
 
 struct state {
 	char *devname;
@@ -72,6 +73,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 			  int test, struct alert_info *info);
 static void try_spare_migration(struct state *statelist, struct alert_info *info);
 static void link_containers_with_subarrays(struct state *list);
+static int check_udev_activity(void);
 
 int Monitor(struct mddev_dev *devlist,
 	    char *mailaddr, char *alert_cmd,
@@ -129,7 +131,6 @@ int Monitor(struct mddev_dev *devlist,
 	char *mailfrom;
 	struct alert_info info;
 	struct mddev_ident *mdlist;
-	int delay_for_event = c->delay;
 
 	if (!mailaddr) {
 		mailaddr = conf_get_mailaddr();
@@ -244,7 +245,7 @@ int Monitor(struct mddev_dev *devlist,
 
 		/* If an array has active < raid && spare == 0 && spare_group != NULL
 		 * Look for another array with spare > 0 and active == raid and same spare_group
-		 *  if found, choose a device and hotremove/hotadd
+		 * if found, choose a device and hotremove/hotadd
 		 */
 		if (share && anydegraded)
 			try_spare_migration(statelist, &info);
@@ -255,17 +256,12 @@ int Monitor(struct mddev_dev *devlist,
 				break;
 			}
 			else {
-				int wait_result = mdstat_wait(delay_for_event);
-
 				/*
-				 * If mdmonitor is awaken by event, set small delay once
-				 * to deal with udev and mdadm.
+				 * If mdmonitor is awaken by event, check for udev activity
+				 * to wait for udev to finish new devices processing.
 				 */
-				if (wait_result != 0) {
-					if (c->delay > 5)
-						delay_for_event = 5;
-				} else
-					delay_for_event = c->delay;
+				if (mdstat_wait(c->delay) && check_udev_activity())
+					pr_err("Error while waiting for UDEV to complete new devices processing\n");
 
 				mdstat_close();
 			}
@@ -1037,6 +1033,61 @@ static void link_containers_with_subarrays(struct state *list)
 				}
 }
 
+
+/* function: check_udev_activity
+ * Description: Function waits for udev to finish
+ * events processing.
+ * Returns:
+ *		1 - detected error while opening udev
+ *		2 - timeout
+ *		0 - successfull completion
+ */
+static int check_udev_activity(void)
+{
+	struct udev *udev = NULL;
+	struct udev_queue *udev_queue = NULL;
+	int timeout_cnt = 30;
+	int rc = 0;
+
+	// in rare cases systemd may not have udev
+	// in such cases just exit with rc 0
+	if (!use_udev())
+		goto out;
+
+	udev = udev_new();
+	if (!udev) {
+		rc = 1;
+		goto out;
+	}
+
+	udev_queue = udev_queue_new(udev);
+	if (!udev_queue) {
+		rc = 1;
+		goto out;
+	}
+
+	if (udev_queue_get_queue_is_empty(udev_queue))
+		goto out;
+
+	while (!udev_queue_get_queue_is_empty(udev_queue)) {
+		sleep(1);
+
+		if (timeout_cnt)
+			timeout_cnt--;
+		else {
+			rc = 2;
+			goto out;
+		}
+	}
+
+out:
+	if (udev_queue)
+		udev_queue_unref(udev_queue);
+	if (udev)
+		udev_unref(udev);
+	return rc;
+}
+
 /* Not really Monitor but ... */
 int Wait(char *dev)
 {
-- 
2.27.0

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
ul. Sowackiego 173 | 80-298 Gdask | Sd Rejonowy Gdask Pnoc | VII Wydzia Gospodarczy Krajowego Rejestru Sdowego - KRS 101882 | NIP 957-07-52-316 | Kapita zakadowy 200.000 PLN.
Ta wiadomo wraz z zacznikami jest przeznaczona dla okrelonego adresata i moe zawiera informacje poufne. W razie przypadkowego otrzymania tej wiadomoci, prosimy o powiadomienie nadawcy oraz trwae jej usunicie; jakiekolwiek przegldanie lub rozpowszechnianie jest zabronione.
This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). If you are not the intended recipient, please contact the sender and delete all copies; any review or distribution by others is strictly prohibited.
 

