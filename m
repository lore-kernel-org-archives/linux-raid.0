From: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Subject: RE: [PATCH 6/6] FIX: Unblock disk in kernel only if it is blocked.
Date: Wed, 26 Jan 2011 14:22:32 +0000
Message-ID: <BE2BFE91933D1B4089447C644860408066FF06C1@irsmsx503.ger.corp.intel.com>
References: <20110119161925.8738.85284.stgit@gklab-128-111.igk.intel.com>
	<20110119162349.8738.43217.stgit@gklab-128-111.igk.intel.com>
 <20110126110626.2d280ef0@nbeee.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110126110626.2d280ef0@nbeee.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Neil Brown
> Sent: Wednesday, January 26, 2011 2:06 AM
> To: Wojcik, Krzysztof
> Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech; Kwolek, Adam;
> Williams, Dan J; Ciechanowski, Ed
> Subject: Re: [PATCH 6/6] FIX: Unblock disk in kernel only if it is
> blocked.
> 
> On Wed, 19 Jan 2011 17:23:49 +0100
> Krzysztof Wojcik <krzysztof.wojcik@intel.com> wrote:
> 
> > Missing condition during setting next state for disk.
> 
> Yet again you completely fail to explain why you want to make this
> change.
> And again it looks wrong.
> 
> There is no harm is setting "-blocked" if the device is not actually
> blocked is there?
> 
> PLEASE PLEASE PLEASE explain exactly the problem you are trying to
> fix.  Don't waste my time and yours by making have to continually ask
> for explanations.
> 
> NeilBrown
> 
Hi,

I'm sorry for insufficient explanation. I will try to be more exact in the future :)
This patch is just cleanup. Setting "-blocked" is no harm but it is problem when we use debug information. Monitor sets "-blocked" many times and it is hard to catch particular information- on the screen we get hundreds of lines with "-blocked" information and it is hard to find useful information.
I think unblock should be triggered only if device is blocked.

Krzysztof Wojcik

> 
> >
> > Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> > ---
> >  monitor.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> >
> > diff --git a/monitor.c b/monitor.c
> > index ed3ce49..4fba5fd 100644
> > --- a/monitor.c
> > +++ b/monitor.c
> > @@ -336,7 +336,9 @@ static int read_and_act(struct active_array *a)
> >  			a->container->ss->set_disk(a,
> > mdi->disk.raid_disk, mdi->curr_state);
> >  			check_degraded = 1;
> > -			mdi->next_state |= DS_UNBLOCK;
> > +			/* if '-blocked' wasn't passed to kernel, do
> > it now */
> > +			if (mdi->curr_state == DS_BLOCKED)
> > +				mdi->next_state |= DS_UNBLOCK;
> >  			if (a->curr_state == read_auto) {
> >  				a->container->ss->set_array_state(a,
> > 0); a->next_state = active;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
