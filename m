From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: [PATCH 2.5.68] eliminate deprecated
 MOD_INC_USE_COUNT/MOD_DEC_USE_COUNT in md.c
Date: Mon, 12 May 2003 03:13:40 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EBF49A4.2BAFB3A4@SteelEye.com>
References: <3EA595D9.E4CBB684@SteelEye.com>
			 <16037.55226.267006.507998@notabene.cse.unsw.edu.au>
			 <3EA6BA35.3A5F25CF@SteelEye.com>
			 <16049.64476.440042.635337@notabene.cse.unsw.edu.au>
			 <3EB2EA71.BA0DC039@SteelEye.com> <1052515181.2492.67.camel@ibm-c.pdx.osdl.net> <3EBC7D09.CF92454F@SteelEye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------3FE747699996BBF03FBDD6BE"
Return-path: <linux-raid-owner@vger.kernel.org>
To: Daniel McNeil <daniel@osdl.org>, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------3FE747699996BBF03FBDD6BE
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Daniel McNeil wrote:
> The try_module_get() should be a __module_get() since we better already
> have a module reference -- doing a try_module_get(THIS_MODULE)
> better not add the 1st reference.


OK, after looking a little more closely at module.c, I think I see what
you're saying:

try_module_get(THIS_MODULE) is overkill (either that or we're running
inside of md without a module reference to md, which is dangerous). So
__module_get(THIS_MODULE) is enough. 

Here's the updated patch, against 2.5.69, compiled and tested to verify
that module ref counting is correct (esp. in the case of an inactive
array with bound device(s)).

Daniel, thanks for your input on this...

Neil, I believe this patch finally closes all the holes...

--
Paul
--------------3FE747699996BBF03FBDD6BE
Content-Type: text/plain; charset=us-ascii;
 name="md_mod_ref-2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_mod_ref-2.diff"

--- linux-2.5/drivers/md/md.c.2.5.69	Sun May 11 22:42:41 2003
+++ linux-2.5/drivers/md/md.c	Sun May 11 22:43:25 2003
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
@@ -1016,7 +1014,11 @@ static int bind_rdev_to_array(mdk_rdev_t
 		if (find_rdev_nr(mddev, rdev->desc_nr))
 			return -EBUSY;
 	}
-			
+
+	/* get a module ref if this is the first disk in the array */
+	if (list_empty(&mddev->disks))
+		__module_get(THIS_MODULE);
+
 	list_add(&rdev->same_set, &mddev->disks);
 	rdev->mddev = mddev;
 	printk(KERN_INFO "md: bind<%s>\n", bdev_partition_name(rdev->bdev));
@@ -1031,6 +1033,11 @@ static void unbind_rdev_from_array(mdk_r
 	}
 	list_del_init(&rdev->same_set);
 	printk(KERN_INFO "md: unbind<%s>\n", bdev_partition_name(rdev->bdev));
+
+	/* drop module ref if this array has no more disks */
+	if (list_empty(&rdev->mddev->disks))
+		module_put(THIS_MODULE);
+
 	rdev->mddev = NULL;
 }
 

--------------3FE747699996BBF03FBDD6BE--

