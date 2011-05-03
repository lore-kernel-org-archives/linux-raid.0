From: Michael Reed <mdr@sgi.com>
Subject: md question re: max_hw_sectors_kb
Date: Tue, 03 May 2011 15:20:46 -0500
Message-ID: <4DC0639E.1070707@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, Jeremy Higdon <jeremy@sgi.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-raid.ids

Resending to linux-raid.


Hi Neil,

My name is Mike Reed.  I work at SGI.  I've been looking at a performance
issue with md writes and have tracked it down to the md device not having
a high enough initial max_hw_sectors_kb setting.

There is code in blk_queue_make_request() which lowers the default value
from INT_MAX to BLK_SAFE_MAX_SECTORS, which is 255.  This is generally
lower than all the underlying devices with which I use md.

As md appears to be a stacking driver, i.e., it calls disk_stack_limits()
for each member of a volume, it would seem reasonable for md to use the,
INT_MAX setting for max_hw_sectors_kb instead of BLK_SAFE_MAX_SECTORS.

I have tried this, and have observed that md correctly limits the md device's
max_sectors_kb to the value of the underlying devices in my mirror volume.

Is this the correct way to address this issue?

Applies to linux-2.6.39-rc4.

Signed-off-by: Michael Reed <mdr@sgi.com>


--- drivers/md/md.c	2011-04-18 21:26:00.000000000 -0700
+++ drivers/md/md.c.new	2011-04-21 15:53:11.452536201 -0700
@@ -4328,6 +4328,7 @@ static int md_alloc(dev_t dev, char *nam
 	mddev->queue->queuedata = mddev;
 
 	blk_queue_make_request(mddev->queue, md_make_request);
+	blk_queue_max_sectors(mddev->queue, INT_MAX);
 
 	disk = alloc_disk(1 << shift);
 	if (!disk) {


