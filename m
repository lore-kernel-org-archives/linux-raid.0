From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/9] imsm: FIX: set correct slot information in metadata
	(raid0)
Date: Tue, 11 Jan 2011 15:03:55 +0100
Message-ID: <20110111140355.13862.2005.stgit@gklab-128-013.igk.intel.com>
References: <20110111135227.13862.88465.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111135227.13862.88465.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Slot was set based on anchor information.
Disks information was copied outside disk list area.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2700401..90bff47 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5648,6 +5648,7 @@ static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
 	struct intel_dev *id;
 	int i;
 	int delta_disks = u->new_raid_disks - u->old_raid_disks;
+	int disk_count = u->old_raid_disks;
 	void **tofree = NULL;
 	int devices_to_reshape = 1;
 	struct imsm_super *mpb = super->anchor;
@@ -5668,7 +5669,7 @@ static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
 		    ((new_disk->index >= 0) &&
 		     (new_disk->index < u->old_raid_disks)))
 			goto update_reshape_exit;
-		new_disk->index = mpb->num_disks++;
+		new_disk->index = disk_count++;
 		/* slot to fill in autolayout
 		 */
 		new_disk->raiddisk = new_disk->index;
@@ -6484,7 +6485,8 @@ static int imsm_create_metadata_update_for_reshape(
 		u->new_disks[i] = makedev(dev->disk.major,
 					  dev->disk.minor);
 		dl = get_disk_super(super, dev->disk.major, dev->disk.minor);
-		dl->index = mpb->num_disks++;
+		dl->index = mpb->num_disks;
+		mpb->num_disks++;
 	}
 
 abort:

