From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: Extendible RAID10
Date: Thu, 31 Mar 2011 19:42:30 +0200
Message-ID: <20110331174230.GA10981@www2.open-std.org>
References: <imv5sm$tuj$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <imv5sm$tuj$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 30, 2011 at 01:57:36PM +0200, David Brown wrote:
> RAID10 with far layout is a very nice raid level - it gives you read 
> speed like RAID0, write speed no slower than other RAID1 mirrors, and of 
> course you have the mirror redundancy.
> 
> But it is not extendible - once you have made your layout, you are stuck 
> with it.  There is no way (at the moment) to migrate over to larger drives.
> 
> As far as I can see, you can grow RAID1 sets to larger disks.  But you 
> can't grow RAID0 sets.  As far as I can see, there is some inconsistency 
> in the mdadm manual pages as to whether or not you can grow the size of 
> a RAID4 array.  If it is possible to grow a RAID4, then it should be 
> possible to use a degraded RAID4 (with a missing parity disk) as a RAID0.
> 
> 
> I'm planning a new server in the near future, and I think I'll get a 
> reasonable balance of price, performance, capacity and redundancy using 
> a 3-drive RAID10,f2 setup (with a small boot partition on each drive, 
> all three as a RAID1, so that grub will work properly).  On the main md 
> device I then have an LVM physical volume, with logical partitions for 
> different virtual machines or other data areas.  I've used such an 
> arrangement before, and been happy with it.
> 
> But as an alternative solution that is expandable, I am considering 
> using LVM to do the striping.  Ignoring the boot partition for 
> simplicity, I would partition each disk into two equal parts - sda1, 
> sda2, sdb1, sdb2, sdc1 and sdc2.  Then I would form a set of RAID1 
> devices - md1 = sda1 + sdb2, md2 = sdb1 + sdc2, md3 = sdc1 + sda2.  I 
> would make an lvm physical volume on each of these md devices, and put 
> all those physical volumes into a single volume group.  Whenever I make 
> a new logical volume, I specify that it should have three stripes.
> 
> If I then want to replace the disks with larger devices, it is possible 
> to add a new disk, partition it into two larger partitions, add these 
> partitions to two of the existing raids, sync, fail then remove the 
> now-redundant drive.  After three rounds, the RAID1 sets can then be 
> grown to match the new partition sizes.  Then the lvm physical volumes 
> can be grown to match the new raid sizes.
> 
> 
> Any opinions?  Have I missed anything here, perhaps some issues that 
> will make this arrangement slower or less efficient than a normal 
> RAID10,f2 with lvm on top?

I am not sure RAID10,f2 works well with LVM. I believe I have seen
reports to the contrary.

It should be possible to extend RAID10 arrays with more disks. I do not
think it is so difficult. But I think neil does not have it on his wish
list.

best regards
keld
