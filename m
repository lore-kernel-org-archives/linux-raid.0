From: Daniel McNeil <daniel@osdl.org>
Subject: [PATCH 2.5.66] md/linear oops fix
Date: 24 Mar 2003 17:14:11 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1048554851.31398.7.camel@ibm-c.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-rPoZXeS65NOp4GXSO0ZG"
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: NeilBrown <neilb@cse.unsw.edu.au>, linux-raid <linux-raid@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-raid.ids


--=-rPoZXeS65NOp4GXSO0ZG
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This fixes an oops caused by incorrect usage of sector_div()
in which_dev() in md/linear.c.  It was dereferencing an non-existent
hash table entry.


-- 
Daniel McNeil <daniel@osdl.org>

--=-rPoZXeS65NOp4GXSO0ZG
Content-Disposition: attachment; filename=patch-2.5.66-linear
Content-Type: text/x-patch; name=patch-2.5.66-linear; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

diff -urNp -X /home/daniel/dontdiff linux-2.5.66/drivers/md/linear.c linux-2.5.66-md/drivers/md/linear.c
--- linux-2.5.66/drivers/md/linear.c	Mon Mar 24 14:00:20 2003
+++ linux-2.5.66-md/drivers/md/linear.c	Mon Mar 24 16:53:50 2003
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

--=-rPoZXeS65NOp4GXSO0ZG--

