From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: [PATCH 2.5.68] eliminate deprecated
 MOD_INC_USE_COUNT/MOD_DEC_USE_COUNT in md.c
Date: Fri, 02 May 2003 18:00:17 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EB2EA71.BA0DC039@SteelEye.com>
References: <3EA595D9.E4CBB684@SteelEye.com>
		<16037.55226.267006.507998@notabene.cse.unsw.edu.au>
		<3EA6BA35.3A5F25CF@SteelEye.com> <16049.64476.440042.635337@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------C0CE75A60115081B88BB7E6F"
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------C0CE75A60115081B88BB7E6F
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Neil Brown wrote:
> 
> On Wednesday April 23, Paul.Clements@SteelEye.com wrote:
> > Neil Brown wrote:

> It is possible for an array to be half-assembled.  To have some drives
> attached, but not to have been started.
> This can happen (for example) if you use mdadm to assemble a raid5
> array without given all of the drives, and without giving --run.
> 
> In this case you don't want 'md' to be unloaded, but you haven't
> loaded a personality module yet.  So you need to take a reference to
> the md module whenever you start putting an md array together.

Ah...I had missed that...appears that was an existing problem, even with
the MOD_INC_USE_COUNT in place. 

So we need to do the ref counting at bind/unbind time, rather than
activation/deactivation time.

So here's the patch...compiled and tested briefly against
2.5.68-bklatest, the ref counting looks correct

--
Paul
--------------C0CE75A60115081B88BB7E6F
Content-Type: text/plain; charset=us-ascii;
 name="md_mod_ref.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_mod_ref.diff"

--- linux-2.5/drivers/md/md.c.2.5.68-bklatest	2003-05-02 11:56:18.000000000 -0400
+++ linux-2.5/drivers/md/md.c	2003-05-02 13:11:57.000000000 -0400
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
@@ -1016,7 +1014,12 @@ static int bind_rdev_to_array(mdk_rdev_t
 		if (find_rdev_nr(mddev, rdev->desc_nr))
 			return -EBUSY;
 	}
-			
+
+	/* get a module ref if this is the first disk in the array */
+	if (list_empty(&mddev->disks))
+		if (!try_module_get(THIS_MODULE))
+			return -EBUSY;
+
 	list_add(&rdev->same_set, &mddev->disks);
 	rdev->mddev = mddev;
 	printk(KERN_INFO "md: bind<%s>\n", bdev_partition_name(rdev->bdev));
@@ -1031,6 +1034,11 @@ static void unbind_rdev_from_array(mdk_r
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
 

--------------C0CE75A60115081B88BB7E6F--

