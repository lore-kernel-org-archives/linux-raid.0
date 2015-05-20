From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V3 05/11] Add a new clustered disk
Date: Wed, 20 May 2015 11:20:37 +0800
Message-ID: <1432092043-24220-6-git-send-email-gqjiang@suse.com>
References: <1432092043-24220-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1432092043-24220-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

A clustered disk is added by the traditional --add sequence.
However, other nodes need to acknowledge that they can "see"
the device. This is done by --cluster-confirm:

--cluster-confirm SLOTNUM:/dev/whatever (if disk is found)
or
--cluster-confirm SLOTNUM:missing (if disk is not found)

The node initiating the --add, has the disk state tagged with
MD_DISK_CLUSTER_ADD and the one confirming tag the disk with
MD_DISK_CANDIDATE.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Manage.c   | 33 +++++++++++++++++++++++++++++----
 ReadMe.c   |  1 +
 md_p.h     |  7 +++++++
 md_u.h     |  1 +
 mdadm.8.in |  9 +++++++++
 mdadm.c    |  4 ++++
 mdadm.h    |  2 ++
 util.c     | 10 ++++++++++
 8 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/Manage.c b/Manage.c
index d3cfb55..4c3d451 100644
--- a/Manage.c
+++ b/Manage.c
@@ -690,7 +690,8 @@ skip_re_add:
 int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 	       struct supertype *tst, mdu_array_info_t *array,
 	       int force, int verbose, char *devname,
-	       char *update, unsigned long rdev, unsigned long long array_size)
+	       char *update, unsigned long rdev, unsigned long long array_size,
+	       int raid_slot)
 {
 	unsigned long long ldsize;
 	struct supertype *dev_st = NULL;
@@ -879,7 +880,10 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 	}
 	disc.major = major(rdev);
 	disc.minor = minor(rdev);
-	disc.number =j;
+	if (raid_slot < 0)
+		disc.number = j;
+	else
+		disc.number = raid_slot;
 	disc.state = 0;
 	if (array->not_persistent==0) {
 		int dfd;
@@ -920,6 +924,14 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 			}
 		free(used);
 	}
