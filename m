From: Maciej Patelczyk <maciej.patelczyk@intel.com>
Subject: [PATCH] mdadm: close parent file descriptors when starting mdmon.
Date: Mon, 29 Aug 2011 17:49:49 +0200
Message-ID: <20110829154949.15993.32383.stgit@gklab-128-044.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

When mdadm is invoked by fork-and-exec it inherits all open file
descriptors and when mdadm forks to exec mdmon those file descriptors
are passed to mdmon. Mdmon closes only first 97 fd and that in some
cases is not enough.
This commit adds function which looks at the '/proc/<pid>/fd' directory
and closes all inherited file descriptors except the standard ones (0-2).

Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
---
 util.c |   41 +++++++++++++++++++++++++++++++++++++----
 1 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/util.c b/util.c
index ce03239..b844447 100644
--- a/util.c
+++ b/util.c
@@ -30,7 +30,12 @@
 #include	<sys/un.h>
 #include	<ctype.h>
 #include	<dirent.h>
+#include	<sys/types.h>
 #include	<signal.h>
+#include	<stdlib.h>
+#include	<string.h>
+#include	<errno.h>
+#include	<unistd.h>
 
 /*
  * following taken from linux/blkpg.h because they aren't
@@ -1571,11 +1576,41 @@ int mdmon_running(int devnum)
 	return 0;
 }
 
+static void close_parent_fds(void)
+{
+	pid_t pid;
+	char buf[128];
+	DIR *dirp;
+	struct dirent *d_entry;
+	int fd;
+
+	pid = getpid();
+	if (snprintf(buf, sizeof(buf), "/proc/%d/fd", (int)pid) < 0)
+		return;
+
+	dirp = opendir((const char *)buf);
+	if (!dirp)
+		return;
+
+	while((d_entry = readdir(dirp)) != NULL) {
+		if (!strcmp(d_entry->d_name, ".") ||
+		    !strcmp(d_entry->d_name, ".."))
+			continue;
+		errno = 0;
+		fd = (int)strtol(d_entry->d_name, NULL, 10);
+		if (errno)
+			continue;
+		if (fd > 2)
+			close(fd);
+	}
+	closedir(dirp);
+}
+
 int start_mdmon(int devnum)
 {
 	int i;
 	int len;
-	pid_t pid;	
+	pid_t pid;
 	int status;
 	char pathbuf[1024];
 	char *paths[4] = {
@@ -1603,9 +1638,7 @@ int start_mdmon(int devnum)
 
 	switch(fork()) {
 	case 0:
-		/* FIXME yuk. CLOSE_EXEC?? */
-		for (i=3; i < 100; i++)
-			close(i);
+		close_parent_fds();
 		for (i=0; paths[i]; i++)
 			if (paths[i][0])
 				execl(paths[i], "mdmon",

