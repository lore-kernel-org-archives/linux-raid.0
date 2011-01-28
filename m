From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH  0/1] unblock the creation of an external metadata RAID
 if native one exists
Date: Fri, 28 Jan 2011 12:48:41 +1000
Message-ID: <20110128124841.5da25834@nbeee.brown>
References: <905EDD02F158D948B186911EB64DB3D176F91B9A@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D176F91B9A@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Tue, 25 Jan 2011 15:23:30 +0000
"Labun, Marcin" <Marcin.Labun@intel.com> wrote:

> >From aa169142c6dde0a7c1dc1b91dec0973474661036 Mon Sep 17 00:00:00
> >2001
> From: Marcin Labun <marcin.labun@intel.com>
> Date: Tue, 25 Jan 2011 16:10:45 +0100
> Subject: [PATCH 0/1] unblock the creation of an external metadata
> RAID if native one exists
> 
> 
> > -----Original Message-----
> > From: Czarnowska, Anna
> > Sent: Friday, January 21, 2011 6:24 PM
> > To: NeilBrown
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > Hawrylewicz Czarnowski, Przemyslaw; Labun, Marcin; Neubauer,
> > Wojciech Subject: Bug - native array blocks external container
> > 
> > Hi Neil,
> > Our validation reported it was not possible to move a spare from
> > native array to imsm container.
> > After closer investigation it appears that this issue shows in
> > kernels from 2.6.36 upwards.
> > It turns out even more serious:
> > If a native array exists in the system it is not possible to create,
> > assemble or add to an imsm container.
> > (confirmed on raid1 arrays, 2 disks for native, 2 disks for imsm + 1
> > spare)
> > In such case for some reason AllReserved is set in rdev->flags in
> > rdev_size_store function in md.c
> > so writing to size file by sysfs_set_str always fails when native
> > array exists.
> > The flag is not set when there is no native arrays and all actions
> > can be completed normally.
> > 
> > This is just to inform about the issue.
> > It will be investigated further after the weekend.
> > Regards
> > Anna
> 
> Native metadata reserves a parent disk device for exclusive use by
> setting AllReserved in rdev->flags. Now if a member device has
> AllReserved flag set on its block device then creation of any
> external metadata array/container on is unreasonably blocked.

This is not unreasonable at all.  Native metadata claims the whole
device.
If you want to move a spare from a native array to an imsm array, then
you should remove the spare from the first array, and then add it to
the container for the second.
This will cause it to get a brand new 'rdev' which will not have
AllReserved set.

If you are having trouble migrating devices from a native array to an
IMSM array, then I suspect the problem is in mdadm.  Maybe we aren't
removing the device from its array first??

NeilBrown 

