From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/5] FIX: set delta_disks to 0 for raid5->raid0
 transition
Date: Tue, 15 Feb 2011 19:58:17 +1100
Message-ID: <20110215195817.4eb5fb00@notabene.brown>
References: <20110214130213.8540.57401.stgit@gklab-128-013.igk.intel.com>
	<20110214131249.8540.73388.stgit@gklab-128-013.igk.intel.com>
	<20110215113206.4677e95d@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D178E61207@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D178E61207@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Tue, 15 Feb 2011 08:30:22 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> 
> 
> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Tuesday, February 15, 2011 1:32 AM
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > Neubauer, Wojciech
> > Subject: Re: [PATCH 1/5] FIX: set delta_disks to 0 for raid5->raid0
> > transition
> > 
> > On Mon, 14 Feb 2011 14:12:49 +0100 Adam Kwolek <adam.kwolek@intel.com>
> > wrote:
> > 
> > > We have to set proper value of delta_disks to avoid it wrongly being
> > set
> > > when it value remains UnSet for this level transition (Grow.c:1224).
> > >
> > > This causes too small value set to "raid_disks" in sysfs
> > > and reshape raid5->raid0 fails.
> > >
> > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > > ---
> > >
> > >  Grow.c |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/Grow.c b/Grow.c
> > > index 424d489..dba2825 100644
> > > --- a/Grow.c
> > > +++ b/Grow.c
> > > @@ -1073,6 +1073,7 @@ char *analyse_change(struct mdinfo *info,
> > struct reshape *re)
> > >  		switch (info->new_level) {
> > >  		case 0:
> > >  			delta_parity = -1;
> > > +			info->delta_disks = 0;
> > >  		case 4:
> > >  			re->level = info->array.level;
> > >  			re->before.data_disks = info->array.raid_disks - 1;
> > 
> > I think we have different expectations about what a RAID5 -> RAID0
> > transition
> > means.
> > 
> > To me, it means getting rid of the parity information.  So a 4-device
> > RAID5
> > is converted to a 3-device RAID0 and stays the same size.
> > 
> > I think you want it to maintain the same number of devices, so a 4-
> > device
> > RAID5 becomes a 4-device RAID0 and thus has larger storage.
> > 
> > If you want that, you need to say:
> >    mdadm -G /dev/md/xxx --level=0 --raid-disks=4
> > 
> > I'd be happy with functionality to do:
> > 
> >    mdadm -G /dev/md/xxx --level=0 --raid-disks=nochange
> > 
> > or something like that so it could be easily scripted easily, but I
> > want the
> > default to do the simplest possible change.
> > 
> > Am I correct about your expectations?
> 
> Yes you are right.
> Working in the way you described above, will probably need a change in md or mdadm should degrade array after reshape (before takeover).
> If I recall takeover code correctly, to execute takeover from raid4/5->raid0, raid4/5 has to be a degraded array.
> This a reason I've make no changes to raid_disks number, as such behavior seams fit current implementation. 
> 
> Please let me know the direction you think we should go.
> 

I don't understand....
Working "the way I described" is just a slightly different way that arguments
passed to mdadm are interpreted.  The underlying process can still happen
exactly the same way - you just have to ask for it slightly differently.  No
change in md or mdadm required.

In any case, care is required if the RAID5 array goes degraded before you
switch it to RAID0.  The sensible thing would probably be to leave it in
RAID4 as the final switch to RAID0 would effectively destroy all your data.
I suspect the kernel wouldn't allow the final switch if the RAID5 were
degraded.

The direction that I want to go is exactly as stated above.  If no explicit
request is made to set the new value for raid-disks, then the change made
should be the simplest possible - leaving the number of data-disks unchanged.

NeilBrown
