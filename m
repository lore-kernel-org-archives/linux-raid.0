Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55FD3C46467
	for <linux-raid@archiver.kernel.org>; Thu, 19 Jan 2023 13:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjASNta (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Jan 2023 08:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjASNtL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Jan 2023 08:49:11 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED565278
        for <linux-raid@vger.kernel.org>; Thu, 19 Jan 2023 05:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674136148; x=1705672148;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dJiHTtaWo3mRxtujNiZLE5lgioEEq2Dhan2EeqPz/ew=;
  b=JTqwZ6RlnaUiCF5C2F2Bdi8ROK+pz1AvyTx7EXz2qrtpIj0Y/brNfkHE
   /wRzgXPWQ+NCY/xSog4vFZuPwe9G5oBoE7H64GEEyhSrevhoXpEmINUeu
   SxzipEE0RFEbugnZcvtcN5Jmud9qjFCL+az464qXTQBccGwjlJTeRnMzE
   8bqMvP8mjKoto13dfBlN16wEeT9qJBmbrmzPsgebtJBnC/ZeuZAHxZOaU
   BTwx+SJi6wzi4sQ9BMQRYRzirxM17RbLldaE5RpXlNFShf/bUr/RERfb8
   DjJNRss+VpW/tGur6Gsy8Mzk8TziBCjpscE2Oo5nwBUzNKcvA8PCpk3dd
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="323973383"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="323973383"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 05:49:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="768221945"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="768221945"
Received: from unknown (HELO localhost.elements.local) ([10.102.104.85])
  by fmsmga002.fm.intel.com with ESMTP; 19 Jan 2023 05:49:05 -0800
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH 3/8] Mdmonitor: Add helper functions
Date:   Thu, 19 Jan 2023 14:30:04 +0100
Message-Id: <20230119133009.12696-4-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230119133009.12696-1-mateusz.grzonka@intel.com>
References: <20230119133009.12696-1-mateusz.grzonka@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Add functions:
- is_email_event(),
- get_syslog_event_priority(),
- sprint_event_message(),
with kernel style comments containing more detailed descriptions.

Also update event syslog priorities to be consistent with man. MoveSpare event was described in man as priority info, while implemented as warning. Move event data into a struct, so that it is passed between different functions if needed.
Sort function declarations alphabetically and remove redundant alert() declaration.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 Monitor.c | 228 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 158 insertions(+), 70 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 029e9efd..39598ba0 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -73,10 +73,12 @@ enum event {
 	EVENT_NEW_ARRAY,
 	EVENT_MOVE_SPARE,
 	EVENT_TEST_MESSAGE,
+	__SYSLOG_PRIORITY_WARNING,
 	EVENT_REBUILD_STARTED,
 	EVENT_REBUILD,
 	EVENT_REBUILD_FINISHED,
 	EVENT_SPARES_MISSING,
+	__SYSLOG_PRIORITY_CRITICAL,
 	EVENT_DEVICE_DISAPPEARED,
 	EVENT_FAIL,
 	EVENT_FAIL_SPARE,
@@ -100,18 +102,31 @@ mapping_t events_map[] = {
 	{NULL, EVENT_UNKNOWN}
 };
 
-static int make_daemon(char *pidfile);
-static int check_one_sharer(int scan);
-static void write_autorebuild_pid(void);
-static void alert(const enum event event_enum, const unsigned int progress, const char *dev, const char *disc);
-static int check_array(struct state *st, struct mdstat_ent *mdstat, int increments, char *prefer);
+struct event_data {
+	enum event event_enum;
+	/*
+	 * @event_name: Rebuild event name must be in form "RebuildXX", where XX is rebuild progress.
+	 */
+	char event_name[EVENT_NAME_MAX];
+	char message[BUFSIZ];
+	const char *description;
+	const char *dev;
+	const char *disc;
+};
+
 static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist);
 static void try_spare_migration(struct state *statelist);
 static void link_containers_with_subarrays(struct state *list);
 static void free_statelist(struct state *statelist);
+static int check_array(struct state *st, struct mdstat_ent *mdstat, int increments, char *prefer);
+static int check_one_sharer(int scan);
 #ifndef NO_LIBUDEV
 static int check_udev_activity(void);
 #endif
+static void link_containers_with_subarrays(struct state *list);
+static int make_daemon(char *pidfile);
+static void try_spare_migration(struct state *statelist);
+static void write_autorebuild_pid(void);
 
 int Monitor(struct mddev_dev *devlist,
 	    char *mailaddr, char *alert_cmd,
@@ -450,7 +465,80 @@ static void write_autorebuild_pid()
 	}
 }
 
