From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 7/8] Finalize reshape after adding disks to array
Date: Thu, 13 Jan 2011 09:25:24 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176E59C6F@irsmsx503.ger.corp.intel.com>
References: <20110112132954.15045.41564.stgit@gklab-128-013.igk.intel.com>
	<20110112135518.15045.88138.stgit@gklab-128-013.igk.intel.com>
 <20110113134317.173c0b26@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110113134317.173c0b26@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Thursday, January 13, 2011 3:43 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH 7/8] Finalize reshape after adding disks to array
> 
> On Wed, 12 Jan 2011 14:55:18 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > When reshape is finished, monitor has to finalize reshape in metadata
> for curent array.
> > To do this set_array_state() should be called.
> > This finishes migration and stores metadata on disks.
> >
> > This finishes reshape flow in mdmon.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> >  monitor.c |   11 +++++++++++
> >  1 files changed, 11 insertions(+), 0 deletions(-)
> >
> > diff --git a/monitor.c b/monitor.c
> > index 1107d47..a0068d3 100644
> > --- a/monitor.c
> > +++ b/monitor.c
> > @@ -322,6 +322,17 @@ static int read_and_act(struct active_array *a)
> >  		 */
> >  		check_reshape = 1;
> >
> > +	/* finalize reshape detection
> > +	 */
> > +	if ((a->curr_action != reshape) &&
> > +	    (a->prev_action == reshape)) {
> > +		/* A reshape has finished.
> > +		 * Some disks may be in sync now.
> > +		 */
> > +		a->container->ss->set_array_state(a, a->curr_state <=
> clean);
> > +		check_degraded = 1;
> > +	}
> > +
> >  	/* Check for failures and if found:
> >  	 * 1/ Record the failure in the metadata and unblock the device.
> >  	 *    FIXME update the kernel to stop notifying on failed drives
> when
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> One day you will explain to me why the current code isn't sufficient
> like I
> keep asking you do.  Then maybe I'll apply this patch.
> 
> Until then, I won't.
> 
> NeilBrown

I've made some tests and you are right, current code is enough.

Thanks
Adam

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
