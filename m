From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] MD: fix missing cpu_to_le32 for MD_FEATURE_JOURNAL
Date: Wed, 14 Oct 2015 22:53:24 -0700
Message-ID: <1444888404-994890-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, neilb@suse.com, shli@fb.com
List-Id: linux-raid.ids

sb->feature_map is __le32, add missing cpu_to_le32()

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 378b9f0..163b548 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1812,7 +1812,7 @@ retry:
 		sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_FAULTY);
 
 	if (test_bit(MD_HAS_JOURNAL, &mddev->flags))
-		sb->feature_map |= MD_FEATURE_JOURNAL;
+		sb->feature_map |= cpu_to_le32(MD_FEATURE_JOURNAL);
 
 	rdev_for_each(rdev2, mddev) {
 		i = rdev2->desc_nr;
-- 
2.4.6

