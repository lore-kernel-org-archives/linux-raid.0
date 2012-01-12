From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/4] FIX: Takeover mdmon when grow is continued from command
	line
Date: Thu, 12 Jan 2012 08:12:31 +0100
Message-ID: <20120112071231.5168.62971.stgit@gklab-128-013.igk.intel.com>
References: <20120112070822.5168.97729.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120112070822.5168.97729.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

When reshape with '--continue' option is executed mdadm doesn't know,
if mdmon is switched to using '--takeover' option to current file system
context. To resolve this, on reshape continuation when mdmon is run,
execute mdmon takeover.

Lack of takeovered mdmon can cause e.g.:
- multivolume reshape is broken when reshaped volume is changed
- size of reshaped volume dowsn't increase

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c  |    2 ++
 mdadm.h |    1 +
 util.c  |   53 ++++++++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/Grow.c b/Grow.c
index b2c1360..f0422d2 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3876,6 +3876,8 @@ int Grow_continue_command(char *devname, int fd,
 		 */
 		if (!mdmon_running(container_dev))
 			start_mdmon(container_dev);
+		else
+			takeover_mdmon(container_dev);
 		ping_monitor(buf);
 
 		if (mdmon_running(container_dev))
diff --git a/mdadm.h b/mdadm.h
index 381ef86..f274ae7 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1223,6 +1223,7 @@ extern int mdmon_pid(int devnum);
 extern int check_env(char *name);
 extern __u32 random32(void);
 extern int start_mdmon(int devnum);
+extern int takeover_mdmon(int devnum);
 
 extern int child_monitor(int afd, struct mdinfo *sra, struct reshape *reshape,
 			 struct supertype *st, unsigned long stripes,
diff --git a/util.c b/util.c
index 6985a70..e95a366 100644
--- a/util.c
+++ b/util.c
@@ -1581,11 +1581,13 @@ int mdmon_running(int devnum)
 	return 0;
 }
 
-int start_mdmon(int devnum)
+#define MDMON_TAKEOVER_WAIT_COUNTER 15
+int execute_mdmon(int devnum, int takeover)
 {
 	int i, skipped;
 	int len;
-	pid_t pid;	
+	pid_t pid;
+	pid_t pid_org;
 	int status;
 	char pathbuf[1024];
 	char *paths[4] = {
@@ -1611,6 +1613,12 @@ int start_mdmon(int devnum)
 	} else
 		pathbuf[0] = '\0';
 
+	if (takeover) {
+		pid_org = mdmon_pid(devnum);
+		if (pid_org < 0)
+			takeover = 0;
+	}
+
 	switch(fork()) {
 	case 0:
 		/* FIXME yuk. CLOSE_EXEC?? */
@@ -1620,24 +1628,51 @@ int start_mdmon(int devnum)
 				skipped++;
 			else
 				skipped = 0;
-
-		for (i=0; paths[i]; i++)
-			if (paths[i][0])
-				execl(paths[i], "mdmon",
-				      devnum2devname(devnum),
-				      NULL);
+		for (i = 0; paths[i]; i++) {
+			if (paths[i][0]) {
+				if (!takeover)
+					execl(paths[i], "mdmon",
+					      devnum2devname(devnum),
+					      NULL);
+				else
+					execl(paths[i], "mdmon",
+					      "--takeover",
+					      devnum2devname(devnum),
+					      NULL);
+			}
+		}
 		exit(1);
 	case -1: fprintf(stderr, Name ": cannot run mdmon. "
 			 "Array remains readonly\n");
 		return -1;
 	default: /* parent - good */
-		pid = wait(&status);
+		i = 0;
+		do {
+			if (i)
+				sleep(1);
+			pid = wait(&status);
+			if (takeover && (pid == pid_org))
+				pid = -1;
+			i++;
+		} while (takeover &&
+			 (i < MDMON_TAKEOVER_WAIT_COUNTER) &&
+			 (pid < 0));
 		if (pid < 0 || status != 0)
 			return -1;
 	}
 	return 0;
 }
 
+int start_mdmon(int devnum)
+{
+	return execute_mdmon(devnum, 0);
+}
+
+int takeover_mdmon(int devnum)
+{
+	return execute_mdmon(devnum, 1);
+}
+
 int check_env(char *name)
 {
 	char *val = getenv(name);

