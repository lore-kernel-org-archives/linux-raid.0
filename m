From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 15/21] FIX: Checkpointing: Enable checkpointing for
	non-growing migrations
Date: Tue, 23 Nov 2010 13:41:39 +0100
Message-ID: <20101123124139.17770.7328.stgit@gklab-170-024.igk.intel.com>
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

For non growing migration case, there are several errors in checkpointing:
1. Write offset was computed incorrectly based on old disk number.
   This causes checkpointing to stop working
   (suspend_lo value was wrong calculated and cannot be saved in sysfs).

2. Checkpointing cannot start due to wrong sync_completed value reported by md
   on reshape start. md reports value 2 instead 0.

3. Layout value for raid0 causes that geo_map() returns error.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/Grow.c     |    2 +-
 mdadm/mdadm/monitor.c  |    8 +++++++-
 mdadm/mdadm/restripe.c |    1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/mdadm/mdadm/Grow.c b/mdadm/mdadm/Grow.c
index f56613f..3747f76 100644
--- a/mdadm/mdadm/Grow.c
+++ b/mdadm/mdadm/Grow.c
@@ -2280,7 +2280,7 @@ int grow_backup_ext(struct supertype *st, struct mdinfo *sra,
 	if (sra->new_level == 6)
 		new_odata--;
 
-	write_offset = offset * 512 * odata;
+	write_offset = offset * 512 * new_odata;
 	bytes_per_unit = sra->new_chunk * new_odata;
 	if (chunk > sra->new_chunk)
 		bytes_per_unit *= (chunk / sra->new_chunk);
diff --git a/mdadm/mdadm/monitor.c b/mdadm/mdadm/monitor.c
index 4cd634d..a37cd93 100644
--- a/mdadm/mdadm/monitor.c
+++ b/mdadm/mdadm/monitor.c
@@ -248,8 +248,14 @@ static int read_and_act(struct active_array *a)
 
 			if (safe_sync_max >= a->info.component_size)
 				sysfs_set_str(&a->info, NULL, "sync_max", "max");
-			else
+			else {
+				/* Workarround:
+				 * sometimes md reports sync_completed == 2 but in fact it is 0
+				 */
+				if ((new_sync_completed == 2) && (safe_sync_max == 0))
+					safe_sync_max = 2;
 				sysfs_set_num(&a->info, NULL, "sync_max", safe_sync_max);
+			}
 		} else {
 			sysfs_set_num(&a->info, NULL, "sync_max", a->grow_sync_max);
 		}
diff --git a/mdadm/mdadm/restripe.c b/mdadm/mdadm/restripe.c
index 7add7ce..3b16ad8 100644
--- a/mdadm/mdadm/restripe.c
+++ b/mdadm/mdadm/restripe.c
@@ -45,6 +45,7 @@ static int geo_map(int block, unsigned long long stripe, int raid_disks,
 
 	switch(level*100 + layout) {
 	case 000:
+	case 000 + ALGORITHM_PARITY_N: /* layout has no matter for raid0 */
 	case 400:
 	case 400 + ALGORITHM_PARITY_N:
 	case 500 + ALGORITHM_PARITY_N:

