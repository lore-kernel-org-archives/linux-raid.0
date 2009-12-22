From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 06/13] imsm: cleanup print_imsm_dev()
Date: Tue, 22 Dec 2009 16:59:50 -0700
Message-ID: <20091222235950.31628.7990.stgit@dwillia2-linux.ch.intel.com>
References: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

When printing the migration state there is no need to print "migrating".
The fact that the state is non-idle should be enough indication.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 super-intel.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2d5796f..ab8172d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -669,23 +669,24 @@ static void print_imsm_dev(struct imsm_dev *dev, char *uuid, int disk_idx)
 	printf("     Chunk Size : %u KiB\n",
 		__le16_to_cpu(map->blocks_per_strip) / 2);
 	printf("       Reserved : %d\n", __le32_to_cpu(dev->reserved_blocks));
-	printf("  Migrate State : %s", dev->vol.migr_state ? "migrating" : "idle\n");
+	printf("  Migrate State : ");
 	if (dev->vol.migr_state) {
 		if (migr_type(dev) == MIGR_INIT)
-			printf(": initializing\n");
+			printf("initialize\n");
 		else if (migr_type(dev) == MIGR_REBUILD)
-			printf(": rebuilding\n");
+			printf("rebuild\n");
 		else if (migr_type(dev) == MIGR_VERIFY)
-			printf(": check\n");
+			printf("check\n");
 		else if (migr_type(dev) == MIGR_GEN_MIGR)
-			printf(": general migration\n");
+			printf("general migration\n");
 		else if (migr_type(dev) == MIGR_STATE_CHANGE)
-			printf(": state change\n");
+			printf("state change\n");
 		else if (migr_type(dev) == MIGR_REPAIR)
-			printf(": repair\n");
+			printf("repair\n");
 		else
-			printf(": <unknown:%d>\n", migr_type(dev));
-	}
+			printf("<unknown:%d>\n", migr_type(dev));
+	} else
+		printf("idle\n");
 	printf("      Map State : %s", map_state_str[map->map_state]);
 	if (dev->vol.migr_state) {
 		struct imsm_map *map = get_imsm_map(dev, 1);

