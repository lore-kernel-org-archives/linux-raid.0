From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: [PATCH 2.5.68] eliminate deprecated MOD_INC_USE_COUNT/MOD_DEC_USE_COUNT
 in md.c
Date: Tue, 22 Apr 2003 15:19:54 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EA595D9.E4CBB684@SteelEye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------2F95E52047DE6175EBA7F7AA"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------2F95E52047DE6175EBA7F7AA
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Following is a simple patch to remove deprecated MOD_INC_USE_COUNT from
md.c.

If it looks good, please apply.

Thanks,
Paul
--------------2F95E52047DE6175EBA7F7AA
Content-Type: text/plain; charset=us-ascii;
 name="md_mod_unsafe.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_mod_unsafe.diff"

--- md.c.PRISTINE	2003-04-22 12:59:37.000000000 -0400
+++ md.c	2003-04-22 12:59:50.000000000 -0400
@@ -181,7 +181,6 @@ static void mddev_put(mddev_t *mddev)
 		list_del(&mddev->all_mddevs);
 		mddev_map[mdidx(mddev)] = NULL;
 		kfree(mddev);
-		MOD_DEC_USE_COUNT;
 	}
 	spin_unlock(&all_mddevs_lock);
 }
@@ -203,7 +202,6 @@ static mddev_t * mddev_find(int unit)
 		mddev_map[unit] = new;
 		list_add(&new->all_mddevs, &all_mddevs);
 		spin_unlock(&all_mddevs_lock);
-		MOD_INC_USE_COUNT;
 		return new;
 	}
 	spin_unlock(&all_mddevs_lock);

--------------2F95E52047DE6175EBA7F7AA--

