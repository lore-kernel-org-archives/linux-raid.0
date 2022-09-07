Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E1FC6FA82
	for <linux-raid@archiver.kernel.org>; Wed,  7 Sep 2022 13:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiIGNOU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Sep 2022 09:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiIGNOS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Sep 2022 09:14:18 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BE180F6A
        for <linux-raid@vger.kernel.org>; Wed,  7 Sep 2022 06:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662556457; x=1694092457;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C7GW3DreKxsMkwQkVhuliAVbrPbCi0zLMxlR20lNwUM=;
  b=Rd8OX6RwBX9i5LQseeIAMoJkQa7cE0kJgSP38i66h/fj/SEutQZMVwhM
   4SO2w3yM9Jneiw8z4XNij1/OozVKVni4LpbsMGvbqlBLTJL2TgcHIEQgA
   or2mFPTdwOB57OsHhzghUSWjcB84bULlsW9URXfp0+ATw0EnCpoJEg9/v
   mJIDRaQzU68oxCiOKu5sHFWSpZ2C/p1nHYiG18b7A3CmCX1XDdUeNGKo+
   a00Z2tdkw2KL3MGH8SIRdak5ct3ZYFhZtBvW99PwCSdXeeWRJH/ha+IQv
   yBTPYqtvAOxI0Ma9KxZasT242Fb7drg2HHRoo8Om5CgLC648OtnKRHGCM
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="296865335"
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="296865335"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2022 06:14:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="644608594"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.105.50])
  by orsmga008.jf.intel.com with ESMTP; 07 Sep 2022 06:14:15 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH 1/9] Mdmonitor: Split alert() into separate functions
Date:   Wed,  7 Sep 2022 14:56:49 +0200
Message-Id: <20220907125657.12192-2-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220907125657.12192-1-mateusz.grzonka@intel.com>
References: <20220907125657.12192-1-mateusz.grzonka@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 Monitor.c | 186 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 95 insertions(+), 91 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index c0ab5412..65e66474 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -66,7 +66,7 @@ struct alert_info {
 static int make_daemon(char *pidfile);
 static int check_one_sharer(int scan);
 static void write_autorebuild_pid(void);
-static void alert(char *event, char *dev, char *disc, struct alert_info *info);
+static void alert(const char *event, const char *dev, const char *disc, struct alert_info *info);
 static int check_array(struct state *st, struct mdstat_ent *mdstat,
 		       int test, struct alert_info *info,
 		       int increments, char *prefer);
@@ -402,111 +402,115 @@ static void write_autorebuild_pid()
 	}
 }
 
