From: Wei Fang <fangwei1@huawei.com>
Subject: [PATCH] md: remove an unneeded condition in set_array_info.
Date: Tue, 23 Jun 2015 18:44:46 +0800
Message-ID: <5589389E.9040800@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

if ->major_version is legal, name can't be NULL, so remove it.

Signed-off-by: Wei Fang <fangwei1@huawei.com>
---
 drivers/md/md.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d4f31e1..1c2f967 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6193,12 +6193,10 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
  */
 static int set_array_info(struct mddev *mddev, mdu_array_info_t *info)
 {
-
 	if (info->raid_disks == 0) {
 		/* just setting version number for superblock loading */
 		if (info->major_version < 0 ||
-		    info->major_version >= ARRAY_SIZE(super_types) ||
-		    super_types[info->major_version].name == NULL) {
+		    info->major_version >= ARRAY_SIZE(super_types)) {
 			/* maybe try to auto-load a module? */
 			printk(KERN_INFO
 				"md: superblock version %d not known\n",
-- 
1.8.3.1

