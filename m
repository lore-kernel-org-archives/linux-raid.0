From: Dan Carpenter <error27@gmail.com>
Subject: [patch] md: memory leak on error path in
 dm_exception_store_create()
Date: Sun, 19 Jul 2009 14:46:28 +0300 (EAT)
Message-ID: <alpine.DEB.2.00.0907171414450.12306@bicker>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

tmp_store should  be freed if the persistent flag is invalid.

Compile tested only.  Sorry.  Found by smatch 
(http://repo.or.cz/w/smatch.git).

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/md/dm-exception-store.c	2009-07-17 14:11:10.000000000 +0300
+++ new/drivers/md/dm-exception-store.c	2009-07-17 14:13:24.000000000 +0300
@@ -217,13 +217,14 @@
 		type = get_type("N");
 	else {
 		ti->error = "Persistent flag is not P or N";
-		return -EINVAL;
+		r = -EINVAL;
+		goto out_free;
 	}
 
 	if (!type) {
 		ti->error = "Exception store type not recognised";
 		r = -EINVAL;
-		goto bad_type;
+		goto out_free;
 	}
 
 	tmp_store->type = type;
@@ -254,7 +255,7 @@
 	dm_put_device(ti, tmp_store->cow);
 bad_cow:
 	put_type(type);
-bad_type:
+out_free:
 	kfree(tmp_store);
 	return r;
 }
