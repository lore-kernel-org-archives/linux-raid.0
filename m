From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] IMSM: Fix problem in mdmon monitor of using removed
 disk from in imsm container.
Date: Thu, 9 Dec 2010 08:37:24 +1100
Message-ID: <20101209083724.3228dc34@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D17676E3B8@irsmsx503.ger.corp.intel.com>
	<20101208132942.1a59efb1@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D176A1AE79@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D176A1AE79@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

On Wed, 8 Dec 2010 17:17:10 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> > -----Original Message-----
> > From: Neil Brown [mailto:neilb@suse.de]
> > Sent: Wednesday, December 08, 2010 3:30 AM
> > To: Labun, Marcin
> > Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech; Williams, Dan J;
> > Ciechanowski, Ed; Hawrylewicz Czarnowski, Przemyslaw; Czarnowska, Anna
> > Subject: Re: [PATCH 1/2] IMSM: Fix problem in mdmon monitor of using
> > removed disk from in imsm container.
> > 
> 
> <cut>
> 
> > > int (*remove_from_super)(struct supertype *st, mdu_disk_info_t
> > *dinfo,
> > >                          int fd);
> > > The message prepared in remove_from_super is later processed
> > > by proceess_update handler in monitor thread.
> > 
> > I don't like this.  There is unnecessary complexity.
> > 
> > adding a disk and removing a disk are very different sorts of
> > operations.
> > When adding a disk, you need to pass extra information about how the
> > disk
> > might be used - whether it is already part of the array, or if it is a
> > fresh
> > spare or whatever.
> > When removing a device there is none of that.  Just remove the device.
> > 
> > So when mdadm removes a device from a container it should
> >   - get a lock so mdmon won't assign the device as spare
> >   - check that the device is still a spare
> >   - remove the device from the container
> >   - unlock
> >   - ping mdmon
> > 
> > mdmon should notice that the device has gone and should update the
> > metadata
> > accordingly.
> 
> Let me add a couple of comments and questions, so I can understand correctly what solution you want to get.
> 
> My changes are in manager and monitor threads of mdmon. 
> 
> As you said, manager notices that a device has gone.
> So I added a call to new remove_disk_from_container in manage_container function (in manager thread).
> remove_disk_from_container is called for every device that has disappeared.
> The function remove_disk_from_container prepares an metadata update using handler functions and queues them using queue_metadata_update
> And that's all for manager thread.
> 
> Now monitor thread of mdmon checks for metadata updates in update_queue global.
> Monitor walks update__queue list to call process_update handler.
> In IMSM process_update handler, I added code that removes spare disk descriptor from IMSM device list.
> 
> Now my questions:
> - do you want to get rid of update_queue communication between manager and monitor for disk removal? 
> 
> - do you want to add non-metadata specific communication between manager and monitor? This would introduce generic disk_remove message
> that is passed from manager to monitor. The monitor would call metadata handler. 
> 
> - do you want the monitor thread to find out what disks has been removed and call metadata handlers?

It looks like I misunderstood your patch.  I got the impression that it was
sending a metadata update from mdadm to mdmon, but from what you say it isn't
doing that.

If it is just being sent from manager to monitor then that is obviously fine.

I'll have another look at the code now that I have a better understanding of
what you intended - maybe it will be fine as it is (except for the extraneous
'fd' argument...)

Thanks,
NeilBrown


> 
> > 
> > So you may still need a 'remove_from_super' method, but it will not
> > send a
> > metadata update request to mdmon.
> > Rather it will be run by mdmon when it notices the device is gone.
> > 
> > It is probably appropriate to pass an mdu_disk_info_t or maybe just a
> > device
> > number.  I don't think there is any need to pass an 'fd'.
> 
> That's correct: fd is not needed.
> 
> Thanks in advance,
> Marcin
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

