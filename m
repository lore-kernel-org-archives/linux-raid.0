From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH] FIX: sysfs_disk_to_scsi_id() adapted to current sysfs format
Date: Wed, 16 Feb 2011 13:40:21 +0100
Message-ID: <20110216124021.9092.83943.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Problem: sysfs_disk_to_scsi_id() not returns correct scsi_id value.
Reason: sysfs format has been changed

This patch adapt sysfs_disk_to_scsi_id() to new sysfs format.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 sysfs.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/sysfs.c b/sysfs.c
index f0773d4..883a834 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -705,7 +705,7 @@ int sysfs_disk_to_scsi_id(int fd, __u32 *id)
 	if (fstat(fd, &st))
 		return 1;
 
-	snprintf(path, sizeof(path), "/sys/dev/block/%d:%d/device",
+	snprintf(path, sizeof(path), "/sys/dev/block/%d:%d/device/scsi_device",
 		 major(st.st_rdev), minor(st.st_rdev));
 
 	dir = opendir(path);
@@ -714,8 +714,7 @@ int sysfs_disk_to_scsi_id(int fd, __u32 *id)
 
 	de = readdir(dir);
 	while (de) {
-		if (strncmp("scsi_disk:", de->d_name,
-			    strlen("scsi_disk:")) == 0)
+		if (strchr(de->d_name, ':'))
 			break;
 		de = readdir(dir);
 	}
@@ -724,21 +723,20 @@ int sysfs_disk_to_scsi_id(int fd, __u32 *id)
 	if (!de)
 		return 1;
 
-	c1 = strchr(de->d_name, ':');
-	c1++;
+	c1 = de->d_name;
 	c2 = strchr(c1, ':');
 	*c2 = '\0';
 	*id = strtol(c1, NULL, 10) << 24; /* host */
 	c1 = c2 + 1;
 	c2 = strchr(c1, ':');
 	*c2 = '\0';
-	*id |= strtol(c1, NULL, 10) << 16; /* channel */
+	*id |= strtol(c1, NULL, 10) << 16; /* bus */
 	c1 = c2 + 1;
 	c2 = strchr(c1, ':');
 	*c2 = '\0';
-	*id |= strtol(c1, NULL, 10) << 8; /* lun */
+	*id |= strtol(c1, NULL, 10) << 8; /* target */
 	c1 = c2 + 1;
-	*id |= strtol(c1, NULL, 10); /* id */
+	*id |= strtol(c1, NULL, 10); /* lun */
 
 	return 0;
 }

