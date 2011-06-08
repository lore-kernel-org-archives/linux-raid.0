From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 13/21] imsm: FIX: Detect failed devices during
	recover_backup_imsm()
Date: Wed, 08 Jun 2011 18:11:18 +0200
Message-ID: <20110608161118.24327.31987.stgit@gklab-128-013.igk.intel.com>
References: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Detect in recover_backup_imsm() if not opened disks number is smaller
than allowed degradation for given raid level. This allows for reshape restart
on degraded array.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 26083c3..c19ffac 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7826,6 +7826,8 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 	unsigned long num_migr_units = __le32_to_cpu(migr_rec->num_migr_units);
 	int ascending = __le32_to_cpu(migr_rec->ascending_migr);
 	char buffer[20];
+	int skipped_disks = 0;
+	int max_degradation;
 
 	err = sysfs_get_str(info, NULL, "array_state", (char *)buffer, 20);
 	if (err < 1)
@@ -7849,6 +7851,7 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 
 	map_dest = get_imsm_map(id->dev, 0);
 	new_disks = map_dest->num_members;
+	max_degradation = new_disks - imsm_num_data_members(id->dev, 0);
 
 	read_offset = (unsigned long long)
 			__le32_to_cpu(migr_rec->ckpt_area_pba) * 512;
@@ -7867,6 +7870,10 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 	open_backup_targets(info, new_disks, targets);
 
 	for (i = 0; i < new_disks; i++) {
+		if (targets[i] < 0) {
+			skipped_disks++;
+			continue;
+		}
 		if (lseek64(targets[i], read_offset, SEEK_SET) < 0) {
 			fprintf(stderr,
 				Name ": Cannot seek to block: %s\n",
@@ -7893,6 +7900,13 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 		}
 	}
 
+	if (skipped_disks > max_degradation) {
+		fprintf(stderr,
+			Name ": Cannot restore data from backup."
+			" Too many failed disks\n");
+		goto abort;
+	}
+
 	if (ascending && curr_migr_unit < (num_migr_units-1))
 		curr_migr_unit++;
 

