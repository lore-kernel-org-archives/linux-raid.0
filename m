From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 23/29] Migration: Chunk size migration
Date: Thu, 09 Dec 2010 16:21:51 +0100
Message-ID: <20101209152151.26876.82353.stgit@gklab-170-024.igk.intel.com>
References: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Add implementation for chunk size migration for external metadata.
Update works using array parameters update in managemon. Reshape is started by managemon also.
mdadm waits for reshape array state instead starting reshape process.
For imsm chunk size parameter flow, from mdadm (via metadata update) to managemon was added.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 managemon.c   |   10 ++++++++++
 mdmon.h       |    1 +
 super-intel.c |    4 ++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/managemon.c b/managemon.c
index 172a355..7ff49ab 100644
--- a/managemon.c
+++ b/managemon.c
@@ -539,6 +539,16 @@ static void manage_member(struct mdstat_ent *mdstat,
 							status_ok = 0;
 					}
 				}
+				if (status_ok && newa->reshape_chunk_size > 0) {
+					dprintf("managemon: set chunk_size "\
+						"to %i\n",
+						newa->reshape_chunk_size);
+					if (sysfs_set_num(&newa->info,
+						NULL,
+						"chunk_size",
+						newa->reshape_chunk_size) < 0)
+						status_ok = 0;
+				}
 				if (status_ok && newa->reshape_layout >= 0) {
 					dprintf("managemon: set layout to %i\n",
 						newa->reshape_layout);
diff --git a/mdmon.h b/mdmon.h
index a35752c..c463003 100644
--- a/mdmon.h
+++ b/mdmon.h
@@ -53,6 +53,7 @@ struct active_array {
 	int reshape_raid_disks;
 	int reshape_level;
 	int reshape_layout;
+	int reshape_chunk_size;
 
 	int check_degraded; /* flag set by mon, read by manage */
 
diff --git a/super-intel.c b/super-intel.c
index 564869e..9f0bb2c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -317,6 +317,7 @@ struct imsm_update_reshape {
 	int reshape_raid_disks;
 	int reshape_level;
 	int reshape_layout;
+	int reshape_chunk_size;
 	int disks_count;
 	int spares_in_update;
 	int devnum;
@@ -5457,6 +5458,7 @@ static void imsm_process_update(struct supertype *st,
 			a->reshape_level = 5;
 			a->reshape_layout = 5;
 		}
+		a->reshape_chunk_size = u->reshape_chunk_size;
 
 		super->updates_pending++;
 update_reshape_exit:
@@ -6645,6 +6647,7 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(
 	u->reshape_raid_disks = 0;
 	u->reshape_level = -1;
 	u->reshape_layout = -1;
+	u->reshape_chunk_size = -1;
 	u->update_memory_size = update_memory_size;
 	u->type = update_reshape;
 	u->spares_in_update = 0;
@@ -7002,6 +7005,7 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 				u->reshape_raid_disks = geo.raid_disks;
 			u->reshape_level = geo.level;
 			u->reshape_layout = geo.layout;
+			u->reshape_chunk_size = geo.chunksize;
 			ret_val = 0;
 			append_metadata_update(st, u, u->update_memory_size);
 		}

