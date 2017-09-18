From: Shaohua Li <shli@kernel.org>
Subject: Re: Linux Plumbers MD BOF discussion notes
Date: Sun, 17 Sep 2017 21:54:44 -0700
Message-ID: <20170918045444.lfhzdovihqxqj6ub@kernel.org>
References: <20170915142737.qafwl3vgl6vhfi5q@kernel.org>
 <871sn78pzt.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <871sn78pzt.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Sep 16, 2017 at 10:08:06AM +1000, Neil Brown wrote:
> 
> Sounds like an interesting, wide ranging discussion...
> 
> 
> 
> On Fri, Sep 15 2017, Shaohua Li wrote:
> 
> > This is a short note based on Song's record. Please reply to the list if
> > anything is missing.
> >
> > *IMSM - PPL
> > Fix write hole without extra device; Updated status and upcomming mdadm change
> > to support it. Intel guys are improving it, like fixing current 'disable disk
> > cache' problem.
> >
> > *Hiding member drives
> > Hiding RAID array member drives from user, so MD RAID array looks more like a
> > hardware raid array. This turns out to be real customer requirement.
> > We do need to access the member drives for different reasons (create/assembly,
> > mdmon, iostat). Working around this issue might be possible, eg, delete the
> > /dev/xxx after array assembly. But must justify the value and also discuss with
> > block guys since this is a general issue.
> 
> 
> "Hiding" is a very vague term.  Should we get Harry Potter's
> invisibility cloak and wrap it around the hardware?
> Do we need to:
>   - remove from /proc/partitions - possible and possibly sane
>   - remove from from /dev - easy, given clear justification
>   - remove from /sys/block - I don't think this is justifiable
>   - make open() impossible - it already is if you use O_EXCL
> ??
> 
> Possibly something sensible could be done, but we do need a clear
> statement of, and justification for, the customer requirement.

Agree. The requirement isn't very clear right now.
 
> >
> > *Block-mq
> > Converting MD to use block-mq? md is bio based (not request based) driver, so
> > no value to go mq. md dispatches bio directly to low level disks. blk-mq still
> > benefits if low level disk supports it but this is transparent to md.
> >  
> > *NVDIMM caching
> > NVDIMM supports block interface. Using it as a raid5 cache disk should be
> > straightforward.
> > Directly storing raid5 stripe cache in NVDIMM without current raid5-cache log
> > device? Had problems for example how to detect/fix data mismatch after power
> > failure. Need major changes in raid5 code.
> >  
> > *stream ID
> > Support stream ID in MD. It should be fairly easy to support stream ID in
> > raid0/1/10. Intel guys described a scenario in raid5 which breaks stream ID,
> > eg, write stripe data multiple times because of read-modify-write (clarify?).
> > Probably detecting IO pattern like what DM does can help.
> >
> > *split/merge problem
> > md layer splits bio and block layer will do bio merge for low level disks. The
> > merge/split overhead is noticeable for raid0 with fast SSD and small chunk
> > size. Fixing the issue for raid0 is doable. Fixing for raid5 is not sure.
> > Discussed increasing stripe size of raid5 to reduce the split/merge overhead.
> > There is tradeoff here for example more unnecessary IO for read-modify-write
> > with bigger stripe size.
> 
> For raid5 I can understand this being an issue as raid5 only submits
> PAGE_SIZE bios to lower level devices.
> The batching that Shaohua added might be a good starting point.  If you
> have a batch of stripes, you should be able to submit one bio per device
> for the whole batch.
> 
> For RAID0, I don't understand the problem.  RAID0 never splits smaller
> than the chunk size, and that is a firm requirement.
> Maybe RAID0 could merge the bios itself rather than passing them down.
> Maybe that would help.  Do if a request is properly aligned and covers
> several stripes, that could be mapped to one-bio-per-device.  Is that
> the goal?

Yes, I think one-bio-per-device is the goal. split bio according to chunk size
and merge bio in low level disk does takes cpu time.

> >
> > *Testing
> > md need recover data after disk failures, mdadm has test suite, but not
> > covering all cases. mdadm test suite is fragile, may kill the machine
> > We need to build more completed tests.
> >
> > The recent null_blk block device driver can emulate several types of disk
> > failures. The plan is to make null_blk support all disk failures which md can
> > handle and create a test suite using null_blk. Help is welcome!
> >  
> > *RAID-1 RAID-10 barrier inconsistency
> > Coly improved the barrier scalibility for raid1, hopefully he can do the same
> > for raid10
> >  
> > *DAX
> > Support DAX in raid0/linear should not be hard. Does it make sense to support
> > other raid types?
> >
> > *sysfs / ioctl
> > Jes started working on it. Goal is to replace ioctl with sysfs based interfaces.
> > There are gaps currently, eg, some operations can only be done with ioctl. Suse
> > guys promised to close the gap in kernel side.
> >
> > Using configfs instead of sysfs?
> 
> It seems that no one actually wants this, but I'll just throw in my
> opinion that this is a nonsensical suggestion.  configfs is only for
> people who don't understand sysfs.  It has no real value. 
> >  
> > *Stop nested RAID device
> > For example a raid0 on top of raid5. Userspace must understand the topology to
> > stop the nested raid arrays.
> > mdadm stop is async, need sync option for stop array (clarify?)
> 
> I've been thinking that it might be useful for md (and dm and loop
> and..) to have a setting whereby it automatically shuts down on last
> close.  This would make it easier to orchestrate shutdown.
> Certainly it would make sense to use such a mode for stacked arrays.

loop does have the setting to automatically shut down on last close.

Thanks,
Shaohua
> The "mdadm stop is async" comment refers to the fact that
> mddev_delayed_delete is run in a work queue, possibly after "mdadm -S
> /dev/mdX" completes.
> It might also refer to that fact that udev subsequently deletes things
> from /dev, possibly after a further delay.
> 
> It might be possible to remove the need for mddev_delayed_delete if we
> enhance disk_release (in genhd.c) in some way so that it can drop the
> reference on the mddev (instead of mddev having to be careful when it
> drops the reference on the gendisk).
> 
> Getting mdadm to wait for udev might be easy if udev provides some sort
> of API for that.
