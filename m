From: Alexander Nyberg <alexn@dsv.su.se>
Subject: [PATCH] Errenous sizeof use in raid1
Date: Wed, 23 Feb 2005 13:30:33 +0100
Message-ID: <1109161833.2249.27.camel@boxen>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This isn't a real bug as the smallest slab-size is 32 bytes 
but please apply for consistency.

Found by the Coverity tool.

Signed-off-by: Alexander Nyberg <alexn@dsv.su.se>

===== drivers/md/raid1.c 1.105 vs edited =====
--- 1.105/drivers/md/raid1.c	2005-01-08 06:44:10 +01:00
+++ edited/drivers/md/raid1.c	2005-02-23 13:23:21 +01:00
@@ -1346,7 +1346,7 @@ static int raid1_reshape(mddev_t *mddev,
 		if (conf->mirrors[d].rdev)
 			return -EBUSY;
 
-	newpoolinfo = kmalloc(sizeof(newpoolinfo), GFP_KERNEL);
+	newpoolinfo = kmalloc(sizeof(*newpoolinfo), GFP_KERNEL);
 	if (!newpoolinfo)
 		return -ENOMEM;
 	newpoolinfo->mddev = mddev;


