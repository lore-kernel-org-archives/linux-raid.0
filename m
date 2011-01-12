From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 02/13] imsm: FIX: allow for container reshape any unset
 size value
Date: Wed, 12 Jan 2011 08:32:10 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176E1A820@irsmsx503.ger.corp.intel.com>
References: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
	<20110110112742.10776.5211.stgit@gklab-128-013.igk.intel.com>
 <20110112145253.63d55739@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110112145253.63d55739@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Wednesday, January 12, 2011 4:53 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH 02/13] imsm: FIX: allow for container reshape any
> unset size value
> 
> On Mon, 10 Jan 2011 12:27:42 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > Any request for no size change has to be accepted.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> >  super-intel.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/super-intel.c b/super-intel.c
> > index d70a7df..58a776e 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -6322,7 +6322,7 @@ static int
> imsm_reshape_is_allowed_on_container(struct supertype *st,
> >  		"st->devnum = (%i)\n",
> >  		st->devnum);
> >
> > -	if (geo->size != -1 ||
> > +	if (geo->size >= 0 ||
> >  	    geo->level != UnSet ||
> >  	    geo->layout != UnSet ||
> >  	    geo->chunksize != 0 ||
> 
> 
> As far as I can tell, this is a not op.
> 'size' will only ever be -1, 0, or positive.
> Given that, "size != -1" and "size >= 0" produce identical results.
> 
> If there is some way that 'size' can be some other negative number, we
> should
> fix that.
> 
> NeilBrown

This issue can be addressed in the following way:

From ce0a720c162c425ae46684ac7866f7076e65d5e5 Mon Sep 17 00:00:00 2001
From: Adam Kwolek <adam.kwolek@intel.com>
Date: Wed, 12 Jan 2011 09:23:53 +0100
Subject: [PATCH] FIX: size is passed incorrectly

reshape_super() called from reshape_container() with size set to info->component_size
gives size in reshape_super == -2 due to unsigned signed conversion
(info->component_size is not initializes).

As size is not changed during container reshape '-1' value is passed to indicate this.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 4cbe427..466d546 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2120,7 +2120,7 @@ int reshape_container(char *container, int cfd, char *devname,
 {
 	struct mdinfo *cc = NULL;
 
-	if (reshape_super(st, info->component_size, info->new_level,
+	if (reshape_super(st, -1, info->new_level,
 			  info->new_layout, info->new_chunk,
 			  info->array.raid_disks + info->delta_disks,
 			  backup_file, devname, quiet))
-- 
1.6.0.2

