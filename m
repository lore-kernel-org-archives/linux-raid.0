From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH] FIX: reshape_active flag is always set for external
 metadata
Date: Thu, 27 Jan 2011 07:56:15 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176FD925B@irsmsx503.ger.corp.intel.com>
References: <20110120155231.9026.34311.stgit@gklab-128-013.igk.intel.com>
 <20110127130717.5da65455@nbeee.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110127130717.5da65455@nbeee.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Thursday, January 27, 2011 4:07 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH] FIX: reshape_active flag is always set for
> external metadata
> 
> On Thu, 20 Jan 2011 16:52:31 +0100
> Adam Kwolek <adam.kwolek@intel.com> wrote:
> 
> > For external metadata based on reshape_active flag is taken decision
> > about reshape when it is equal to 1. At this momenta mdadm cannot
> > give up when this flag is set for external metadata.
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
> 
> This is a bit too simplistic.  I have applied a patch which is
> (hopefully) more thorough.
> 
> Thanks,
> NeilBrown

Your patch is OK.

Thanks
Adam

> 
> >  		/* nothing needed here */;
> >  	else if (info->array.chunk_size == info->new_chunk &&
> >  	    reshape.before.layout == reshape.after.layout &&
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

