From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 3/5] imsm: don't allow disks with different sector size in one array
Date: Tue,  9 May 2017 12:25:45 +0200
Message-ID: <1494325547-3028-4-git-send-email-tomasz.majchrzak@intel.com>
References: <1494325547-3028-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1494325547-3028-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, Alexey Obitotskiy <aleksey.obitotskiy@intel.com>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

From: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>

As there is no support in IMSM for arrays including disks with different
sector sizes, don't allow to create such configuration. Also skip the
disk with unsuitable sector size when looking for spares in the same
container.

Signed-off-by: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 super-intel.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index cfb10d5..e88fe82 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5468,6 +5468,22 @@ static int init_super_imsm(struct supertype *st, mdu_array_info_t *info,
 	return 1;
 }
 
+static int drive_validate_sector_size(struct intel_super *super, struct dl *dl)
+{
+	unsigned int member_sector_size;
+
+	if (dl->fd < 0) {
+		pr_err("Invalid file descriptor for %s\n", dl->devname);
+		return 0;
+	}
+
+	if (!get_dev_sector_size(dl->fd, dl->devname, &member_sector_size))
+		return 0;
+	if (member_sector_size != super->sector_size)
+		return 0;
+	return 1;
+}
+
 static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 				     int fd, char *devname)
 {
@@ -5507,6 +5523,11 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 		return 1;
 	}
 
+	if (!drive_validate_sector_size(super, dl)) {
+		pr_err("Combining drives of different sector size in one volume is not allowed\n");
+		return 1;
+	}
+
 	/* add a pristine spare to the metadata */
 	if (dl->index < 0) {
 		dl->index = super->anchor->num_disks;
@@ -8440,6 +8461,9 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
 		if (dl->index == -1 && !activate_new)
 			continue;
 
+		if (!drive_validate_sector_size(super, dl))
+			continue;
+
 		/* Does this unused device have the requisite free space?
 		 * It needs to be able to cover all member volumes
 		 */
-- 
1.8.3.1

