From: Jes.Sorensen@redhat.com
Subject: [PATCH 2/8] load_sys(): Add a buffer size argument
Date: Tue,  8 Mar 2016 12:30:46 -0500
Message-ID: <1457458252-20203-3-git-send-email-Jes.Sorensen@redhat.com>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, gqjiang@suse.com, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This adds a buffer size argument to load_sys(), rather than relying on
a hard coded buffer size. The old behavior was safe because we knew
the kernel would never return strings overrunning the buffers, however
it was ugly, and would cause code checking tools to spit out warnings.

This caused a Coverity warning over the read into
sra->sysfs_array_state which is only 20 bytes.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Detail.c      |  2 +-
 mdadm.h       |  2 +-
 super-intel.c |  6 +++---
 sysfs.c       | 47 ++++++++++++++++++++++++-----------------------
 4 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/Detail.c b/Detail.c
index 0cfccad..20c4553 100644
--- a/Detail.c
+++ b/Detail.c
@@ -582,7 +582,7 @@ This is pretty boring
 					continue;
 				sprintf(path, "/sys/block/%s/md/metadata_version",
 					de->d_name);
-				if (load_sys(path, vbuf) < 0)
+				if (load_sys(path, vbuf, sizeof(vbuf)) < 0)
 					continue;
 				if (strncmp(vbuf, "external:", 9) != 0 ||
 				    !is_subarray(vbuf+9) ||
diff --git a/mdadm.h b/mdadm.h
index 97aac52..3b96076 100755
--- a/mdadm.h
+++ b/mdadm.h
@@ -631,7 +631,7 @@ extern int sysfs_disk_to_scsi_id(int fd, __u32 *id);
 extern int sysfs_unique_holder(char *devnm, long rdev);
 extern int sysfs_freeze_array(struct mdinfo *sra);
 extern int sysfs_wait(int fd, int *msec);
-extern int load_sys(char *path, char *buf);
+extern int load_sys(char *path, char *buf, int len);
 extern int reshape_prepare_fdlist(char *devname,
 				  struct mdinfo *sra,
 				  int raid_disks,
diff --git a/super-intel.c b/super-intel.c
index ff0506d..158f4e8 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1654,7 +1654,7 @@ static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_b
 			break;
 		}
 		sprintf(device, "/sys/dev/block/%d:%d/device/type", major, minor);
-		if (load_sys(device, buf) != 0) {
+		if (load_sys(device, buf, sizeof(buf)) != 0) {
 			if (verbose > 0)
 				pr_err("failed to read device type for %s\n",
 					path);
@@ -1669,7 +1669,7 @@ static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_b
 			vendor[0] = '\0';
 			model[0] = '\0';
 			sprintf(device, "/sys/dev/block/%d:%d/device/vendor", major, minor);
-			if (load_sys(device, buf) == 0) {
+			if (load_sys(device, buf, sizeof(buf)) == 0) {
 				strncpy(vendor, buf, sizeof(vendor));
 				vendor[sizeof(vendor) - 1] = '\0';
 				c = (char *) &vendor[sizeof(vendor) - 1];
@@ -1678,7 +1678,7 @@ static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_b
 
 			}
 			sprintf(device, "/sys/dev/block/%d:%d/device/model", major, minor);
-			if (load_sys(device, buf) == 0) {
+			if (load_sys(device, buf, sizeof(buf)) == 0) {
 				strncpy(model, buf, sizeof(model));
 				model[sizeof(model) - 1] = '\0';
 				c = (char *) &model[sizeof(model) - 1];
diff --git a/sysfs.c b/sysfs.c
index 2600343..8379ca8 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -27,15 +27,15 @@
 #include	<dirent.h>
 #include	<ctype.h>
 
-int load_sys(char *path, char *buf)
+int load_sys(char *path, char *buf, int len)
 {
 	int fd = open(path, O_RDONLY);
 	int n;
 	if (fd < 0)
 		return -1;
-	n = read(fd, buf, 1024);
+	n = read(fd, buf, len);
 	close(fd);
-	if (n <0 || n >= 1024)
+	if (n <0 || n >= len)
 		return -1;
 	buf[n] = 0;
 	if (n && buf[n-1] == '\n')
@@ -118,7 +118,7 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 	sra->devs = NULL;
 	if (options & GET_VERSION) {
 		strcpy(base, "metadata_version");
-		if (load_sys(fname, buf))
+		if (load_sys(fname, buf, sizeof(buf)))
 			goto abort;
 		if (strncmp(buf, "none", 4) == 0) {
 			sra->array.major_version =
@@ -137,31 +137,31 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 	}
 	if (options & GET_LEVEL) {
 		strcpy(base, "level");
-		if (load_sys(fname, buf))
+		if (load_sys(fname, buf, sizeof(buf)))
 			goto abort;
 		sra->array.level = map_name(pers, buf);
 	}
 	if (options & GET_LAYOUT) {
 		strcpy(base, "layout");
-		if (load_sys(fname, buf))
+		if (load_sys(fname, buf, sizeof(buf)))
 			goto abort;
 		sra->array.layout = strtoul(buf, NULL, 0);
 	}
 	if (options & GET_DISKS) {
 		strcpy(base, "raid_disks");
-		if (load_sys(fname, buf))
+		if (load_sys(fname, buf, sizeof(buf)))
 			goto abort;
 		sra->array.raid_disks = strtoul(buf, NULL, 0);
 	}
 	if (options & GET_DEGRADED) {
 		strcpy(base, "degraded");
-		if (load_sys(fname, buf))
+		if (load_sys(fname, buf, sizeof(buf)))
 			goto abort;
 		sra->array.failed_disks = strtoul(buf, NULL, 0);
 	}
 	if (options & GET_COMPONENT) {
 		strcpy(base, "component_size");
-		if (load_sys(fname, buf))
+		if (load_sys(fname, buf, sizeof(buf)))
 			goto abort;
 		sra->component_size = strtoull(buf, NULL, 0);
 		/* sysfs reports "K", but we want sectors */
@@ -169,13 +169,13 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 	}
 	if (options & GET_CHUNK) {
 		strcpy(base, "chunk_size");
-		if (load_sys(fname, buf))
+		if (load_sys(fname, buf, sizeof(buf)))
 			goto abort;
 		sra->array.chunk_size = strtoul(buf, NULL, 0);
 	}
 	if (options & GET_CACHE) {
 		strcpy(base, "stripe_cache_size");
-		if (load_sys(fname, buf))
+		if (load_sys(fname, buf, sizeof(buf)))
 			/* Probably level doesn't support it */
 			sra->cache_size = 0;
 		else
@@ -183,7 +183,7 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 	}
 	if (options & GET_MISMATCH) {
 		strcpy(base, "mismatch_cnt");
-		if (load_sys(fname, buf))
+		if (load_sys(fname, buf, sizeof(buf)))
 			goto abort;
 		sra->mismatch_cnt = strtoul(buf, NULL, 0);
 	}
@@ -195,7 +195,7 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 		size_t len;
 
 		strcpy(base, "safe_mode_delay");
-		if (load_sys(fname, buf))
+		if (load_sys(fname, buf, sizeof(buf)))
 			goto abort;
 
 		/* remove a period, and count digits after it */
@@ -218,7 +218,7 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 	}
 	if (options & GET_BITMAP_LOCATION) {
 		strcpy(base, "bitmap/location");
-		if (load_sys(fname, buf))
+		if (load_sys(fname, buf, sizeof(buf)))
 			goto abort;
 		if (strncmp(buf, "file", 4) == 0)
 			sra->bitmap_offset = 1;
@@ -232,7 +232,8 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 
 	if (options & GET_ARRAY_STATE) {
 		strcpy(base, "array_state");
-		if (load_sys(fname, sra->sysfs_array_state))
+		if (load_sys(fname, sra->sysfs_array_state,
+			     sizeof(sra->sysfs_array_state)))
 			goto abort;
 	} else
 		sra->sysfs_array_state[0] = 0;
@@ -262,7 +263,7 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 
 		/* Always get slot, major, minor */
 		strcpy(dbase, "slot");
-		if (load_sys(fname, buf)) {
+		if (load_sys(fname, buf, sizeof(buf))) {
 			/* hmm... unable to read 'slot' maybe the device
 			 * is going away?
 			 */
@@ -287,7 +288,7 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 		if (*ep) dev->disk.raid_disk = -1;
 
 		strcpy(dbase, "block/dev");
-		if (load_sys(fname, buf)) {
+		if (load_sys(fname, buf, sizeof(buf))) {
 			/* assume this is a stale reference to a hot
 			 * removed device
 			 */
@@ -299,7 +300,7 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 
 		/* special case check for block devices that can go 'offline' */
 		strcpy(dbase, "block/device/state");
-		if (load_sys(fname, buf) == 0 &&
+		if (load_sys(fname, buf, sizeof(buf)) == 0 &&
 		    strncmp(buf, "offline", 7) == 0) {
 			free(dev);
 			continue;
@@ -312,25 +313,25 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 
 		if (options & GET_OFFSET) {
 			strcpy(dbase, "offset");
-			if (load_sys(fname, buf))
+			if (load_sys(fname, buf, sizeof(buf)))
 				goto abort;
 			dev->data_offset = strtoull(buf, NULL, 0);
 			strcpy(dbase, "new_offset");
-			if (load_sys(fname, buf) == 0)
+			if (load_sys(fname, buf, sizeof(buf)) == 0)
 				dev->new_data_offset = strtoull(buf, NULL, 0);
 			else
 				dev->new_data_offset = dev->data_offset;
 		}
 		if (options & GET_SIZE) {
 			strcpy(dbase, "size");
-			if (load_sys(fname, buf))
+			if (load_sys(fname, buf, sizeof(buf)))
 				goto abort;
 			dev->component_size = strtoull(buf, NULL, 0) * 2;
 		}
 		if (options & GET_STATE) {
 			dev->disk.state = 0;
 			strcpy(dbase, "state");
-			if (load_sys(fname, buf))
+			if (load_sys(fname, buf, sizeof(buf)))
 				goto abort;
 			if (strstr(buf, "in_sync"))
 				dev->disk.state |= (1<<MD_DISK_SYNC);
@@ -341,7 +342,7 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 		}
 		if (options & GET_ERROR) {
 			strcpy(buf, "errors");
-			if (load_sys(fname, buf))
+			if (load_sys(fname, buf, sizeof(buf)))
 				goto abort;
 			dev->errors = strtoul(buf, NULL, 0);
 		}
-- 
2.5.0

