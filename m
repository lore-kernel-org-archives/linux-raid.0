From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 9] md: Fix sizing problem with raid5-reshape and CONFIG_LBD=n
Date: Wed, 8 Nov 2006 09:09:31 +1100
Message-ID: <1061107220931.12489@suse.de>
References: <20061108085917.12064.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


I forgot to has the size-in-blocks to (loff_t) before shifting up to a size-in-bytes.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2006-11-06 11:21:24.000000000 +1100
+++ ./drivers/md/raid5.c	2006-11-06 11:28:51.000000000 +1100
@@ -3659,7 +3659,7 @@ static void end_reshape(raid5_conf_t *co
 		bdev = bdget_disk(conf->mddev->gendisk, 0);
 		if (bdev) {
 			mutex_lock(&bdev->bd_inode->i_mutex);
-			i_size_write(bdev->bd_inode, conf->mddev->array_size << 10);
+			i_size_write(bdev->bd_inode, (loff_t)conf->mddev->array_size << 10);
 			mutex_unlock(&bdev->bd_inode->i_mutex);
 			bdput(bdev);
 		}
