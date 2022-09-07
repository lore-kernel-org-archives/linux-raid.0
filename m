Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2673EC38145
	for <linux-raid@archiver.kernel.org>; Wed,  7 Sep 2022 13:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiIGNOk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Sep 2022 09:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiIGNOa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Sep 2022 09:14:30 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277091D7
        for <linux-raid@vger.kernel.org>; Wed,  7 Sep 2022 06:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662556462; x=1694092462;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IIPOjDOB+kQBGLbcXFDNJjQ6lLs0onhjFQJYEirAcig=;
  b=bVEBmAtiYlSp0XBPmxT1lBdLkP2uCSyObmq4unnkOLszIHXNQ8O55KFD
   Ez4xqoQ6kphYWBImojr92EDqBEMT79v5gXCs8GN8CDLZL0pdWEsm67Vyx
   6LxUaT/ETvqIqh1ZdSuK8PjzykhE+ajQVSCpNhOT+C4Nm/6YzKRnASKms
   yq0UR2ScMnkDLWyEYeci7zu4Tc1+T+257zJUvyPHosPyoe5w3DsKgOSs9
   JE2Flk6uv4yAbShBQLebIbeMavaMQE7CmBGz8JWU32Pg88dDOmK28rmFo
   Zr/vyAKUI7JFA0enpYy+MezJOSYmBAyegmpCVuvTuNhZHgmlSfxAm68UO
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="296865355"
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="296865355"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2022 06:14:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="644608636"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.105.50])
  by orsmga008.jf.intel.com with ESMTP; 07 Sep 2022 06:14:20 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH 3/9] Mdmonitor: Pass events to alert() using enums instead of strings
Date:   Wed,  7 Sep 2022 14:56:51 +0200
Message-Id: <20220907125657.12192-4-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220907125657.12192-1-mateusz.grzonka@intel.com>
References: <20220907125657.12192-1-mateusz.grzonka@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Add events enum, and mapping_t struct, that maps them to strings, so
that enums are passed around instead of strings.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 Monitor.c | 136 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 83 insertions(+), 53 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 73c5790d..aa0ee047 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -32,6 +32,8 @@
 #include	<libudev.h>
 #endif
 
+#define EVENT_NAME_MAX 32
+
 struct state {
 	char *devname;
 	char devnm[32];	/* to sync with mdstat info */
@@ -65,10 +67,43 @@ struct alert_info {
 	int dosyslog;
 	int test;
 } info;
+
+enum event {
+	EVENT_SPARE_ACTIVE = 0,
+	EVENT_NEW_ARRAY,
+	EVENT_MOVE_SPARE,
+	EVENT_TEST_MESSAGE,
+	EVENT_REBUILD_STARTED,
+	EVENT_REBUILD,
+	EVENT_REBUILD_FINISHED,
+	EVENT_SPARES_MISSING,
+	EVENT_DEVICE_DISAPPEARED,
+	EVENT_FAIL,
+	EVENT_FAIL_SPARE,
+	EVENT_DEGRADED_ARRAY,
+	EVENT_UNKNOWN
+};
+
+mapping_t events_map[] = {
+	{"SpareActive", EVENT_SPARE_ACTIVE},
+	{"NewArray", EVENT_NEW_ARRAY},
+	{"MoveSpare", EVENT_MOVE_SPARE},
+	{"TestMessage", EVENT_TEST_MESSAGE},
+	{"RebuildStarted", EVENT_REBUILD_STARTED},
+	{"Rebuild", EVENT_REBUILD},
+	{"RebuildFinished", EVENT_REBUILD_FINISHED},
+	{"SparesMissing", EVENT_SPARES_MISSING},
+	{"DeviceDisappeared", EVENT_DEVICE_DISAPPEARED},
+	{"Fail", EVENT_FAIL},
+	{"FailSpare", EVENT_FAIL_SPARE},
+	{"DegradedArray", EVENT_DEGRADED_ARRAY},
+	{NULL, EVENT_UNKNOWN}
+};
+
 static int make_daemon(char *pidfile);
 static int check_one_sharer(int scan);
 static void write_autorebuild_pid(void);
-static void alert(const char *event, const char *dev, const char *disc);
+static void alert(const enum event event_enum, const unsigned int progress, const char *dev, const char *disc);
 static int check_array(struct state *st, struct mdstat_ent *mdstat, int increments, char *prefer);
 static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist);
 static void try_spare_migration(struct state *statelist);
@@ -405,7 +440,7 @@ static void write_autorebuild_pid()
 	}
 }
 
-static void execute_alert_cmd(const char *event, const char *dev, const char *disc)
+static void execute_alert_cmd(const char *event_name, const char *dev, const char *disc)
 {
 	int pid = fork();
 
@@ -417,12 +452,12 @@ static void execute_alert_cmd(const char *event, const char *dev, const char *di
 		pr_err("Cannot fork to execute alert command");
 		break;
 	case 0:
-		execl(info.alert_cmd, info.alert_cmd, event, dev, disc, NULL);
+		execl(info.alert_cmd, info.alert_cmd, event_name, dev, disc, NULL);
 		exit(2);
 	}
 }
 
