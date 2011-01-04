From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 23/34] Set array size after adding new disks
Date: Tue, 04 Jan 2011 15:38:39 +0100
Message-ID: <20110104143839.6697.70347.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When new disks are added array size has to be set by mdadm as array grows.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 51 insertions(+), 16 deletions(-)

diff --git a/Grow.c b/Grow.c
index 1c10889..0b151f1 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2034,26 +2034,61 @@ static int reshape_array(char *container, int fd, char *devname,
 			unlink(backup_file);
 		if (!done)
 			abort_reshape(sra);
-		else if (info->new_level != info->array.level) {
-			/* We need to wait for the reshape to finish
-			 * (which will have happened unless odata < ndata)
-			 * and then set the level
+		else {
+			/* set new array size size - if required
 			 */
+			if (reshape.before.raid_disks <
+			    reshape.after.raid_disks) {
+				struct mdinfo *info2;
 
-			c = map_num(pers, info->new_level);
-			if (c == NULL) {
-				if (forked)
-					return 1;
-				exit(0);/* not possible */
+				wait_reshape(sra);
+				ping_monitor(container);
+
+				info2 = st->ss->container_content(st, subarray);
+				if (info2) {
+					unsigned long long current_size = 0;
+					unsigned long long new_size =
+						info2->custom_array_size/2;
+
+					sysfs_get_ll(sra,
+						     NULL,
+						     "array_size",
+						     &current_size);
+					if (new_size > current_size) {
+						if (sysfs_set_num(sra, NULL,
+							"array_size", new_size)
+						    < 0)
+							dprintf("Error: Cannot"\
+							     " set array size");
+						else
+							dprintf("Array size "\
+								"changed");
+						dprintf(" from %llu to %llu.\n",
+							current_size, new_size);
+					}
+					sysfs_free(info2);
+				}
 			}
 
-			if (reshape.before.raid_disks < 
-			    reshape.after.raid_disks)
-				wait_reshape(sra);
-			err = sysfs_set_str(sra, NULL, "level", c);
-			if (err)
-				fprintf(stderr, Name ": %s: could not set level to %s\n",
-					devname, c);
+			if (info->new_level != info->array.level) {
+				/* We need to wait for the reshape to finish
+				* (which will have happened unless
+				 * odata < ndata) and then set the level
+				*/
+
+				c = map_num(pers, info->new_level);
+				if (c == NULL) {
+					if (forked)
+						return 1;
+					exit(0);/* not possible */
+				}
+
+				err = sysfs_set_str(sra, NULL, "level", c);
+				if (err)
+					fprintf(stderr, Name\
+						": %s: could not set level"\
+						"to %s\n", devname, c);
+			}
 		}
 		if (forked)
 			return 0;

