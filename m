From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 10/31] Add support to skip slot configuration
Date: Tue, 9 Nov 2010 17:01:03 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CA99@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

When managemon is signaled by monitor (using reshape_delta_disks variable), it adds new disks to md configuration.
To allow md to set slot numbers, flag SYSFS_ADD_DISK_DO_NOT_SET_SLOT was introduced to skip slot setting in sysfs_add_disk() function.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/mdadm.h |    1 +
 mdadm/mdadm/sysfs.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mdadm/mdadm/mdadm.h b/mdadm/mdadm/mdadm.h index 3a8115a..d967057 100644
--- a/mdadm/mdadm/mdadm.h
+++ b/mdadm/mdadm/mdadm.h
@@ -443,6 +443,7 @@ extern int sysfs_get_str(struct mdinfo *sra, struct mdinfo *dev,
 			 char *name, char *val, int size);
 extern int sysfs_set_safemode(struct mdinfo *sra, unsigned long ms);  extern int sysfs_set_array(struct mdinfo *info, int vers);
+#define SYSFS_ADD_DISK_DO_NOT_SET_SLOT		(-INT_MAX)
 extern int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume);  extern int sysfs_disk_to_scsi_id(int fd, __u32 *id);  extern int sysfs_unique_holder(int devnum, long rdev); diff --git a/mdadm/mdadm/sysfs.c b/mdadm/mdadm/sysfs.c index 06e8c93..54fcae0 100644
--- a/mdadm/mdadm/sysfs.c
+++ b/mdadm/mdadm/sysfs.c
@@ -26,6 +26,7 @@
 #include	"mdadm.h"
 #include	<dirent.h>
 #include	<ctype.h>
+#include	<limits.h>
 
 int load_sys(char *path, char *buf)
 {
@@ -614,7 +615,8 @@ int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume)
 			 * yet, so just ignore status for now.
 			 */
 			sysfs_set_str(sra, sd, "state", "insync");
-		rv |= sysfs_set_num(sra, sd, "slot", sd->disk.raid_disk);
+		if (sd->disk.raid_disk != SYSFS_ADD_DISK_DO_NOT_SET_SLOT)
+			rv |= sysfs_set_num(sra, sd, "slot", sd->disk.raid_disk);
 		if (resume)
 			sysfs_set_num(sra, sd, "recovery_start", sd->recovery_start);
 	}

