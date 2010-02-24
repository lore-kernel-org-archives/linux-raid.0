From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [mdadm PATCH 9/11] Enable OLCE for external IMSM metadata
Date: Wed, 24 Feb 2010 07:47:09 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1016F65CF@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From 26e5fea37d6370fca6fc2495ec5e43401464615e Mon Sep 17 00:00:00 2001
From: Adam Kwolek <adam.kwolek@intel.com>
Date: Thu, 18 Feb 2010 11:10:01 +0100
Subject: [PATCH] OLCE: OLCE works on whole container for IMSM

Changes to be committed:
	modified:   Grow.c

IMSM requires that we perform OLCE for all arrays that belongs
to container. It should be made in sequential way due to single
copy area in metadata.

When OLCE is performed for particular array
mdadm will invoke OLCE for all arrays in container.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 Grow.c |  121 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 121 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 9b82b6f..862d82f 100644
--- a/Grow.c
+++ b/Grow.c
@@ -42,6 +42,117 @@
  ***********************************************************/
 #define OLCE_ADDITIONAL_SPACE		10
 
+void OLCE_waitReshape(struct mdinfo *sra, int orig_level)
+{
+	int fd;
+	char action[20];
+
+	if (sra) {
+		fd = sysfs_get_fd(sra, NULL, "sync_action");
+		do {
+			if (orig_level == UnSet) {
+				fd_set rfds;
+				FD_ZERO(&rfds);
+				FD_SET(fd, &rfds);
+				select(fd+1, NULL, NULL, &rfds, NULL);
+			}
+			else sleep (2);
+		
+			if (sysfs_fd_get_str(fd, action, 20) < 0) {
+				close(fd);
+				return;
+			}
+		} while  (strncmp(action, "reshape", 7) == 0);
+	}
+}
+
+
+char *OLCE_GetNextVolume(int fd, int raid_disks, char *retBuf)
+{
+	char *retVal = NULL;
+	struct supertype *st = NULL;
+
+	if ((retBuf) && (fd >-1)) {
+		st = super_by_fd(fd);
+		if (st != NULL) {
+			if (st->ss->external) {
+				int container_fd = -1;
+				int dn;
+				struct mdinfo *sra = NULL; 
+
+				sra =sysfs_read(fd, 0, GET_VERSION);
+				if (sra) {
+					dn = devname2devnum(sra->text_version + 1);
+					sysfs_free(sra);
+					sra = NULL; 
+					container_fd = open_dev_excl(dn);
+					if (container_fd > -1) {
+						sra = sysfs_read(container_fd, 0, GET_VERSION);
+						if (sra) {
+							if ((sra->array.major_version == -1) &&
+							    (strncmp(sra->text_version, "imsm", 4) == 0)) {
+								/* Check OLCE IMSM limitation */
+								struct mdinfo *retInfo;
+								struct mdinfo *info;
+								dprintf("OLCE: IMSM external meta detected\n");
+
+								st->ss->load_super(st, container_fd, NULL);
+								retInfo = st->ss->container_content(st);
+								if (retInfo) {
+									for (info = retInfo ; info; info = info->next) {
+										if ((info->array.level ==0) ||
+										    (info->array.level ==5)){
+											int delta_disks = raid_disks - info->array.raid_disks;
+											if (delta_disks>0) {
+												sprintf(retBuf, "/dev/md/%s",  info->name);
+												retVal = retBuf;
+												break;
+											}
+										}
+									}
+								}
+							}
+							sysfs_free(sra);
+							sra = NULL;
+						}
+						close(container_fd);
+					}
+				}
+			}
+			st->ss->free_super(st);
+		}
+	}
+	return retVal;
+}
+
+int OLCE_processNextVolume(char *devname, int quiet, char *backup_file,
+	long long size, int level, char *layout_str, int chunksize, int raid_disks,
+	struct mdinfo *sra, int orig_level)
+{
+	int fd;
+	char nextVolumeBuf[100];
+	char *nextVolume;
+	int retVal = 0;
+
+	fd = open(devname, O_RDONLY | O_DIRECT);
+	if (fd > -1) {
+		nextVolume = OLCE_GetNextVolume(fd, raid_disks, nextVolumeBuf);
+		close (fd);
+
+		if (nextVolume) {
+			fd = open_mddev(nextVolume, 1);
+			if (fd > -1) {
+				size = -1;
+				OLCE_waitReshape( sra, orig_level);
+				retVal = Grow_reshape(nextVolume, fd, quiet, backup_file, size,
+						level, layout_str, chunksize, raid_disks);
+				close (fd);
+			}
+		}
+	}
+	return retVal;
+}
+
 int OLCE_AllowProceed(int fd)
 {
 	int retVal = 0;
@@ -621,6 +732,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 	unsigned long long array_size;
 	int changed = 0;
 	int done;
+	int raid_disks2 = raid_disks;
 
 	struct mdinfo *sra;
 	struct mdinfo *sd;
@@ -1545,6 +1657,15 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 						devname, c);
 			}
 			
+			if (done >= 0) {
+				OLCE_processNextVolume(devname, quiet, backup_file, size, level, 
+							layout_str, chunksize, raid_disks2,
+							sra, orig_level);
+			} else {
+				fprintf(stderr, Name ": Operation for device %s returns error.\n",
+						devname);
+			}
+			
 			sysfs_free(sra);
 			sra = NULL;
 			exit(0);
-- 
1.6.0.2