-static void execute_alert_cmd(const char *event_name, const char *dev, const char *disc)
+#define BASE_MESSAGE "%s event detected on md device %s"
+#define COMPONENT_DEVICE_MESSAGE ", component device %s"
+#define DESCRIPTION_MESSAGE ": %s"
+/*
+ * sprint_event_message() - Writes basic message about detected event to destination ptr.
+ * @dest: message destination, should be at least the size of BUFSIZ
+ * @data: event data
+ *
+ * Return: 0 on success, 1 on error
+ */
+static int sprint_event_message(char *dest, const struct event_data *data)
+{
+	if (!dest || !data)
+		return 1;
+
+	if (data->disc && data->description)
+		snprintf(dest, BUFSIZ, BASE_MESSAGE COMPONENT_DEVICE_MESSAGE DESCRIPTION_MESSAGE,
+			 data->event_name, data->dev, data->disc, data->description);
+	else if (data->disc)
+		snprintf(dest, BUFSIZ, BASE_MESSAGE COMPONENT_DEVICE_MESSAGE,
+			 data->event_name, data->dev, data->disc);
+	else if (data->description)
+		snprintf(dest, BUFSIZ, BASE_MESSAGE DESCRIPTION_MESSAGE,
+			 data->event_name, data->dev, data->description);
+	else
+		snprintf(dest, BUFSIZ, BASE_MESSAGE, data->event_name, data->dev);
+
+	return 0;
+}
+
+/*
+ * get_syslog_event_priority() - Determines event priority.
+ * @event_enum: event to be checked
+ *
+ * Return: LOG_CRIT, LOG_WARNING or LOG_INFO
+ */
+static int get_syslog_event_priority(const enum event event_enum)
+{
+	if (event_enum > __SYSLOG_PRIORITY_CRITICAL)
+		return LOG_CRIT;
+	if (event_enum > __SYSLOG_PRIORITY_WARNING)
+		return LOG_WARNING;
+	return LOG_INFO;
+}
+
+/*
+ * is_email_event() - Determines whether email for event should be sent or not.
+ * @event_enum: event to be checked
+ *
+ * Return: true if email should be sent, false otherwise
+ */
+static bool is_email_event(const enum event event_enum)
+{
+	static const enum event email_events[] = {
+	EVENT_FAIL,
+	EVENT_FAIL_SPARE,
+	EVENT_DEGRADED_ARRAY,
+	EVENT_SPARES_MISSING,
+	EVENT_TEST_MESSAGE
+	};
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(email_events); ++i) {
+		if (event_enum == email_events[i])
+			return true;
+	}
+	return false;
+}
+
+/*
+ * execute_alert_cmd() - Forks and executes command provided as alert_cmd.
+ * @data: event data
+ */
+static void execute_alert_cmd(const struct event_data *data)
 {
 	int pid = fork();
 
@@ -462,12 +550,16 @@ static void execute_alert_cmd(const char *event_name, const char *dev, const cha
 		pr_err("Cannot fork to execute alert command");
 		break;
 	case 0:
-		execl(info.alert_cmd, info.alert_cmd, event_name, dev, disc, NULL);
+		execl(info.alert_cmd, info.alert_cmd, data->event_name, data->dev, data->disc, NULL);
 		exit(2);
 	}
 }
 
