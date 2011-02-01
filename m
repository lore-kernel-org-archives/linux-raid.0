From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] imsm: FIX: crash during getting map
Date: Tue, 01 Feb 2011 08:57:37 +0100
Message-ID: <20110201075736.4921.34737.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When get_imsm_map() is called with second_map parameter == '-1'
and array is not in migration state NULL pointer is returned.
This is wrong. '-1' means return map as migration record points.

'-1' can be passed to get_imsm_map() from imsm_num_data_members().
imsm_num_data_members() is called to get current map members based
on migr_state information

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 84ab47b..ee0d9c4 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -567,15 +567,16 @@ struct imsm_map *get_imsm_map(struct imsm_dev *dev, int second_map)
 {
 	struct imsm_map *map = &dev->vol.map[0];
 
-	if (second_map && !dev->vol.migr_state)
+	if ((second_map == 1) && !dev->vol.migr_state)
 		return NULL;
-	else if (second_map) {
+	else if ((second_map == 1) ||
+		 ((second_map < 0) && (dev->vol.migr_state))) {
 		void *ptr = map;
 
 		return ptr + sizeof_imsm_map(map);
 	} else
 		return map;
-		
+
 }
 
 /* return the size of the device.

