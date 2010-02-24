From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [mdadm PATCH 8/11] Enable OLCE for external IMSM metadata
Date: Wed, 24 Feb 2010 07:46:58 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1016F65CE@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From 9e4b23ace5be747c4398e66e87696a295617babd Mon Sep 17 00:00:00 2001
From: Adam Kwolek <adam.kwolek@intel.com>
Date: Thu, 18 Feb 2010 11:09:15 +0100
Subject: [PATCH] OLCE: Add OLCE Limitations

Changes to be committed:
	modified:   Grow.c

OLCE can be used for Raid5 and Raid0 only

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 Grow.c |  109 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 109 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index e568c37..9b82b6f 100644
--- a/Grow.c
+++ b/Grow.c
@@ -42,6 +42,105 @@
  ***********************************************************/
 #define OLCE_ADDITIONAL_SPACE		10
 
+int OLCE_AllowProceed(int fd)
+{
+	int retVal = 0;
+	struct supertype *st = NULL;
+	struct mdinfo *sra = NULL; 
+	int container_fd = -1;
+	int dn = -1;
+	struct mdinfo *retInfo = NULL;
+	struct mdinfo *info = NULL;
+	char buf[1024];
+
+	if (fd > -1) {
+		st = super_by_fd(fd);
+		if (st != NULL) {
+			if (st->ss->external) {
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
+								/*  Check OLCE IMSM limitation */
+								dprintf("OLCE: IMSM external meta detected\n");
+
+								st->ss->load_super(st, container_fd, NULL);
+								retInfo = st->ss->container_content(st);
+								if (retInfo) {
+									retVal = 1;
+									for (info = retInfo ; info; info = info->next) {
+									
+										if ((info->array.level !=0) &&
+										    (info->array.level !=5)) {
+											/* we cannot use this container
+											 * other reid level
+											 */
+											retVal = 0;
+											break;
+										} else {
+											/* all raid5 and raid0 volumes in container 
+											 * has to be ready for OLCE
+											 */
+											int result;
+											int minor;
+											
+											result = find_array_minor(info->text_version, st->ss->external ,&minor);
+											
+											if (result > -1) {
+												sprintf(info->sys_name,"md%i", minor);;
+												
+												if (sysfs_get_str(info, NULL, "array_state", buf, 20) <= 0) {
+													retVal = 0;
+													break;
+												}
+												if (strcmp(buf, "clean\n") != 0 &&
+												    strcmp(buf, "active\n") != 0) {
+													retVal = 0;
+													break;
+												}
+												
+												if (info->array.level == 5) {
+													if (sysfs_get_str(info, NULL, "sync_action", buf, 20) <= 0) {
+														retVal = 0;
+														break;
+													}
+													if (strcmp(buf, "idle\n") != 0 &&
+													    strcmp(buf, "active\n") != 0 &&
+													    strcmp(buf, "frozen\n") != 0) {
+														retVal = 0;
+														break;
+													}
+												}
+											} else {
+												retVal = 0;
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
+			else retVal = 1; /* native meta */
+			st->ss->free_super(st);
+			st = NULL;
+		}
+	}
+	return retVal;
+}
+
 int Grow_Add_device(char *devname, int fd, char *newdev)
 {
 	/* Add a device to an active array.
@@ -874,6 +973,16 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		}
 	}
 
+	/* =========  check OLCE limitations =========== */
+	/* it have to be check after takeover, 
+	   for Raid0 it cannot be done ealier
+	 */
+	if (OLCE_AllowProceed(fd) == 0) {
+		fprintf(stderr, Name ": %s cannot be reshaped due to OLCE limitations.\n", devname);
+		rv = -1;
+		goto release;
+	}
+
 	/* ========= set shape (chunk_size / layout / ndisks)  ============== */
 	/* Check if layout change is a no-op */
 	if (layout_str) switch(array.level) {
-- 
1.6.0.2

