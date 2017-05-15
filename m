From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] Get failed disk count from array state
Date: Mon, 15 May 2017 14:17:16 +0200
Message-ID: <1494850636-28438-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Recent commit has changed the way failed disks are counted. It breaks
recovery for external metadata arrays as failed disks are not part of
the array and have no corresponding entries is sysfs (they are only
reported for containers) so degraded arrays show no failed disks.

Recent commit overwrites GET_DEGRADED result prior to GET_STATE and it
is not set again if GET_STATE has not been requested. As GET_STATE
provides the same information as GET_DEGRADED, the latter is not needed
anymore. Remove GET_DEGRADED option and replace it with GET_STATE
option.

Don't count number of failed disks looking at sysfs entries but
calculate it at the end. Do it only for arrays as containers report
no disks, just spares.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 Incremental.c | 14 ++++----------
 managemon.c   |  4 ++--
 mdadm.h       |  1 -
 raid6check.c  |  2 +-
 sysfs.c       | 17 +++++++----------
 5 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 680d318..64b63a1 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -886,16 +886,10 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 		}
 		sra = sysfs_read(-1, mp->devnm,
 				 GET_DEVS|GET_OFFSET|GET_SIZE|GET_STATE|
-				 GET_DEGRADED|GET_COMPONENT|GET_VERSION);
-		if (!sra) {
-			/* Probably a container - no degraded info */
-			sra = sysfs_read(-1, mp->devnm,
-					 GET_DEVS|GET_OFFSET|GET_SIZE|GET_STATE|
-					 GET_COMPONENT|GET_VERSION);
-			if (sra)
-				sra->array.failed_disks = -1;
-		}
-		if (!sra)
+				 GET_COMPONENT|GET_VERSION);
+		if (sra)
+			sra->array.failed_disks = -1;
+		else
 			continue;
 		if (st == NULL) {
 			int i;
diff --git a/managemon.c b/managemon.c
index 3c1d4cb..f1eb68a 100644
--- a/managemon.c
+++ b/managemon.c
@@ -685,8 +685,8 @@ static void manage_new(struct mdstat_ent *mdstat,
 
 	mdi = sysfs_read(-1, mdstat->devnm,
 			 GET_LEVEL|GET_CHUNK|GET_DISKS|GET_COMPONENT|
-			 GET_DEGRADED|GET_SAFEMODE|
-			 GET_DEVS|GET_OFFSET|GET_SIZE|GET_STATE|GET_LAYOUT);
+			 GET_SAFEMODE|GET_DEVS|GET_OFFSET|GET_SIZE|GET_STATE|
+			 GET_LAYOUT);
 
 	if (!mdi)
 		return;
diff --git a/mdadm.h b/mdadm.h
index a92feb2..38b2180 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -632,7 +632,6 @@ enum sysfs_read_flags {
 	GET_MISMATCH	= (1 << 5),
 	GET_VERSION	= (1 << 6),
 	GET_DISKS	= (1 << 7),
-	GET_DEGRADED	= (1 << 8),
 	GET_SAFEMODE	= (1 << 9),
 	GET_BITMAP_LOCATION = (1 << 10),
 
diff --git a/raid6check.c b/raid6check.c
index 551f835..a8e6005 100644
--- a/raid6check.c
+++ b/raid6check.c
@@ -562,7 +562,7 @@ int main(int argc, char *argv[])
 			  GET_LEVEL|
 			  GET_LAYOUT|
 			  GET_DISKS|
-			  GET_DEGRADED |
+			  GET_STATE |
 			  GET_COMPONENT|
 			  GET_CHUNK|
 			  GET_DEVS|
diff --git a/sysfs.c b/sysfs.c
index f7967e8..dff986a 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -162,18 +162,12 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 			goto abort;
 		sra->array.layout = strtoul(buf, NULL, 0);
 	}
-	if (options & GET_DISKS) {
+	if (options & (GET_DISKS|GET_STATE)) {
 		strcpy(base, "raid_disks");
 		if (load_sys(fname, buf, sizeof(buf)))
 			goto abort;
 		sra->array.raid_disks = strtoul(buf, NULL, 0);
 	}
-	if (options & GET_DEGRADED) {
-		strcpy(base, "degraded");
-		if (load_sys(fname, buf, sizeof(buf)))
-			goto abort;
-		sra->array.failed_disks = strtoul(buf, NULL, 0);
-	}
 	if (options & GET_COMPONENT) {
 		strcpy(base, "component_size");
 		if (load_sys(fname, buf, sizeof(buf)))
@@ -362,10 +356,8 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 				dev->disk.state |= (1<<MD_DISK_SYNC);
 				sra->array.active_disks++;
 			}
-			if (strstr(buf, "faulty")) {
+			if (strstr(buf, "faulty"))
 				dev->disk.state |= (1<<MD_DISK_FAULTY);
-				sra->array.failed_disks++;
-			}
 			if (dev->disk.state == 0)
 				sra->array.spare_disks++;
 		}
@@ -376,6 +368,11 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 			dev->errors = strtoul(buf, NULL, 0);
 		}
 	}
+
+	if ((options & GET_STATE) && sra->array.raid_disks)
+		sra->array.failed_disks = sra->array.raid_disks -
+			sra->array.active_disks - sra->array.spare_disks;
+
 	closedir(dir);
 	return sra;
 
-- 
1.8.3.1

