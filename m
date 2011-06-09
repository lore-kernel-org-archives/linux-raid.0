From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/4] imsm: FIX: Cannot create volume
Date: Thu, 09 Jun 2011 18:29:12 +0200
Message-ID: <20110609162912.690.5879.stgit@gklab-128-013.igk.intel.com>
References: <20110609162050.690.87261.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110609162050.690.87261.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

getinfo_super_imsm_volume() clears entire 'info' structure before filling with new
information. Disk number and raid_disk can be required later by caller
but it is lost.

Restore disk number information in getinfo_super_imsm_volume() call.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 5c840ec..e094b85 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2075,11 +2075,18 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	unsigned int component_size_alligment;
 	int map_disks = info->array.raid_disks;
 
-	memset(info, 0, sizeof(*info));
 	if (prev_map)
 		map_to_analyse = prev_map;
 
 	dl = super->disks;
+	while (dl) {
+		if (dl->index == info->disk.number)
+			break;
+		dl = dl->next;
+	}
+	if (!dl)
+		dl = super->disks;
+	memset(info, 0, sizeof(*info));
 
 	info->container_member	  = super->current_vol;
 	info->array.raid_disks    = map->num_members;
@@ -2147,6 +2154,8 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	if (dl) {
 		info->disk.major = dl->major;
 		info->disk.minor = dl->minor;
+		info->disk.number = dl->index;
+		info->disk.raid_disk = dl->index;
 	}
 
 	info->data_offset	  = __le32_to_cpu(map_to_analyse->pba_of_lba0);

