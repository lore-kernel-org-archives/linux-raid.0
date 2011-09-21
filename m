From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 08/14] Check if reshape can be restarted
Date: Wed, 21 Sep 2011 07:45:31 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A03253E@IRSMSX101.ger.corp.intel.com>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
	<20110916115448.5201.56575.stgit@gklab-128-013.igk.intel.com>
 <20110921122734.338d6f59@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110921122734.338d6f59@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Wednesday, September 21, 2011 4:28 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin
> Subject: Re: [PATCH 08/14] Check if reshape can be restarted
> 
> On Fri, 16 Sep 2011 13:54:48 +0200 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > When reshape was invoked during initramfs start-up stage array is
> > pushed in to reshape state already, so read only state cannot be set
> > again. To verify if reshape continuation should be allowed sync_action
> > sysfs key is tested and number of existing mdadm instances is checked
> > again.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> 
> Again, it is not at all clear to me what you are trying to protect against here...
> 
> The "set_str ... readonly" is going to need to be changed.
> 
> In the normal case, this is where the array is activated, but it is activated
> read-only to ensure no reshape automatically starts.
> 
> In the --continue case it is already running and reshape is suspended, so
> there is no need to set it to readonly when Grow_continue is called from
> Grow_continue_command.


This is exactly the case.

We have 2 continuation possibilities,  when Grow_continue() is called: 

1. Assembly when  array is set to readonly state and this activates it.

2. grow --continue. Reshape is continued and array is already in reshape state,
     It is not possible to set readonly state again, this is why sync_action is checked
     For "reshape" to allow continuation for run.
    Conjunction with count_mdadms() /the single mdadm instance/ guards any potential race conditions.
       
BR
Adam

> 
> NeilBrown
> 
> 
> > ---
> >
> >  Grow.c |   19 +++++++++++++++++--
> >  1 files changed, 17 insertions(+), 2 deletions(-)
> >
> > diff --git a/Grow.c b/Grow.c
> > index 4d2c361..b331287 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -3714,8 +3714,23 @@ int Grow_continue(int mdfd, struct supertype
> *st, struct mdinfo *info,
> >  	int err;
> >
> >  	err = sysfs_set_str(info, NULL, "array_state", "readonly");
> > -	if (err)
> > -		return err;
> > +	if (err) {
> > +		/* check if array is set in to reshape stare,
> > +		 * and current mdadm instance is the only one
> > +		 */
> > +		if ((sysfs_get_str(info, NULL, "sync_action",
> > +				   buf, 40) == 8) &&
> > +		    (count_mdadms() == 1)) {
> > +			dprintf("Warning: Grow_continue() cannot set array
> in"
> > +				"to read only state [sync_action is %s].",
> > +				buf);
> > +			if (strncmp(buf, "reshape", 7))
> > +				return err;
> > +			dprintf("Allow to continue.\n");
> > +		} else
> > +			return err;
> > +	}
> > +
> >  	if (st->ss->external) {
> >  		fmt_devname(buf, st->container_dev);
> >  		container = buf;
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in the body of a message to majordomo@vger.kernel.org More
> majordomo
> > info at  http://vger.kernel.org/majordomo-info.html

