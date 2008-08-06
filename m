From: Neil Brown <neilb@suse.de>
Subject: Re: Nested raid operation and disk sizes
Date: Wed, 6 Aug 2008 11:55:18 +1000
Message-ID: <18585.1158.151051.791210@notabene.brown>
References: <925039.86717.qm@web30804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Myers on Tuesday August 5
Sender: linux-raid-owner@vger.kernel.org
To: Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday August 5, mikesm559@yahoo.com wrote:

> Hi.  I friend asked me a question about reconfiguring his linux
> software raid system, and I think I know the answer, but thought I
> would ask here to make sure since I'd never done this before. 

Sensible.

> 
> My friend has 2 raid5 disk sets right now, one with 8 500 GB saegate
> 7200.10 disks, and the other with 5 1 TB Hitachi 7K1000 disks. 
> 
> He just bought 5 new seagate 7200.11 1 TB disks, and will format
> them as new raid5 set.  He then plans to use lvm to move the data
> off the  8x500GB set to the new 5x1TB set, destroy the 8x500 set,
> and then use group 6 of the 500 GB disks into 3 raid0 sets of 2x500
> each, and then add the raid0 sets as members of the new 1TB raid set
> by expanding the array. 
> 
That should work.

> This enables him to replace the 500 GB drives later with 1TB disks
> as the price of the disks gets cheaper as make the best use of the
> SATA sleds that his case has.  The new 7200.11's have 1,953,525,168
> 512 byte sectors each.  The existing segate 500 GB drives have
> 976,773,168 512 byte sectors.  If he combines two of the 500's
> together into a raid0, he should have a total of 1,953,546,336
> sectors available, which is greater number of sectors than the 1 TB
> drives, so there should be no problem using the 2 disk raid0 set as
> a member of the 7200.11 1 TB disk raid5 set, right?   

Take the size of the 500GB drives, subtract 128K for overhead, then
divide by your chunksize (e.g.64K) and double to get the number of
chunks that will be available to the raid5.
Compare this with the size of the 1TB device divided by the chunk
size.

2 500GB get 7631038 64K chunks each, or 15262076 total.
1 1TB has 15261915.  So the 2*500GB is still bigger, which is good.

If you want to be extra sure, you could create the raid5 on the 1TB
devices with a smaller size. e.g. --size 950000000
Then when all the devices are in place use "--grow --size=max",
and then grow the filesystem to use all the available size.

As you probably realise, you one need a single step to grow from 5
devices to 8.  Just add the 3 raid0s as spares and "mdadm -G /dev/md0 -n8"

NeilBrown
