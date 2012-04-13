From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 04/14] imsm: Execute size change for external metatdata
Date: Fri, 13 Apr 2012 16:51:58 +0200
Message-ID: <1334328728-12544-5-git-send-email-adam.kwolek@intel.com>
References: <1334328728-12544-1-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-2-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-3-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-4-git-send-email-adam.kwolek@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334328728-12544-4-git-send-email-adam.kwolek@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, grzegorz.grabowski@intel.com, maciej.patelczyk@intel.com, anna.czarnowska@intel.com, Adam Kwolek <adam.kwolek@intel.com>
List-Id: linux-raid.ids

For external metatdata ioctl doesn't set new size. Set new size using sysfs.
Put code for size change in to function to re-use the same code as during
On-line Capacity Expansion

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 Grow.c |   78 ++++++++++++++++++++++++++++++++++++++-------------------------
 1 files changed, 47 insertions(+), 31 deletions(-)

diff --git a/Grow.c b/Grow.c
index e3ef8d4..5fd44aa 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1386,6 +1386,44 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 	return NULL;
 }
 
+static int set_array_size(struct supertype *st, struct mdinfo *sra,
+			  char *text_version)
+{
+	struct mdinfo *info;
+	char *subarray;
+	int ret_val = -1;
+
+	if ((st == NULL) || (sra == NULL))
+		return ret_val;
+
+	if (text_version == NULL)
+		text_version = sra->text_version;
+	subarray = strchr(text_version+1, '/')+1;
+	info = st->ss->container_content(st, subarray);
+	if (info) {
+		unsigned long long current_size = 0;
+		unsigned long long new_size =
+			info->custom_array_size/2;
+
+		if (sysfs_get_ll(sra, NULL, "array_size", &current_size) == 0 &&
+		    new_size > current_size) {
+			if (sysfs_set_num(sra, NULL, "array_size", new_size)
+					< 0)
+				dprintf("Error: Cannot set array size");
+			else {
+				ret_val = 0;
+				dprintf("Array size changed");
+			}
+			dprintf(" from %llu to %llu.\n",
+				current_size, new_size);
+		}
+		sysfs_free(info);
+	} else
+		dprintf("Error: set_array_size(): info pointer in NULL\n");
+
+	return ret_val;
+}
+
 static int reshape_array(char *container, int fd, char *devname,
 			 struct supertype *st, struct mdinfo *info,
 			 int force, struct mddev_dev *devlist,
@@ -1636,7 +1674,6 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				"2TB per device\n");
 			size = min_csize;
 		}
-
 		array.size = size;
 		if (array.size != size) {
 			/* got truncated to 32bit, write to
@@ -1647,8 +1684,14 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 						   "component_size", size);
 			else
 				rv = -1;
-		} else
+		} else {
 			rv = ioctl(fd, SET_ARRAY_INFO, &array);
+			/* manage array size when it is managed externally
+			 */
+			if ((rv == 0) && st->ss->external)
+				rv = set_array_size(st, sra, sra->text_version);
+		}
+
 		if (rv != 0) {
 			int err = errno;
 
@@ -2507,35 +2550,8 @@ started:
 	 */
 	if (reshape.before.data_disks !=
 	    reshape.after.data_disks &&
-	    info->custom_array_size) {
-		struct mdinfo *info2;
-		char *subarray = strchr(info->text_version+1, '/')+1;
-
-		info2 = st->ss->container_content(st, subarray);
-		if (info2) {
-			unsigned long long current_size = 0;
-			unsigned long long new_size =
-				info2->custom_array_size/2;
-
-			if (sysfs_get_ll(sra,
-					 NULL,
-					 "array_size",
-					 &current_size) == 0 &&
-			    new_size > current_size) {
-				if (sysfs_set_num(sra, NULL,
-						  "array_size", new_size)
-				    < 0)
-					dprintf("Error: Cannot"
-						" set array size");
-				else
-					dprintf("Array size "
-						"changed");
-				dprintf(" from %llu to %llu.\n",
-					current_size, new_size);
-			}
-			sysfs_free(info2);
-		}
-	}
+	    info->custom_array_size)
+		set_array_size(st, info, info->text_version);
 
 	if (info->new_level != reshape.level) {
 
-- 
1.6.4.2

