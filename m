Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 431A8C4338F
	for <linux-raid@archiver.kernel.org>; Fri, 30 Jul 2021 09:16:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27AF261008
	for <linux-raid@archiver.kernel.org>; Fri, 30 Jul 2021 09:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238178AbhG3JQl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 30 Jul 2021 05:16:41 -0400
Received: from mga03.intel.com ([134.134.136.65]:17861 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237864AbhG3JQT (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 30 Jul 2021 05:16:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10060"; a="213094861"
X-IronPort-AV: E=Sophos;i="5.84,281,1620716400"; 
   d="scan'208";a="213094861"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 02:16:11 -0700
X-IronPort-AV: E=Sophos;i="5.84,281,1620716400"; 
   d="scan'208";a="581818861"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 02:16:10 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] Add monitor delay parameter to mdadm.conf
Date:   Fri, 30 Jul 2021 11:16:00 +0200
Message-Id: <20210730091600.28014-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: oshchirs <oleksandr.shchirskyi@intel.com>

Add possibility to configure delay for mdadm in monitoring mode
using mdadm.conf.
--delay command line argument takes precedence over config file.

Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 config.c     | 23 ++++++++++++++++++++++-
 mdadm.c      |  6 ++----
 mdadm.conf.5 | 24 +++++++++++++++++++++---
 mdadm.h      |  1 +
 4 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/config.c b/config.c
index 7592b2d7..9c725457 100644
--- a/config.c
+++ b/config.c
@@ -81,7 +81,7 @@ char DefaultAltConfDir[] = CONFFILE2 ".d";
 
 enum linetype { Devices, Array, Mailaddr, Mailfrom, Program, CreateDev,
 		Homehost, HomeCluster, AutoMode, Policy, PartPolicy, Sysfs,
-		LTEnd };
+		MonitorDelay, LTEnd };
 char *keywords[] = {
 	[Devices]  = "devices",
 	[Array]    = "array",
@@ -95,6 +95,7 @@ char *keywords[] = {
 	[Policy]   = "policy",
 	[PartPolicy]="part-policy",
 	[Sysfs]    = "sysfs",
+	[MonitorDelay] = "monitordelay",
 	[LTEnd]    = NULL
 };
 
@@ -588,6 +589,17 @@ void homeclusterline(char *line)
 	}
 }
 
+static int monitor_delay;
+void monitordelayline(char *line)
+{
+	char *w;
+
+	for (w = dl_next(line); w != line; w = dl_next(w)) {
+		if (monitor_delay == 0)
+			monitor_delay = strtol(w, NULL, 10);
+	}
+}
+
 char auto_yes[] = "yes";
 char auto_no[] = "no";
 char auto_homehost[] = "homehost";
@@ -769,6 +781,9 @@ void conf_file(FILE *f)
 		case Sysfs:
 			sysfsline(line);
 			break;
+		case MonitorDelay:
+			monitordelayline(line);
+			break;
 		default:
 			pr_err("Unknown keyword %s\n", line);
 		}
@@ -925,6 +940,12 @@ char *conf_get_homecluster(void)
 	return home_cluster;
 }
 
+int conf_get_monitor_delay(void)
+{
+	load_conffile();
+	return monitor_delay;
+}
+
 struct createinfo *conf_get_create_info(void)
 {
 	load_conffile();
diff --git a/mdadm.c b/mdadm.c
index 493d70e4..fd61c25c 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1657,10 +1657,8 @@ int main(int argc, char *argv[])
 			break;
 		}
 		if (c.delay == 0) {
-			if (get_linux_version() > 2006016)
-				/* mdstat responds to poll */
-				c.delay = 1000;
-			else
+			c.delay = conf_get_monitor_delay();
+			if (!c.delay)
 				c.delay = 60;
 		}
 		rv = Monitor(devlist, mailaddr, program,
diff --git a/mdadm.conf.5 b/mdadm.conf.5
index 27dbab18..74a21c5f 100644
--- a/mdadm.conf.5
+++ b/mdadm.conf.5
@@ -505,7 +505,7 @@ Keywords used in the
 .I POLICY
 line and supported values are:
 
-.RS 7
+.RS 4
 .TP
 .B domain=
 any arbitrary string
@@ -589,7 +589,9 @@ found.
 
 .TP
 .B SYSFS
-The SYSFS line lists custom values of MD device's sysfs attributes which will be
+The
+.B SYSFS
+line lists custom values of MD device's sysfs attributes which will be
 stored in sysfs after the array is assembled. Multiple lines are allowed and each
 line has to contain the uuid or the name of the device to which it relates.
 .RS 4
@@ -604,8 +606,22 @@ name of the MD device as was given to
 when the array was created. It will be ignored if
 .B uuid
 is not empty.
+.RE
+
 .TP
-.RS 7
+.B MONITORDELAY
+The
+.B monitordelay
+line gives a delay in seconds
+.I mdadm
+shall wait before pooling md arrays
+when
+.I mdadm
+is running in
+.B \-\-monitor
+mode.
+.B \-d/\-\-delay
+command line argument takes precedence over the config file
 
 .SH EXAMPLE
 DEVICE /dev/sd[bcdjkl]1
@@ -682,6 +698,8 @@ SYSFS name=/dev/md/raid5 group_thread_cnt=4 sync_speed_max=1000000
 .br
 SYSFS uuid=bead5eb6:31c17a27:da120ba2:7dfda40d group_thread_cnt=4
 sync_speed_max=1000000
+.br
+MONITORDELAY 60
 
 .SH SEE ALSO
 .BR mdadm (8),
diff --git a/mdadm.h b/mdadm.h
index 1ee6c92e..c3334caf 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1521,6 +1521,7 @@ extern char *conf_get_mailfrom(void);
 extern char *conf_get_program(void);
 extern char *conf_get_homehost(int *require_homehostp);
 extern char *conf_get_homecluster(void);
+extern int conf_get_monitor_delay(void);
 extern char *conf_line(FILE *file);
 extern char *conf_word(FILE *file, int allow_key);
 extern void print_quoted(char *str);
-- 
2.26.2

