From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 10/14] Perform restore backup for reshape continuation
Date: Wed, 21 Sep 2011 07:35:21 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A032516@IRSMSX101.ger.corp.intel.com>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
	<20110916115503.5201.11096.stgit@gklab-128-013.igk.intel.com>
 <20110921122956.6786fc86@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110921122956.6786fc86@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Wednesday, September 21, 2011 4:30 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin
> Subject: Re: [PATCH 10/14] Perform restore backup for reshape continuation
> 
> On Fri, 16 Sep 2011 13:55:03 +0200 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > It can happen that reshape is broken by different reason than reboot.
> > this means that on reshape continuation start we cannot be sure that
> > critical section has been restored already.
> 
> I don't think this is true.
> 
> If the array is running, then the critical section must have been restored.
> Anything else is simply wrong.
> 
> What scenario are you thinking of here?

You are right. If array is assembled backup is restored already.

BR
Adam

> 
> Thanks,
> NeilBrown
> 
> 
> >
> > Restore data from checkpoint before reshape continuation to avoid data
> > corruption.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> >  Grow.c |   18 +++++++++++++++++-
> >  1 files changed, 17 insertions(+), 1 deletions(-)
> >
> > diff --git a/Grow.c b/Grow.c
> > index 0b96f7a..da8b72d 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -3652,6 +3652,9 @@ int Grow_continue_command(char *devname,
> int fd,
> >  	char container[20];
> >  	int cfd = -1;
> >  	int fd2 = -1;
> > +	int spares;
> > +	int working_disks;
> > +	struct mdinfo *dev;
> >
> >  	dprintf("Grow continue from command line called for %s\n",
> >  		devname);
> > @@ -3753,7 +3756,20 @@ int Grow_continue_command(char *devname,
> int
> > fd,
> >
> >  	/* continue reshape
> >  	 */
> > -	ret_val = Grow_continue(fd, st, content, backup_file);
> > +	dev = content->devs;
> > +	spares = 0;
> > +	working_disks = 0;
> > +	while (dev) {
> > +		if (dev->disk.raid_disk == -1)
> > +			spares++;
> > +		else
> > +			working_disks++;
> > +		dev = dev->next;
> > +	}
> > +	ret_val = restore_backup(st, content, working_disks, spares,
> > +				 backup_file, verbose);
> > +	if (!ret_val)
> > +		ret_val = Grow_continue(fd, st, content, backup_file);
> >
> >  Grow_continue_command_exit:
> >  	if (fd2 > -1)

