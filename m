From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH] imsm: FIX: getinfo_super_imsm_volume() doesn't fill all disk
	information
Date: Fri, 01 Jul 2011 18:34:48 +0200
Message-ID: <20110701163448.28088.30128.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Adam Kwolek <adam.kwolek@intel.com>

Issue:
getinfo_super_imsm_volume() clears entire 'info' structure before filling with new
information. Disk number and raid_disk can be required later by caller
but it is also cleared.

Resolution:
Patch backs up all disk information before zeroing info structure and
restore it before function return.
The patch aslo reverses workaround for the same problem introduced
in commit:

80e4abc99c7f5a16c56c1c4084bfad63aec03c01
FIX: Cannot create volume

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 Create.c      |    9 ---------
 super-intel.c |   13 ++++++++++++-
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/Create.c b/Create.c
index 48115db..8d88aa1 100644
--- a/Create.c
+++ b/Create.c
@@ -856,15 +856,6 @@ int Create(struct supertype *st, char *mddev,
 					/* getinfo_super might have lost these ... */
 					inf->disk.major = major(stb.st_rdev);
 					inf->disk.minor = minor(stb.st_rdev);
-					/* FIXME the following should not be needed
-					 * as getinfo_super is suppose to set
-					 * them.  However it doesn't for imsm,
-					 * so we have this hack for now
-					 */
-					if (st->ss == &super_imsm) {
-						inf->disk.number = dnum;
-						inf->disk.raid_disk = dnum;
-					}
 				}
 				break;
 			case 2:
diff --git a/super-intel.c b/super-intel.c
index 0bddc6b..e3a693c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2204,11 +2204,20 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	unsigned int component_size_alligment;
 	int map_disks = info->array.raid_disks;
 
-	memset(info, 0, sizeof(*info));
 	if (prev_map)
 		map_to_analyse = prev_map;
 
+	/* find requested (by info->disk.number) disk on the list */
 	dl = super->disks;
+	while (dl) {
+		if (dl->index == info->disk.number)
+			break;
+		dl = dl->next;
+	}
+	if (!dl)
+		dl = super->disks;
+
+	memset(info, 0, sizeof(*info));
 
 	info->container_member	  = super->current_vol;
 	info->array.raid_disks    = map->num_members;
@@ -2275,6 +2284,8 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	if (dl) {
 		info->disk.major = dl->major;
 		info->disk.minor = dl->minor;
+		info->disk.number = dl->index;
+		info->disk.raid_disk = dl->index;
 	}
 
 	info->data_offset	  = __le32_to_cpu(map_to_analyse->pba_of_lba0);

