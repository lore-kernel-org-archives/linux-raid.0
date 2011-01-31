From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/2] imsm: FIX: sizeof_imsm_dev() can return too small value
Date: Mon, 31 Jan 2011 16:25:24 +0100
Message-ID: <20110131152524.13213.50120.stgit@gklab-128-013.igk.intel.com>
References: <20110131151657.13213.16328.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131151657.13213.16328.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

sizeof_imsm_dev() should return value that can satisfy map operation
for 2 maps of size equal to bigger one.
If function reports too small value copy of bigger map can overwrite
other data in memory.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 0c988d6..3c969c3 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -584,12 +584,17 @@ static size_t sizeof_imsm_dev(struct imsm_dev *dev, int migr_state)
 {
 	size_t size = sizeof(*dev) - sizeof(struct imsm_map) +
 		      sizeof_imsm_map(get_imsm_map(dev, 0));
+	int map_size = sizeof_imsm_map(get_imsm_map(dev, 0));
+
+	if (dev->vol.migr_state) {
+		int map1_size = sizeof_imsm_map(get_imsm_map(dev, 1));
+		if (map1_size > map_size)
+			map_size = map1_size;
+	}
 
 	/* migrating means an additional map */
-	if (dev->vol.migr_state)
-		size += sizeof_imsm_map(get_imsm_map(dev, 1));
-	else if (migr_state)
-		size += sizeof_imsm_map(get_imsm_map(dev, 0));
+	if ((dev->vol.migr_state) || (migr_state))
+		size += map_size;
 
 	return size;
 }

