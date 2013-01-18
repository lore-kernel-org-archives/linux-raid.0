From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/2] Add support for launching mdmon via systemctl instead of fork/exec
Date: Fri, 18 Jan 2013 09:43:11 +0100
Message-ID: <1358498592-20827-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1358498592-20827-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1358498592-20827-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, harald@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This allows for having mdmon launched via systemctl which avoids
problems with it getting killed by systemd due to it ending up in the
parent's cgroup (udev).

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Makefile |  6 ++++++
 mdmon.c  |  4 +++-
 util.c   | 14 ++++++++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index b9787d6..b786aa9 100644
--- a/Makefile
+++ b/Makefile
@@ -57,6 +57,12 @@ else
  DEFAULT_METADATA=1.2
 endif
 
+# Use systemctl to launch mdmon
+#MDMON_SYSTEMCTL=yes
+ifdef MDMON_SYSTEMCTL
+ CPPFLAGS += -DMDMON_SYSTEMCTL=1
+endif
+
 PKG_CONFIG ?= pkg-config
 
 SYSCONFDIR = /etc
diff --git a/mdmon.c b/mdmon.c
index 5d5ae94..7459ae2 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -188,7 +188,9 @@ static void try_kill_monitor(pid_t pid, char *devname, int sock)
 	 * might be "@dmon"
 	 */
 	if (n < 0 || !(strstr(buf, "mdmon") ||
-		       strstr(buf, "@dmon")))
+		       strstr(buf, "@dmon") ||
+		       strstr(buf, "/usr/sbin/mdmon") ||
+		       strstr(buf, "@usr/sbin/mdmon")))
 		return;
 
 	kill(pid, SIGTERM);
diff --git a/util.c b/util.c
index 6c10365..6b28f4e 100644
--- a/util.c
+++ b/util.c
@@ -1641,12 +1641,14 @@ int start_mdmon(int devnum)
 	pid_t pid;
 	int status;
 	char pathbuf[1024];
+#ifndef MDMON_SYSTEMCTL
 	char *paths[4] = {
 		pathbuf,
 		"/sbin/mdmon",
 		"mdmon",
 		NULL
 	};
+#endif
 
 	if (check_env("MDADM_NO_MDMON"))
 		return 0;
@@ -1674,6 +1676,17 @@ int start_mdmon(int devnum)
 			else
 				skipped = 0;
 
+#ifdef MDMON_SYSTEMCTL
+		if (__offroot) {
+			snprintf(pathbuf, 40, "mdmon-offroot@%s.service",
+				 devnum2devname(devnum));
+			execl("/usr/bin/systemctl", "systemctl", "start", pathbuf, NULL);
+		} else {
+			snprintf(pathbuf, 30, "mdmon@%s.service",
+				 devnum2devname(devnum));
+			execl("/usr/bin/systemctl", "systemctl", "start", pathbuf, NULL);
+		}
+#else
 		for (i = 0; paths[i]; i++)
 			if (paths[i][0]) {
 				if (__offroot) {
@@ -1686,6 +1699,7 @@ int start_mdmon(int devnum)
 					      NULL);
 				}
 			}
+#endif
 		exit(1);
 	case -1: pr_err("cannot run mdmon. "
 			 "Array remains readonly\n");
-- 
1.7.11.7

