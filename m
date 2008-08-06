From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Nested raid operation and disk sizes
Date: Wed, 6 Aug 2008 10:30:03 -0700 (PDT)
Message-ID: <609054.31279.qm@web30808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(whoops, for got to copy the list list the first time)

Neil, thanks very much for this.  I follow the calculations and it does
seem even with a 128K chunk size (he's doing media serving) that this
will work just fine.  A couple quick questions:

1) I forgot to
take into account partitioning.  If the max partition size is used
(i.e. using /dev/sdb1 as a raid set member instead of /dev/sdb), isn't
there some amount of space left over on the disk?  Does that affect
this calculation any?

2) Is the md driver smart enough to
realize if a member of a raid set is another md device that it should
start that md set first before trying to bring up the larger set?  

I
had forgotten that you could also grow the max size of each member as
you describe.  That does sound foolproof, though requires two grow
operations...  I am always impressed by the flexibility of linux
software raid - half this stuff I don't naturally think about because
you can only do it with linux software raid and not with other raid
solutions.

thx
mike



----- Original Message ----
From: Neil Brown <neilb@suse.de>
To: Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org
Sent: Tuesday, August 5, 2008 6:55:18 PM
Subject: Re: Nested raid operation and disk sizes

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
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



      
