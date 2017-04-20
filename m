From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH] md: handle read-only member devices better.
Date: Thu, 20 Apr 2017 13:24:28 -0700
Message-ID: <20170420202306.zcsx4prawtqyapfy@kernel.org>
References: <87a87lutj7.fsf@notabene.neil.brown.name>
 <20170413054723.2spvhtze6bljkaop@kernel.org>
 <877f2muvmc.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877f2muvmc.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Nanda Kishore Chinnaram <Nanda_Kishore_Chinna@dell.com>
List-Id: linux-raid.ids

On Sat, Apr 15, 2017 at 02:45:31PM +1000, Neil Brown wrote:
> On Wed, Apr 12 2017, Shaohua Li wrote:
> 
> > On Thu, Apr 13, 2017 at 08:53:48AM +1000, Neil Brown wrote:
> >> 
> >> 1/ If an array has any read-only devices when it is started,
> >>    the array itself must be read-only
> >> 2/ A read-only device cannot be added to an array after it is
> >>    started.
> >> 3/ Setting an array to read-write should not succeed
> >>    if any member devices are read-only
> >
> > Didn't get these. We call md_import_device() first to open under layer disk. We
> > always use FMOD_READ|FMOD_WRITE to open the disk. So if the disk is ro,
> > md_import_device should fail, we don't add the disk to the array. Why would we
> > have such issues?
> >
> 
> Because life isn't always as simple as we might like it to be. :-(
> 
> md_import_device() calls lock_rdev() which calls blkdev_get_by_dev().
> 
> blkdev_get_by_dev() doesn't pay much attention to the mode, nor does
> blkdev_get() which it calls.  The main place where FMODE_WRITE could be
> rejected on a read-only device is in the device's 'open()' function.  A
> few open functions do check for read-only, but it isn't at all
> consistent.
> scsi/sd.c does, block/loop.c doesn't, nor does nvme.  Most drivers seem
> to ignore the mode.
> 
> blkdev_get_by_path() has
> 
> 	if ((mode & FMODE_WRITE) && bdev_read_only(bdev)) {
> 		blkdev_put(bdev, mode);
> 		return ERR_PTR(-EACCES);
> 	}
> 
> so when you open a device by path name you always get this check, but
> not when you open a device by device-number like md does.
> It is worth having a look at
> Commit: e51900f7d38c ("block: revert block_dev read-only check")
> from 2011.  The bdev_read_only() check was in blkdev_get() for a while,
> but it was moved out because doing that broke md and dm and others.
> 
> So at present, callers of blkdev_get_by_dev() need to do their own
> bdev_read_only() tests before writing.
> We could discuss where in md.c is the best place to put them, but unless
> you want to take on a largish project to 'fix' (or audit) all callers of
> blkdev_get_by_dev(), they need to go in md somewhere.

It's unfortunate we need the hack, but anyway I applied this. I'm wonding how
useful a ro array is. At least ro array with .sync_request is dangerous because
we could read inconsistent data.

Thanks,
Shaohua
