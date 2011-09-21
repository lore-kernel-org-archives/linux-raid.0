From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 13/14] Check if md allows to control reshape
Date: Wed, 21 Sep 2011 07:31:48 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A0324E2@IRSMSX101.ger.corp.intel.com>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
	<20110916115525.5201.42756.stgit@gklab-128-013.igk.intel.com>
 <20110921123338.6ede25bc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110921123338.6ede25bc@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Wednesday, September 21, 2011 4:34 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin
> Subject: Re: [PATCH 13/14] Check if md allows to control reshape
> 
> On Fri, 16 Sep 2011 13:55:25 +0200 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > It can happen that there is no mdadm in memory and 'max' was already
> > set to sync_max. Such array cannot be put under check pointing control
> > again.
> 
> Again I don't understand what you are trying to guard against.
> If resync_max is 'max', then the kernel is allowed to fun reshape to
> completion without any help from mdadm.  If mdadm needs to monitor
> things it always sets resync_max to a smaller value.
> 
> Confused.

In my opinion running reshape continuation on array that is allowed to freely reshape to the end
is race condition (another mdadm or user via sysfs manage this array already).
We can tell nothing about restart point (read from metadata) when md runs with reshape already.
I think we should not allow to attach mdadm to such reshape process.

I think this guard is required.

BR
Adam 

> 
> NeilBrown
> 
> 
> >
> > Verify such situation and refuse to control array in such condition.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> >  Grow.c |   19 +++++++++++++++++++
> >  1 files changed, 19 insertions(+), 0 deletions(-)
> >
> > diff --git a/Grow.c b/Grow.c
> > index d54b8a8..04e6679 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -3656,6 +3656,7 @@ int Grow_continue_command(char *devname,
> int fd,
> >  	int spares;
> >  	int working_disks;
> >  	struct mdinfo *dev;
> > +	char buf[40];
> >
> >  	dprintf("Grow continue from command line called for %s\n",
> >  		devname);
> > @@ -3769,6 +3770,24 @@ int Grow_continue_command(char *devname,
> int fd,
> >  		}
> >  	}
> >
> > +	/* verify that array under reshape is stopped
> > +	 */
> > +	ret_val = sysfs_get_str(content, NULL, "sync_max", buf, 40);
> > +	if (ret_val <= 0) {
> > +		fprintf(stderr, Name
> > +			": cannot open verify reshape progress for %s
> (%i)\n",
> > +			content->sys_name, ret_val);
> > +		ret_val = 1;
> > +		goto Grow_continue_command_exit;
> > +	}
> > +	dprintf(Name ": Read sync_max sysfs entry is: %s\n", buf);
> > +	if (strncmp(buf, "max", 3) == 0) {
> > +		fprintf(stderr, Name ": md is not allowed to finish reshape "
> > +			"wihout mdadm assistance.\n");
> > +		ret_val = 1;
> > +		goto Grow_continue_command_exit;
> > +	}
> > +
> >  	/* continue reshape
> >  	 */
> >  	dev = content->devs;
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in the body of a message to majordomo@vger.kernel.org More
> majordomo
> > info at  http://vger.kernel.org/majordomo-info.html

