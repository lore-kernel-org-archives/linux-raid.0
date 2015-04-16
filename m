From: nhdailey <nate.dailey@stratus.com>
Subject: [PATCH] Manage: prevent re-adding a raid1 device that was assembled on its own
Date: Thu, 16 Apr 2015 16:03:01 -0400
Message-ID: <1429214581-7704-1-git-send-email-nate.dailey@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

From: Nate Dailey <nate.dailey@stratus.com>

When re-adding a device to a RAID1, check if it appears to have been assembled
on its own and prevent the re-add if it has (unless --force is given). This
prevents overwriting unique data on the device to be added, and prevents
incomplete resync if a bitmap is in use.

To determine this, get the raid_disk numbers for devices already in the array,
and check those against the superblock of the device-to-be-added. If any active
disk shows as faulty/removed, then the device being added was likely assembled
on its own.

Signed-off-by: Nate Dailey <nate.dailey@stratus.com>
---
 Manage.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 3 deletions(-)

diff --git a/Manage.c b/Manage.c
index d3cfb55..f1df608 100644
--- a/Manage.c
+++ b/Manage.c
@@ -593,17 +593,45 @@ static void add_set(struct mddev_dev *dv, int fd, char set_char)
 	}
 }
 
+int assembled_separately(int fd, struct supertype *tst, char *devmap)
+{
+	mdu_disk_info_t disc;
+	int j;
+
+	/* This device may have been assembled on its own if the superblock
+	 * indicates that some device in the running array is faulty/removed.
+	 */
+	for (j = 0; j < tst->max_devs; j++) {
+		disc.number = j;
+		if (ioctl(fd, GET_DISK_INFO, &disc))
+			continue;
+		if (disc.major == 0 && disc.minor == 0)
+			continue;
+		if (disc.state & (1<<MD_DISK_FAULTY | 1<<MD_DISK_REMOVED))
+			continue;
+		if (disc.raid_disk < 0)
+			continue;
+		if (devmap[disc.raid_disk] == 0)
+			return 1;
+	}
+
+	return 0;
+}
+
 int attempt_re_add(int fd, int tfd, struct mddev_dev *dv,
 		   struct supertype *dev_st, struct supertype *tst,
 		   unsigned long rdev,
-		   char *update, char *devname, int verbose,
+		   char *update, char *devname, int force, int verbose,
 		   mdu_array_info_t *array)
 {
 	struct mdinfo mdi;
 	int duuid[4];
 	int ouuid[4];
+	char *devmap = NULL;
 
-	dev_st->ss->getinfo_super(dev_st, &mdi, NULL);
+	devmap = calloc(array->raid_disks, 1);
+	mdi.array.raid_disks = array->raid_disks;
+	dev_st->ss->getinfo_super(dev_st, &mdi, devmap);
 	dev_st->ss->uuid_from_super(dev_st, ouuid);
 	if (tst->sb)
 		tst->ss->uuid_from_super(tst, duuid);
@@ -630,6 +658,22 @@ int attempt_re_add(int fd, int tfd, struct mddev_dev *dv,
 		    || disc.major != 0 || disc.minor != 0
 			)
 			goto skip_re_add;
+
+		if (array->level == 1 &&
+		    assembled_separately(fd, tst, devmap)) {
+			if (!force) {
+				pr_err("not adding %s as it reports a device in the active array as failed.\n"
+				       "       Add --force if you really want to add this device.\n",
+				       dv->devname);
+				free(devmap);
+				return 1;
+			}
+			pr_err("%s reports a device in the active array as failed.\n"
+			       "       Adding anyway as --force was given.\n",
+			       dv->devname);
+			goto skip_re_add;
+		}
+
 		disc.major = major(rdev);
 		disc.minor = minor(rdev);
 		disc.number = mdi.disk.number;
@@ -645,6 +689,7 @@ int attempt_re_add(int fd, int tfd, struct mddev_dev *dv,
 			tfd = dev_open(dv->devname, O_RDWR);
 			if (tfd < 0) {
 				pr_err("failed to open %s for superblock update during re-add\n", dv->devname);
+				free(devmap);
 				return -1;
 			}
 
@@ -665,6 +710,7 @@ int attempt_re_add(int fd, int tfd, struct mddev_dev *dv,
 			close(tfd);
 			if (rv != 0) {
 				pr_err("failed to update superblock during re-add\n");
+				free(devmap);
 				return -1;
 			}
 		}
@@ -673,17 +719,20 @@ int attempt_re_add(int fd, int tfd, struct mddev_dev *dv,
 		if (ioctl(fd, ADD_NEW_DISK, &disc) == 0) {
 			if (verbose >= 0)
 				pr_err("re-added %s\n", dv->devname);
+			free(devmap);
 			return 1;
 		}
 		if (errno == ENOMEM || errno == EROFS) {
 			pr_err("add new device failed for %s: %s\n",
 			       dv->devname, strerror(errno));
+			free(devmap);
 			if (dv->disposition == 'M')
 				return 0;
 			return -1;
 		}
 	}
 skip_re_add:
+	free(devmap);
 	return 0;
 }
 
@@ -805,7 +854,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 						dev_st, tst,
 						rdev,
 						update, devname,
-						verbose,
+						force, verbose,
 						array);
 			dev_st->ss->free_super(dev_st);
 			if (rv)
-- 
1.8.3.1

