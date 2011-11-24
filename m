From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 10/11] imsm: FIX: Check maximum allowed degradation level in
	recover_backup_imsm()
Date: Thu, 24 Nov 2011 13:18:29 +0100
Message-ID: <20111124121829.5254.70501.stgit@gklab-128-013.igk.intel.com>
References: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Any degradation during backup recovery causes error and array assembly
failure.

Allow for degradation during backup recovery.
This allows for degraded array assembly.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e2b3c05..208af80 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8391,7 +8391,6 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 	unsigned long num_migr_units = __le32_to_cpu(migr_rec->num_migr_units);
 	char buffer[20];
 	int skipped_disks = 0;
-	int max_degradation;
 
 	err = sysfs_get_str(info, NULL, "array_state", (char *)buffer, 20);
 	if (err < 1)
@@ -8415,7 +8414,6 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 
 	map_dest = get_imsm_map(id->dev, 0);
 	new_disks = map_dest->num_members;
-	max_degradation = new_disks - imsm_num_data_members(id->dev, 0);
 
 	read_offset = (unsigned long long)
 			__le32_to_cpu(migr_rec->ckpt_area_pba) * 512;
@@ -8446,29 +8444,36 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 			fprintf(stderr,
 				Name ": Cannot seek to block: %s\n",
 				strerror(errno));
-			goto abort;
+			skipped_disks++;
+			continue;
 		}
 		if ((unsigned)read(targets[i], buf, unit_len) != unit_len) {
 			fprintf(stderr,
 				Name ": Cannot read copy area block: %s\n",
 				strerror(errno));
-			goto abort;
+			skipped_disks++;
+			continue;
 		}
 		if (lseek64(targets[i], write_offset, SEEK_SET) < 0) {
 			fprintf(stderr,
 				Name ": Cannot seek to block: %s\n",
 				strerror(errno));
-			goto abort;
+			skipped_disks++;
+			continue;
 		}
 		if ((unsigned)write(targets[i], buf, unit_len) != unit_len) {
 			fprintf(stderr,
 				Name ": Cannot restore block: %s\n",
 				strerror(errno));
-			goto abort;
+			skipped_disks++;
+			continue;
 		}
 	}
 
-	if (skipped_disks > max_degradation) {
+	if (skipped_disks > imsm_get_allowed_degradation(info->new_level,
+							 new_disks,
+							 super,
+							 id->dev)) {
 		fprintf(stderr,
 			Name ": Cannot restore data from backup."
 			" Too many failed disks\n");

