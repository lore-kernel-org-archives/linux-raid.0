From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] md/raid5: FIX: manually-added spare is not used
Date: Thu, 20 Jan 2011 20:30:50 +1100
Message-ID: <20110120203050.633eb1b1@notabene.brown>
References: <20110114125537.15648.73873.stgit@gklab-128-013.igk.intel.com>
	<20110114130000.15648.52870.stgit@gklab-128-013.igk.intel.com>
	<20110117101128.60a9b683@notabene.brown>
	<20110117102821.3460a918@notabene.brown>
	<20110117114441.141f249f@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D176EA541F@irsmsx503.ger.corp.intel.com>
	<20110120074840.2977b276@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D176EFD77C@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D176EFD77C@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Thu, 20 Jan 2011 08:29:12 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> 
> 
> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Wednesday, January 19, 2011 9:49 PM
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > Neubauer, Wojciech
> > Subject: Re: [PATCH 1/2] md/raid5: FIX: manually-added spare is not
> > used
> > 
> > On Mon, 17 Jan 2011 14:13:34 +0000 "Kwolek, Adam"
> > <adam.kwolek@intel.com>
> > wrote:
> > 
> > >
> > >
> > > > -----Original Message-----
> > > > From: NeilBrown [mailto:neilb@suse.de]
> > > > Sent: Monday, January 17, 2011 1:45 AM
> > > > To: Kwolek, Adam
> > > > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > > > Neubauer, Wojciech
> > > > Subject: Re: [PATCH 1/2] md/raid5: FIX: manually-added spare is not
> > > > used
> > > >
> > > > On Mon, 17 Jan 2011 10:28:21 +1100 NeilBrown <neilb@suse.de> wrote:
> > > >
> > > > > On Mon, 17 Jan 2011 10:11:28 +1100 NeilBrown <neilb@suse.de>
> > wrote:
> > > > >
> > > > > > On Fri, 14 Jan 2011 14:00:00 +0100 Adam Kwolek
> > > > <adam.kwolek@intel.com> wrote:
> > > > > >
> > > > > > > Manually added spares are not used due to fact that they not
> > > > added to md configuration.
> > > > > > > Counters are updated only.
> > > > > > >
> > > > > > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > > > > > > ---
> > > > > > >
> > > > > > >  drivers/md/raid5.c |    6 ++++--
> > > > > > >  1 files changed, 4 insertions(+), 2 deletions(-)
> > > > > > >
> > > > > > > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > > > > > > index a2087c7..59c4150 100644
> > > > > > > --- a/drivers/md/raid5.c
> > > > > > > +++ b/drivers/md/raid5.c
> > > > > > > @@ -5592,8 +5592,10 @@ static int raid5_start_reshape(mddev_t
> > > > *mddev)
> > > > > > >  		} else if (rdev->raid_disk >= conf-
> > > > >previous_raid_disks
> > > > > > >  			   && !test_bit(Faulty, &rdev->flags)) {
> > > > > > >  			/* This is a spare that was manually added */
> > > > > > > -			set_bit(In_sync, &rdev->flags);
> > > > > > > -			added_devices++;
> > > > > > > +			if (raid5_add_disk(mddev, rdev) == 0) {
> > > > > > > +				set_bit(In_sync, &rdev->flags);
> > > > > > > +				added_devices++;
> > > > > > > +			}
> > > > > > >  		}
> > > > > > >
> > > > > > >  	/* When a reshape changes the number of devices, ->degraded
> > > > > >
> > > > > > This should not be needed.
> > > > > > When a device is manually added, the desired slot number is
> > written
> > > > to
> > > > > >    ..../md/dev-XXX/slot
> > > > > >
> > > > > > This calls slot_store (in md.c) which call mddev->pers-
> > > > >hot_add_disk which
> > > > > > for raid5 is raid5_add_disk.
> > > > > > So you shouldn't need to call raid5_add_disk again.
> > > > > >
> > > > >
> > > > > ahhh... I see.  raid5_add_disk doesn't do the right thing in that
> > > > case.  It
> > > > > actually indexes beyond the end of an array, which is bad.
> > > > >
> > > > > We possibly do need the raid5_add_disk where you had put it.
> > I'll
> > > > have a
> > > > > think and see what is best.
> > > >
> > > > On third thoughts, I cannot see the problem you are seeing.
> > > > I even did some simple testing (manually writing to things in
> > sysfs)
> > > > and it
> > > > seems to include the new device properly.
> > > >
> > > > There are some issues that I found which are address by the
> > following
> > > > patch,
> > > > but it isn't clear to me that any of them relate to what you are
> > > > seeing.
> > > > Maybe if you could be more specific about what you see happening?
> > > >
> > > > Thanks,
> > > > NeilBrown
> > >
> > >
> > > When I'm not using raid5_add_disk() in raid5_start_reshape() added
> > disk LED light doesn't blinks
> > > (but it should during reshape ;)),
> > > md doesn't make any signs that something goes wrong (even size can be
> > increased).
> > >
> > > I've made some debug, and at second (during reshape start)
> > raid5_add_disk() call rcu_assign_pointer() is called again.
> > > This means that somehow previous assignment when slot is set was
> > cleared.
> > >
> > > Correct situation (all disks are used during reshape) I can archive
> > when instead raid5_add_disk() call
> > > I've add the following code:
> > >
> > >      struct disk_info *p = conf->disks + rdev->raid_disk;
> > >      rcu_assign_pointer(p->rdev, rdev);
> > >
> > > and (conf->disks + rdev->raid_disk)->rdev pointer is present in
> > configuration.
> > > I've checked that if I do not do call to rcu_assign_pointer() pointer
> > (p->rdev) has NULL value.
> > > In both cases call rcu_assign_pointer() sets p->rdev to the same
> > value, so rdev doesn't change his location in memory.
> > >
> > >
> > > BR
> > > Adam
> > >
> > 
> > Could you put some debug printks in slot_store (in md.c) and make sure
> > it is
> > being called, and that it calls raid5_add_disk, and see what
> > raid5_add_disk
> > does in that case?
> > Thanks,
> > 
> > NeilBrown
> 
> 
> I've did it before (and I've double checked now).
> slot_store() calls raid5_add_disk() and inside it, rcu_assign_pointer() sets correct rdev pointer (I've checked, it is set during slot_store() call).
> During raid5_start_reshape() this pointer has NULL value. When I set it again, disk is used properly. Second time rdev pointer I'm setting is the same as I've set during slot_store() call.
> It seems that slot_store() works correctly. I've didn't find why rdev pointer is cleaned meanwhile. I have it in my plans after I've close mdadm OLCE/migration code (main parts at least ;)).
> 

Thanks.
It is almost certainly getting removed by remove_add_add_spares calling
raid5_remove_disk.  One of those should stop the removal happening in that
case, but presumably isn't.
I'll try to figure out what "should" happen and get you a patch to try - not
sure when.

NeilBrown

