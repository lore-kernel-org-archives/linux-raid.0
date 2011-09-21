From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 12/14] Early reshape backup verification
Date: Wed, 21 Sep 2011 07:33:15 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A0324FC@IRSMSX101.ger.corp.intel.com>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
	<20110916115518.5201.5649.stgit@gklab-128-013.igk.intel.com>
 <20110921123120.5021dd84@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110921123120.5021dd84@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Wednesday, September 21, 2011 4:31 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin
> Subject: Re: [PATCH 12/14] Early reshape backup verification
> 
> On Fri, 16 Sep 2011 13:55:18 +0200 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > Ever reshape needs to backup its critical section. For this purposes
> > backup file or external metadata mechanisms can be used.
> 
> This is not correct.

You are right.

BR
Adam


> For internal metadata the critical section can be stored on a spare device, and
> this is preferred where possible.
> 
> So it is not the case that you must have a backup_file for non-external data.
> 
> NeilBrown
> 
> 
> >
> > Add verification if backup file or metadata mechanisms can have chance
> > to restore data form backup.
> > For native metadata existence of passed (from command line) backup
> > file is checked. For external metadta manage_reshape() and
> > recover_backup() are tested for this purposes.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> >  Grow.c |   12 ++++++++++++
> >  1 files changed, 12 insertions(+), 0 deletions(-)
> >
> > diff --git a/Grow.c b/Grow.c
> > index fa22382..d54b8a8 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -3667,6 +3667,18 @@ int Grow_continue_command(char *devname,
> int fd,
> >  			devname);
> >  		return 1;
> >  	}
> > +
> > +	/* request backup file
> > +	 * when no metadta specific backup action is defined
> > +	 */
> > +	if ((backup_file == NULL) &&
> > +	    ((st->ss->manage_reshape == NULL) ||
> > +	     (st->ss->recover_backup == NULL))) {
> > +		fprintf(stderr, Name ": Please provide backup file "
> > +			"for reshape continuation.\n");
> > +		return 1;
> > +	}
> > +
> >  	dprintf("Grow continue is run for ");
> >  	if (st->ss->external == 0) {
> >  		dprintf("native array (%s)\n", devname);
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in the body of a message to majordomo@vger.kernel.org More
> majordomo
> > info at  http://vger.kernel.org/majordomo-info.html

