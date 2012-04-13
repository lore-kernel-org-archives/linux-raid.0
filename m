From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 09/14] FIX: Detect error and rollback metadata
Date: Fri, 13 Apr 2012 16:52:03 +0200
Message-ID: <1334328728-12544-10-git-send-email-adam.kwolek@intel.com>
References: <1334328728-12544-1-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-2-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-3-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-4-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-5-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-6-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-7-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-8-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-9-git-send-email-adam.kwolek@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334328728-12544-9-git-send-email-adam.kwolek@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, grzegorz.grabowski@intel.com, maciej.patelczyk@intel.com, anna.czarnowska@intel.com, Adam Kwolek <adam.kwolek@intel.com>
List-Id: linux-raid.ids

Some setting size error cases were not detected.
When error occurs, stop setting new size action and rollback metadata
changes.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 Grow.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index 86d1020..1b45199 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1665,9 +1665,12 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		 * understands '0' to mean 'max'.
 		 */
 		min_csize = 0;
+		rv = 0;
 		for (mdi = sra->devs; mdi; mdi = mdi->next) {
-			if (sysfs_set_num(sra, mdi, "size", size) < 0)
+			if (sysfs_set_num(sra, mdi, "size", size) < 0) {
+				rv = 1;
 				break;
+			}
 			if (array.not_persistent == 0 &&
 			    array.major_version == 0 &&
 			    get_linux_version() < 3001000) {
@@ -1682,11 +1685,16 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				}
 			}
 		}
+		if (rv) {
+			fprintf(stderr, Name ": Cannot set size on "
+				"array members.\n");
+			goto size_change_error;
+		}
 		if (min_csize && size > min_csize) {
 			fprintf(stderr, Name ": Cannot safely make this array "
 				"use more than 2TB per device on this kernel.\n");
 			rv = 1;
-			goto release;
+			goto size_change_error;
 		}
 		if (min_csize && size == 0) {
 			/* Don't let the kernel choose a size - it will get
@@ -1748,6 +1756,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			ioctl(fd, GET_ARRAY_INFO, &array);
 		}
 
+size_change_error:
 		if (rv != 0) {
 			int err = errno;
 
-- 
1.6.4.2

