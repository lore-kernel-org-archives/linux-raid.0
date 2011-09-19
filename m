From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 01/14] Stop array reshape when mounted initramfs is
 detected
Date: Mon, 19 Sep 2011 11:14:35 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A023D73@IRSMSX101.ger.corp.intel.com>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
	<20110916115354.5201.38688.stgit@gklab-128-013.igk.intel.com>
 <20110919204220.2a2418a5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110919204220.2a2418a5@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Monday, September 19, 2011 12:42 PM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin
> Subject: Re: [PATCH 01/14] Stop array reshape when mounted initramfs is
> detected
> 
> On Fri, 16 Sep 2011 13:53:54 +0200 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > During remounting file system from initramfs to real one, mdadm is not
> > able to continue reshape procedure due to lost filesystem context.
> > To avoid this mdadm detects mounted initramfs and performs critical
> > section restore only. Array is set for later reshape continuation.
> >
> > Reshape continuation will be possible to invoking manually, using
> > '--continue' option.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> >  Grow.c  |   25 +++++++++++++++++++++++--
> >  mdadm.h |    4 ++++
> >  util.c  |   22 ++++++++++++++++++++++
> >  3 files changed, 49 insertions(+), 2 deletions(-)
> >
> > diff --git a/Grow.c b/Grow.c
> > index 17d14b6..420177c 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -635,10 +635,21 @@ static int subarray_set_num(char *container,
> struct mdinfo *sra, char *name, int
> >  	return rc;
> >  }
> >
> > +/* possible return values:
> > + * 0 : success
> > + * -1: error
> > + * INITRAMFS_IS_IN_USE: continue reshape later  */
> >  int start_reshape(struct mdinfo *sra, int already_running)  {
> >  	int err;
> > -	sysfs_set_num(sra, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
> > +
> > +	/* do not block array as we not continue reshape this time
> > +	 */
> > +	if (initramfs_is_in_use() == INITRAMFS_NOT_USED)
> > +		sysfs_set_num(sra, NULL, "suspend_lo",
> 0x7FFFFFFFFFFFFFFFULL);
> > +	else
> > +		sysfs_set_num(sra, NULL, "suspend_lo", 0);
> >  	err = sysfs_set_num(sra, NULL, "suspend_hi", 0);
> >  	err = err ?: sysfs_set_num(sra, NULL, "suspend_lo", 0);
> >  	if (!already_running)
> > @@ -2190,6 +2201,14 @@ started:
> >  	}
> >  	if (restart)
> >  		sysfs_set_str(sra, NULL, "array_state", "active");
> > +	if (initramfs_is_in_use() == INITRAMFS_IS_IN_USE) {
> > +		free(fdlist);
> > +		free(offsets);
> > +		sysfs_free(sra);
> > +		fprintf(stderr, Name ": Reshape has to be continued "
> > +			"when root fileststem will be mounted\n");
> > +		return 1;
> > +	}
> >
> >  	/* Now we just need to kick off the reshape and watch, while
> >  	 * handling backups of the data...
> > @@ -2357,7 +2376,9 @@ int reshape_container(char *container, char
> *devname,
> >  		unfreeze(st);
> >  		return 1;
> >  	default: /* parent */
> > -		printf(Name ": multi-array reshape continues in
> background\n");
> > +		if (initramfs_is_in_use() == INITRAMFS_NOT_USED)
> > +			printf(Name ": multi-array reshape continues "
> > +			       "in background\n");
> >  		return 0;
> >  	case 0: /* child */
> >  		break;
> > diff --git a/mdadm.h b/mdadm.h
> > index d616966..9035e67 100644
> > --- a/mdadm.h
> > +++ b/mdadm.h
> > @@ -1161,6 +1161,10 @@ extern char *human_size(long long bytes);
> > extern char *human_size_brief(long long bytes);  extern void
> > print_r10_layout(int layout);
> >
> > +extern int initramfs_is_in_use(void);
> > +#define INITRAMFS_IS_IN_USE		1
> > +#define INITRAMFS_NOT_USED		0
> > +
> >  #define NoMdDev (1<<23)
> >  extern int find_free_devnum(int use_partitions);
> >
> > diff --git a/util.c b/util.c
> > index 0ea7e0d..7186f3f 100644
> > --- a/util.c
> > +++ b/util.c
> > @@ -1768,3 +1768,25 @@ struct mdinfo *container_choose_spares(struct
> supertype *st,
> >  	}
> >  	return disks;
> >  }
> > +
> > +int initramfs_is_in_use(void)
> > +{
> > +	int ret_val;
> > +	struct stat sts;
> > +
> > +	/* /init
> > +	 *	common script for many Linux distribution
> > +	 * /sysboot
> > +	 *	is specific for RH
> > +	 * /mkinitrd.config
> > +	 *	is specific for SLES
> > +	 */
> > +	if ((stat("/init", &sts) == -1) ||
> > +	    ((stat("/sysroot", &sts) == -1) &&
> > +	     (stat("/mkinitrd.config", &sts) == -1)))
> > +		ret_val = INITRAMFS_NOT_USED;
> > +	else
> > +		ret_val = INITRAMFS_IS_IN_USE;
> > +
> > +	return ret_val;
> > +}
> >
> 
> Hi,
>  I meant to look through this today but didn't manage to get to it.
> 
> However an easy comment is that this initramfs_is_in_use is not
> acceptable.
> You are measuring symptoms and not the cause.
> 
> Unfortunately it isn't really easy to measure "Is someone likely to want
> to replace the current root filesystem with a different one soon".
> 
> In the first instance I think this should be implemented as a command
> line
> option:  --freeze-reshape maybe.  It is understood with --assemble to
> mean that any reshape should not be continued.
> It should be possible to get that into the mdadm flags during initrd but
> not in the root filesystem.
> 
> The second patch looks like it should be combined with the first.
> 
> The rest seems OK at a first glance but I'll need to review it more
> carefully.
> 
> Thanks,
> NeilBrown

Thank you for the first part of the review.

I was worry about file system detection I've made, and you confirms my doubts.
I like your idea about another option for reshape freeze at the early boot stage.
I'll include it in second approach.

I'm waiting for rest of your review.
When I'll get it, I'll prepare updated fix.

BR
Adam

