From: Maciej Patelczyk <maciej.patelczyk@intel.com>
Subject: [PATCH v2] mdadm: close parent file descriptors when starting mdmon.
Date: Fri, 02 Sep 2011 16:51:29 +0200
Message-ID: <20110902145129.8411.53122.stgit@gklab-128-044.igk.intel.com>
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
 util.c |   43 +++++++++++++++++++++++++++++++++++++++----
 1 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/util.c b/util.c
index ce03239..9e8cc46 100644
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
@@ -1571,11 +1576,43 @@ int mdmon_running(int devnum)
 	return 0;
 }
 
+static void close_parent_fds(void)
+{
+	DIR *dirp;
+	struct dirent *d_entry;
+	int fd, p_fd;
+
+	dirp = opendir("/proc/self/fd");
+	if (!dirp)
+		return;
+
+	p_fd = dirfd(dirp);
+	if (p_fd == -1) {
+		closedir(dirp);
+		return;
+	}
+
+	while((d_entry = readdir(dirp)) != NULL) {
+		if (!strcmp(d_entry->d_name, ".") ||
+		    !strcmp(d_entry->d_name, ".."))
+			continue;
+		errno = 0;
+		fd = (int)strtol(d_entry->d_name, NULL, 10);
+		if (errno)
+			continue;
+		if (p_fd == fd)
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
@@ -1603,9 +1640,7 @@ int start_mdmon(int devnum)
 
 	switch(fork()) {
 	case 0:
-		/* FIXME yuk. CLOSE_EXEC?? */
-		for (i=3; i < 100; i++)
-			close(i);
+		close_parent_fds();
 		for (i=0; paths[i]; i++)
 			if (paths[i][0])
 				execl(paths[i], "mdmon",

