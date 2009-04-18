From: Dan Carpenter <error27@gmail.com>
Subject: [patch] md.c release locks on error
Date: Sat, 18 Apr 2009 16:47:17 +0300 (EAT)
Message-ID: <alpine.DEB.2.00.0904181641450.5780@bicker>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think we need to release disks_mutex and put mddev here.  The other 
return paths are like that.

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/md/md.c	2009-04-15 18:32:05.000000000 +0300
+++ devel/drivers/md/md.c	2009-04-15 18:32:48.000000000 +0300
@@ -3860,6 +3860,8 @@
 			if (mddev2->gendisk &&
 			    strcmp(mddev2->gendisk->disk_name, name) == 0) {
 				spin_unlock(&all_mddevs_lock);
+		                mutex_unlock(&disks_mutex);
+                		mddev_put(mddev);
 				return -EEXIST;
 			}
 		spin_unlock(&all_mddevs_lock);
