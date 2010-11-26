From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 02/53] block monitor: freeze spare assignment for external
	arrays
Date: Fri, 26 Nov 2010 09:04:07 +0100
Message-ID: <20101126080407.5221.27723.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

In order to support reshape and atomic removal of spares from containers
we need to prevent mdmon from activating spares.  In the reshape case we
additionally need to freeze sync_action while the reshape transaction is
initiated with the kernel and recorded in the metadata.

When reshaping a raid0 array we need to freeze the array *before* it is
transitioned to a redundant raid level.  Since sync_action does not exist
at this point we extend the '-' prefix of a subarray string to flag
mdmon not to activate spares.

Mdadm needs to be reasonably certain that the version of mdmon in the
system honors this 'freeze' indication.  If mdmon is not already active
then we assume the version that gets started is the same as the mdadm
version.  Otherwise, we check the version of mdmon as returned by the
extended ping_monitor() operation.  This is to catch cases where mdadm
is upgraded in the filesystem, but mdmon started in the initramfs is
from a previous release.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 managemon.c |   19 +++++-
 mdadm.h     |    4 +
 msg.c       |  195 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 msg.h       |    2 +
 sysfs.c     |   33 ++++++++++
 util.c      |   24 +++++++
 6 files changed, 273 insertions(+), 4 deletions(-)