-static void send_event_email(const char *event, const char *dev, const char *disc)
+static void send_event_email(const char *event_name, const char *dev, const char *disc)
 {
 	FILE *mp, *mdstat;
 	char buf[BUFSIZ];
@@ -440,9 +475,9 @@ static void send_event_email(const char *event, const char *dev, const char *dis
 	else
 		fprintf(mp, "From: %s monitoring <root>\n", Name);
 	fprintf(mp, "To: %s\n", info.mailaddr);
-	fprintf(mp, "Subject: %s event on %s:%s\n\n", event, dev, info.hostname);
+	fprintf(mp, "Subject: %s event on %s:%s\n\n", event_name, dev, info.hostname);
 	fprintf(mp, "This is an automatically generated mail message. \n");
-	fprintf(mp, "A %s event had been detected on md device %s.\n\n", event, dev);
+	fprintf(mp, "A %s event had been detected on md device %s.\n\n", event_name, dev);
 
 	if (disc && disc[0] != ' ')
 		fprintf(mp,
@@ -464,20 +499,20 @@ static void send_event_email(const char *event, const char *dev, const char *dis
 	pclose(mp);
 }
 
-static void log_event_to_syslog(const char *event, const char *dev, const char *disc)
+static void log_event_to_syslog(const enum event event_enum, const char *event_name, const char *dev, const char *disc)
 {
 	int priority;
 	/* Log at a different severity depending on the event.
 	 *
 	 * These are the critical events:  */
-	if (strncmp(event, "Fail", 4) == 0 ||
-		strncmp(event, "Degrade", 7) == 0 ||
-		strncmp(event, "DeviceDisappeared", 17) == 0)
+	if (event_enum == EVENT_FAIL ||
+	    event_enum == EVENT_DEGRADED_ARRAY ||
+	    event_enum == EVENT_DEVICE_DISAPPEARED)
 		priority = LOG_CRIT;
 	/* Good to know about, but are not failures: */
-	else if (strncmp(event, "Rebuild", 7) == 0 ||
-			strncmp(event, "MoveSpare", 9) == 0 ||
-			strncmp(event, "Spares", 6) != 0)
+	else if (event_enum == EVENT_REBUILD ||
+		 event_enum == EVENT_MOVE_SPARE ||
+		 event_enum == EVENT_SPARES_MISSING)
 		priority = LOG_WARNING;
 	/* Everything else: */
 	else
@@ -485,33 +520,37 @@ static void log_event_to_syslog(const char *event, const char *dev, const char *
 
 	if (disc && disc[0] != ' ')
 		syslog(priority,
-			"%s event detected on md device %s, component device %s", event, dev, disc);
+		       "%s event detected on md device %s, component device %s",
+		       event_name, dev, disc);
 	else if (disc)
-		syslog(priority, "%s event detected on md device %s: %s", event, dev, disc);
+		syslog(priority, "%s event detected on md device %s: %s", event_name, dev, disc);
 	else
-		syslog(priority, "%s event detected on md device %s", event, dev);
+		syslog(priority, "%s event detected on md device %s", event_name, dev);
 }
 
-static void alert(const char *event, const char *dev, const char *disc)
+static void alert(const enum event event_enum, const unsigned int progress, const char *dev, const char *disc)
 {
-	if (!info.alert_cmd && !info.mailaddr && !info.dosyslog) {
-		time_t now = time(0);
+	char event_name[EVENT_NAME_MAX];
 
-		printf("%1.15s: %s on %s %s\n", ctime(&now) + 4,
-		       event, dev, disc?disc:"unknown device");
+	if (event_enum == EVENT_REBUILD) {
+		snprintf(event_name, sizeof(event_name), "%s%02d",
+			 map_num_s(events_map, EVENT_REBUILD), progress);
+	} else {
+		snprintf(event_name, sizeof(event_name), "%s", map_num_s(events_map, event_enum));
 	}
+
 	if (info.alert_cmd)
-		execute_alert_cmd(event, dev, disc);
+		execute_alert_cmd(event_name, dev, disc);
 
-	if (info.mailaddr && (strncmp(event, "Fail", 4) == 0 ||
-			       strncmp(event, "Test", 4) == 0 ||
-			       strncmp(event, "Spares", 6) == 0 ||
-			       strncmp(event, "Degrade", 7) == 0)) {
-		send_event_email(event, dev, disc);
+	if (info.mailaddr && (event_enum == EVENT_FAIL ||
+			      event_enum == EVENT_TEST_MESSAGE ||
+			      event_enum == EVENT_SPARES_MISSING ||
+			      event_enum == EVENT_DEGRADED_ARRAY)) {
+		send_event_email(event_name, dev, disc);
 	}
 
 	if (info.dosyslog)
-		log_event_to_syslog(event, dev, disc);
+		log_event_to_syslog(event_enum, event_name, dev, disc);
 }
 
 static int check_array(struct state *st, struct mdstat_ent *mdstat,
@@ -536,7 +575,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	unsigned long redundancy_only_flags = 0;
 
 	if (info.test)
-		alert("TestMessage", dev, NULL);
+		alert(EVENT_TEST_MESSAGE, 0, dev, NULL);
 
 	retval = 0;
 
@@ -585,7 +624,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	 */
 	if (sra->array.level == 0 || sra->array.level == -1) {
 		if (!st->err && !st->from_config)
-			alert("DeviceDisappeared", dev, " Wrong-Level");
+			alert(EVENT_DEVICE_DISAPPEARED, 0, dev, " Wrong-Level");
 		st->err++;
 		goto out;
 	}
@@ -602,7 +641,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 		st->percent = RESYNC_NONE;
 		new_array = 1;
 		if (!is_container)
-			alert("NewArray", st->devname, NULL);
+			alert(EVENT_NEW_ARRAY, 0, st->devname, NULL);
 	}
 
 	if (st->utime == array.utime && st->failed == sra->array.failed_disks &&
@@ -615,29 +654,20 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	}
 	if (st->utime == 0 && /* new array */
 	    mse->pattern && strchr(mse->pattern, '_') /* degraded */)
-		alert("DegradedArray", dev, NULL);
+		alert(EVENT_DEGRADED_ARRAY, 0, dev, NULL);
 
 	if (st->utime == 0 && /* new array */ st->expected_spares > 0 &&
 	    sra->array.spare_disks < st->expected_spares)
-		alert("SparesMissing", dev, NULL);
+		alert(EVENT_SPARES_MISSING, 0, dev, NULL);
 	if (st->percent < 0 && st->percent != RESYNC_UNKNOWN &&
 	    mse->percent >= 0)
-		alert("RebuildStarted", dev, NULL);
+		alert(EVENT_REBUILD_STARTED, 0, dev, NULL);
 	if (st->percent >= 0 && mse->percent >= 0 &&
 	    (mse->percent / increments) > (st->percent / increments)) {
-		char percentalert[18];
-		/*
-		 * "RebuildNN" (10 chars) or "RebuildStarted" (15 chars)
-		 */
-
 		if((mse->percent / increments) == 0)
-			snprintf(percentalert, sizeof(percentalert),
-				 "RebuildStarted");
+			alert(EVENT_REBUILD_STARTED, 0, dev, NULL);
 		else
-			snprintf(percentalert, sizeof(percentalert),
-				 "Rebuild%02d", mse->percent);
-
-		alert(percentalert, dev, NULL);
+			alert(EVENT_REBUILD, mse->percent, dev, NULL);
 	}
 
 	if (mse->percent == RESYNC_NONE && st->percent >= 0) {
@@ -650,9 +680,9 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 			snprintf(cnt, sizeof(cnt),
 				 " mismatches found: %d (on raid level %d)",
 				 sra->mismatch_cnt, sra->array.level);
-			alert("RebuildFinished", dev, cnt);
+			alert(EVENT_REBUILD_FINISHED, 0, dev, cnt);
 		} else
-			alert("RebuildFinished", dev, NULL);
+			alert(EVENT_REBUILD_FINISHED, 0, dev, NULL);
 	}
 	st->percent = mse->percent;
 
@@ -706,14 +736,14 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 		change = newstate ^ st->devstate[i];
 		if (st->utime && change && !st->err && !new_array) {
 			if ((st->devstate[i]&change) & (1 << MD_DISK_SYNC))
-				alert("Fail", dev, dv);
+				alert(EVENT_FAIL, 0, dev, dv);
 			else if ((newstate & (1 << MD_DISK_FAULTY)) &&
 				 (disc.major || disc.minor) &&
 				 st->devid[i] == makedev(disc.major,
 							 disc.minor))
-				alert("FailSpare", dev, dv);
+				alert(EVENT_FAIL_SPARE, 0, dev, dv);
 			else if ((newstate&change) & (1 << MD_DISK_SYNC))
-				alert("SpareActive", dev, dv);
+				alert(EVENT_SPARE_ACTIVE, 0, dev, dv);
 		}
 		st->devstate[i] = newstate;
 		st->devid[i] = makedev(disc.major, disc.minor);
@@ -737,7 +767,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 
  disappeared:
 	if (!st->err && !is_container)
-		alert("DeviceDisappeared", dev, NULL);
+		alert(EVENT_DEVICE_DISAPPEARED, 0, dev, NULL);
 	st->err++;
 	goto out;
 }
@@ -797,7 +827,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist)
 				st->parent_devnm[0] = 0;
 			*statelist = st;
 			if (info.test)
-				alert("TestMessage", st->devname, NULL);
+				alert(EVENT_TEST_MESSAGE, 0, st->devname, NULL);
 			new_found = 1;
 		}
 	return new_found;
@@ -1020,7 +1050,7 @@ static void try_spare_migration(struct state *statelist)
 				if (devid > 0 &&
 				    move_spare(from->devname, to->devname,
 					       devid)) {
-					alert("MoveSpare", to->devname, from->devname);
+					alert(EVENT_MOVE_SPARE, 0, to->devname, from->devname);
 					break;
 				}
 			}
-- 
2.26.2

