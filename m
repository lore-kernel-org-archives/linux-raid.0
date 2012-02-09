From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 08/12] FIX: use md position to reshape restart
Date: Thu, 9 Feb 2012 09:49:01 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A0987B0@IRSMSX101.ger.corp.intel.com>
References: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
	<20120207140359.20627.10861.stgit@gklab-128-013.igk.intel.com>
	<20120209123625.13dd5ae4@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A0986DE@IRSMSX101.ger.corp.intel.com>
 <20120209201903.24b899fb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120209201903.24b899fb@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Dorau, Lukasz" <lukasz.dorau@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Thursday, February 09, 2012 10:19
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin; Williams, Dan
> J; Dorau, Lukasz
> Subject: Re: [PATCH 08/12] FIX: use md position to reshape restart
> 
> On Thu, 9 Feb 2012 08:16:16 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
> wrote:
> 
> >
> >
> > > -----Original Message-----
> > > From: NeilBrown [mailto:neilb@suse.de]
> > > Sent: Thursday, February 09, 2012 02:36
> > > To: Kwolek, Adam
> > > Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin;
> > > Williams, Dan J; Dorau, Lukasz
> > > Subject: Re: [PATCH 08/12] FIX: use md position to reshape restart
> > >
> > > On Tue, 07 Feb 2012 15:03:59 +0100 Adam Kwolek
> > > <adam.kwolek@intel.com>
> > > wrote:
> > >
> > > > When reshape is broken, it can occur that metadata is not saved properly.
> > > > This can cause that reshape process is farther in md than metadata states.
> > > >
> > > > On reshape restart use md position as start position, if it is
> > > > farther than position specified in metadata. Opposite situation treat as
> error.
> > > >
> > > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > > > ---
> > > >
> > > >  Grow.c |   86 +++++++++++++++++++++++++++++++++++++++++++++------
> -----
> > > --------
> > > >  1 files changed, 60 insertions(+), 26 deletions(-)
> > > >
> > > > diff --git a/Grow.c b/Grow.c
> > > > index 70bdee1..0668a16 100644
> > > > --- a/Grow.c
> > > > +++ b/Grow.c
> > > > @@ -1862,6 +1862,55 @@ release:
> > > >  	return rv;
> > > >  }
> > > >
> > > > +/* verify_reshape_position()
> > > > + *	Function checks if reshape position in metadata is not farther
> > > > + *	than position in md.
> > > > + * Return value:
> > > > + *	 0 : not valid sysfs entry
> > > > + *		it can be caused by not started reshape, it should be
> started
> > > > + *		by reshape array or raid0 array is before takeover
> > > > + *	-1 :	error, reshape position is obviously wrong
> > > > + *	 1 :	success, reshape progress correct or updated
> > > > +*/
> > > > +static int verify_reshape_position(struct mdinfo *info, int level) {
> > > > +	int ret_val = 0;
> > > > +	char buf[40];
> > > > +
> > > > +	/* read sync_max, failure can mean raid0 array */
> > > > +	if (sysfs_get_str(info, NULL, "sync_max", buf, 40) > 0) {
> > > > +		char *ep;
> > > > +		unsigned long long position = strtoull(buf, &ep, 0);
> > > > +
> > > > +		dprintf(Name": Read sync_max sysfs entry is: %s\n", buf);
> > > > +		if (!(ep == buf || (*ep != 0 && *ep != '\n' && *ep != ' '))) {
> > > > +			position *= get_data_disks(level,
> > > > +						   info->new_layout,
> > > > +						   info->array.raid_disks);
> > > > +			if (info->reshape_progress < position) {
> > > > +				dprintf("Corrected reshape progress (%llu) to "
> > > > +					"md position (%llu)\n",
> > > > +					info->reshape_progress, position);
> > > > +				info->reshape_progress = position;
> > > > +				ret_val = 1;
> > > > +			} else if (info->reshape_progress > position) {
> > > > +				fprintf(stderr, Name ": Fatal error: array "
> > > > +					"reshape was not properly frozen "
> > > > +					"(expected reshape position is %llu, "
> > > > +					"but reshape progress is %llu.\n",
> > > > +					position, info->reshape_progress);
> > > > +				ret_val = -1;
> > > > +			} else {
> > > > +				dprintf("Reshape position in md and metadata "
> > > > +					"are the same;");
> > > > +				ret_val = 1;
> > > > +			}
> > > > +		}
> > > > +	}
> > > > +
> > > > +	return ret_val;
> > > > +}
> > > > +
> > > >  static int reshape_array(char *container, int fd, char *devname,
> > > >  			 struct supertype *st, struct mdinfo *info,
> > > >  			 int force, struct mddev_dev *devlist, @@ -2251,9
> > > +2300,16 @@
> > > > started:
> > > >
> > > >  	sra->new_chunk = info->new_chunk;
> > > >
> > > > -	if (restart)
> > > > +	if (restart) {
> > > > +		/* for external metadata checkpoint saved by mdmon can be
> > > lost
> > > > +		 * or missed /due to e.g. crash/. Check if md is not during
> > > > +		 * restart farther than metadata points to.
> > > > +		 * If so, this means metadata information is obsolete.
> > > > +		 */
> > > > +		if (st->ss->external)
> > > > +			verify_reshape_position(info, reshape.level);
> > > >  		sra->reshape_progress = info->reshape_progress;
> > > > -	else {
> > > > +	} else {
> > > >  		sra->reshape_progress = 0;
> > > >  		if (reshape.after.data_disks < reshape.before.data_disks)
> > > >  			/* start from the end of the new array */ @@ -3765,8
> > > +3821,6 @@
> > > > int Grow_continue_command(char *devname, int fd,
> > > >  	char buf[40];
> > > >  	int cfd = -1;
> > > >  	int fd2 = -1;
> > > > -	char *ep;
> > > > -	unsigned long long position;
> > > >
> > > >  	dprintf("Grow continue from command line called for %s\n",
> > > >  		devname);
> > > > @@ -3894,28 +3948,8 @@ int Grow_continue_command(char *devname,
> > > > int
> > > fd,
> > > >  	/* verify that array under reshape is started from
> > > >  	 * correct position
> > > >  	 */
> > > > -	ret_val = sysfs_get_str(content, NULL, "sync_max", buf, 40);
> > > > -	if (ret_val <= 0) {
> > >                     ^^^
> > >
> > > This test is '<=' however ...
> > >
> > >
> > > > -		fprintf(stderr, Name
> > > > -			": cannot open verify reshape progress for %s (%i)\n",
> > > > -			content->sys_name, ret_val);
> > > > -		ret_val = 1;
> > > > -		goto Grow_continue_command_exit;
> > > > -	}
> > > > -	dprintf(Name ": Read sync_max sysfs entry is: %s\n", buf);
> > > > -	position = strtoull(buf, &ep, 0);
> > > > -	if (ep == buf || (*ep != 0 && *ep != '\n' && *ep != ' ')) {
> > > > -		fprintf(stderr, Name ": Fatal error: array reshape was"
> > > > -			" not properly frozen\n");
> > > > -		ret_val = 1;
> > > > -		goto Grow_continue_command_exit;
> > > > -	}
> > > > -	position *= get_data_disks(map_name(pers, mdstat->level),
> > > > -				   content->new_layout,
> > > > -				   content->array.raid_disks);
> > > > -	if (position != content->reshape_progress) {
> > > > -		fprintf(stderr, Name ": Fatal error: array reshape was"
> > > > -			" not properly frozen.\n");
> > > > +	if (verify_reshape_position(content,
> > > > +				    map_name(pers, mdstat->level)) < 0) {
> > >
> > > ^^
> > >
> > > this one is just '<'.  However it looks like it should be the same.
> > >
> > > Was there a reason for the change, or was it an oversight?
> > >
> > > Thanks,
> > > NeilBrown
> > >
> > >
> > >
> > >
> > > >  		ret_val = 1;
> > > >  		goto Grow_continue_command_exit;
> > > >  	}
> >
> >
> > Removed code is put in to function verify_reshape_position() for use
> > in current location and reshape_array(), as calculated new position in
> Grow_continue_command() cannot be passed to reshape_array(), it has to be
> calculated again.
> >
> > This is what you are mention above?
> 
> Not exactly.
> 
> The original code would print an error if
>       sysfs_get_str(content, NULL, "sync_max", buf, 40); returns 0 or negative.
> The new code will not print an error if that returns zero.
> 
> i.e. you changed a '<=' into a '<'.  I wondered if there was some reason for that -
> something that I was missing.
> 
> NeilBrown

Yes, you are right. I've missed '0' case during code reorganization.
You would fix this or you want me to post additional patch?

BR
Adam



