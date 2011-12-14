From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/3] imsm: FIX: UT '08imsm-overlap' fails
Date: Wed, 14 Dec 2011 16:07:20 +0100
Message-ID: <20111214150720.21483.27249.stgit@gklab-128-013.igk.intel.com>
References: <20111214150448.21483.16231.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111214150448.21483.16231.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Problem was introduced by patch (2011-09-19):
   Create: Allow to create two volumes of different sizes within one container

To resolve problem check requested disks number not against all disks
recorded in metadata, but against disks number set in array map structure.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 5e1d278..3c10d29 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5318,10 +5318,26 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 
 	mpb = super->anchor;
 
-	if (mpb->num_raid_devs > 0 && mpb->num_disks != raiddisks) {
-		fprintf(stderr, Name ": the option-rom requires all "
-			"member disks to be a member of all volumes.\n");
-		return 0;
+	/* check if currently verified volume spans the same disks number
+	 * as all other arrays that belongs to metadata.
+	 * Do not allow to create volume with different disks number
+	 * than curently is used.
+	 */
+	for (i = 0; i < mpb->num_raid_devs; i++) {
+		/* There is any already existing array in metadata
+		 */
+		struct imsm_dev *dev = get_imsm_dev(super, i);
+		struct imsm_map *map = NULL;
+		if (dev)
+			map = get_imsm_map(dev, MAP_0);
+		if (map) {
+			if (raiddisks != map->num_members) {
+				fprintf(stderr, Name ": the option-rom requires"
+					" all member disks to be a member of "
+					"all volumes.\n");
+				return 0;
+			}
+		}
 	}
 
 	if (!validate_geometry_imsm_orom(super, level, layout, raiddisks, chunk, verbose)) {