> Solution:
> When creating a new external RAID device we must check that the new
> device is not using a partition of a disk, when there is another array
> using another partition of the same disk calming exclusive usage for
> the disk. Exclusive usage is enforced by setting AllReserved in
> rdev->flags.
> 
> Here is the list of my tests and conclusion after applying the patch:
> 1. I have validated that containers and arrays can be created when
> there is a native raid present. Previously it was failing. If there
> was a native raid, the rdev_size_store prevented from creation of any
> external metadata, even if there was no disk or block device overlap.
> This was because of invalid AllReserved bit check for external
> metadata arrays.
> 
> # mdadm -CR /dev/md122 -l 1 -n 2  /dev/sdb1 /dev/sdb2
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md122 started.
> 
> # cat /proc/mdstat 
> Personalities : [raid1] 
> md122 : active raid1 sdb2[1] sdb1[0]
>       19530154 blocks super 1.2 [2/2] [UU]
>       [>....................]  resync =  0.3% (63680/19530154)
> finish=20.3min speed=15920K/sec 
> unused devices: <none>
> 
> # mdadm -CR /dev/md121 -e ddf -n 2 --force /dev/sdc /dev/sdd
> mdadm: container /dev/md121 prepared.
> 
> # mdadm -CR /dev/md123 -l 1  -n 2 --force /dev/sdc /dev/sdd
> mdadm: largest drive (/dev/sdd) exceeds size (78117976K) by more than
> 1% mdadm: Creating array inside ddf container /dev/md121
> mdadm: array /dev/md123 started.
> starting mdmon for md121
> 
> # cat /proc/mdstat 
> Personalities : [raid1] 
> md123 : active raid1 sdd[1] sdc[0]
>       78117976 blocks super external:/md121/0 [2/2] [UU]
>       [=>...................]  resync =  8.9% (6980928/78117976)
> finish=15.6min speed=75612K/sec 
> md121 : inactive sdd[1](S) sdc[0](S)
>       65536 blocks super external:ddf
>        
> md122 : active raid1 sdb2[1] sdb1[0]
>       19530154 blocks super 1.2 [2/2] [UU]
>       [=====>...............]  resync = 25.5% (4995776/19530154)
> finish=9.4min speed=25659K/sec 
> unused devices: <none>
> 
> 
> 2. Creating native raid array on partitions on the same disk works
> fine. The same for dff container (imsm does not allow for raids on
> partitions). In case of container, raid array can be created.
> 
> # mdadm -CR /dev/md121 -l 1 -n 2 --force /dev/sdb1 /dev/sdb2
> mdadm: /dev/sdb1 appears to contain an ext2fs file system
>     size=19529728K  mtime=Thu Jan  1 01:00:00 1970
> mdadm: Note: this array has metadata at the start and
>     may not be suitable as a boot device.  If you plan to
>     store '/boot' on this device please ensure that
>     your boot-loader understands md/v1.x metadata, or use
>     --metadata=0.90
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md121 started.
> 
> 
> 
> # mdadm -CR /dev/md121 -e ddf -n 2 --force /dev/sdb1 /dev/sdb2
> 
> 
> # mdadm -CR /dev/md122 -l 1 -n 2  /dev/sdb1 /dev/sdb2
> 
> mdadm: Creating array inside ddf container /dev/md121
> mdadm: array /dev/md122 started.
> 
> 
> 
> 3. Preventing external container from from using partition of the
> disk, when there is a native raid using another partition of the same
> disk. Since, the prevention is conducted in store_size, the container
> is created with zero size. mdadm aborts the creation but does not
> clean-up.
> 
> # mdadm -CR /dev/md119 -l 0 -n 2 --force /dev/sdb1 /dev/sdd
> mdadm: array /dev/md119 started.
> 
> 
> # mdadm -CR /dev/md120 -e ddf -n 2 --force /dev/sdb2 /dev/sdc
> mdadm: failed to write '32768' to
> '/sys/block/md120/md/dev-sdb2/size' (Device or resource busy) mdadm:
> ADD_NEW_DISK for /dev/sdb2 failed: Device or resource busy
> 
>  # cat /proc/mdstat 
> Personalities : [raid1] [raid0] 
> md120 : inactive sdb2[0](S)
>       0 blocks super external:ddf
>        
> md119 : active raid0 sdd[1] sdb1[0]
>       175819264 blocks super 1.2 512k chunks
>       
> unused devices: <none>
> 
> 
> 4. Two native raid can be created when they use different partitions
> of the same disks:
> 
> # mdadm -CR /dev/md119 -l 0 -n 2 --force /dev/sdb1 /dev/sdd
> # mdadm -CR /dev/md120 -l 0 -n 2 --force /dev/sdb2 /dev/sdc
> 
> # cat /proc/mdstat 
> Personalities : [raid1] [raid0] 
> md120 : active raid0 sdc[1] sdb2[0]
>       97679360 blocks super 1.2 512k chunks
>       
> md119 : active raid0 sdd[1] sdb1[0]
>       175819264 blocks super 1.2 512k chunks
>       
> unused devices: <none>
> 
> 5. size_store does not prevent for using the partition and its disk
> in the same container or native raid. Later mdadm aborts creation and
> clean-ups. The fix does not tries to detect this situation earlier.
> 
> # mdadm -CR /dev/md121 -e ddf  -n 2 --force /dev/sdb1 /dev/sdb
> mdadm: /dev/sdb1 appears to contain an ext2fs file system
>     size=19529728K  mtime=Thu Jan  1 01:00:00 1970
> mdadm: /dev/sdb appears to be part of a raid array:
>     level=raid1 devices=1 ctime=Mon Jan 24 16:23:59 2011
> mdadm: failed to open /dev/sdb after earlier success - aborting
> 
> 
> Marcin Labun (1):
>   md: unblock the creation of an external metadata RAID if native one
>     exists
> 
>  drivers/md/md.c |   19 +++++++++++++++++--
>  1 files changed, 17 insertions(+), 2 deletions(-)
> 
> 
> 
> 
> 

