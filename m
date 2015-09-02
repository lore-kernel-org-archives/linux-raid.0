From: Shaohua Li <shli@fb.com>
Subject: [PATCH 1/8] md: fix feature map check
Date: Wed, 2 Sep 2015 13:49:44 -0700
Message-ID: <f1c70f674fdbc7f6b6bba71f1a19a1f01a78af45.1441221530.git.shli@fb.com>
References: <cover.1441221530.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1441221530.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

the feature map is a __le32, should convert it to cpu endian.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8e49ea3..b3f9eed 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1660,7 +1660,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 			set_bit(Faulty, &rdev->flags);
 			break;
 		case MD_DISK_ROLE_JOURNAL: /* journal device */
-			if (!(sb->feature_map & MD_FEATURE_JOURNAL)) {
+			if (!(le32_to_cpu(sb->feature_map) & MD_FEATURE_JOURNAL)) {
 				/* journal device without journal feature */
 				printk(KERN_WARNING
 				  "md: journal device provided without "
-- 
1.8.1

