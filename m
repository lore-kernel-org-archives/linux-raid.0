From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] imsm: fix: correct debug printing of the volume's name
Date: Wed, 19 Oct 2011 15:16:33 +0200
Message-ID: <20111019131633.9001.95710.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

The volume's name is saved in the array of chars.
All elements of the array can have nonzero values
and the next byte in memory does not have to have
the value of 0, so one must be cautious when
printing out the volume's name.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 super-intel.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2c1bf05..dfa85aa 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6642,9 +6642,9 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 	 * are removed from container.
 	 */
 	if (failed) {
-		dprintf("found failed disks in %s, check if there another"
+		dprintf("found failed disks in %.*s, check if there another"
 			"failed sub-array.\n",
-			dev->volume);
+			MAX_RAID_SERIAL_LEN, dev->volume);
 		/* check if states of the other volumes allow for rebuild */
 		for (i = 0; i <  super->anchor->num_raid_devs; i++) {
 			if (i != inst) {

