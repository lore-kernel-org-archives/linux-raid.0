From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/4] imsm: Add information about failed disk to '-E' option
Date: Wed, 09 Feb 2011 14:48:03 +0100
Message-ID: <20110209134803.4559.28729.stgit@gklab-128-013.igk.intel.com>
References: <20110209134737.4559.34527.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110209134737.4559.34527.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

During metadata printout in '-E' option failed disk map field information is missing.
Add this information to mdadm '-E' option output.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 876cc4c..4a9c230 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -897,6 +897,12 @@ static void print_imsm_dev(struct imsm_dev *dev, char *uuid, int disk_idx)
 		printf("]");
 	}
 	printf("\n");
+	printf("    Failed disk : ");
+	if (map->failed_disk_num == 0xff)
+		printf("none");
+	else
+		printf("%i", map->failed_disk_num);
+	printf("\n");
 	slot = get_imsm_disk_slot(map, disk_idx);
 	if (slot >= 0) {
 		ord = get_imsm_ord_tbl_ent(dev, slot, -1);

