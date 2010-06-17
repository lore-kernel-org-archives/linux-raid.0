From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: RE: [md PATCH 2/5]  md: Enable reshape for external metadata
Date: Thu, 17 Jun 2010 14:19:22 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801E8E6AA3@irsmsx503.ger.corp.intel.com>
References: <905EDD02F158D948B186911EB64DB3D11EECE8A2@irsmsx503.ger.corp.intel.com>
	<20100616145343.1fc13b4c@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D11F2FF471@irsmsx503.ger.corp.intel.com>
	<20100617161135.73a377a0@notabene.brown>
	<BE2BFE91933D1B4089447C64486040801E8E686C@irsmsx503.ger.corp.intel.com>
 <20100617203519.681a7586@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100617203519.681a7586@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Thursday, June 17, 2010 12:35 PM
> To: Trela, Maciej
> Cc: Kwolek, Adam; linux-raid@vger.kernel.org; Williams, Dan J;
> Ciechanowski, Ed
> Subject: Re: [md PATCH 2/5] md: Enable reshape for external metadata
> 
> On Thu, 17 Jun 2010 10:40:36 +0100
> "Trela, Maciej" <Maciej.Trela@intel.com> wrote:
> 
> > >
> > > >
> > > > Another thing is waiting during reshape for metadata update on
> > > MD_CHANGE_DEVS flag.
> > > > To roll reshape I've added the following code (instead calling
> > > md_ubdate_sb()):
> > >
> > > Yes, there is a real issue there...
> > >
> > > I don't think we ever need the kernel to wait for an external
> metadata
> > > handler
> > > to respond to device changes (apart from failure which is handled
> > > separately).
> > > So maybe the best thing is to guard all settings of MD_CHANGE_DEVS
> with
> > > if (mddev->persistent)
> > >
> > > I think that would be best, but I've make a note to review that
> later.
> > >
> >
> > Neil,
> > from what I see in the raid5.c/md.c "native" code uses MD_CHANGE_DEVS
> > during the reshape if it reaches special points when metadata
> > write is really needed to update the reshape checkpoint.
> > In reshape_request():
> > 	/* Cannot proceed until we've updated the superblock */
> > 	..
> > 	set_bit(MD_CHANGE_DEVS, mddev->flags)
> >
> > In md_check_recovery() we have:
> > 	if (mddev->flags)
> > 		md_update_sb()
> >
> > Couldn't we follow this logic with MD_CHANGE_DEVS for external
> metadata?
> > If not, how to detect the need for migration checkpoint update?
> 
> Good question.
> The first question to ask is
>   How does mdmon know when a metadata update is required, and how does
>   it tell md that the metadata update is complete.
> 
> OK, 2 first questions...
> 
> For the first I suspect it should watch 'md/reshape_position' (which
> need to
> use sysfs_notify for).

Yes, I agree here.

> For the second .... I don't know.
> - Maybe sync_action could change to 'paused' and mdmon writes
> 'continue'....
>   but that is possibly overloading that file too much.
> - We could have a new sysfs file which just shows paused/active ??
> - We could require that mdmon sets 'sync_max' appropriately so that
> reshape
>   will stop at the right place, and then when mdmon has updated the
> metadata,
>   it sets a new sync_max value.
> - As above, but if sync_max is set too high, it is automatically
> reduced
>   to the place when raid5 finds that it has to stop
> 
> I think the last one is probably best.
> Before updating ->reshape_position, raid5 checks ->resync_max and if it
> is
> too high for safety it set is lower to a safer value.
> Then it changes ->reshape_position and calls sysfs_notify.
> 
> mdmon watches for 'reshape_postion' to change.  when it does it updates
> the
> metadata and then writes a larger value to ->resync_max.
> 
> Things can get a little confusing when reshaping to fewer devices as
> reshape_position decreases, but sync_completed always increases and
> sync_max
> is still an 'upper' limit.
> 
> But it should work OK.
> 
> Does that seem reasonable?
> 

Yes, it looks ok to me.
However, I have one doubt:
Let's assume we have child_grow() reshape type:

1. child_grow() performs backup for N stripes and sets 
	resync_max = N * stripe_size

2. md start reshaping

3. For one of the first stripes = M (where M < N) md decides to
   update metadata and notifies mdmon with the new reshape_position = M
   However, before that, it changes resync_max = M so md_do_sync main
   loop will wait for a new resync_max value.

4. mdmon wakes on reshape_position, updates meta and it should
   set the new value for resync_max to confirm the checkpoint.
   I think that resync_max should be set to N at this moment but mdmon
   is not able to do that... 
   it does not know the original resync_max value (set in Grow.c)

what do you think?

Maybe using other sysfs file would be better?
I would vote for "resync_start" = "continue" or something like that.. :)


Maciek.
