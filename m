From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 3/4 v2] mdmon: bad block support for external metadata - store bad blocks
Date: Thu, 27 Oct 2016 10:53:44 +0200
Message-ID: <1477558425-13332-3-git-send-email-tomasz.majchrzak@intel.com>
References: <1477558425-13332-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477558425-13332-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

If md has changed the state to 'blocked' and metadata handler supports
bad blocks, try process them first. If metadata handler has successfully
stored bad block, acknowledge it to md via 'badblocks' sysfs file. If
metadata handler has failed to store the new bad block (ie. lack of
space), remove bad block support for a disk by writing "-external_bbl"
to state sysfs file. If all bad blocks have been acknowledged, request
to unblock the array.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Acked-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 mdadm.h   |   4 +++
 monitor.c | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+)

diff --git a/mdadm.h b/mdadm.h
index 1a1c7af..05a2e3e 100755
--- a/mdadm.h
+++ b/mdadm.h
@@ -1050,6 +1050,10 @@ extern struct superswitch {
 	/* validate container after assemble */
 	int (*validate_container)(struct mdinfo *info);
 
+	/* records new bad block in metadata */
+	int (*record_bad_block)(struct active_array *a, int n,
+					unsigned long long sector, int length);
+
 	int swapuuid; /* true if uuid is bigending rather than hostendian */
 	int external;
 	const char *name; /* canonical metadata name */
diff --git a/monitor.c b/monitor.c
index 56c6500..9de9c8d 100644
--- a/monitor.c
+++ b/monitor.c
@@ -31,6 +31,10 @@ static char *sync_actions[] = {
 	"idle", "reshape", "resync", "recover", "check", "repair", NULL
 };
 
+enum bb_action {
+	RECORD_BB = 1,
+};
+
 static int write_attr(char *attr, int fd)
 {
 	return write(fd, attr, strlen(attr));
@@ -158,6 +162,104 @@ int read_dev_state(int fd)
 	return rv;
 }
 
+int process_ubb(struct active_array *a, struct mdinfo *mdi, const unsigned long
+		long sector, const int length, const char *buf,
+		const int buf_len)
+{
+	struct superswitch *ss = a->container->ss;
+
+	/*
+	 * record bad block in metadata first, then acknowledge it to the driver
+	 * via sysfs file
+	 */
+	if ((ss->record_bad_block(a, mdi->disk.raid_disk, sector, length)) &&
+	    (write(mdi->bb_fd, buf, buf_len) == buf_len))
+		return 1;
+
+	/*
+	 * failed to store or acknowledge bad block, switch of bad block support
+	 * to get it out of blocked state
+	 */
+	sysfs_set_str(&a->info, mdi, "state", "-external_bbl");
+	return -1;
+}
+
+static int read_bb_file(int fd, struct active_array *a, struct mdinfo *mdi,
+			enum bb_action action, void *arg)
+{
+	char buf[30];
+	int n = 0;
+	int ret = 0;
+	int read_again = 0;
+	int off = 0;
+	int pos = 0;
+	int preserve_pos = (action == RECORD_BB ? 0 : 1);
+
+	if (lseek(fd, 0, SEEK_SET) == (off_t) -1)
+		return -1;
+
+	do {
+		read_again = 0;
+		n = read(fd, buf + pos, sizeof(buf) - 1 - pos);
+		if (n < 0)
+			return -1;
+		n += pos;
+
+		buf[n] = '\0';
+		off = 0;
+
+		while (off < n) {
+			unsigned long long sector;
+			int length;
+			char newline;
+			int consumed;
+			int matched;
+			int rc;
+
+			/* kernel sysfs file format: "sector length\n" */
+			matched = sscanf(buf + off, "%llu %d%c%n", &sector,
+					 &length, &newline, &consumed);
+			if ((matched != 3) && (off > 0)) {
+				/* truncated entry, read again */
+				if (preserve_pos) {
+					pos = sizeof(buf) - off - 1;
+					memmove(buf, buf + off, pos);
+				} else {
+					if (lseek(fd, 0, SEEK_SET) ==
+					    (off_t) -1)
+						return -1;
+				}
+				read_again = 1;
+				break;
+			}
+			if (matched != 3)
+				return -1;
+			if (newline != '\n')
+				return -1;
+			if (length <= 0)
+				return -1;
+
+			if (action == RECORD_BB)
+				rc = process_ubb(a, mdi, sector, length,
+						  buf + off, consumed);
+			else
+				rc = -1;
+
+			if (rc < 0)
+				return rc;
+			ret += rc;
+			off += consumed;
+		}
+	} while (read_again);
+
+	return ret;
+}
+
+static int process_dev_ubb(struct active_array *a, struct mdinfo *mdi)
+{
+	return read_bb_file(mdi->ubb_fd, a, mdi, RECORD_BB, NULL);
+}
+
 static void signal_manager(void)
 {
 	/* tgkill(getpid(), mon_tid, SIGUSR1); */
@@ -256,6 +358,16 @@ static int read_and_act(struct active_array *a)
 					  &mdi->recovery_start);
 			mdi->curr_state = read_dev_state(mdi->state_fd);
 		}
+		/*
+		 * If array is blocked and metadata handler is able to handle
+		 * BB, check if you can acknowledge them to md driver. If
+		 * successful, clear faulty state and unblock the array.
+		 */
+		if ((mdi->curr_state & DS_BLOCKED) &&
+		    a->container->ss->record_bad_block &&
+		    (process_dev_ubb(a, mdi) > 0)) {
+			mdi->next_state |= DS_UNBLOCK;
+		}
 	}
 
 	gettimeofday(&tv, NULL);
-- 
1.8.3.1

