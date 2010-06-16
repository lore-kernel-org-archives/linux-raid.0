From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [md PATCH 1/5] md: Fix: max_disks limit set for external
 metadata
Date: Wed, 16 Jun 2010 12:25:21 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11F295EC9@irsmsx503.ger.corp.intel.com>
References: <905EDD02F158D948B186911EB64DB3D11EECE89E@irsmsx503.ger.corp.intel.com>
 <20100616145030.4ed80d70@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100616145030.4ed80d70@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Wednesday, June 16, 2010 6:51 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed
> Subject: Re: [md PATCH 1/5] md: Fix: max_disks limit set for external
> metadata
> 
> On Wed, 9 Jun 2010 15:20:37 +0100
> "Kwolek, Adam" <adam.kwolek@intel.com> wrote:
> 
> > (md: Online Capacity Expansion for IMSM) If max_disks limit is not
> > set, md doesn't allow for reconfiguration and starting reshape. For
> external metadata this limit is not set.
> > It is set for native meta during metadata reading.
> > Limit max_disks is not used for external meta, so we can set it to
> value (MD_SB_DISKS) that will not block reshape.
> > ---
> >
> >  drivers/md/md.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c index dfbba92..9cec771
> > 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -5380,6 +5380,8 @@ static int update_raid_disks(mddev_t *mddev,
> int raid_disks)
> >  	/* change the number of raid disks */
> >  	if (mddev->pers->check_reshape == NULL)
> >  		return -EINVAL;
> > +	if (mddev->external)
> > +		mddev->max_disks = MD_SB_DISKS;
> >  	if (raid_disks <= 0 ||
> >  	    raid_disks >= mddev->max_disks)
> >  		return -EINVAL;
> >
> 
> 
> commit 233fca36bb439eadcad28500b5139fed7c64a0ae
> should make this unnecessary.
> 
> NeilBrown

Yes, you are right.
Commit you pointed makes this patch unnecessary.

BR
Adam