diff --git a/managemon.c b/managemon.c
index 544c4a6..164e4f8 100644
--- a/managemon.c
+++ b/managemon.c
@@ -394,12 +394,21 @@ static void manage_member(struct mdstat_ent *mdstat,
 	 * trying to find and assign a spare.
 	 * We do that whenever the monitor tells us too.
 	 */
+	char buf[64];
+	int frozen;
+
 	// FIXME
 	a->info.array.raid_disks = mdstat->raid_disks;
 	a->info.array.chunk_size = mdstat->chunk_size;
 	// MORE
 
-	if (a->check_degraded) {
+	/* honor 'frozen' */
+	if (sysfs_get_str(&a->info, NULL, "metadata_version", buf, sizeof(buf)) > 0)
+		frozen = buf[9] == '-';
+	else
+		frozen = 1; /* can't read metadata_version assume the worst */
+
+	if (a->check_degraded && !frozen) {
 		struct metadata_update *updates = NULL;
 		struct mdinfo *newdev = NULL;
 		struct active_array *newa;
@@ -656,7 +665,13 @@ void read_sock(struct supertype *container)
 		/* read and validate the message */
 		if (receive_message(fd, &msg, tmo) == 0) {
 			handle_message(container, &msg);
-			if (ack(fd, tmo) < 0)
+			if (msg.len == 0) {
+				/* ping reply with version */
+				msg.buf = Version;
+				msg.len = strlen(Version) + 1;
+				if (send_message(fd, &msg, tmo) < 0)
+					terminate = 1;
+			} else if (ack(fd, tmo) < 0)
 				terminate = 1;
 		} else
 			terminate = 1;
diff --git a/mdadm.h b/mdadm.h
index 9787f9e..f7172e9 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -436,6 +436,8 @@ extern int sysfs_fd_get_ll(int fd, unsigned long long *val);
 extern int sysfs_get_ll(struct mdinfo *sra, struct mdinfo *dev,
 			char *name, unsigned long long *val);
 extern int sysfs_fd_get_str(int fd, char *val, int size);
+extern int sysfs_attribute_available(struct mdinfo *sra, struct mdinfo *dev,
+				     char *name);
 extern int sysfs_get_str(struct mdinfo *sra, struct mdinfo *dev,
 			 char *name, char *val, int size);
 extern int sysfs_set_safemode(struct mdinfo *sra, unsigned long ms);
@@ -443,6 +445,7 @@ extern int sysfs_set_array(struct mdinfo *info, int vers);
 extern int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume);
 extern int sysfs_disk_to_scsi_id(int fd, __u32 *id);
 extern int sysfs_unique_holder(int devnum, long rdev);
+extern int sysfs_freeze_array(struct mdinfo *sra);
 extern int load_sys(char *path, char *buf);
 
 
@@ -847,6 +850,7 @@ extern unsigned long bitmap_sectors(struct bitmap_super_s *bsb);
 
 extern int md_get_version(int fd);
 extern int get_linux_version(void);
+extern int mdadm_version(char *version);
 extern long long parse_size(char *size);
 extern int parse_uuid(char *str, int uuid[4]);
 extern int parse_layout_10(char *layout);
diff --git a/msg.c b/msg.c
index aabfa8f..8e7ebfd 100644
--- a/msg.c
+++ b/msg.c
@@ -135,7 +135,15 @@ int ack(int fd, int tmo)
 int wait_reply(int fd, int tmo)
 {
 	struct metadata_update msg;
-	return receive_message(fd, &msg, tmo);
+	int err = receive_message(fd, &msg, tmo);
+
+	/* mdmon sent extra data, but caller only cares that we got a
+	 * successful reply
+	 */
+	if (err == 0 && msg.len > 0)
+		free(msg.buf);
+
+	return err;
 }
 
 int connect_monitor(char *devname)
@@ -195,7 +203,6 @@ int fping_monitor(int sfd)
 	return err;
 }
 
-
 /* give the monitor a chance to update the metadata */
 int ping_monitor(char *devname)
 {
@@ -206,6 +213,190 @@ int ping_monitor(char *devname)
 	return err;
 }
 
+static char *ping_monitor_version(char *devname)
+{
+	int sfd = connect_monitor(devname);
+	struct metadata_update msg;
+	int err = 0;
+
+	if (sfd < 0)
+		return NULL;
+
+	if (ack(sfd, 20) != 0)
+		err = -1;
+
+	if (!err && receive_message(sfd, &msg, 20) != 0)
+		err = -1;
+
+	close(sfd);
+
+	if (err || !msg.len || !msg.buf)
+		return NULL;
+	return msg.buf;
+}
+
+static int unblock_subarray(struct mdinfo *sra, const int unfreeze)
+{
+	char buf[64];
+	int rc = 0;
+
+	if (sra) {
+		sprintf(buf, "external:%s\n", sra->text_version);
+		buf[9] = '/';
+	} else
+		buf[9] = '-';
+
+	if (buf[9] == '-' ||
+	    sysfs_set_str(sra, NULL, "metadata_version", buf) ||
+	    (unfreeze &&
+	     sysfs_attribute_available(sra, NULL, "sync_action") &&
+	     sysfs_set_str(sra, NULL, "sync_action", "idle")))
+		rc = -1;
+	return rc;
+}
+
+/**
+ * block_monitor - prevent mdmon spare assignment
+ * @container - container to block
+ * @freeze - flag to additionally freeze sync_action
+ *
+ * This is used by the reshape code to freeze the container, and the
+ * auto-rebuild implementation to atomically move spares.  For reshape
+ * we need to freeze sync_action in the auto-rebuild we only need to
+ * block new spare assignment, existing rebuilds can continue
+ */
+int block_monitor(char *container, const int freeze)
+{
+	int devnum = devname2devnum(container);
+	struct mdstat_ent *ent, *e, *e2;
+	struct mdinfo *sra = NULL;
+	char *version = NULL;
+	char buf[64];
+	int rv = 0;
+
+	if (!mdmon_running(devnum)) {
+		/* if mdmon is not active we assume that any instance that is
+		 * later started will match the current mdadm version, if this
+		 * assumption is violated we may inadvertantly rebuild an array
+		 * that was meant for reshape, or start rebuild on a spare that
+		 * was to be moved to another container
+		 */
+		/* pass */;
+	} else {
+		int ver;
+
+		version = ping_monitor_version(container);
+		ver = version ? mdadm_version(version) : -1;
+		free(version);
+		if (ver < 3001003) {
+			fprintf(stderr, Name
+				": mdmon instance for %s cannot be disabled\n",
+				container);
+			return -1;
+		}
+	}
+
+	ent = mdstat_read(0, 0);
+	if (!ent) {
+		fprintf(stderr, Name
+			": failed to read /proc/mdstat while disabling mdmon\n");
+		return -1;
+	}
+
+	/* freeze container contents */
+	for (e = ent; e; e = e->next) {
+		if (!is_container_member(e, container))
+			continue;
+		sysfs_free(sra);
+		sra = sysfs_read(-1, e->devnum, GET_VERSION);
+		if (!sra) {
+			fprintf(stderr, Name
+				": failed to read sysfs for subarray%s\n",
+				to_subarray(e, container));
+			break;
+		}
+		/* can't reshape an array that we can't monitor */
+		if (sra->text_version[0] == '-')
+			break;
+
+		if (freeze && sysfs_freeze_array(sra) < 1)
+			break;
+		/* flag this array to not be modified by mdmon (close race with
+		 * takeover in reshape case and spare reassignment in the
+		 * auto-rebuild case)
+		 */
+		sprintf(buf, "external:%s\n", sra->text_version);
+		buf[9] = '-';
+		if (sysfs_set_str(sra, NULL, "metadata_version", buf))
+			break;
+		ping_monitor(container);
+
+		/* check that we did not race with recovery */
+		if ((freeze &&
+		     !sysfs_attribute_available(sra, NULL, "sync_action")) ||
+		    (freeze &&
+		     sysfs_attribute_available(sra, NULL, "sync_action") &&
+		     sysfs_get_str(sra, NULL, "sync_action", buf, 20) > 0 &&
+		     strcmp(buf, "frozen\n") == 0))
+			/* pass */;
+		else
+			break;
+	}
+
+	if (e) {
+		fprintf(stderr, Name ": failed to freeze subarray%s\n",
+			to_subarray(e, container));
+
+		/* thaw the partially frozen container */
+		for (e2 = ent; e2 && e2 != e; e2 = e2->next) {
+			if (!is_container_member(e2, container))
+				continue;
+			sysfs_free(sra);
+			sra = sysfs_read(-1, e2->devnum, GET_VERSION);
+			if (unblock_subarray(sra, freeze))
+				fprintf(stderr, Name ": Failed to unfreeze %s\n", e2->dev);
+		}
+
+		ping_monitor(container); /* cleared frozen */
+		rv = -1;
+	}
+
+	sysfs_free(sra);
+	free_mdstat(ent);
+	free(container);
+
+	return rv;
+}
+
+void unblock_monitor(char *container, const int unfreeze)
+{
+	struct mdstat_ent *ent, *e;
+	struct mdinfo *sra = NULL;
+
+	ent = mdstat_read(0, 0);
+	if (!ent) {
+		fprintf(stderr, Name
+			": failed to read /proc/mdstat while unblocking container\n");
+		return;
+	}
+
+	/* unfreeze container contents */
+	for (e = ent; e; e = e->next) {
+		if (!is_container_member(e, container))
+			continue;
+		sysfs_free(sra);
+		sra = sysfs_read(-1, e->devnum, GET_VERSION);
+		if (unblock_subarray(sra, unfreeze))
+			fprintf(stderr, Name ": Failed to unfreeze %s\n", e->dev);
+	}
+	ping_monitor(container);
+
+	sysfs_free(sra);
+	free_mdstat(ent);
+}
+
+
+
 /* give the manager a chance to view the updated container state.  This
  * would naturally happen due to the manager noticing a change in
  * /proc/mdstat; however, pinging encourages this detection to happen
diff --git a/msg.h b/msg.h
index f8e89fd..1f916de 100644
--- a/msg.h
+++ b/msg.h
@@ -27,6 +27,8 @@ extern int ack(int fd, int tmo);
 extern int wait_reply(int fd, int tmo);
 extern int connect_monitor(char *devname);
 extern int ping_monitor(char *devname);
+extern int block_monitor(char *container, const int freeze);
+extern void unblock_monitor(char *container, const int unfreeze);
 extern int fping_monitor(int sock);
 extern int ping_manager(char *devname);
 
diff --git a/sysfs.c b/sysfs.c
index 6e1d77b..3582fed 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -435,6 +435,17 @@ int sysfs_uevent(struct mdinfo *sra, char *event)
 	return 0;
 }	
 
+int sysfs_attribute_available(struct mdinfo *sra, struct mdinfo *dev, char *name)
+{
+	char fname[60];
+	struct stat st;
+
+	sprintf(fname, "/sys/block/%s/md/%s/%s",
+		sra->sys_name, dev?dev->sys_name:"", name);
+
+	return stat(fname, &st) == 0;
+}
+
 int sysfs_get_fd(struct mdinfo *sra, struct mdinfo *dev,
 		       char *name)
 {
@@ -789,6 +800,28 @@ int sysfs_unique_holder(int devnum, long rdev)
 		return found;
 }
 
+int sysfs_freeze_array(struct mdinfo *sra)
+{
+	/* Try to freeze resync/rebuild on this array/container.
+	 * Return -1 if the array is busy,
+	 * return -2 container cannot be frozen,
+	 * return 0 if this kernel doesn't support 'frozen'
+	 * return 1 if it worked.
+	 */
+	char buf[20];
+
+	if (!sysfs_attribute_available(sra, NULL, "sync_action"))
+		return 1; /* no sync_action == frozen */
+	if (sysfs_get_str(sra, NULL, "sync_action", buf, 20) <= 0)
+		return 0;
+	if (strcmp(buf, "idle\n") != 0 &&
+	    strcmp(buf, "frozen\n") != 0)
+		return -1;
+	if (sysfs_set_str(sra, NULL, "sync_action", "frozen") < 0)
+		return 0;
+	return 1;
+}
+
 #ifndef MDASSEMBLE
 
 static char *clean_states[] = {
diff --git a/util.c b/util.c
index 6f1c1d2..5f2694e 100644
--- a/util.c
+++ b/util.c
@@ -216,6 +216,30 @@ int get_linux_version()
 	return (a*1000000)+(b*1000)+c;
 }
 
+int mdadm_version(char *version)
+{
+	int a, b, c;
+	char *cp;
+
+	if (!version)
+		version = Version;
+
+	cp = strchr(version, '-');
+	if (!cp || *(cp+1) != ' ' || *(cp+2) != 'v')
+		return -1;
+	cp += 3;
+	a = strtoul(cp, &cp, 10);
+	if (*cp != '.')
+		return -1;
+	b = strtoul(cp+1, &cp, 10);
+	if (*cp != '.')
+		return -1;
+	c = strtoul(cp+1, &cp, 10);
+	if (*cp != ' ')
+		return -1;
+	return (a*1000000)+(b*1000)+c;
+}
+
 #ifndef MDASSEMBLE
 long long parse_size(char *size)
 {

