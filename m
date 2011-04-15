From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/4] FIX: Set proper raid disks during migration
Date: Fri, 15 Apr 2011 14:30:47 +0200
Message-ID: <20110415123047.6601.73897.stgit@gklab-128-013.igk.intel.com>
References: <20110415122820.6601.48084.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110415122820.6601.48084.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

During migration raid_disks field contains new disks number now.
It should be set old disks number first and then new disks number
to allow md to calculate e.g. delta_disks parameter.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 sysfs.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/sysfs.c b/sysfs.c
index b806e14..f1c6669 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -531,6 +531,7 @@ int sysfs_set_array(struct mdinfo *info, int vers)
 {
 	int rv = 0;
 	char ver[100];
+	int raid_disks = info->array.raid_disks;
 
 	ver[0] = 0;
 	if (info->array.major_version == -1 &&
@@ -549,7 +550,9 @@ int sysfs_set_array(struct mdinfo *info, int vers)
 		return 0; /* FIXME */
 	rv |= sysfs_set_str(info, NULL, "level",
 			    map_num(pers, info->array.level));
-	rv |= sysfs_set_num(info, NULL, "raid_disks", info->array.raid_disks);
+	if (info->reshape_active && info->delta_disks != UnSet)
+		raid_disks -= info->delta_disks;
+	rv |= sysfs_set_num(info, NULL, "raid_disks", raid_disks);
 	rv |= sysfs_set_num(info, NULL, "chunk_size", info->array.chunk_size);
 	rv |= sysfs_set_num(info, NULL, "layout", info->array.layout);
 	rv |= sysfs_set_num(info, NULL, "component_size", info->component_size/2);
@@ -576,7 +579,7 @@ int sysfs_set_array(struct mdinfo *info, int vers)
 		rv |= sysfs_set_num(info, NULL, "chunk_size", info->new_chunk);
 		rv |= sysfs_set_num(info, NULL, "layout", info->new_layout);
 		rv |= sysfs_set_num(info, NULL, "raid_disks",
-				    info->array.raid_disks + info->delta_disks);
+				    info->array.raid_disks);
 		/* We don't set 'new_level' here.  That can only happen
 		 * once the reshape completes.
 		 */

