From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/3] Add support for launching mdmon via systemctl instead of fork/exec
Date: Mon, 21 Jan 2013 14:22:56 +0100
Message-ID: <1358774578-2183-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1358774578-2183-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1358774578-2183-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, harald@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

To launch mdmon via systemctl, a new command line argument is added to
mdadm '--systemctl'. Alternatively it is possible to set the
environment variable MDMON_SYSTEMCTL.

This allows for having mdmon launched via systemctl which avoids
problems with it getting killed by systemd due to it ending up in the
parent's cgroup (udev).

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 ReadMe.c |  2 ++
 mdadm.c  |  4 ++++
 mdadm.h  |  2 ++
 mdmon.c  |  4 +++-
 util.c   | 41 ++++++++++++++++++++++++++++++-----------
 5 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/ReadMe.c b/ReadMe.c
index 0aa8cbd..69b8597 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -95,6 +95,7 @@ struct option long_options[] = {
     {"update-subarray", 1, 0, UpdateSubarray},
     {"udev-rules", 2, 0, UdevRules},
     {"offroot", 0, 0, OffRootOpt},
+    {"systemctl", 0, 0, SystemctlOpt},
 
     /* synonyms */
     {"monitor",   0, 0, 'F'},
@@ -261,6 +262,7 @@ char OptionHelp[] =
 "                       application was launched from initrd/initramfs and\n"
 "                       should not be shutdown by systemd as part of the\n"
 "                       regular shutdown process.\n"
+"  --systemctl        : Use systemctl to launch mdmon rather than exec/fork\n"
 ;
 /*
 "\n"
diff --git a/mdadm.c b/mdadm.c
index 11016e7..4c8d382 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -176,6 +176,10 @@ int main(int argc, char *argv[])
 				c.prefer = NULL;
 			continue;
 
+		case SystemctlOpt:
+			__mdmon_systemctl = 1;
+			continue;
+
 		case ':':
 		case '?':
 			fputs(Usage, stderr);
diff --git a/mdadm.h b/mdadm.h
index f1352e3..54874cb 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -337,6 +337,7 @@ enum special_options {
 	Prefer,
 	KillOpt,
 	DataOffset,
+	SystemctlOpt,
 };
 
 enum prefix_standard {
@@ -1485,3 +1486,4 @@ char *xstrdup(const char *str);
 #define VARIABLE_OFFSET 3
 
 extern int __offroot;
+extern int __mdmon_systemctl;
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
index 6c10365..500b2bd 100644
--- a/util.c
+++ b/util.c
@@ -33,6 +33,7 @@
 #include	<signal.h>
 
 int __offroot;
+int __mdmon_systemctl;
 
 /*
  * following taken from linux/blkpg.h because they aren't
@@ -1651,6 +1652,9 @@ int start_mdmon(int devnum)
 	if (check_env("MDADM_NO_MDMON"))
 		return 0;
 
+	if (check_env("MDMON_SYSTEMCTL"))
+		__mdmon_systemctl = 1;
+
 	len = readlink("/proc/self/exe", pathbuf, sizeof(pathbuf)-1);
 	if (len > 0) {
 		char *sl;
@@ -1674,18 +1678,33 @@ int start_mdmon(int devnum)
 			else
 				skipped = 0;
 
-		for (i = 0; paths[i]; i++)
-			if (paths[i][0]) {
-				if (__offroot) {
-					execl(paths[i], "mdmon", "--offroot",
-					      devnum2devname(devnum),
-					      NULL);
-				} else {
-					execl(paths[i], "mdmon",
-					      devnum2devname(devnum),
-					      NULL);
-				}
+		if (__mdmon_systemctl) {
+			if (__offroot) {
+				snprintf(pathbuf, 40, "mdmon-offroot@%s.service",
+					 devnum2devname(devnum));
+				execl("/usr/bin/systemctl", "systemctl",
+				      "start", pathbuf, NULL);
+			} else {
+				snprintf(pathbuf, 30, "mdmon@%s.service",
+					 devnum2devname(devnum));
+				execl("/usr/bin/systemctl", "systemctl",
+				      "start", pathbuf, NULL);
 			}
+		} else {
+			for (i = 0; paths[i]; i++)
+				if (paths[i][0]) {
+					if (__offroot) {
+						execl(paths[i], "mdmon",
+						      "--offroot",
+						      devnum2devname(devnum),
+						      NULL);
+					} else {
+						execl(paths[i], "mdmon",
+						      devnum2devname(devnum),
+						      NULL);
+					}
+				}
+		}
 		exit(1);
 	case -1: pr_err("cannot run mdmon. "
 			 "Array remains readonly\n");
-- 
1.7.11.7

