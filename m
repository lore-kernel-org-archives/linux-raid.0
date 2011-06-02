From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 16/22] imsm: Add metadata update type for general migration
	check-pointing
Date: Thu, 02 Jun 2011 16:50:24 +0200
Message-ID: <20110602145024.27355.66753.stgit@gklab-128-111.igk.intel.com>
References: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Adam Kwolek <adam.kwolek@intel.com>

There are 2 places for keeping checkpoint information:
- metadata (per volume information used during volume
  initialization and rebuilding).
- migration record (per container information used during
  migration/reshape)

During reshape both checkpoints has to contains the same information.
To do this mdadm will send metadta update with checkpoint information.

Note: Checkpoint information consistence is not critical. During general
      migration restart, information from migration record is used only.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 super-intel.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 77d6167..2a11879 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -345,7 +345,8 @@ enum imsm_update_type {
 	update_add_remove_disk,
 	update_reshape_container_disks,
 	update_reshape_migration,
-	update_takeover
+	update_takeover,
+	update_general_migration_checkpoint
 };
 
 struct imsm_update_activate_spare {
@@ -398,6 +399,11 @@ struct imsm_update_reshape_migration {
 	int new_disks[1]; /* new_raid_disks - old_raid_disks makedev number */
 };
 
+struct imsm_update_general_migration_checkpoint {
+	enum imsm_update_type type;
+	__u32 curr_migr_unit;
+};
+
 struct disk_info {
 	__u8 serial[MAX_RAID_SERIAL_LEN];
 };

