Return-Path: <SRS0=4QbR=EK=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD1F6C2D0A3
	for <linux-raid@archiver.kernel.org>; Wed,  4 Nov 2020 09:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 477682220B
	for <linux-raid@archiver.kernel.org>; Wed,  4 Nov 2020 09:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgKDJCw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 4 Nov 2020 04:02:52 -0500
Received: from mga17.intel.com ([192.55.52.151]:44583 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgKDJCv (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 4 Nov 2020 04:02:51 -0500
IronPort-SDR: rP1GzdXevovb95gGhrYxujRrkJ5juHJhp7+fhdbs9SyjtRFE3tysOEQQfqLdDRFqbs2ssjBPlB
 BjoHEq+yDvaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="149040246"
X-IronPort-AV: E=Sophos;i="5.77,450,1596524400"; 
   d="scan'208";a="149040246"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 01:02:50 -0800
IronPort-SDR: pSNQavy/dA5kc0VpQdiMwREMElIbXPZGnsrLtcYiqLfeSwwTT7A6+okjoYw4Fu/MVFPw+QEVCM
 ziWt80qQYadw==
X-IronPort-AV: E=Sophos;i="5.77,450,1596524400"; 
   d="scan'208";a="325534715"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 01:02:48 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] mdadm: Unify forks behaviour
Date:   Wed,  4 Nov 2020 10:02:36 +0100
Message-Id: <20201104090236.17146-1-mariusz.tkaczyk@intel.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If mdadm is run by udev or systemd, it gets a pipe as each stream.
Forks in the background may run after an event or service has been
processed when udev is detached from pipe. As a result process
fails quietly if any message is written.
To prevent from it, each fork has to close all parent streams. Leave
stderr and stdout opened only for debug purposes.
Unify it across all forks. Introduce other descriptors detection by
scanning /proc/self/fd directory. Add generic method for
managing systemd services.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
---
 Grow.c        |  52 +++------------------
 Incremental.c |   1 +
 Monitor.c     |   5 +-
 mdadm.h       |  10 ++++
 mdmon.c       |   9 +---
 util.c        | 124 ++++++++++++++++++++++++++++++++------------------
 6 files changed, 100 insertions(+), 101 deletions(-)

diff --git a/Grow.c b/Grow.c
index 57db7d45..6b8321c5 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2982,47 +2982,6 @@ static void catch_term(int sig)
 	sigterm = 1;
 }
 
-static int continue_via_systemd(char *devnm)
-{
-	int skipped, i, pid, status;
-	char pathbuf[1024];
-	/* In a systemd/udev world, it is best to get systemd to
-	 * run "mdadm --grow --continue" rather than running in the
-	 * background.
-	 */
-	switch(fork()) {
-	case  0:
-		/* FIXME yuk. CLOSE_EXEC?? */
-		skipped = 0;
-		for (i = 3; skipped < 20; i++)
-			if (close(i) < 0)
-				skipped++;
-			else
-				skipped = 0;
-
-		/* Don't want to see error messages from
-		 * systemctl.  If the service doesn't exist,
-		 * we fork ourselves.
-		 */
-		close(2);
-		open("/dev/null", O_WRONLY);
-		snprintf(pathbuf, sizeof(pathbuf),
-			 "mdadm-grow-continue@%s.service", devnm);
-		status = execl("/usr/bin/systemctl", "systemctl", "restart",
-			       pathbuf, NULL);
-		status = execl("/bin/systemctl", "systemctl", "restart",
-			       pathbuf, NULL);
-		exit(1);
-	case -1: /* Just do it ourselves. */
-		break;
-	default: /* parent - good */
-		pid = wait(&status);
-		if (pid >= 0 && status == 0)
-			return 1;
-	}
-	return 0;
-}
-
 static int reshape_array(char *container, int fd, char *devname,
 			 struct supertype *st, struct mdinfo *info,
 			 int force, struct mddev_dev *devlist,
@@ -3401,6 +3360,7 @@ static int reshape_array(char *container, int fd, char *devname,
 		default: /* parent */
 			return 0;
 		case 0:
+			manage_fork_fds(0);
 			map_fork();
 			break;
 		}
@@ -3509,8 +3469,9 @@ started:
 		return 1;
 	}
 
-	if (!forked && !check_env("MDADM_NO_SYSTEMCTL"))
-		if (continue_via_systemd(container ?: sra->sys_name)) {
+	if (!forked)
+		if (continue_via_systemd(container ?: sra->sys_name,
+					 GROW_SERVICE)) {
 			free(fdlist);
 			free(offsets);
 			sysfs_free(sra);
@@ -3704,8 +3665,8 @@ int reshape_container(char *container, char *devname,
 	 */
 	ping_monitor(container);
 
-	if (!forked && !freeze_reshape && !check_env("MDADM_NO_SYSTEMCTL"))
-		if (continue_via_systemd(container))
+	if (!forked && !freeze_reshape)
+		if (continue_via_systemd(container, GROW_SERVICE))
 			return 0;
 
 	switch (forked ? 0 : fork()) {
@@ -3718,6 +3679,7 @@ int reshape_container(char *container, char *devname,
 			printf("%s: multi-array reshape continues in background\n", Name);
 		return 0;
 	case 0: /* child */
+		manage_fork_fds(0);
 		map_fork();
 		break;
 	}
diff --git a/Incremental.c b/Incremental.c
index 98dbcd92..ad9ec1cc 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1679,6 +1679,7 @@ static void run_udisks(char *arg1, char *arg2)
 	int pid = fork();
 	int status;
 	if (pid == 0) {
+		manage_fork_fds(1);
 		execl("/usr/bin/udisks", "udisks", arg1, arg2, NULL);
 		execl("/bin/udisks", "udisks", arg1, arg2, NULL);
 		exit(1);
diff --git a/Monitor.c b/Monitor.c
index 2d6b3b90..66527c65 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -291,10 +291,7 @@ static int make_daemon(char *pidfile)
 		perror("daemonise");
 		return 1;
 	}
-	close(0);
-	open("/dev/null", O_RDWR);
-	dup2(0, 1);
-	dup2(0, 2);
+	manage_fork_fds(0);
 	setsid();
 	return -1;
 }
diff --git a/mdadm.h b/mdadm.h
index 399478b8..9b3ad1dc 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -129,6 +129,14 @@ struct dlm_lksb {
 #define FAILED_SLOTS_DIR "/run/mdadm/failed-slots"
 #endif /* FAILED_SLOTS */
 
+#ifndef MDMON_SERVICE
+#define MDMON_SERVICE "mdmon"
+#endif /* MDMON_SERVICE */
+
+#ifndef GROW_SERVICE
+#define GROW_SERVICE "mdadm-grow-continue"
+#endif /* GROW_SERVICE */
+
 #include	"md_u.h"
 #include	"md_p.h"
 #include	"bitmap.h"
@@ -1497,6 +1505,8 @@ extern int is_standard(char *dev, int *nump);
 extern int same_dev(char *one, char *two);
 extern int compare_paths (char* path1,char* path2);
 extern void enable_fds(int devices);
+extern void manage_fork_fds(int close_all);
+extern int continue_via_systemd(char *devnm, char *service_name);
 
 extern int parse_auto(char *str, char *msg, int config);
 extern struct mddev_ident *conf_get_ident(char *dev);
diff --git a/mdmon.c b/mdmon.c
index ff985d29..c71e62c6 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -546,14 +546,7 @@ static int mdmon(char *devnm, int must_fork, int takeover)
 	}
 
 	setsid();
-	close(0);
-	open("/dev/null", O_RDWR);
-	close(1);
-	ignore = dup(0);
-#ifndef DEBUG
-	close(2);
-	ignore = dup(0);
-#endif
+	manage_fork_fds(0);
 
 	/* This silliness is to stop the compiler complaining
 	 * that we ignore 'ignore'
diff --git a/util.c b/util.c
index 579dd423..58796947 100644
--- a/util.c
+++ b/util.c
@@ -1915,7 +1915,7 @@ int mdmon_running(char *devnm)
 
 int start_mdmon(char *devnm)
 {
-	int i, skipped;
+	int i;
 	int len;
 	pid_t pid;
 	int status;
@@ -1929,7 +1929,10 @@ int start_mdmon(char *devnm)
 
 	if (check_env("MDADM_NO_MDMON"))
 		return 0;
+	if (continue_via_systemd(devnm, MDMON_SERVICE))
+		return 0;
 
+	/* That failed, try running mdmon directly */
 	len = readlink("/proc/self/exe", pathbuf, sizeof(pathbuf)-1);
 	if (len > 0) {
 		char *sl;
@@ -1943,51 +1946,9 @@ int start_mdmon(char *devnm)
 	} else
 		pathbuf[0] = '\0';
 
-	/* First try to run systemctl */
-	if (!check_env("MDADM_NO_SYSTEMCTL"))
-		switch(fork()) {
-		case 0:
-			/* FIXME yuk. CLOSE_EXEC?? */
-			skipped = 0;
-			for (i = 3; skipped < 20; i++)
-				if (close(i) < 0)
-					skipped++;
-				else
-					skipped = 0;
-
-			/* Don't want to see error messages from
-			 * systemctl.  If the service doesn't exist,
-			 * we start mdmon ourselves.
-			 */
-			close(2);
-			open("/dev/null", O_WRONLY);
-			snprintf(pathbuf, sizeof(pathbuf), "mdmon@%s.service",
-				 devnm);
-			status = execl("/usr/bin/systemctl", "systemctl",
-				       "start",
-				       pathbuf, NULL);
-			status = execl("/bin/systemctl", "systemctl", "start",
-				       pathbuf, NULL);
-			exit(1);
-		case -1: pr_err("cannot run mdmon. Array remains readonly\n");
-			return -1;
-		default: /* parent - good */
-			pid = wait(&status);
-			if (pid >= 0 && status == 0)
-				return 0;
-		}
-
-	/* That failed, try running mdmon directly */
 	switch(fork()) {
 	case 0:
-		/* FIXME yuk. CLOSE_EXEC?? */
-		skipped = 0;
-		for (i = 3; skipped < 20; i++)
-			if (close(i) < 0)
-				skipped++;
-			else
-				skipped = 0;
-
+		manage_fork_fds(1);
 		for (i = 0; paths[i]; i++)
 			if (paths[i][0]) {
 				execl(paths[i], paths[i],
@@ -2192,6 +2153,81 @@ void enable_fds(int devices)
 	setrlimit(RLIMIT_NOFILE, &lim);
 }
 
+/* Close all opened descriptors if needed and redirect
+ * streams to /dev/null.
+ * For debug purposed, leave STDOUT and STDERR untouched
+ * Returns:
+ *	1- if any error occurred
+ *	0- otherwise
+ */
+void manage_fork_fds(int close_all)
+{
+	DIR *dir;
+	struct dirent *dirent;
+
+	close(0);
+	open("/dev/null", O_RDWR);
+
+#ifndef DEBUG
+	dup2(0, 1);
+	dup2(0, 2);
+#endif
+
+	if (close_all == 0)
+		return;
+
+	dir = opendir("/proc/self/fd");
+	if (!dir) {
+		pr_err("Cannot open /proc/self/fd directory.\n");
+		return;
+	}
+	for (dirent = readdir(dir); dirent; dirent = readdir(dir)) {
+		int fd = -1;
+
+		if ((strcmp(dirent->d_name, ".") == 0) ||
+		    (strcmp(dirent->d_name, "..")) == 0)
+			continue;
+
+		fd = strtol(dirent->d_name, NULL, 10);
+		if (fd > 2)
+			close(fd);
+	}
+}
+
+/* In a systemd/udev world, it is best to get systemd to
+ * run daemon rather than running in the background.
+ * Returns:
+ *	1- if systemd service has been started
+ *	0- otherwise
+ */
+int continue_via_systemd(char *devnm, char *service_name)
+{
+	int pid, status;
+	char pathbuf[1024];
+
+	/* Simply return that service cannot be started */
+	if (check_env("MDADM_NO_SYSTEMCTL"))
+		return 0;
+	switch (fork()) {
+	case  0:
+		manage_fork_fds(1);
+		snprintf(pathbuf, sizeof(pathbuf),
+			 "%s@%s.service", service_name, devnm);
+		status = execl("/usr/bin/systemctl", "systemctl", "restart",
+			       pathbuf, NULL);
+		status = execl("/bin/systemctl", "systemctl", "restart",
+			       pathbuf, NULL);
+		exit(1);
+	case -1: /* Just do it ourselves. */
+		break;
+	default: /* parent - good */
+		pid = wait(&status);
+		if (pid >= 0 && status == 0)
+			return 1;
+	}
+	return 0;
+}
+
 int in_initrd(void)
 {
 	/* This is based on similar function in systemd. */
-- 
2.25.0

