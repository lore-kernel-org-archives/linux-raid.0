From: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Subject: RE: [PATCH 4/6] FIX: Remove disks in mdmon for external metadata
Date: Wed, 26 Jan 2011 13:00:49 +0000
Message-ID: <BE2BFE91933D1B4089447C644860408066FF062B@irsmsx503.ger.corp.intel.com>
References: <20110119161925.8738.85284.stgit@gklab-128-111.igk.intel.com>
	<20110119162333.8738.79313.stgit@gklab-128-111.igk.intel.com>
 <20110126110429.144b9aab@nbeee.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110126110429.144b9aab@nbeee.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Wednesday, January 26, 2011 2:04 AM
> To: Wojcik, Krzysztof
> Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech; Kwolek, Adam;
> Williams, Dan J; Ciechanowski, Ed
> Subject: Re: [PATCH 4/6] FIX: Remove disks in mdmon for external
> metadata
> 
> On Wed, 19 Jan 2011 17:23:33 +0100
> Krzysztof Wojcik <krzysztof.wojcik@intel.com> wrote:
> 
> > For raid10 -> raid0 takeover operation we shoud reject disks
> > in mirror by mark them as 'failed' and then remove them from
> > array.
> > For external metadata second action should be execuded by
> > mdmon so additional condition is necessary.
> 
> I don't understand this..
> I think you are saying that removing failed devices should be done by
> mdmon rather than mdadm.  Is that what you are saying?
> I don't think that is correct.  WHY do you want to make this change?
> What is not working that should.
> 
> NeilBrown

Hi,

According the description in monitor.c:175 when monitor detect "faulty" in device state, it blocks the device, mark it as failed in metadata, unblocks the device and finally writes "remove" to device state.
So writing "remove" to device state in mdadm is not necessary- all operations connected with removing disk are supported by monitor. 
Moreover write operation in mdadm is not successful because monior is blocking the device.

Krzysztof Wojcik

> 
> >
> > Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> > ---
> >  Grow.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> >
> > diff --git a/Grow.c b/Grow.c
> > index 78d5b0e..c5f83a8 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -711,7 +711,9 @@ int
> > remove_disks_on_raid10_to_raid0_takeover(struct supertype *st,
> >  		sysfs_set_str(sra, sd, "state", "faulty");
> >  		sysfs_set_str(sra, sd, "slot", "none");
> > -		sysfs_set_str(sra, sd, "state", "remove");
> > +		/* for external metadata disks should be removed in
> > mdmon */
> > +		if (!st->ss->external)
> > +			sysfs_set_str(sra, sd, "state", "remove");
> >  		sd->disk.state |= (1<<MD_DISK_REMOVED);
> >  		sd->disk.state &= ~(1<<MD_DISK_SYNC);
> >  		sd->next = sra->devs;

