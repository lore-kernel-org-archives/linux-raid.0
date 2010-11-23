From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 21/21] Migration: Chunk size migration
Date: Tue, 23 Nov 2010 13:42:28 +0100
Message-ID: <20101123124227.17770.88168.stgit@gklab-170-024.igk.intel.com>
References: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Add implementation for chunk size migration for external metadata.
Update works using array parameters update in managemon. Reshape is started by managemon also.
mdadm waits for reshape array state instead starting reshape process.
For imsm chunk size parameter flow, from mdadm (via metadata update) to managemon was added.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/managemon.c   |    6 ++++++
 mdadm/mdadm/mdmon.h       |    1 +
 mdadm/mdadm/super-intel.c |    4 ++++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/mdadm/mdadm/managemon.c b/mdadm/mdadm/managemon.c
index 8b2d73c..860354a 100644
--- a/mdadm/mdadm/managemon.c
+++ b/mdadm/mdadm/managemon.c
@@ -522,6 +522,12 @@ static void manage_member(struct mdstat_ent *mdstat,
 					}
 				}
 
+				if (status_ok && newa->reshape_chunk_size > 0) {
+					dprintf("managemon: set chunk_size to %i\n", newa->reshape_chunk_size);
+					if (sysfs_set_num(&newa->info, NULL, "chunk_size", newa->reshape_chunk_size) < 0)
+						status_ok = 0;
+				}
+
 				if (status_ok && newa->reshape_layout >= 0) {
 					dprintf("managemon: set layout to %i\n", newa->reshape_layout);
 					if (sysfs_set_num(&newa->info, NULL, "layout", newa->reshape_layout) < 0)
diff --git a/mdadm/mdadm/mdmon.h b/mdadm/mdadm/mdmon.h
index 18bd780..cf8c1f2 100644
--- a/mdadm/mdadm/mdmon.h
+++ b/mdadm/mdadm/mdmon.h
@@ -62,6 +62,7 @@ struct active_array {
 	int reshape_raid_disks;
 	int reshape_level;
 	int reshape_layout;
+	int reshape_chunk_size;
 	unsigned long long grow_sync_max; /* sync_max from mdadm Grow */
 	enum reshape_wait waiting_for; /* we can wait for grow backup event
 					  or for md reshape completed */
diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c
index 0b553bc..2d61df4 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -347,6 +347,7 @@ struct imsm_update_reshape {
 	int reshape_raid_disks;
 	int reshape_level;
 	int reshape_layout;
+	int reshape_chunk_size;
 	int disks_count;
 	int spares_in_update;
 	int devnum;
@@ -5776,6 +5777,7 @@ static void imsm_process_update(struct supertype *st,
 			a->reshape_level = 5;
 			a->reshape_layout = 5;
 		}
+		a->reshape_chunk_size = u->reshape_chunk_size;
 
 		/* Clear migration record */
 		memset(super->migr_rec, 0, sizeof(struct migr_record));
@@ -7231,6 +7233,7 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
 	u->reshape_raid_disks = 0;
 	u->reshape_level = -1;
 	u->reshape_layout = -1;
+	u->reshape_chunk_size = -1;
 	u->update_memory_size = update_memory_size;
 	u->type = update_reshape;
 	u->spares_in_update = 0;
@@ -7623,6 +7626,7 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 					u->reshape_raid_disks = geo.raid_disks;
 				u->reshape_level = geo.level;
 				u->reshape_layout = geo.layout;
+				u->reshape_chunk_size = geo.chunksize;
 				ret_val = 0;
 				append_metadata_update(st, u, u->update_memory_size);
 

