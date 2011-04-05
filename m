From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/3] imsm: fix: report aligned component size value
Date: Tue, 05 Apr 2011 15:46:25 +0200
Message-ID: <20110405134625.4843.93141.stgit@gklab-128-013.igk.intel.com>
References: <20110405134609.4843.95211.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110405134609.4843.95211.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

OROM can create array with chunk size not aligned.
To resolve this problem in mdadm ,metadata handler has to report
component size aligned value for mdadm operations
while metadata value stays unchanged.

Do not correct alignment for raid1 and in error case.

Correction allows check in analyse_change() (Grow.c:905) to pass.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 9e9d6a9..fd044cb 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1745,6 +1745,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	struct imsm_map *map_to_analyse = map;
 	struct dl *dl;
 	char *devname;
+	unsigned int component_size_alligment;
 	int map_disks = info->array.raid_disks;
 
 	if (prev_map)
@@ -1824,6 +1825,21 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	info->data_offset	  = __le32_to_cpu(map_to_analyse->pba_of_lba0);
 	info->component_size	  =
 		__le32_to_cpu(map_to_analyse->blocks_per_member);
+
+	/* check component size aligment
+	 */
+	component_size_alligment =
+		info->component_size % (info->array.chunk_size/512);
+
+	if (component_size_alligment &&
+	    (info->array.level != 1) && (info->array.level != UnSet)) {
+		dprintf("imsm: reported component size alligned from %llu ",
+			info->component_size);
+		info->component_size -= component_size_alligment;
+		dprintf("to %llu (%i).\n",
+			info->component_size, component_size_alligment);
+	}
+
 	memset(info->uuid, 0, sizeof(info->uuid));
 	info->recovery_start = MaxSector;
 

