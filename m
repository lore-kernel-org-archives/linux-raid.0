From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 18/31] imsm: FIX: spare list contains one device several
 times
Date: Tue, 9 Nov 2010 17:01:17 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CAA1@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Assumption for spares searching was that after picking new device, it has to be added to array before next search.
This causes returning different disk on each call.

When spares list is created during Online Capacity Expansion, first devices list is collected and then all devices are added to md.
Picked device from spares pool has to be checked against picked devices so far. If not, the same disk will be returned all the time.
Already picked devices are stored in the list and this list is used for new devices verification also.


Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/super-intel.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c index e35c6dc..3ff2bb0 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -5008,7 +5008,8 @@ static struct dl *imsm_readd(struct intel_super *super, int idx, struct active_a  }
 
 static struct dl *imsm_add_spare(struct intel_super *super, int slot,
-				 struct active_array *a, int activate_new)
+				 struct active_array *a, int activate_new,
+				 struct mdinfo *additional_test_list)
 {
 	struct imsm_dev *dev = get_imsm_dev(super, a->info.container_member);
 	int idx = get_imsm_disk_idx(dev, slot); @@ -5034,6 +5035,16 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
 			}
 		if (d)
 			continue;
+		while (additional_test_list) {
+			if (additional_test_list->disk.major == dl->major &&
+			    additional_test_list->disk.minor == dl->minor) {
+				dprintf("%x:%x already in additional test list\n", dl->major, dl->minor);
+				break;
+			}
+			additional_test_list = additional_test_list->next;
+		}
+		if (additional_test_list)
+			continue;
 
 		/* skip in use or failed drives */
 		if (is_failed(&dl->disk) || idx == dl->index || @@ -5167,9 +5178,9 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 		 */
 		dl = imsm_readd(super, i, a);
 		if (!dl)
-			dl = imsm_add_spare(super, i, a, 0);
+			dl = imsm_add_spare(super, i, a, 0, NULL);
 		if (!dl)
-			dl = imsm_add_spare(super, i, a, 1);
+			dl = imsm_add_spare(super, i, a, 1, NULL);
 		if (!dl)
 			continue;
  
@@ -6943,10 +6954,9 @@ struct mdinfo *imsm_grow_array(struct active_array *a)
 	for (i = prev_raid_disks; i < new_raid_disks; i++) {
 		/* OK, this device can be added.  Try to add.
 		 */
-		dl = imsm_add_spare(super, i, a, 0);
+		dl = imsm_add_spare(super, i, a, 0, rv);
 		if (!dl)
 			continue;
-
 		if (dl->index < 0)
 			dl->index = i;
 		/* found a usable disk with enough space */

