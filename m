From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 0/5] Make OLCE workeable
Date: Wed, 9 Mar 2011 08:13:42 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A8AEF9F@irsmsx503.ger.corp.intel.com>
References: <20110308132228.9578.34611.stgit@gklab-128-013.igk.intel.com>
 <20110309115312.37a04ad7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: Kwolek, Adam
> Sent: Wednesday, March 09, 2011 8:45 AM
> To: 'NeilBrown'
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: RE: [PATCH 0/5] Make OLCE workeable
> 
> 
> 
> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Wednesday, March 09, 2011 1:53 AM
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > Neubauer, Wojciech
> > Subject: Re: [PATCH 0/5] Make OLCE workeable
> >
> > On Tue, 08 Mar 2011 14:24:29 +0100 Adam Kwolek <adam.kwolek@intel.com>
> > wrote:
> >
> > > This is first part of my comments for your latest changes on devel3-
> 2
> > regarding reshape and reshape restart.
> > > Unfortunately those changes breaks OLCE functionality. This patch
> > series makes OLCE workable (mdadm UT suits 12 and 13 succeed).
> >
> > That's really strange as the patches all look wrong.  I'll do some
> > testing
> > my self and see what I can come up with.
> >
> > >
> > > Problems:
> > > 1. In passing in mdinfo (array.level) raid4 for transition raid0-
> > >raid0.
> > >    This causes problems in takeover
> > >    a.Raid0 takeover doesn't occur. array.level == reshape.level == 4
> > >      Resolution: Decision about takeover has to be made based on
> real
> > md level not info->array.level
> >
> > But takeover doesn't *need* to occur.
> > When we have a RAID0 array and we want to make it grow, we have to
> > 'takeover'
> > to RAID4 first.
> > But when assembling an array that is in the middle of a growth we
> > assemble
> > it as a RAID4 array - so it never was a RAID0 array.  It starts out as
> > RAID4.
> 
> Takeover has to occur during 'normal' reshape (patches doesn't even
> touch restart problem).
> When during normal start mdadm enters reshape_array() metadata is in
> reshape state already (reshape_active == 1)
> This means that in case raid0, raid4 is reported but in md raid0 is
> still present.
> Due to this 'takeover' has to be executed.
> 
> >
> > >    b.Decision about backward takeover cannot be always taken by
> mdadm.
> > mdadm can think that original level is raid4
> > >      Resolution: use level read from md as orig_level (not from
> > metadata)
> >
> > I see that is a problem.   We should record '0' as the 'new_level' and
> > get mdadm to make use of that information.
> 
> This is true for success path. In error case mdadm exits via 'release'
> label, where
> md is switched to orig_level (not new_level). As I remember for
> 'succeess' path it works as you describes already.
> 
> 
> >
> > >
> > > 2.On the begin of reshape_array() array structure is read from md
> (via
> > ioctrl). Md knows nothing about raid4 working level, so spares_needed
> is
> > wrongly computed
> > >   Resolution: use info->array.raid_disks instead array.raid_disks to
> > compute  spares_needed.
> >
> > md certainly should know about RAID4 working level because it is
> > assembled
> > as RAID4.... hopefully some testing will show me what you really mean.
> 
> 
> 
> During assembly - yes, but for regular reshape start no.
> Regular reshape start:
> 1. md knows raid0
> 2. metadata reports raid4 (metadata has reshape_active == 1 already)
> 
> Reshape restart
> 1. md knows raid4
> 2. metadata reports raid4
> 
> 
> >
> > > 3.Analyse_changes() delta_parity concept doesn't match information
> > currently metadata reports. Result of this is wrongly computed
> > reshape.after.data_disks field.
> > >   Resolution: do not use delta_parity, base on information from
> > metadata handle
> >
> > You cannot just remove delta_parity like that.  It is needed when we
> > start
> > a growth.  Maybe it is confusing when we restart a growth - I will
> look
> > in to in.
> 
> It looks for me that when metadata handler takes responsibility for
> reporting
> Different raid level and increasing raid disks by 'delta parity' we
> should not
> Count delta parity in different place.
> If you think that analyse_change() should support both cases:
> 1. reshape handler increases raid_disks by delta parity
> 2. reshape handler doesn't increase raid_disks by delta parity
> 
> I'll fix analyse_changes() for this.

I've have a look at this and problem is as follow:
Configuration during reshape start:
1. md: raid0, n disks
2. metadata: raid4, n+1 disks
3. new_level: raid0, delta_disks = 1

analyse_change() detects transition raid4->raid0 so:
1. delta_parity = -1
2. before.data_disks = n
3. after.data_disks = before.data_disks + delta_disks - delta_parity

This gives: after.raid_disks = n + 2

1. What parity disk has to do with data disks?
2. we have transition raid0->raid0, so data disks has to increase by delta_disks only
   How to differentiate cases:
	a) raid0->raid0
     	b) raid4->raid0
  For both:
  Array.level == 4 and new_level == 0
Pass md level to analyse changes() to make difference or add field to mdinfo (orig_level)?

3. If we set delta_parity to '-1' then I think it should be added (we removing it twice -> this means adding)?

Please let me know your opinion.

BR
Adam

> 
> 
> 
> 
> >
> > > 4.Defects/potential defects
> > >  a.delta_disks should be checked in sysfs_set_array()
> >
> > No it shouldn't.  If delta_disks is UnSet, then the metadata handler
> has
> > done the wrong thing.
> >
> > >  b.array assembly problem
> > > reshape_active flag has to be evaluated. Existing second map doesn't
> > means reshape always (rebuild, initialization)
> >
> > There is no problem here.  I agree with your second sentence, but that
> > code already does this.
> > That first patch in your series makes *no* change to the meaning
> > of the code.
> > Before the patch it is
> >
> >   if (condition) {
> >      variable = 1;
> >      stuff;
> >      ...
> >
> > After the patch it is
> >
> >   variable = condition;
> >   if (variable) {
> >      stuff;
> >      ...
> >
> >
> > which has exactly the same effect.
> 
> Of course you are right !!!, I don't know, how I've look at this
> condition yesterday.
> 
> BR
> Adam
> 
> >
> > So I haven't applied any of these matches as none of them make any
> sense
> > to
> > me - sorry.
> >
> > NeilBrown
> >
> >
> >
> > >
> > > I've tried to follow your idea in this series. Generally it seems ok
> > (proved by UT). I like putting more array configuration in
> > sysfs_set_array().
> > >
> > > Now I'm going to look at patches at the reshape restart point of
> view.
> > > I'll let you know results soon.
> > >
> > > BR
> > > Adam
> > >
> > >
> > > ---
> > >
> > > Adam Kwolek (5):
> > >       FIX: Compute spares_needed basing on metadata info
> > >       FIX: Remove delta_parity concept
> > >       FIX: Allow for takeover
> > >       FIX: Set new raid disks when delta_disks is valid
> > >       fix: array is reassembled inactive if stopped during resync
> > >
> > >
> > >  Grow.c        |   22 +++++-----------------
> > >  super-intel.c |    5 +++--
> > >  sysfs.c       |    4 +++-
> > >  3 files changed, 11 insertions(+), 20 deletions(-)
> > >

