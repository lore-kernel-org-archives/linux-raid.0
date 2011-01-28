From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] imsm: Update metadata for second array
Date: Fri, 28 Jan 2011 09:21:41 +0100
Message-ID: <20110128082141.7609.85545.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When second array reshape is about to start external metadata should be updated
by mdmon in imsm_set_array_state().
for this purposes imsm_progress_container_reshape() is reused.

In imsm_progress_container_reshape() we have to make sure that prev_disks
shows expanded disks number. Current decision about prev_disks in 'for'
loop doesn't make us sure about this. We are getting first positive value,
but not necessarily right one.

prev_disks have to be found before we enter 'for' loop.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index d5501bd..4ae4764 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5062,6 +5062,15 @@ static void imsm_progress_container_reshape(struct intel_super *super)
 	int prev_disks = -1;
 	int i;
 
+	/* find maximum number of disks used in any array
+	 */
+	for (i = 0; i < mpb->num_raid_devs; i++) {
+		struct imsm_dev *dev = get_imsm_dev(super, i);
+		struct imsm_map *map = get_imsm_map(dev, 0);
+		if (map->num_members > prev_disks)
+			prev_disks = map->num_members;
+	}
+
 	for (i = 0; i < mpb->num_raid_devs; i++) {
 		struct imsm_dev *dev = get_imsm_dev(super, i);
 		struct imsm_map *map = get_imsm_map(dev, 0);
@@ -5253,13 +5262,17 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 		super->updates_pending++;
 	}
 
-	/* finalize online capacity expansion/reshape */
+	/* manage online capacity expansion/reshape */
 	if ((a->curr_action != reshape) &&
 	    (a->prev_action == reshape)) {
 		struct mdinfo *mdi;
 
+		/* finalize online capacity expansion/reshape */
 		for (mdi = a->info.devs; mdi; mdi = mdi->next)
 			imsm_set_disk(a, mdi->disk.raid_disk, mdi->curr_state);
+
+		/* check next volume reshape */
+		imsm_progress_container_reshape(super);
 	}
 
 	return consistent;

