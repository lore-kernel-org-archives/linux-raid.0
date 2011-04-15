From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/4] FIX: Count correctly added devices
Date: Fri, 15 Apr 2011 14:30:56 +0200
Message-ID: <20110415123055.6601.98856.stgit@gklab-128-013.igk.intel.com>
References: <20110415122820.6601.48084.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110415122820.6601.48084.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When array is in reshape state raid_disks field contains final disks number.
To know how many disks were added, disk.raid_disk index has to be compared
against old disk number computed using delta_disks.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 268e248..8b05829 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1516,6 +1516,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
 	int working = 0, preexist = 0;
 	int expansion = 0;
 	struct map_ent *map = NULL;
+	int old_raid_disks;
 
 	sysfs_init(content, mdfd, 0);
 
@@ -1529,10 +1530,10 @@ int assemble_container_content(struct supertype *st, int mdfd,
 
 	if (sra)
 		sysfs_free(sra);
-
+	old_raid_disks = content->array.raid_disks - content->delta_disks;
 	for (dev = content->devs; dev; dev = dev->next)
 		if (sysfs_add_disk(content, dev, 1) == 0) {
-			if (dev->disk.raid_disk >= content->array.raid_disks &&
+			if (dev->disk.raid_disk >= old_raid_disks &&
 			    content->reshape_active)
 				expansion++;
 			else

