From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH] FIX: reshape_active flag is always set for external
 metadata
Date: Tue, 25 Jan 2011 07:27:51 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176F916F1@irsmsx503.ger.corp.intel.com>
References: <20110120155231.9026.34311.stgit@gklab-128-013.igk.intel.com>
 <20110125080531.0d357815@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110125080531.0d357815@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Monday, January 24, 2011 10:06 PM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH] FIX: reshape_active flag is always set for
> external metadata
> 
> On Thu, 20 Jan 2011 16:52:31 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > For external metadata based on reshape_active flag is taken decision
> about reshape
> > when it is equal to 1. At this momenta mdadm cannot give up when this
> flag is set
> > for external metadata.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> >  Grow.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/Grow.c b/Grow.c
> > index c9f4b9c..f220f50 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -1870,7 +1870,7 @@ started:
> >
> >  	sra->new_chunk = info->new_chunk;
> >
> > -	if (info->reshape_active)
> > +	if ((info->reshape_active) && (st->ss->external == 0))
> >  		/* nothing needed here */;
> >  	else if (info->array.chunk_size == info->new_chunk &&
> >  	    reshape.before.layout == reshape.after.layout &&
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> I can guess why you think you need this, though it is always better to
> say
> explicitly what the problem is that you are fixing.
> 
> But this is the wrong place for the fix.
> 
> I assume this is when you are assembling an array that is in the middle
> of a
> reshape.  For that case, sysfs_set_array (called from set_array_info
> called
> from Assemble) is the place to configure the 'new' geometry of the
> array.
> 
> NeilBrown

It is not assemble case.
This patch is need for container reshape. When I pick up array in container_reshape(), I'm picking array with reshape_active flag set.
Later in reshape array if reshape_active flag is set and  I'm making no configuration (due to reshape_active flag set). 
This configuration is required. I'm not in the middle of reshape.
I've just have updated metadata and now I want to configure. Configuration is guarded by reshape_active flag and it cannot be made.
This leads to OLCE without added disk (raid_disk sysfs entry is not changed).

Reshape_active flag doesn't tell us about reshape position. To skip configuration reshape position should be checked also (or something that indicates that).

I've guarded it by external flag, because in container_reshape for external metadata and reshape_active flag set doesn't mean that we have resuming reshape process.
It means that metadata is ready for reshape only.

Adam

