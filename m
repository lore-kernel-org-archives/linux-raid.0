From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 1/3] Always run Grow_continue() for started array.
Date: Wed, 5 Oct 2011 07:04:01 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A0368E5@IRSMSX101.ger.corp.intel.com>
References: <20111004155129.27434.81564.stgit@gklab-128-013.igk.intel.com>
	<20111004155349.27434.70639.stgit@gklab-128-013.igk.intel.com>
 <20111005135909.13fe29d9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111005135909.13fe29d9@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Wednesday, October 05, 2011 4:59 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin; Williams,
> Dan J
> Subject: Re: [PATCH 1/3] Always run Grow_continue() for started array.
> 
> On Tue, 04 Oct 2011 17:53:49 +0200 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > So far there were 2 reshape continuation cases:
> >  1. array is started /e.g. reshape was already invoked during initrd
> >                       start-up stage using "--freeze-reshape" option/
> > 2. array is not started yet /"normal" assembling array under reshape
> > case/
> >
> > This patch narrows continuation cases in to single one. To do this
> > array should be started /set readonly in to array_state/ before
> > calling
> > Grow_continue() function.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> 
> I mostly like this patch.
> However it seems to have lost something in Grow_continue.
> The distinction between ->reshape_active==1 and ->reshape_active==2 is
> lost.
> 
> ==1 means just this array is in the middle of a reshape.
> ==2 means that the whole container is being reshaped and after this array is
> done we need to move on to the next one.
> 
> Was there are reason you removed that?  If not, please put it back.

In both cases metadata is updated already and container _reshape() goes (somehow) directly to reshape array.
In container reshape case mdmon moves changes to next array for reshape and container_reshape() will continue with next one.

In case that single array is reshaped only mdmon finalizes reshape and container_reshape() finds no more arrays under reshape,
So this would means end of work also.

In my opinion during reshape continuation we do not need to know if this is container or single array reshape,
Both cases can be handled by container_reshape() /external metadata/ and we do not need to track what kind of reshape occurs.

Let me know your opinion.

BR
Adam

> 
> Thanks,
> NeilBrown
> 
> 
> > ---
> >
> >  Assemble.c |   17 +++++++++++++----
> >  Grow.c     |   43 +++++++++++++++++++------------------------
> >  2 files changed, 32 insertions(+), 28 deletions(-)
> >
> > diff --git a/Assemble.c b/Assemble.c
> > index 4511f4d..0d3730b 100644
> > --- a/Assemble.c
> > +++ b/Assemble.c
> > @@ -1343,10 +1343,14 @@ int Assemble(struct supertype *st, char
> *mddev,
> >  			int rv;
> >  #ifndef MDASSEMBLE
> >  			if (content->reshape_active &&
> > -			    content->delta_disks <= 0)
> > -				rv = Grow_continue(mdfd, st, content,
> > -						   backup_file,
> freeze_reshape);
> > -			else
> > +			    content->delta_disks <= 0) {
> > +				rv = sysfs_set_str(content, NULL,
> > +						   "array_state", "readonly");
> > +				if (rv == 0)
> > +					rv = Grow_continue(mdfd, st,
> content,
> > +							   backup_file,
> > +							   freeze_reshape);
> > +			} else
> >  #endif
> >  				rv = ioctl(mdfd, RUN_ARRAY, NULL);
> >  			if (rv == 0) {
> > @@ -1561,6 +1565,11 @@ int assemble_container_content(struct
> supertype *st, int mdfd,
> >  					   spare, backup_file, verbose) == 1)
> >  				return 1;
> >
> > +			err = sysfs_set_str(content, NULL,
> > +					    "array_state", "readonly");
> > +			if (err)
> > +				return 1;
> > +
> >  			err = Grow_continue(mdfd, st, content, backup_file,
> >  					    freeze_reshape);
> >  		} else switch(content->array.level) { diff --git a/Grow.c
> b/Grow.c
> > index 0b58d5e..076375a 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -3797,33 +3797,28 @@ Grow_continue_command_exit:
> >  int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
> >  		  char *backup_file, int freeze_reshape)  {
> > -	char buf[40];
> > -	char *container = NULL;
> > -	int err;
> > +	int ret_val = 2;
> > +
> > +	if (!info->reshape_active)
> > +		return ret_val;
> >
> > -	err = sysfs_set_str(info, NULL, "array_state", "readonly");
> > -	if (err)
> > -		return err;
> >  	if (st->ss->external) {
> > -		fmt_devname(buf, st->container_dev);
> > -		container = buf;
> > +		char container[40];
> > +		int cfd = open_dev(st->container_dev);
> >
> > -		if (!mdmon_running(st->container_dev))
> > -			start_mdmon(st->container_dev);
> > -		ping_monitor_by_id(st->container_dev);
> > +		if (cfd < 0)
> > +			return 1;
> >
> > +		fmt_devname(container, st->container_dev);
> > +		st->ss->load_container(st, cfd, container);
> > +		close(cfd);
> > +		ret_val = reshape_container(container, NULL,
> > +					    st, info, 0, backup_file,
> > +					    0, 1, freeze_reshape);
> > +	} else
> > +		ret_val = reshape_array(NULL, mdfd, "array", st, info, 1,
> > +					NULL, backup_file, 0, 0, 1,
> > +					freeze_reshape);
> >
> > -		if (info->reshape_active == 2) {
> > -			int cfd = open_dev(st->container_dev);
> > -			if (cfd < 0)
> > -				return 1;
> > -			st->ss->load_container(st, cfd, container);
> > -			close(cfd);
> > -			return reshape_container(container, NULL,
> > -						 st, info, 0, backup_file,
> > -						 0, 1, freeze_reshape);
> > -		}
> > -	}
> > -	return reshape_array(container, mdfd, "array", st, info, 1,
> > -			     NULL, backup_file, 0, 0, 1, freeze_reshape);
> > +	return ret_val;
> >  }
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in the body of a message to majordomo@vger.kernel.org More
> majordomo
> > info at  http://vger.kernel.org/majordomo-info.html