-static void alert(char *event, char *dev, char *disc, struct alert_info *info)
+static void execute_alert_cmd(const char *event, const char *dev, const char *disc, struct alert_info *info)
+{
+	int pid = fork();
+
+	switch (pid) {
+	default:
+		waitpid(pid, NULL, 0);
+		break;
+	case -1:
+		pr_err("Cannot fork to execute alert command");
+		break;
+	case 0:
+		execl(info->alert_cmd, info->alert_cmd, event, dev, disc, NULL);
+		exit(2);
+	}
+}
+
+static void send_event_email(const char *event, const char *dev, const char *disc, struct alert_info *info)
+{
+	FILE *mp, *mdstat;
+	char hname[256];
+	char buf[BUFSIZ];
+	int n;
+
+	mp = popen(Sendmail, "w");
+	if (!mp) {
+		pr_err("Cannot open pipe stream for sendmail.\n");
+		return;
+	}
+
+	gethostname(hname, sizeof(hname));
+	signal(SIGPIPE, SIG_IGN);
+	if (info->mailfrom)
+		fprintf(mp, "From: %s\n", info->mailfrom);
+	else
+		fprintf(mp, "From: %s monitoring <root>\n", Name);
+	fprintf(mp, "To: %s\n", info->mailaddr);
+	fprintf(mp, "Subject: %s event on %s:%s\n\n", event, dev, hname);
+	fprintf(mp, "This is an automatically generated mail message. \n");
+	fprintf(mp, "A %s event had been detected on md device %s.\n\n", event, dev);
+
+	if (disc && disc[0] != ' ')
+		fprintf(mp,
+			"It could be related to component device %s.\n\n", disc);
+	if (disc && disc[0] == ' ')
+		fprintf(mp, "Extra information:%s.\n\n", disc);
+
+	mdstat = fopen("/proc/mdstat", "r");
+	if (!mdstat) {
+		pr_err("Cannot open /proc/mdstat\n");
+		pclose(mp);
+		return;
+	}
+
+	fprintf(mp, "The /proc/mdstat file currently contains the following:\n\n");
+	while ((n = fread(buf, 1, sizeof(buf), mdstat)) > 0)
+		n = fwrite(buf, 1, n, mp);
+	fclose(mdstat);
+	pclose(mp);
+}
+
+static void log_event_to_syslog(const char *event, const char *dev, const char *disc)
 {
 	int priority;
+	/* Log at a different severity depending on the event.
+	 *
+	 * These are the critical events:  */
+	if (strncmp(event, "Fail", 4) == 0 ||
+		strncmp(event, "Degrade", 7) == 0 ||
+		strncmp(event, "DeviceDisappeared", 17) == 0)
+		priority = LOG_CRIT;
+	/* Good to know about, but are not failures: */
+	else if (strncmp(event, "Rebuild", 7) == 0 ||
+			strncmp(event, "MoveSpare", 9) == 0 ||
+			strncmp(event, "Spares", 6) != 0)
+		priority = LOG_WARNING;
+	/* Everything else: */
+	else
+		priority = LOG_INFO;
 
+	if (disc && disc[0] != ' ')
+		syslog(priority,
+			"%s event detected on md device %s, component device %s", event, dev, disc);
+	else if (disc)
+		syslog(priority, "%s event detected on md device %s: %s", event, dev, disc);
+	else
+		syslog(priority, "%s event detected on md device %s", event, dev);
+}
+
+static void alert(const char *event, const char *dev, const char *disc, struct alert_info *info)
+{
 	if (!info->alert_cmd && !info->mailaddr && !info->dosyslog) {
 		time_t now = time(0);
 
 		printf("%1.15s: %s on %s %s\n", ctime(&now) + 4,
 		       event, dev, disc?disc:"unknown device");
 	}
-	if (info->alert_cmd) {
-		int pid = fork();
-		switch(pid) {
-		default:
-			waitpid(pid, NULL, 0);
-			break;
-		case -1:
-			break;
-		case 0:
-			execl(info->alert_cmd, info->alert_cmd,
-			      event, dev, disc, NULL);
-			exit(2);
-		}
-	}
+	if (info->alert_cmd)
+		execute_alert_cmd(event, dev, disc, info);
+
 	if (info->mailaddr && (strncmp(event, "Fail", 4) == 0 ||
 			       strncmp(event, "Test", 4) == 0 ||
 			       strncmp(event, "Spares", 6) == 0 ||
 			       strncmp(event, "Degrade", 7) == 0)) {
-		FILE *mp = popen(Sendmail, "w");
-		if (mp) {
-			FILE *mdstat;
-			char hname[256];
-
-			gethostname(hname, sizeof(hname));
-			signal_s(SIGPIPE, SIG_IGN);
-
-			if (info->mailfrom)
-				fprintf(mp, "From: %s\n", info->mailfrom);
-			else
-				fprintf(mp, "From: %s monitoring <root>\n",
-					Name);
-			fprintf(mp, "To: %s\n", info->mailaddr);
-			fprintf(mp, "Subject: %s event on %s:%s\n\n",
-				event, dev, hname);
-
-			fprintf(mp,
-				"This is an automatically generated mail message from %s\n", Name);
-			fprintf(mp, "running on %s\n\n", hname);
-
-			fprintf(mp,
-				"A %s event had been detected on md device %s.\n\n", event, dev);
-
-			if (disc && disc[0] != ' ')
-				fprintf(mp,
-					"It could be related to component device %s.\n\n", disc);
-			if (disc && disc[0] == ' ')
-				fprintf(mp, "Extra information:%s.\n\n", disc);
-
-			fprintf(mp, "Faithfully yours, etc.\n");
-
-			mdstat = fopen("/proc/mdstat", "r");
-			if (mdstat) {
-				char buf[8192];
-				int n;
-				fprintf(mp,
-					"\nP.S. The /proc/mdstat file currently contains the following:\n\n");
-				while ((n = fread(buf, 1, sizeof(buf),
-						  mdstat)) > 0)
-					n = fwrite(buf, 1, n, mp);
-				fclose(mdstat);
-			}
-			pclose(mp);
-		}
+		send_event_email(event, dev, disc, info);
 	}
 
-	/* log the event to syslog maybe */
-	if (info->dosyslog) {
-		/* Log at a different severity depending on the event.
-		 *
-		 * These are the critical events:  */
-		if (strncmp(event, "Fail", 4) == 0 ||
-		    strncmp(event, "Degrade", 7) == 0 ||
-		    strncmp(event, "DeviceDisappeared", 17) == 0)
-			priority = LOG_CRIT;
-		/* Good to know about, but are not failures: */
-		else if (strncmp(event, "Rebuild", 7) == 0 ||
-			 strncmp(event, "MoveSpare", 9) == 0 ||
-			 strncmp(event, "Spares", 6) != 0)
-			priority = LOG_WARNING;
-		/* Everything else: */
-		else
-			priority = LOG_INFO;
-
-		if (disc && disc[0] != ' ')
-			syslog(priority,
-			       "%s event detected on md device %s, component device %s", event, dev, disc);
-		else if (disc)
-			syslog(priority,
-			       "%s event detected on md device %s: %s",
-			       event, dev, disc);
-		else
-			syslog(priority,
-			       "%s event detected on md device %s",
-			       event, dev);
-	}
+	if (info->dosyslog)
+		log_event_to_syslog(event, dev, disc);
 }
 
 static int check_array(struct state *st, struct mdstat_ent *mdstat,
-- 
2.26.2

