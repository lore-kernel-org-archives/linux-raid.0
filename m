From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] imsm:FIX: change arrays reshape order (v2)
Date: Mon, 31 Jan 2011 11:20:46 +0100
Message-ID: <20110131102046.12129.7335.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Reshape is started from second array, so it causes imsm incompatibility
and problems during second array start.

Reshape should be started in arrays metadata order.

v2: added function to obtain intel_dev

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 48336b2..3e163ec 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -641,6 +641,18 @@ static struct imsm_dev *get_imsm_dev(struct intel_super *super, __u8 index)
 	return NULL;
 }
 
+static struct intel_dev *get_intel_dev(struct intel_super *super, __u8 index)
+{
+	struct intel_dev *dv;
+
+	if (index >= super->anchor->num_raid_devs)
+		return NULL;
+	for (dv = super->devlist; dv; dv = dv->next)
+		if (dv->index == index)
+			return dv;
+	return NULL;
+}
+
 /*
  * for second_map:
  *  == 0 get first map
@@ -5852,6 +5864,7 @@ static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
 	int devices_to_reshape = 1;
 	struct imsm_super *mpb = super->anchor;
 	int ret_val = 0;
+	unsigned int dev_id;
 
 	dprintf("imsm: imsm_process_update() for update_reshape\n");
 
@@ -5881,11 +5894,14 @@ static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
 		" mpb->num_raid_devs = %i\n", mpb->num_raid_devs);
 	/* manage changes in volume
 	 */
-	for (id = super->devlist ; id; id = id->next) {
+	for (dev_id = 0; dev_id < mpb->num_raid_devs; dev_id++) {
 		void **sp = *space_list;
 		struct imsm_dev *newdev;
 		struct imsm_map *newmap, *oldmap;
 
+		id = get_intel_dev(super, dev_id);
+		if (id == NULL)
+			break;
 		if (!sp)
 			continue;
 		*space_list = *sp;

