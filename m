From: Xiao Ni <xni@redhat.com>
Subject: Fwd: [PATCH] need read reshape_groress from sys
Date: Tue, 19 May 2015 22:35:35 -0400 (EDT)
Message-ID: <592729481.1396196.1432089335521.JavaMail.zimbra@redhat.com>
References: <1431673637-10817-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1431673637-10817-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

   Send the patch again. Because I don't see them at http://www.spinics.net/lists/raid/


----- Forwarded Message -----
From: "Xiao Ni" <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: "Xiao Ni" <xni@redhat.com>
Sent: Friday, May 15, 2015 3:07:17 PM
Subject: [PATCH] need read reshape_groress from sys


Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Grow.c  |   18 ++++++++++++------
 mdadm.h |    1 +
 sysfs.c |   15 +++++++++++++++
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/Grow.c b/Grow.c
index 568e399..44ee8a7 100644
--- a/Grow.c
+++ b/Grow.c
@@ -710,11 +710,17 @@ int start_reshape(struct mdinfo *sra, int already_running,
 	err = sysfs_set_num(sra, NULL, "suspend_hi", sra->reshape_progress);
 	err = err ?: sysfs_set_num(sra, NULL, "suspend_lo",
 				   sra->reshape_progress);
-	if (before_data_disks <= data_disks)
-		sync_max_to_set = sra->reshape_progress / data_disks;
-	else
-		sync_max_to_set = (sra->component_size * data_disks
-				   - sra->reshape_progress) / data_disks;
+
+	if (sra->reshape_progress == UINT64_MAX) {
+		err = err ?: sysfs_set_str(sra, NULL, "sync_max", "max");
+	} else {
+		if (before_data_disks <= data_disks)
+			sync_max_to_set = sra->reshape_progress / data_disks;
+		else
+			sync_max_to_set = (sra->component_size * 2 * data_disks
+										- sra->reshape_progress) / data_disks;
+	}
+
 	if (!already_running)
 		sysfs_set_num(sra, NULL, "sync_min", sync_max_to_set);
 	err = err ?: sysfs_set_num(sra, NULL, "sync_max", sync_max_to_set);
@@ -3075,7 +3081,7 @@ static int reshape_array(char *container, int fd, char *devname,
 	}
 	sra = sysfs_read(fd, NULL,
 			 GET_COMPONENT|GET_DEVS|GET_OFFSET|GET_STATE|GET_CHUNK|
-			 GET_CACHE);
+			 GET_CACHE|GET_RESHAPE_PROGRESS);
 	if (!sra) {
 		pr_err("%s: Cannot get array details from sysfs\n",
 			devname);
diff --git a/mdadm.h b/mdadm.h
index 141f963..6fb17e1 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -526,6 +526,7 @@ enum sysfs_read_flags {
 	GET_DEGRADED	= (1 << 8),
 	GET_SAFEMODE	= (1 << 9),
 	GET_BITMAP_LOCATION = (1 << 10),
+	GET_RESHAPE_PROGRESS = (1 << 11),
 
 	GET_DEVS	= (1 << 20), /* gets role, major, minor */
 	GET_OFFSET	= (1 << 21),
diff --git a/sysfs.c b/sysfs.c
index 18f3df9..09b0c93 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -26,6 +26,7 @@
 #include	"mdadm.h"
 #include	<dirent.h>
 #include	<ctype.h>
+#include	<stdint.h>
 
 int load_sys(char *path, char *buf)
 {
@@ -210,6 +211,19 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 		msec = (msec * 1000) / scale;
 		sra->safe_mode_delay = msec;
 	}
+
+	if (options & GET_RESHAPE_PROGRESS) {
+			  
+		strcpy(base, "reshape_progress");
+		if (load_sys(fname, buf))
+			goto abort;
+
+		if (strncmp(buf, "max", 3) == 0)
+			sra->reshape_progress = UINT64_MAX;
+		else
+			sra->reshape_progress = strtol(buf, NULL, 10);
+	}
+
 	if (options & GET_BITMAP_LOCATION) {
 		strcpy(base, "bitmap/location");
 		if (load_sys(fname, buf))
@@ -224,6 +238,7 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 			goto abort;
 	}
 
+
 	if (! (options & GET_DEVS))
 		return sra;
 
-- 
1.7.1

