From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 15/53] FIX: Unfreeze not only container for external
 metadata
Date: Tue, 30 Nov 2010 16:03:54 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174C8AB5A@irsmsx503.ger.corp.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
	<20101126080545.5221.8247.stgit@gklab-170-024.igk.intel.com>
 <20101129104844.2ec7efd3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101129104844.2ec7efd3@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

You missed nothing ;), I'm removing this patch.

BR
Adam


> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Monday, November 29, 2010 12:49 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed
> Subject: Re: [PATCH 15/53] FIX: Unfreeze not only container for
> external metadata
> 
> On Fri, 26 Nov 2010 09:05:45 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > Unfreeze for external metadata case should unfreeze arrays and
> container,
> > not only container as so far. Unfreeze() function doesn't know
> > what the changes to configuration was made so far, and if arrays
> > are pulled from frozen state in md.
> > Unfreeze() has to make sure by performing array unfreeze that all
> arrays
> > are not frozen and then unblock monitor.
> 
> unfreeze for external metadata case *does* unfreeze the arrays.
> unfreeze_container calls unblock_monitor which calls unblock_subarray
> for each subarray.
> 
> So I cannot see that this patch changes anything.  What have I missed?
> 
> NeilBrown
> 
> 
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> >  Grow.c |   18 ++++++++----------
> >  1 files changed, 8 insertions(+), 10 deletions(-)
> >
> > diff --git a/Grow.c b/Grow.c
> > index 4060129..8ca1812 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -495,16 +495,14 @@ static void unfreeze(struct supertype *st, int
> frozen)
> >  		return;
> >
> >  	if (st->ss->external)
> > -		return unfreeze_container(st);
> > -	else {
> > -		struct mdinfo *sra = sysfs_read(-1, st->devnum,
> GET_VERSION);
> > -
> > -		if (sra)
> > -			sysfs_set_str(sra, NULL, "sync_action", "idle");
> > -		else
> > -			fprintf(stderr, Name ": failed to unfreeze array\n");
> > -		sysfs_free(sra);
> > -	}
> > +		unfreeze_container(st);
> > +
> > +	struct mdinfo *sra = sysfs_read(-1, st->devnum, GET_VERSION);
> > +	if (sra)
> > +		sysfs_set_str(sra, NULL, "sync_action", "idle");
> > +	else
> > +		fprintf(stderr, Name ": failed to unfreeze array\n");
> > +	sysfs_free(sra);
> >  }
> >
> >  static void wait_reshape(struct mdinfo *sra)

