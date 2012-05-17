From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] md/raid10: unlock on error path in raid10_start_reshape()
Date: Thu, 17 May 2012 09:49:11 +0300
Message-ID: <20120517064911.GB14660@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

We need to unlock and enable IRQs before returning here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e8ed1d8..ba7290f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3918,6 +3918,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 	if (mddev->reshape_backwards) {
 		sector_t size = raid10_size(mddev, 0, 0);
 		if (size < mddev->array_sectors) {
+			spin_unlock_irq(&conf->device_lock);
 			printk(KERN_ERR "md/raid10:%s: array size must be reduce before number of disks\n",
 			       mdname(mddev));
 			return -EINVAL;
