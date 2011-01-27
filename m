From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 2/2] FIX: Meet SET_ARRAY_INFO ioctl requirements
Date: Thu, 27 Jan 2011 17:46:58 +0100
Message-ID: <20110127164658.11703.49930.stgit@gklab-128-111.igk.intel.com>
References: <20110127154905.11703.56960.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110127154905.11703.56960.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Problem has been observed when raid10<->raid0 takeover operation
is executed.
In code updating layout, raid_disks and chunk_size for non-restriping
operations in reshape array functions SET_ARRAY_INFO ioctl call was
not succeeded.
Takeover process finish execution with error, mdadm shows message:
"mdadm: failed to set disks"

Cause is not meeting SET_ARRAY_INFO ioctl requirements:
- only one parameter may be changed at one time
- level of current array info and new info should be the same

Patch introduces solution for this issue.
At the beginning of discussed code we read current information
about array and then compare them with new values should be set.
If particular value is different (and should be set),
we are overwrite only this one in array info and then call ioctl.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 Grow.c |   31 ++++++++++++++++++++-----------
 1 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/Grow.c b/Grow.c
index 8c6ff23..194cc3e 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1714,35 +1714,44 @@ static int reshape_array(char *container, int fd, char *devname,
 		/* No restriping needed, but we might need to impose
 		 * some more changes: layout, raid_disks, chunk_size
 		 */
+		/* read current array info */
+		if (ioctl(fd, GET_ARRAY_INFO, &array) != 0) {
+			dprintf("Canot get array information.\n");
+			goto release;
+		}
+		/* compare current array info with new values and if
+		 * it is different update them to new */
 		if (info->new_layout != UnSet &&
-		    info->new_layout != info->array.layout) {
-			info->array.layout = info->new_layout;
-			if (ioctl(fd, SET_ARRAY_INFO, &info->array) != 0) {
+		    info->new_layout != array.layout) {
+			array.layout = info->new_layout;
+			if (ioctl(fd, SET_ARRAY_INFO, &array) != 0) {
 				fprintf(stderr, Name ": failed to set new layout\n");
 				goto release;
 			} else if (!quiet)
 				printf("layout for %s set to %d\n",
-				       devname, info->array.layout);
+				       devname, array.layout);
 		}
 		if (info->delta_disks != UnSet &&
-		    info->delta_disks != 0) {
-			info->array.raid_disks += info->delta_disks;
-			if (ioctl(fd, SET_ARRAY_INFO, &info->array) != 0) {
+		    info->delta_disks != 0 &&
+		    array.raid_disks != (info->array.raid_disks + info->delta_disks)) {
+			array.raid_disks += info->delta_disks;
+			if (ioctl(fd, SET_ARRAY_INFO, &array) != 0) {
 				fprintf(stderr, Name ": failed to set raid disks\n");
 				goto release;
-			} else if (!quiet)
+			} else if (!quiet) {
 				printf("raid_disks for %s set to %d\n",
-				       devname, info->array.raid_disks);
+				       devname, array.raid_disks);
+			}
 		}
 		if (info->new_chunk != 0 &&
-		    info->new_chunk != info->array.chunk_size) {
+		    info->new_chunk != array.chunk_size) {
 			if (sysfs_set_num(info, NULL,
 					  "chunk_size", info->new_chunk) != 0) {
 				fprintf(stderr, Name ": failed to set chunk size\n");
 				goto release;
 			} else if (!quiet)
 				printf("chunk size for %s set to %d\n",
-				       devname, info->array.chunk_size);
+				       devname, array.chunk_size);
 		}
 		unfreeze(st);
 		return 0;

