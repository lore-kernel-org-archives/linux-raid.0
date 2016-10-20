From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 4/4] mdmon: bad block support for external metadata - clear bad blocks
Date: Thu, 20 Oct 2016 15:06:03 +0200
Message-ID: <1476968763-19391-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com, maksymilian.kunt@intel.com, mariusz.dabrowski@intel.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

If an update of acknowledged bad blocks file is notified, read entire
bad block list from sysfs file and compare it against local list of bad
blocks. If any obsolete entries are found, remove them from metadata.

As mdmon cannot perform any memory allocation, new superswitch method
get_bad_blocks is expected to return a list of bad blocks in metadata
without allocating memory. It's up to metadata handler to allocate all
required memory in advance.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 mdadm.h   |  7 ++++++
 monitor.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 05a2e3e..7f1a1b8 100755
--- a/mdadm.h
+++ b/mdadm.h
@@ -1054,6 +1054,13 @@ extern struct superswitch {
 	int (*record_bad_block)(struct active_array *a, int n,
 					unsigned long long sector, int length);
 
+	/* clears bad block from metadata */
+	int (*clear_bad_block)(struct active_array *a, int n,
+					unsigned long long sector, int length);
+
+	/* get list of bad blocks from metadata */
+	struct md_bb *(*get_bad_blocks)(struct active_array *a, int n);
+
 	int swapuuid; /* true if uuid is bigending rather than hostendian */
 	int external;
 	const char *name; /* canonical metadata name */
diff --git a/monitor.c b/monitor.c
index 981da5b..1704a59 100644
--- a/monitor.c
+++ b/monitor.c
@@ -33,6 +33,7 @@ static char *sync_actions[] = {
 
 enum bb_action {
 	RECORD_BB = 1,
+	COMPARE_BB,
 };
 
 static int write_attr(char *attr, int fd)
@@ -184,6 +185,49 @@ int process_ubb(struct active_array *a, struct mdinfo *mdi, const unsigned long
 	return -1;
 }
 
+int compare_bb(struct active_array *a, struct mdinfo *mdi, const unsigned long
+	       long sector, const unsigned int length, void *arg)
+{
+	struct superswitch *ss = a->container->ss;
+	struct md_bb *bb = (struct md_bb *) arg;
+	int record = 1;
+	int i;
+
+	for (i = 0; i < bb->count; i++) {
+		unsigned long long start = bb->entries[i].sector;
+		unsigned long long len = bb->entries[i].length;
+
+		/*
+		 * bad block in metadata exactly matches bad block in kernel
+		 * list, just remove it from a list
+		 */
+		if ((start == sector) && (len == length)) {
+			if (i < bb->count - 1)
+				bb->entries[i] = bb->entries[bb->count - 1];
+			bb->count -= 1;
+			record = 0;
+			break;
+		}
+		/*
+		 * bad block in metadata spans bad block in kernel list,
+		 * clear it and record new bad block
+		 */
+		if ((sector >= start) && (sector + length <= start + len)) {
+			ss->clear_bad_block(a, mdi->disk.raid_disk, start, len);
+			break;
+		}
+	}
+
+	/* record all bad blocks not in metadata list */
+	if (record && (ss->record_bad_block(a, mdi->disk.raid_disk, sector,
+					     length) <= 0)) {
+		sysfs_set_str(&a->info, mdi, "state", "-external_bbl");
+		return -1;
+	}
+
+	return 1;
+}
+
 static int read_bb_file(int fd, struct active_array *a, struct mdinfo *mdi,
 			enum bb_action action, void *arg)
 {
@@ -242,6 +286,8 @@ static int read_bb_file(int fd, struct active_array *a, struct mdinfo *mdi,
 			if (action == RECORD_BB)
 				rc = process_ubb(a, mdi, sector, length,
 						  buf + off, consumed);
+			else if (action == COMPARE_BB)
+				rc = compare_bb(a, mdi, sector, length, arg);
 			else
 				rc = -1;
 
@@ -260,6 +306,34 @@ static int process_dev_ubb(struct active_array *a, struct mdinfo *mdi)
 	return read_bb_file(mdi->ubb_fd, a, mdi, RECORD_BB, NULL);
 }
 
+static int check_for_cleared_bb(struct active_array *a, struct mdinfo *mdi)
+{
+	struct superswitch *ss = a->container->ss;
+	struct md_bb *bb;
+	int i;
+
+	/*
+	 * Get a list of bad blocks for an array, then read list of
+	 * acknowledged bad blocks from kernel and compare it against metadata
+	 * list, clear all bad blocks remaining in metadata list
+	 */
+	bb = ss->get_bad_blocks(a, mdi->disk.raid_disk);
+	if (!bb)
+		return -1;
+
+	if (read_bb_file(mdi->bb_fd, a, mdi, COMPARE_BB, bb) < 0)
+		return -1;
+
+	for (i = 0; i < bb->count; i++) {
+		unsigned long long sector = bb->entries[i].sector;
+		int length = bb->entries[i].length;
+
+		ss->clear_bad_block(a, mdi->disk.raid_disk, sector, length);
+	}
+
+	return 0;
+}
+
 static void signal_manager(void)
 {
 	/* tgkill(getpid(), mon_tid, SIGUSR1); */
@@ -326,7 +400,7 @@ static void signal_manager(void)
 
 #define ARRAY_DIRTY 1
 #define ARRAY_BUSY 2
-static int read_and_act(struct active_array *a)
+static int read_and_act(struct active_array *a, fd_set *fds)
 {
 	unsigned long long sync_completed;
 	int check_degraded = 0;
@@ -369,6 +443,8 @@ static int read_and_act(struct active_array *a)
 			mdi->curr_state &= ~DS_FAULTY;
 			mdi->next_state |= DS_UNBLOCK;
 		}
+		if (FD_ISSET(mdi->bb_fd, fds))
+			check_for_cleared_bb(a, mdi);
 	}
 
 	gettimeofday(&tv, NULL);
@@ -755,6 +831,7 @@ static int wait_and_act(struct supertype *container, int nowait)
 		if (rv == -1) {
 			if (errno == EINTR) {
 				rv = 0;
+				FD_ZERO(&rfds);
 				dprintf("monitor: caught signal\n");
 			} else
 				dprintf("monitor: error %d in pselect\n",
@@ -796,7 +873,7 @@ static int wait_and_act(struct supertype *container, int nowait)
 			signal_manager();
 		}
 		if (a->container && !a->to_remove) {
-			int ret = read_and_act(a);
+			int ret = read_and_act(a, &rfds);
 			rv |= 1;
 			dirty_arrays += !!(ret & ARRAY_DIRTY);
 			/* when terminating stop manipulating the array after it
-- 
1.8.3.1

