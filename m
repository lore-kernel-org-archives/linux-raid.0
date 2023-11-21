Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i533oCWS"
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B98C3
	for <linux-raid@vger.kernel.org>; Mon, 20 Nov 2023 23:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700553436; x=1732089436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o1MIwwj6rbXQpEQZJGymO6yKxTfFPwSnpcN3I6lqwmw=;
  b=i533oCWSDpKkgaYP/AUZzpUYPbeBc5zhRnR98QjydTnnosoZHBW7lkqe
   lTzVCXBcGFz7YeNcW/9L8rDCvX0dviDN6tLiD3vQRGPrnRwAv1iPSUVsL
   8I6oBQPmI4IoPREMnvphmXZWHWXmKrhvzXh1jTZweA29W89TncLjZrYy0
   guZHLXWJjiYPnjgySCkXMV1YzU4qBxkRAvlrxTf52fz7jAIBO5v6/hNqG
   EfCUNF0N4Aq/7LNfDljX12GSjozvkuolnwq4EmOotHher320nlDMXX4wP
   L71ucI9MjtH7Z1zic1R907xxMTiqr6c79WxI+ukgJvSuIobrxtpHS+G6R
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="477991897"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="477991897"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 23:57:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="890174511"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="890174511"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orsmga004.jf.intel.com with ESMTP; 20 Nov 2023 23:57:14 -0800
From: Kinga Tanska <kinga.tanska@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	colyli@suse.de
Subject: [PATCH v5 1/2] Mdmonitor: Improve udev event handling
Date: Tue, 21 Nov 2023 01:58:23 +0100
Message-Id: <20231121005824.3951-2-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20231121005824.3951-1-kinga.tanska@intel.com>
References: <20231121005824.3951-1-kinga.tanska@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mateusz Grzonka <mateusz.grzonka@intel.com>

Mdmonitor is waiting for udev queue to become empty.
Even if the queue becomes empty, udev might still be processing last event.
However we want to wait and wake up mdmonitor when udev finished
processing events..

Also, the udev queue interface is considered legacy and should not be
used outside of udev.

Use udev monitor instead, and wake up mdmonitor on every event triggered
by udev for md block device.

We need to generate more change events from kernel, because they are
missing in some situations, for example, when rebuild started.
This will be addressed in a separate patch.

Move udev specific code into separate functions, and place them in udev.c file.
Also move use_udev() logic from lib.c into newly created file.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Makefile  |  18 +++----
 Manage.c  |   3 +-
 Monitor.c | 137 ++++++++++++++++++-------------------------------
 lib.c     |  13 -----
 mdadm.h   |   1 +
 mdopen.c  |   7 +--
 udev.c    | 150 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 udev.h    |  37 ++++++++++++++
 8 files changed, 253 insertions(+), 113 deletions(-)
 create mode 100644 udev.c
 create mode 100644 udev.h

diff --git a/Makefile b/Makefile
index b3aa36f6..cbdba49a 100644
--- a/Makefile
+++ b/Makefile
@@ -163,14 +163,14 @@ else
 	ECHO=:
 endif
 
-OBJS =  mdadm.o config.o policy.o mdstat.o  ReadMe.o uuid.o util.o maps.o lib.o \
-	Manage.o Assemble.o Build.o \
-	Create.o Detail.o Examine.o Grow.o Monitor.o dlink.o Kill.o Query.o \
-	Incremental.o Dump.o \
-	mdopen.o super0.o super1.o super-ddf.o super-intel.o bitmap.o \
-	super-mbr.o super-gpt.o \
-	restripe.o sysfs.o sha1.o mapfile.o crc32.o sg_io.o msg.o xmalloc.o \
-	platform-intel.o probe_roms.o crc32c.o
+OBJS = mdadm.o config.o policy.o mdstat.o  ReadMe.o uuid.o util.o maps.o lib.o udev.o \
+       Manage.o Assemble.o Build.o \
+       Create.o Detail.o Examine.o Grow.o Monitor.o dlink.o Kill.o Query.o \
+       Incremental.o Dump.o \
+       mdopen.o super0.o super1.o super-ddf.o super-intel.o bitmap.o \
+       super-mbr.o super-gpt.o \
+       restripe.o sysfs.o sha1.o mapfile.o crc32.o sg_io.o msg.o xmalloc.o \
+       platform-intel.o probe_roms.o crc32c.o
 
 CHECK_OBJS = restripe.o uuid.o sysfs.o maps.o lib.o xmalloc.o dlink.o
 