+
+	if (array->state & (1 << MD_SB_CLUSTERED)) {
+		if (dv->disposition == 'c')
+			disc.state |= (1 << MD_DISK_CANDIDATE);
+		else
+			disc.state |= (1 << MD_DISK_CLUSTER_ADD);
+	}
+
 	if (dv->writemostly == 1)
 		disc.state |= (1 << MD_DISK_WRITEMOSTLY);
 	if (tst->ss->external) {
@@ -1239,6 +1251,7 @@ int Manage_subdevs(char *devname, int fd,
 	 *        variant on 'A'
 	 *  'F' - Another variant of 'A', where the device was faulty
 	 *        so must be removed from the array first.
+	 *  'c' - confirm the device as found (for clustered environments)
 	 *
 	 * For 'f' and 'r', the device can also be a kernel-internal
 	 * name such as 'sdb'.
@@ -1254,6 +1267,7 @@ int Manage_subdevs(char *devname, int fd,
 	struct mdinfo info;
 	int frozen = 0;
 	int busy = 0;
+	int raid_slot = -1;
 
 	if (ioctl(fd, GET_ARRAY_INFO, &array)) {
 		pr_err("Cannot get array info for %s\n",
@@ -1282,6 +1296,11 @@ int Manage_subdevs(char *devname, int fd,
 		int rv;
 		int mj,mn;
 
+		raid_slot = -1;
+		if (dv->disposition == 'c')
+			parse_cluster_confirm_arg(dv->devname, &dv->devname,
+					&raid_slot);
+
 		if (strcmp(dv->devname, "failed") == 0 ||
 		    strcmp(dv->devname, "faulty") == 0) {
 			if (dv->disposition != 'A'
@@ -1307,6 +1326,11 @@ int Manage_subdevs(char *devname, int fd,
 		if (strcmp(dv->devname, "missing") == 0) {
 			struct mddev_dev *add_devlist = NULL;
 			struct mddev_dev **dp;
+			if (dv->disposition == 'c') {
+				rv = ioctl(fd, CLUSTERED_DISK_NACK, NULL);
+				break;
+			}
+
 			if (dv->disposition != 'A') {
 				pr_err("'missing' only meaningful with --re-add\n");
 				goto abort;
@@ -1399,7 +1423,7 @@ int Manage_subdevs(char *devname, int fd,
 			else {
 				int open_err = errno;
 				if (stat(dv->devname, &stb) != 0) {
-					pr_err("Cannot find %s: %s\n",
+					pr_err("%s: %d Cannot find %s: %s\n", __func__, __LINE__,
 					       dv->devname, strerror(errno));
 					goto abort;
 				}
@@ -1437,6 +1461,7 @@ int Manage_subdevs(char *devname, int fd,
 		case 'A':
 		case 'M': /* --re-add missing */
 		case 'F': /* --re-add faulty  */
+		case 'c': /* --cluster-confirm */
 			/* add the device */
 			if (subarray) {
 				pr_err("Cannot add disks to a \'member\' array, perform this operation on the parent container\n");
@@ -1470,7 +1495,7 @@ int Manage_subdevs(char *devname, int fd,
 			}
 			rv = Manage_add(fd, tfd, dv, tst, &array,
 					force, verbose, devname, update,
-					rdev, array_size);
+					rdev, array_size, raid_slot);
 			close(tfd);
 			tfd = -1;
 			if (rv < 0)
diff --git a/ReadMe.c b/ReadMe.c
index c6286ae..c854cd5 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -169,6 +169,7 @@ struct option long_options[] = {
     {"wait",	  0, 0,  WaitOpt},
     {"wait-clean", 0, 0, Waitclean },
     {"action",    1, 0, Action },
+    {"cluster-confirm", 0, 0, ClusterConfirm},
 
     /* For Detail/Examine */
     {"brief",	  0, 0, Brief},
diff --git a/md_p.h b/md_p.h
index c4846ba..e59504f 100644
--- a/md_p.h
+++ b/md_p.h
@@ -78,6 +78,12 @@
 #define MD_DISK_ACTIVE		1 /* disk is running but may not be in sync */
 #define MD_DISK_SYNC		2 /* disk is in sync with the raid set */
 #define MD_DISK_REMOVED		3 /* disk is in sync with the raid set */
+#define MD_DISK_CLUSTER_ADD     4 /* Initiate a disk add across the cluster
+				   * For clustered enviroments only.
+				   */
+#define MD_DISK_CANDIDATE	5 /* disk is added as spare (local) until confirmed
+				   * For clustered enviroments only.
+				   */
 
 #define	MD_DISK_WRITEMOSTLY	9 /* disk is "write-mostly" is RAID1 config.
 				   * read requests will only be sent here in
@@ -106,6 +112,7 @@ typedef struct mdp_device_descriptor_s {
 #define MD_SB_BLOCK_CONTAINER_RESHAPE 3 /* block container wide reshapes */
 #define MD_SB_BLOCK_VOLUME	4 /* block activation of array, other arrays
 				   * in container can be activated */
+#define MD_SB_CLUSTERED		5 /* MD is clustered  */
 #define	MD_SB_BITMAP_PRESENT	8 /* bitmap may be present nearby */
 
 typedef struct mdp_superblock_s {
diff --git a/md_u.h b/md_u.h
index be9868a..76068d6 100644
--- a/md_u.h
+++ b/md_u.h
@@ -44,6 +44,7 @@
 #define STOP_ARRAY		_IO (MD_MAJOR, 0x32)
 #define STOP_ARRAY_RO		_IO (MD_MAJOR, 0x33)
 #define RESTART_ARRAY_RW	_IO (MD_MAJOR, 0x34)
+#define CLUSTERED_DISK_NACK	_IO (MD_MAJOR, 0x35)
 
 typedef struct mdu_version_s {
 	int major;
diff --git a/mdadm.8.in b/mdadm.8.in
index 56d9bcc..57873ec 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1406,6 +1406,15 @@ will avoid reading from these devices if possible.
 .BR \-\-readwrite
 Subsequent devices that are added or re\-added will have the 'write-mostly'
 flag cleared.
+.TP
+.BR \-\-cluster\-confirm
+Confirm the existence of the device. This is issued in response to an \-\-add
+request by a node in a cluster. When a node adds a device it sends a message
+to all nodes in the cluster to look for a device with a UUID. This translates
+to a udev notification with the UUID of the device to be added and the slot
+number. The receiving node must acknowledge this message
+with \-\-cluster\-confirm. Valid arguments are <slot>:<devicename> in case
+the device is found or <slot>:missing in case the device is not found.
 
 .P
 Each of these options requires that the first device listed is the array
diff --git a/mdadm.c b/mdadm.c
index 8f567d8..56fdeb7 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -196,6 +196,7 @@ int main(int argc, char *argv[])
 		case 'f':
 		case Fail:
 		case ReAdd: /* re-add */
+		case ClusterConfirm:
 			if (!mode) {
 				newmode = MANAGE;
 				shortopt = short_bitmap_options;
@@ -933,6 +934,9 @@ int main(int argc, char *argv[])
 					   * remove the device */
 			devmode = 'f';
 			continue;
+		case O(MANAGE, ClusterConfirm):
+			devmode = 'c';
+			continue;
 		case O(MANAGE,Replace):
 			/* Mark these devices for replacement */
 			devmode = 'R';
diff --git a/mdadm.h b/mdadm.h
index f56d9d6..00c726e 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -346,6 +346,7 @@ enum special_options {
 	Action,
 	Nodes,
 	ClusterName,
+	ClusterConfirm,
 };
 
 enum prefix_standard {
@@ -1281,6 +1282,7 @@ extern int parse_uuid(char *str, int uuid[4]);
 extern int parse_layout_10(char *layout);
 extern int parse_layout_faulty(char *layout);
 extern long parse_num(char *num);
+extern int parse_cluster_confirm_arg(char *inp, char **devname, int *slot);
 extern int check_ext2(int fd, char *name);
 extern int check_reiser(int fd, char *name);
 extern int check_raid(int fd, char *name);
diff --git a/util.c b/util.c
index ed9a745..8d27564 100644
--- a/util.c
+++ b/util.c
@@ -273,6 +273,16 @@ long parse_num(char *num)
 }
 #endif
 
+int parse_cluster_confirm_arg(char *input, char **devname, int *slot)
+{
+	char *dev;
+	*slot = strtoul(input, &dev, 10);
+	if (dev == input || dev[0] != ':')
+		return -1;
+	*devname = dev+1;
+	return 0;
+}
+
 void remove_partitions(int fd)
 {
 	/* remove partitions from this block devices.
-- 
1.7.12.4

