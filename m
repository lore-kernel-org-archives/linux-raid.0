From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH  0/1] unblock the creation of an external metadata RAID
 if native one exists
Date: Mon, 31 Jan 2011 11:30:56 +1100
Message-ID: <20110131113056.20264ce4@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D176F91B9A@irsmsx503.ger.corp.intel.com>
	<20110128124841.5da25834@nbeee.brown>
	<905EDD02F158D948B186911EB64DB3D17701BDA4@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D17701BDA4@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Fri, 28 Jan 2011 16:11:22 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> 
> 
> > -----Original Message-----
> > From: Neil Brown [mailto:neilb@suse.de]
> > Sent: Friday, January 28, 2011 3:49 AM
> > To: Labun, Marcin
> > Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech; Williams, Dan J;
> > Ciechanowski, Ed
> > Subject: Re: [PATCH 0/1] unblock the creation of an external metadata
> > RAID if native one exists
> > 
> > On Tue, 25 Jan 2011 15:23:30 +0000
> > "Labun, Marcin" <Marcin.Labun@intel.com> wrote:
> > 
> > > >From aa169142c6dde0a7c1dc1b91dec0973474661036 Mon Sep 17 00:00:00
> > > >2001
> > > From: Marcin Labun <marcin.labun@intel.com>
> > > Date: Tue, 25 Jan 2011 16:10:45 +0100
> > > Subject: [PATCH 0/1] unblock the creation of an external metadata
> > > RAID if native one exists
> > >
> > >
> > >
> 
> <cut>
> 
> > > Native metadata reserves a parent disk device for exclusive use by
> > > setting AllReserved in rdev->flags. Now if a member device has
> > > AllReserved flag set on its block device then creation of any
> > > external metadata array/container on is unreasonably blocked.
> > 
> > This is not unreasonable at all.  Native metadata claims the whole
> > device.
> > If you want to move a spare from a native array to an imsm array, then
> > you should remove the spare from the first array, and then add it to
> > the container for the second.
> > This will cause it to get a brand new 'rdev' which will not have
> > AllReserved set.
> 
> The problem occurs when someone tries to create an external container
> while there is active native raid!
> For instance:
> # Mdadm -CR /dev/md/raid1 -n 2 -l 1 /dev/sdc /dev/sdb
> # mdadm -CR /dev/md/cont1 -e imsm -n 2 dev/sdd /dev/sde
> <--- fails
> 
> The container and native array do NOT share devices.
> Current code does not check if the devices are shared/overlapped when there is a device with AllReserved.
> Just blocks ANY external raid array.
> 
> 
> 			list_for_each_entry(rdev2, &mddev->disks, same_set)
> -				if (test_bit(AllReserved, &rdev2->flags) ||              <----- blocks any device
> +				if ((test_bit(AllReserved, &rdev2->flags) &&
> +				     rdev->bdev->bd_contains == rdev2->bdev->bd_contains) ||   <----- blocks if the parent devices are the same
>  				    (rdev->bdev == rdev2->bdev &&
>  				     rdev != rdev2 &&
>  				     overlaps(rdev->data_offset, rdev->sectors,
>  					      rdev2->data_offset,
>  					      rdev2->sectors))) {
> +					char b[BDEVNAME_SIZE];
> +
> +					dprintk(KERN_INFO "rdev: %p %s\n", rdev, bdevname(rdev->bdev,b));
> +					dprintk(KERN_INFO "rdev tested: %p %s\n", rdev2, bdevname(rdev2->bdev,b));
> +					dprintk(KERN_INFO "my_mddev: %p tested: %p if: %d, %d, %d, %d, %d \n",
> +						my_mddev,
> +						mddev,
> +						test_bit(AllReserved, &rdev2->flags),
> +						rdev->bdev->bd_contains == rdev2->bdev->bd_contains,
> +						rdev->bdev == rdev2->bdev,
> +						rdev != rdev2,
> +						overlaps(rdev->data_offset, rdev->sectors,
> +							 rdev2->data_offset,  rdev2->sectors));
>  					overlap = 1;
>  					break;
>  				}
> 
> 
> 
> The reason is explained in patch proposal:
> 
> Native metadata reserves a parent disk device for exclusive use by setting AllReserved in rdev->flags. 
> Now if a member device has AllReserved flag set on its block device then creation of any external metadata array/container on is unreasonably blocked.
> 														----
Thanks for the explanation.  I now see what is wrong.
The test on AllReserved is wrong.  In fact, AllReserved isn't needed at all.
If a device is claimed for native metadata, then it is impossible for two
different rdevs to both point to it.  So the tests:
   rdev->bdev == rdev2->bdev &&
   rdev != rdev2
are enough to ensure that neither are for native metadata.

So the following patch, which removes AllReserved, should fix this.

Thanks,
NeilBrown


diff --git a/drivers/md/md.c b/drivers/md/md.c
index cd4cccd..33b96a1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1953,8 +1953,6 @@ static int lock_rdev(mdk_rdev_t *rdev, dev_t dev, int shared)
 		blkdev_put(bdev, FMODE_READ|FMODE_WRITE);
 		return err;
 	}
-	if (!shared)
-		set_bit(AllReserved, &rdev->flags);
 	rdev->bdev = bdev;
 	return err;
 }
@@ -2617,12 +2615,11 @@ rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 
 			mddev_lock(mddev);
 			list_for_each_entry(rdev2, &mddev->disks, same_set)
-				if (test_bit(AllReserved, &rdev2->flags) ||
-				    (rdev->bdev == rdev2->bdev &&
-				     rdev != rdev2 &&
-				     overlaps(rdev->data_offset, rdev->sectors,
-					      rdev2->data_offset,
-					      rdev2->sectors))) {
+				if (rdev->bdev == rdev2->bdev &&
+				    rdev != rdev2 &&
+				    overlaps(rdev->data_offset, rdev->sectors,
+					     rdev2->data_offset,
+					     rdev2->sectors)) {
 					overlap = 1;
 					break;
 				}
diff --git a/drivers/md/md.h b/drivers/md/md.h
index eec517c..7e90b85 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -93,8 +93,6 @@ struct mdk_rdev_s
 #define	Faulty		1		/* device is known to have a fault */
 #define	In_sync		2		/* device is in_sync with rest of array */
 #define	WriteMostly	4		/* Avoid reading if at all possible */
-#define	AllReserved	6		/* If whole device is reserved for
-					 * one array */
 #define	AutoDetected	7		/* added by auto-detect */
 #define Blocked		8		/* An error occured on an externally
 					 * managed array, don't allow writes
