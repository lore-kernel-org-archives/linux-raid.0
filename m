From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 5] md: Make sure array geometry changes persist with version-1 superblocks.
Date: Tue, 24 Jan 2006 14:58:27 +1100
Message-ID: <1060124035827.28824@suse.de>
References: <20060124145516.28734.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


super_1_sync only updates fields in the superblock that might
have changed.
'raid_disks' and 'size' could have changed, but this information
doesn't get updated.... until this patch.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    3 +++
 1 file changed, 3 insertions(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-01-24 13:32:25.000000000 +1100
+++ ./drivers/md/md.c	2006-01-24 13:42:29.000000000 +1100
@@ -1162,6 +1162,9 @@ static void super_1_sync(mddev_t *mddev,
 
 	sb->cnt_corrected_read = atomic_read(&rdev->corrected_errors);
 
+	sb->raid_disks = cpu_to_le32(mddev->raid_disks);
+	sb->size = cpu_to_le64(mddev->size);
+
 	if (mddev->bitmap && mddev->bitmap_file == NULL) {
 		sb->bitmap_offset = cpu_to_le32((__u32)mddev->bitmap_offset);
 		sb->feature_map = cpu_to_le32(MD_FEATURE_BITMAP_OFFSET);
