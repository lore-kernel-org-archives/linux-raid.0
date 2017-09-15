From: Shaohua Li <shli@kernel.org>
Subject: Re: Linux Plumbers MD BOF discussion notes
Date: Fri, 15 Sep 2017 14:20:49 -0700
Message-ID: <20170915212049.w4qietvns234eywm@kernel.org>
References: <20170915142737.qafwl3vgl6vhfi5q@kernel.org>
 <28934cdc-e3c8-a201-1813-248a64a7a6c1@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <28934cdc-e3c8-a201-1813-248a64a7a6c1@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Sep 15, 2017 at 10:42:23PM +0200, Coly Li wrote:
> On 2017/9/15 下午4:27, Shaohua Li wrote:
> > This is a short note based on Song's record. Please reply to the list if
> > anything is missing.
> 
> [snip]
> >  
> > *stream ID
> > Support stream ID in MD. It should be fairly easy to support stream ID in
> > raid0/1/10. Intel guys described a scenario in raid5 which breaks stream ID,
> > eg, write stripe data multiple times because of read-modify-write (clarify?).
> > Probably detecting IO pattern like what DM does can help.
> > 
> 
> Can anyone give me a hint what is stream ID in the context of md raid ?

I think it's called write hint right now, see c75b1d9421f8 fs: add fcntl()
interface for setting/getting write life time hints 
> 
> > *split/merge problem md layer splits bio and block layer will do bio merge
> > for low level disks. The merge/split overhead is noticeable for raid0 with
> > fast SSD and small chunk size. Fixing the issue for raid0 is doable. Fixing
> > for raid5 is not sure.  Discussed increasing stripe size of raid5 to reduce
> > the split/merge overhead.  There is tradeoff here for example more
> > unnecessary IO for read-modify-write with bigger stripe size.
> > 
> > *Testing md need recover data after disk failures, mdadm has test suite,
> > but not covering all cases. mdadm test suite is fragile, may kill the
> > machine We need to build more completed tests.
> > 
> > The recent null_blk block device driver can emulate several types of disk
> > failures. The plan is to make null_blk support all disk failures which md
> > can handle and create a test suite using null_blk. Help is welcome!
> >  
> > *RAID-1 RAID-10 barrier inconsistency Coly improved the barrier scalibility
> > for raid1, hopefully he can do the same for raid10
> >  
> 
> Copied, I will handle it.
> 
> 
> > *DAX Support DAX in raid0/linear should not be hard. Does it make sense to
> > support other raid types?
> > 
> > *sysfs / ioctl Jes started working on it. Goal is to replace ioctl with
> > sysfs based interfaces.  There are gaps currently, eg, some operations can
> > only be done with ioctl. Suse guys promised to close the gap in kernel
> > side.
> > 
> 
> Yes, I will handle kernel part. The change will be done one by one, step by
> step. The first step is to unify code path for both ioctl and sysfs
> interfaces. Once I finish my emergent tasks on hand, I will start to handle
> this. Hopefully this work can start by end of this year.
> 
> > Using configfs instead of sysfs?
> >  
> 
> Currently it is sysfs and I feel is it OK being sysfs interface. Do we have
> specific reason or benefit for using configfs ?

No strong reason, just because configfs is generally for configure. If sysfs
works here, I think it's ok.

Thanks,
Shaohua
