From: Neil Brown <neilb@suse.de>
Subject: Re: How does md determine which partitions to use in RAID1 when DEVICE partitions is specified
Date: Tue, 4 Jul 2006 08:40:03 +1000
Message-ID: <17577.40131.651688.98278@cse.unsw.edu.au>
References: <e0904ff40607031327o5fd9fcc6v9b431656d5a01d02@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Brian Bonner on Monday July 3
Sender: linux-raid-owner@vger.kernel.org
To: bkbonner@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday July 3, bkbonner@gmail.com wrote:
> I have Fedora Core 5 installed with mirroring on the Boot partition
> and root partition.  I created a Logical Volume Group on the mirrored
> root partition.
> 
> How does md figure out which partitions are actually specified.  It
> says it stores the uuid in the superblock, but I can't seem to figure
> out where this is, or how to get it.  is it in the partition, or
> volume.

The superblock is near the end of whatever you told md to use for the
array.
 From your 'mdadm --detail' output, I see that means /dev/sda1
/dev/sdb1 /dev/sda2 etc.  The superblock for each partition is near
the end of each partition.

> 
> The reason I'm asking this, I'd like to add two USB 2.0 drives that
> are mirrored, and I would specify the device name (/dev/sdd, /dev/sde)
> for the ARRAY, but I found that the allocation of these device names
> is dependent upon when the drive is inserted into the USB.

You don't need to care about the device name.  Just add the uuid
information to mdadm.conf.  Providing the devices are plugged in,
mdadm will find them.

> 
> I'm going to ask if there is a way to "lock" the volume names for
> devices (I'm thinking by UUID) for USB devices in partitions.
> 

'udev' might have functionality to do this.  But you don't really need
it with mdadm.

NeilBrown