-static void send_event_email(const char *event_name, const char *dev, const char *disc)
+/*
+ * send_event_email() - Sends an email about event detected by monitor.
+ * @data: event data
+ */
+static void send_event_email(const struct event_data *data)
 {
 	FILE *mp, *mdstat;
 	char buf[BUFSIZ];
@@ -485,15 +577,9 @@ static void send_event_email(const char *event_name, const char *dev, const char
 	else
 		fprintf(mp, "From: %s monitoring <root>\n", Name);
 	fprintf(mp, "To: %s\n", info.mailaddr);
-	fprintf(mp, "Subject: %s event on %s:%s\n\n", event_name, dev, info.hostname);
-	fprintf(mp, "This is an automatically generated mail message. \n");
-	fprintf(mp, "A %s event had been detected on md device %s.\n\n", event_name, dev);
-
-	if (disc && disc[0] != ' ')
-		fprintf(mp,
-			"It could be related to component device %s.\n\n", disc);
-	if (disc && disc[0] == ' ')
-		fprintf(mp, "Extra information:%s.\n\n", disc);
+	fprintf(mp, "Subject: %s event on %s:%s\n\n", data->event_name, data->dev, info.hostname);
+	fprintf(mp, "This is an automatically generated mail message.\n");
+	fprintf(mp, "%s\n", data->message);
 
 	mdstat = fopen("/proc/mdstat", "r");
 	if (!mdstat) {
@@ -509,58 +595,60 @@ static void send_event_email(const char *event_name, const char *dev, const char
 	pclose(mp);
 }
 
-static void log_event_to_syslog(const enum event event_enum, const char *event_name, const char *dev, const char *disc)
+/*
+ * log_event_to_syslog() - Logs an event into syslog.
+ * @data: event data
+ */
+static void log_event_to_syslog(const struct event_data *data)
 {
 	int priority;
-	/* Log at a different severity depending on the event.
-	 *
-	 * These are the critical events:  */
-	if (event_enum == EVENT_FAIL ||
-	    event_enum == EVENT_DEGRADED_ARRAY ||
-	    event_enum == EVENT_DEVICE_DISAPPEARED)
-		priority = LOG_CRIT;
-	/* Good to know about, but are not failures: */
-	else if (event_enum == EVENT_REBUILD ||
-		 event_enum == EVENT_MOVE_SPARE ||
-		 event_enum == EVENT_SPARES_MISSING)
-		priority = LOG_WARNING;
-	/* Everything else: */
-	else
-		priority = LOG_INFO;
-
-	if (disc && disc[0] != ' ')
-		syslog(priority,
-		       "%s event detected on md device %s, component device %s",
-		       event_name, dev, disc);
-	else if (disc)
-		syslog(priority, "%s event detected on md device %s: %s", event_name, dev, disc);
-	else
-		syslog(priority, "%s event detected on md device %s", event_name, dev);
+
+	priority = get_syslog_event_priority(data->event_enum);
+
+	syslog(priority, "%s\n", data->message);
 }
 
-static void alert(const enum event event_enum, const unsigned int progress, const char *dev, const char *disc)
+/*
+ * alert() - Alerts about the monitor event.
+ * @event_enum: event to be sent
+ * @description: event description
+ * @progress: rebuild progress
+ * @dev: md device name
+ * @disc: component device
+ *
+ * If needed function executes alert command, sends an email or logs event to syslog.
+ */
+static void alert(const enum event event_enum, const char *description, const uint8_t progress,
+		  const char *dev, const char *disc)
 {
-	char event_name[EVENT_NAME_MAX];
+	struct event_data data = {.dev = dev, .disc = disc, .description = description};
+
+	if (!dev)
+		return;
 
 	if (event_enum == EVENT_REBUILD) {
-		snprintf(event_name, sizeof(event_name), "%s%02d",
+		snprintf(data.event_name, sizeof(data.event_name), "%s%02d",
 			 map_num_s(events_map, EVENT_REBUILD), progress);
 	} else {
-		snprintf(event_name, sizeof(event_name), "%s", map_num_s(events_map, event_enum));
+		snprintf(data.event_name, sizeof(data.event_name), "%s", map_num_s(events_map, event_enum));
 	}
 
-	if (info.alert_cmd)
-		execute_alert_cmd(event_name, dev, disc);
+	data.event_enum = event_enum;
 
-	if (info.mailaddr && (event_enum == EVENT_FAIL ||
-			      event_enum == EVENT_TEST_MESSAGE ||
-			      event_enum == EVENT_SPARES_MISSING ||
-			      event_enum == EVENT_DEGRADED_ARRAY)) {
-		send_event_email(event_name, dev, disc);
+	if (sprint_event_message(data.message, &data) != 0) {
+		pr_err("Cannot create event message.\n");
+		return;
 	}
+	pr_err("%s\n", data.message);
+
+	if (info.alert_cmd)
+		execute_alert_cmd(&data);
+
+	if (info.mailaddr && is_email_event(event_enum))
+		send_event_email(&data);
 
 	if (info.dosyslog)
-		log_event_to_syslog(event_enum, event_name, dev, disc);
+		log_event_to_syslog(&data);
 }
 
 static int check_array(struct state *st, struct mdstat_ent *mdstat,
@@ -585,7 +673,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	unsigned long redundancy_only_flags = 0;
 
 	if (info.test)
-		alert(EVENT_TEST_MESSAGE, 0, dev, NULL);
+		alert(EVENT_TEST_MESSAGE, NULL, 0, dev, NULL);
 
 	retval = 0;
 
@@ -634,7 +722,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	 */
 	if (sra->array.level == 0 || sra->array.level == -1) {
 		if (!st->err && !st->from_config)
-			alert(EVENT_DEVICE_DISAPPEARED, 0, dev, " Wrong-Level");
+			alert(EVENT_DEVICE_DISAPPEARED, "Wrong-Level", 0, dev, NULL);
 		st->err++;
 		goto out;
 	}
@@ -651,7 +739,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 		st->percent = RESYNC_NONE;
 		new_array = 1;
 		if (!is_container)
-			alert(EVENT_NEW_ARRAY, 0, st->devname, NULL);
+			alert(EVENT_NEW_ARRAY, NULL, 0, st->devname, NULL);
 	}
 
 	if (st->utime == array.utime && st->failed == sra->array.failed_disks &&
@@ -664,20 +752,20 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	}
 	if (st->utime == 0 && /* new array */
 	    mse->pattern && strchr(mse->pattern, '_') /* degraded */)
-		alert(EVENT_DEGRADED_ARRAY, 0, dev, NULL);
+		alert(EVENT_DEGRADED_ARRAY, NULL, 0, dev, NULL);
 
 	if (st->utime == 0 && /* new array */ st->expected_spares > 0 &&
 	    sra->array.spare_disks < st->expected_spares)
-		alert(EVENT_SPARES_MISSING, 0, dev, NULL);
+		alert(EVENT_SPARES_MISSING, NULL, 0, dev, NULL);
 	if (st->percent < 0 && st->percent != RESYNC_UNKNOWN &&
 	    mse->percent >= 0)
-		alert(EVENT_REBUILD_STARTED, 0, dev, NULL);
+		alert(EVENT_REBUILD_STARTED, NULL, 0, dev, NULL);
 	if (st->percent >= 0 && mse->percent >= 0 &&
 	    (mse->percent / increments) > (st->percent / increments)) {
 		if((mse->percent / increments) == 0)
-			alert(EVENT_REBUILD_STARTED, 0, dev, NULL);
+			alert(EVENT_REBUILD_STARTED, NULL, 0, dev, NULL);
 		else
-			alert(EVENT_REBUILD, mse->percent, dev, NULL);
+			alert(EVENT_REBUILD, NULL, mse->percent, dev, NULL);
 	}
 
 	if (mse->percent == RESYNC_NONE && st->percent >= 0) {
@@ -690,9 +778,9 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 			snprintf(cnt, sizeof(cnt),
 				 " mismatches found: %d (on raid level %d)",
 				 sra->mismatch_cnt, sra->array.level);
-			alert(EVENT_REBUILD_FINISHED, 0, dev, cnt);
+			alert(EVENT_REBUILD_FINISHED, NULL, 0, dev, cnt);
 		} else
-			alert(EVENT_REBUILD_FINISHED, 0, dev, NULL);
+			alert(EVENT_REBUILD_FINISHED, NULL, 0, dev, NULL);
 	}
 	st->percent = mse->percent;
 
@@ -746,14 +834,14 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 		change = newstate ^ st->devstate[i];
 		if (st->utime && change && !st->err && !new_array) {
 			if ((st->devstate[i]&change) & (1 << MD_DISK_SYNC))
-				alert(EVENT_FAIL, 0, dev, dv);
+				alert(EVENT_FAIL, NULL, 0, dev, dv);
 			else if ((newstate & (1 << MD_DISK_FAULTY)) &&
 				 (disc.major || disc.minor) &&
 				 st->devid[i] == makedev(disc.major,
 							 disc.minor))
-				alert(EVENT_FAIL_SPARE, 0, dev, dv);
+				alert(EVENT_FAIL_SPARE, NULL, 0, dev, dv);
 			else if ((newstate&change) & (1 << MD_DISK_SYNC))
-				alert(EVENT_SPARE_ACTIVE, 0, dev, dv);
+				alert(EVENT_SPARE_ACTIVE, NULL, 0, dev, dv);
 		}
 		st->devstate[i] = newstate;
 		st->devid[i] = makedev(disc.major, disc.minor);
@@ -777,7 +865,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 
  disappeared:
 	if (!st->err && !is_container)
-		alert(EVENT_DEVICE_DISAPPEARED, 0, dev, NULL);
+		alert(EVENT_DEVICE_DISAPPEARED, NULL, 0, dev, NULL);
 	st->err++;
 	goto out;
 }
@@ -836,7 +924,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist)
 				st->parent_devnm[0] = 0;
 			*statelist = st;
 			if (info.test)
-				alert(EVENT_TEST_MESSAGE, 0, st->devname, NULL);
+				alert(EVENT_TEST_MESSAGE, NULL, 0, st->devname, NULL);
 			new_found = 1;
 		}
 	return new_found;
@@ -1059,7 +1147,7 @@ static void try_spare_migration(struct state *statelist)
 				if (devid > 0 &&
 				    move_spare(from->devname, to->devname,
 					       devid)) {
-					alert(EVENT_MOVE_SPARE, 0, to->devname, from->devname);
+					alert(EVENT_MOVE_SPARE, NULL, 0, to->devname, from->devname);
 					break;
 				}
 			}
-- 
2.26.2

