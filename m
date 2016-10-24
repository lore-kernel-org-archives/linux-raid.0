From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] imsm: load migration record from right disk
Date: Mon, 24 Oct 2016 12:00:17 +0200
Message-ID: <1477303217-7968-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Migration record is only stored on disks in first and second metadata
slot. The function to load the record incorrectly passes disk slot as
disk index. If rebuilt has taken place for a container, disk slot
doesn't match disk index so it causes migration record to be read from a
disk it has not been written to. As a result reshape operation fails.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 super-intel.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index ac3330a..4859950 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2656,19 +2656,12 @@ static int load_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
 	*/
 	if (dev == NULL)
 		return -2;
-	map = get_imsm_map(dev, MAP_0);
 
 	if (info) {
 		for (sd = info->devs ; sd ; sd = sd->next) {
-			/* skip spare and failed disks
-			 */
-			if (sd->disk.raid_disk < 0)
-				continue;
 			/* read only from one of the first two slots */
-			if (map)
-				slot = get_imsm_disk_slot(map,
-							  sd->disk.raid_disk);
-			if (map == NULL || slot > 1 || slot < 0)
+			if ((sd->disk.raid_disk < 0) ||
+			    (sd->disk.raid_disk > 1))
 				continue;
 
 			sprintf(nm, "%d:%d", sd->disk.major, sd->disk.minor);
@@ -2678,6 +2671,7 @@ static int load_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
 		}
 	}
 	if (fd < 0) {
+		map = get_imsm_map(dev, MAP_0);
 		for (dl = super->disks; dl; dl = dl->next) {
 			/* skip spare and failed disks
 			*/
-- 
1.8.3.1