@@ -179,7 +179,7 @@ SRCS =  $(patsubst %.o,%.c,$(OBJS))
 INCL = mdadm.h part.h bitmap.h
 
 MON_OBJS = mdmon.o monitor.o managemon.o uuid.o util.o maps.o mdstat.o sysfs.o config.o mapfile.o mdopen.o\
-	policy.o lib.o \
+	policy.o lib.o udev.o \
 	Kill.o sg_io.o dlink.o ReadMe.o super-intel.o \
 	super-mbr.o super-gpt.o \
 	super-ddf.o sha1.o crc32.o msg.o bitmap.o xmalloc.o \
diff --git a/Manage.c b/Manage.c
index 075dd720..f0d4cb01 100644
--- a/Manage.c
+++ b/Manage.c
@@ -25,6 +25,7 @@
 #include "mdadm.h"
 #include "md_u.h"
 #include "md_p.h"
+#include "udev.h"
 #include <ctype.h>
 
 int Manage_ro(char *devname, int fd, int readonly)
@@ -462,7 +463,7 @@ done:
 		goto out;
 	}
 
-	if (devnm[0] && use_udev()) {
+	if (devnm[0] && udev_is_available()) {
 		struct map_ent *mp = map_by_devnm(&map, devnm);
 		remove_devices(devnm, mp ? mp->path : NULL);
 	}
diff --git a/Monitor.c b/Monitor.c
index e74a0558..9a1f2514 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -23,18 +23,17 @@
  */
 
 #include	"mdadm.h"
+#include	"udev.h"
 #include	"md_p.h"
 #include	"md_u.h"
 #include	<sys/wait.h>
 #include	<limits.h>
 #include	<syslog.h>
-#ifndef NO_LIBUDEV
-#include	<libudev.h>
-#endif
 
 #define TASK_COMM_LEN 16
 #define EVENT_NAME_MAX 32
 #define AUTOREBUILD_PID_PATH MDMON_DIR "/autorebuild.pid"
+#define FALLBACK_DELAY 5
 
 /**
  * struct state - external array or container properties.
@@ -126,12 +125,11 @@ static void link_containers_with_subarrays(struct state *list);
 static void free_statelist(struct state *statelist);
 static int check_array(struct state *st, struct mdstat_ent *mdstat, int increments, char *prefer);
 static int check_one_sharer(int scan);
-#ifndef NO_LIBUDEV
-static int check_udev_activity(void);
-#endif
 static void link_containers_with_subarrays(struct state *list);
 static int make_daemon(char *pidfile);
 static void try_spare_migration(struct state *statelist);
+static void wait_for_events(int *delay_for_event, int c_delay);
+static void wait_for_events_mdstat(int *delay_for_event, int c_delay);
 static int write_autorebuild_pid(void);
 
 int Monitor(struct mddev_dev *devlist,
@@ -326,32 +324,12 @@ int Monitor(struct mddev_dev *devlist,
 		if (!new_found) {
 			if (oneshot)
 				break;
-			else if (!anyredundant) {
+			if (!anyredundant) {
 				pr_err("No array with redundancy detected, stopping\n");
 				break;
 			}
-			else {
-#ifndef NO_LIBUDEV
-				/*
-				 * Wait for udevd to finish new devices
-				 * processing.
-				 */
-				if (mdstat_wait(delay_for_event) &&
-				    check_udev_activity())
-					pr_err("Error while waiting for UDEV to complete new devices processing\n");
-#else
-				int wait_result = mdstat_wait(delay_for_event);
-				/*
-				 * Give chance to process new device
-				 */
-				if (wait_result != 0) {
-					if (c->delay > 5)
-						delay_for_event = 5;
-				} else
-					delay_for_event = c->delay;
-#endif
-				mdstat_close();
-			}
+
+			wait_for_events(&delay_for_event, c->delay);
 		}
 		info.test = 0;
 
