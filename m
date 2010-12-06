From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 16/27] FIX: core during getting map
Date: Mon, 06 Dec 2010 14:22:51 +0100
Message-ID: <20101206132251.21125.58108.stgit@gklab-170-024.igk.intel.com>
References: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

It can occurs that during walking container end conditions bases on "map"
function return value, so function can be protected for wrong data input.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 5f96af2..aced38c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -435,8 +435,12 @@ static size_t sizeof_imsm_map(struct imsm_map *map)
 
 struct imsm_map *get_imsm_map(struct imsm_dev *dev, int second_map)
 {
-	struct imsm_map *map = &dev->vol.map[0];
+	struct imsm_map *map;
+
+	if (dev == NULL)
+		return NULL;
 
+	map = &dev->vol.map[0];
 	if (second_map && !dev->vol.migr_state)
 		return NULL;
 	else if (second_map) {
@@ -1517,6 +1521,9 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	char *devname;
 	int map_disks = info->array.raid_disks;
 
+	if (map == NULL)
+		return;
+
 	for (dl = super->disks; dl; dl = dl->next)
 		if (dl->raiddisk == info->disk.raid_disk)
 			break;

