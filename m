From: Daniel McNeil <daniel@osdl.org>
Subject: [PATCH 2.5.65] md/linear oops fix
Date: 18 Mar 2003 10:45:56 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1048013156.2542.11.camel@ibm-c.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-iKuDKTgAesgz48O3oSK8"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: NeilBrown <neilb@cse.unsw.edu.au>, Ingo Molnar <mingo@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids


--=-iKuDKTgAesgz48O3oSK8
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This fixes an oops caused by incorrect usage of sector_div()
in which_dev() in md/linear.c.  It was dereferencing an non-existent
hash table entry.

-- 
Daniel McNeil <daniel@osdl.org>

--=-iKuDKTgAesgz48O3oSK8
Content-Disposition: attachment; filename=patch-2.5.65-linear
Content-Type: text/x-patch; name=patch-2.5.65-linear; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

diff -urNp -X /home/daniel/dontdiff linux-2.5.65/drivers/md/linear.c linux-2.5.65-md/drivers/md/linear.c
--- linux-2.5.65/drivers/md/linear.c	Mon Mar 17 13:44:04 2003
+++ linux-2.5.65-md/drivers/md/linear.c	Tue Mar 18 09:34:09 2003
@@ -37,7 +37,11 @@ static inline dev_info_t *which_dev(mdde
 	linear_conf_t *conf = mddev_to_conf(mddev);
 	sector_t block = sector >> 1;
 
-	hash = conf->hash_table + sector_div(block, conf->smallest->size);
+	/*
+	 * sector_div(a,b) returns the remainer and sets a to a/b
+	 */
+	(void)sector_div(block, conf->smallest->size);
+	hash = conf->hash_table + block;
 
 	if ((sector>>1) >= (hash->dev0->size + hash->dev0->offset))
 		return hash->dev1;

--=-iKuDKTgAesgz48O3oSK8--
