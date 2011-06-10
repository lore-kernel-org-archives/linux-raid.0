From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] imsm: FIX: Raid5 data corruption data recovering from backup
Date: Fri, 10 Jun 2011 15:00:14 +0200
Message-ID: <20110610130014.23864.66923.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Sporadicaly when Raid5's data are restored from backup area,
corruption occurs.
It doesn't happen if reshape process is beyond critical section.

Root cause of the problem is passing wrong starting point in
restore_stripes(). It was hard coded to 0 so far.
This causes that parity disks position in first stripe was always set
to the last raid disk. This position should depend on data position in array.

Proper start position was set and pointer for restoring data
(copy area address) is adjusted to passed start parameter.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---

 super-intel.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 5e8b834..075385a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7718,6 +7718,8 @@ int save_backup_imsm(struct supertype *st,
 	int new_disks = map_dest->num_members;
 	int dest_layout = 0;
 	int dest_chunk;
+	unsigned long long start;
+	int data_disks = imsm_num_data_members(dev, 0);
 
 	targets = malloc(new_disks * sizeof(int));
 	if (!targets)
@@ -7727,10 +7729,15 @@ int save_backup_imsm(struct supertype *st,
 	if (!target_offsets)
 		goto abort;
 
+	start = info->reshape_progress * 512;
 	for (i = 0; i < new_disks; i++) {
 		targets[i] = -1;
 		target_offsets[i] = (unsigned long long)
 		  __le32_to_cpu(super->migr_rec->ckpt_area_pba) * 512;
+		/* move back copy area adderss, it will be moved forward
+		 * in restore_stripes() using start input variable
+		 */
+		target_offsets[i] -= start/data_disks;
 	}
 
 	if (open_backup_targets(info, new_disks, targets))
@@ -7748,7 +7755,7 @@ int save_backup_imsm(struct supertype *st,
 			    -1,    /* source backup file descriptor */
 			    0,     /* input buf offset
 				    * always 0 buf is already offseted */
-			    0,
+			    start,
 			    length,
 			    buf) != 0) {
 		fprintf(stderr, Name ": Error restoring stripes\n");

