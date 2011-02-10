From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH] md: Detect raid1->raid0 takeover when comparing raid_disks
Date: Thu, 10 Feb 2011 10:30:43 +0100
Message-ID: <20110210093043.7890.16300.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Takeover raid1->raid0 not succeded. Kernel message is shown:
"md/raid0:md126: too few disks (1 of 2) - aborting!"

After takeover process we have only one active disk
(rest of raid1's disks have been removed before takeover)
mddev->raid_disks stores initial number of disks so comparing
mddev->raid_disks with "cnt" calculated in create_strip_zones()
returns error.

Patch introduces fix for this- skip comparing number of disk if
takeover is detected.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 drivers/md/raid0.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 637a968..9255d52 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -215,7 +215,8 @@ static int create_strip_zones(mddev_t *mddev, raid0_conf_t **private_conf)
 			smallest = rdev1;
 		cnt++;
 	}
-	if (cnt != mddev->raid_disks) {
+	/* compare number of disk if not taking over raid1 */
+	if ((cnt != mddev->raid_disks) && (mddev->level != 1)) {
 		printk(KERN_ERR "md/raid0:%s: too few disks (%d of %d) - "
 		       "aborting!\n", mdname(mddev), cnt, mddev->raid_disks);
 		goto abort;