@@ -374,6 +352,49 @@ int Monitor(struct mddev_dev *devlist,
 	return 0;
 }
 
+/*
+ * wait_for_events() - Waits for events on md devices.
+ * @delay_for_event: pointer to current event delay
+ * @c_delay: delay from config
+ */
+static void wait_for_events(int *delay_for_event, int c_delay)
+{
+#ifndef NO_LIBUDEV
+	if (udev_is_available()) {
+		if (udev_wait_for_events(*delay_for_event) == UDEV_STATUS_ERROR)
+			pr_err("Error while waiting for udev events.\n");
+		return;
+	}
+#endif
+	wait_for_events_mdstat(delay_for_event, c_delay);
+}
+
+/*
+ * wait_for_events_mdstat() - Waits for events on mdstat.
+ * @delay_for_event: pointer to current event delay
+ * @c_delay: delay from config
+ */
+static void wait_for_events_mdstat(int *delay_for_event, int c_delay)
+{
+	int wait_result = mdstat_wait(*delay_for_event);
+
+	if (wait_result < 0) {
+		pr_err("Error while waiting for events on mdstat.\n");
+		return;
+	}
+
+	/*
+	 * Give chance to process new device
+	 */
+	if (wait_result != 0) {
+		if (c_delay > FALLBACK_DELAY)
+			*delay_for_event = FALLBACK_DELAY;
+	} else {
+		*delay_for_event = c_delay;
+	}
+	mdstat_close();
+}
+
 static int make_daemon(char *pidfile)
 {
 	/* Return:
@@ -1254,64 +1275,6 @@ static void free_statelist(struct state *statelist)
 	}
 }
 
-#ifndef NO_LIBUDEV
-/* function: check_udev_activity
- * Description: Function waits for udev to finish
- * events processing.
- * Returns:
- *		1 - detected error while opening udev
- *		2 - timeout
- *		0 - successfull completion
- */
-static int check_udev_activity(void)
-{
-	struct udev *udev = NULL;
-	struct udev_queue *udev_queue = NULL;
-	int timeout_cnt = 30;
-	int rc = 0;
-
-	/*
-	 * In rare cases systemd may not have udevm,
-	 * in such cases just exit with rc 0
-	 */
-	if (!use_udev())
-		goto out;
-
-	udev = udev_new();
-	if (!udev) {
-		rc = 1;
-		goto out;
-	}
-
-	udev_queue = udev_queue_new(udev);
-	if (!udev_queue) {
-		rc = 1;
-		goto out;
-	}
-
-	if (udev_queue_get_queue_is_empty(udev_queue))
-		goto out;
-
-	while (!udev_queue_get_queue_is_empty(udev_queue)) {
-		sleep(1);
-
-		if (timeout_cnt)
-			timeout_cnt--;
-		else {
-			rc = 2;
-			goto out;
-		}
-	}
-
-out:
-	if (udev_queue)
-		udev_queue_unref(udev_queue);
-	if (udev)
-		udev_unref(udev);
-	return rc;
-}
-#endif
-
 /* Not really Monitor but ... */
 int Wait(char *dev)
 {
diff --git a/lib.c b/lib.c
index 7ab59988..cf2701cd 100644
--- a/lib.c
+++ b/lib.c
@@ -539,19 +539,6 @@ int check_env(char *name)
 	return 0;
 }
 
-int use_udev(void)
-{
-	static int use = -1;
-	struct stat stb;
-
-	if (use < 0) {
-		use = ((stat("/dev/.udev", &stb) == 0 ||
-			stat("/run/udev", &stb) == 0) &&
-		       check_env("MDADM_NO_UDEV") == 0);
-	}
-	return use;
-}
-
 unsigned long GCD(unsigned long a, unsigned long b)
 {
 	while (a != b) {
diff --git a/mdadm.h b/mdadm.h
index b48e6f86..9514cbe5 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1656,6 +1656,7 @@ extern char *conf_line(FILE *file);
 extern char *conf_word(FILE *file, int allow_key);
 extern void print_quoted(char *str);
 extern int use_udev(void);
+extern void print_escape(char *str);
 extern unsigned long GCD(unsigned long a, unsigned long b);
 extern int conf_name_is_free(char *name);
 extern bool is_devname_ignore(const char *devname);
diff --git a/mdopen.c b/mdopen.c
index 3daa71f9..f9b04e1c 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -23,6 +23,7 @@
  */
 
 #include "mdadm.h"
+#include "udev.h"
 #include "md_p.h"
 #include <ctype.h>
 
@@ -176,7 +177,7 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 	char devnm[32];
 	char cbuf[400];
 
-	if (!use_udev())
+	if (!udev_is_available())
 		block_udev = 0;
 
 	if (chosen == NULL)
@@ -384,7 +385,7 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 	 * If we cannot detect udev, we need to make
 	 * devices and links ourselves.
 	 */
-	if (!use_udev()) {
+	if (!udev_is_available()) {
 		/* Make sure 'devname' exists and 'chosen' is a symlink to it */
 		if (lstat(devname, &stb) == 0) {
 			/* Must be the correct device, else error */
@@ -508,7 +509,7 @@ char *find_free_devnm(int use_partitions)
 			continue;
 		if (!conf_name_is_free(devnm))
 			continue;
-		if (!use_udev()) {
+		if (!udev_is_available()) {
 			/* make sure it is new to /dev too, at least as a
 			 * non-standard */
 			dev_t devid = devnm2devid(devnm);
diff --git a/udev.c b/udev.c
new file mode 100644
index 00000000..2bac6921
--- /dev/null
+++ b/udev.c
@@ -0,0 +1,150 @@
+/*
+ * mdadm - manage Linux "md" devices aka RAID arrays.
+ *
+ * Copyright (C) 2022 Mateusz Grzonka <mateusz.grzonka@intel.com>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License
+ *    along with this program; if not, write to the Free Software
+ *    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include	"mdadm.h"
+#include	"udev.h"
+#include	"md_p.h"
+#include	"md_u.h"
+#include	<sys/wait.h>
+#include	<signal.h>
+#include	<limits.h>
+#include	<syslog.h>
+#include	<libudev.h>
+
+/*
+ * udev_is_available() - Checks for udev in the system.
+ *
+ * Function looks whether udev directories are available and MDADM_NO_UDEV env defined.
+ *
+ * Return:
+ * true if udev is available,
+ * false if not
+ */
+bool udev_is_available(void)
+{
+	struct stat stb;
+
+	if (stat("/dev/.udev", &stb) != 0 &&
+	    stat("/run/udev", &stb) != 0)
+		return false;
+	if (check_env("MDADM_NO_UDEV") == 1)
+		return false;
+	return true;
+}
+
+#ifndef NO_LIBUDEV
+
+static struct udev *udev;
+static struct udev_monitor *udev_monitor;
+
+/*
+ * udev_release() - Drops references of udev and udev_monitor.
+ */
+static void udev_release(void)
+{
+	udev_monitor_unref(udev_monitor);
+	udev_unref(udev);
+}
+
+/*
+ * udev_initialize() - Initializes udev and udev_monitor structures.
+ *
+ * Function initializes udev, udev_monitor, and sets udev_monitor filter for block devices.
+ *
+ * Return:
+ * UDEV_STATUS_SUCCESS on success
+ * UDEV_STATUS_ERROR on error
+ * UDEV_STATUS_ERROR_NO_UDEV when udev not available
+ */
+static enum udev_status udev_initialize(void)
+{
+	if (!udev_is_available()) {
+		pr_err("No udev.\n");
+		return UDEV_STATUS_ERROR_NO_UDEV;
+	}
+
+	udev = udev_new();
+	if (!udev) {
+		pr_err("Cannot initialize udev.\n");
+		return UDEV_STATUS_ERROR;
+	}
+
+	udev_monitor = udev_monitor_new_from_netlink(udev, "udev");
+	if (!udev_monitor) {
+		pr_err("Cannot initialize udev monitor.\n");
+		udev = udev_unref(udev);
+		return UDEV_STATUS_ERROR;
+	}
+
+	if (udev_monitor_filter_add_match_subsystem_devtype(udev_monitor, "block", 0) < 0) {
+		pr_err("Cannot add udev monitor event filter for md devices.\n");
+		udev_release();
+		return UDEV_STATUS_ERROR;
+	}
+	if (udev_monitor_enable_receiving(udev_monitor) < 0) {
+		pr_err("Cannot enable receiving udev events through udev monitor.\n");
+		udev_release();
+		return UDEV_STATUS_ERROR;
+	}
+	atexit(udev_release);
+	return UDEV_STATUS_SUCCESS;
+}
+
+/*
+ * udev_wait_for_events() - Waits for events from udev.
+ * @seconds: Timeout in seconds.
+ *
+ * Function waits udev events, wakes up on event or timeout.
+ *
+ * Return:
+ * UDEV_STATUS_SUCCESS on detected event
+ * UDEV_STATUS_TIMEOUT on timeout
+ * UDEV_STATUS_ERROR on error
+ */
+enum udev_status udev_wait_for_events(int seconds)
+{
+	int fd;
+	fd_set readfds;
+	struct timeval tv;
+	int ret;
+
+	if (!udev || !udev_monitor) {
+		ret = udev_initialize();
+		if (ret != UDEV_STATUS_SUCCESS)
+			return ret;
+	}
+
+	fd = udev_monitor_get_fd(udev_monitor);
+	if (fd < 0) {
+		pr_err("Cannot access file descriptor associated with udev monitor.\n");
+		return UDEV_STATUS_ERROR;
+	}
+
+	FD_ZERO(&readfds);
+	FD_SET(fd, &readfds);
+	tv.tv_sec = seconds;
+	tv.tv_usec = 0;
+
+	if (select(fd + 1, &readfds, NULL, NULL, &tv) > 0 && FD_ISSET(fd, &readfds))
+		if (udev_monitor_receive_device(udev_monitor))
+			return UDEV_STATUS_SUCCESS; /* event detected */
+	return UDEV_STATUS_TIMEOUT;
+}
+#endif
diff --git a/udev.h b/udev.h
new file mode 100644
index 00000000..33884861
--- /dev/null
+++ b/udev.h
@@ -0,0 +1,37 @@
+/*
+ * mdadm - manage Linux "md" devices aka RAID arrays.
+ *
+ * Copyright (C) 2022 Mateusz Grzonka <mateusz.grzonka@intel.com>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License
+ *    along with this program; if not, write to the Free Software
+ *    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef MONITOR_UDEV_H
+#define MONITOR_UDEV_H
+
+enum udev_status {
+	UDEV_STATUS_ERROR_NO_UDEV = -2,
+	UDEV_STATUS_ERROR,
+	UDEV_STATUS_SUCCESS = 0,
+	UDEV_STATUS_TIMEOUT
+};
+
+bool udev_is_available(void);
+
+#ifndef NO_LIBUDEV
+enum udev_status udev_wait_for_events(int seconds);
+#endif
+
+#endif
-- 
2.26.2

