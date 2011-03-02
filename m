From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 0/5] Grow_continue() prepare for usage in assembly
Date: Wed, 2 Mar 2011 07:37:19 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A534A10@irsmsx503.ger.corp.intel.com>
References: <20110228145815.14670.56597.stgit@gklab-128-013.igk.intel.com>
 <20110302115734.63b76660@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110302115734.63b76660@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Wednesday, March 02, 2011 1:58 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH 0/5] Grow_continue() prepare for usage in assembly
> 
> On Mon, 28 Feb 2011 16:06:55 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > This is first part of reshape continuation. This patch series makes
> (mainly) some changes to Grow_continue()
> > for use for reshape continuation during array assembling.
> >
> > It runs reshape_array() in background (for container operation it
> should be also ok, as we can have only one
> > metadata marked for reshape at the time).
> 
> This is the 4th patch I assume...
> That fork should not be needed.  We pass '0' as the 'forked' parameter
> to


fork() is required to support container operation, before calling reshape_array()
Grow_continue() has to have place (forked) to wait for its turn (or exit for not container operation).

Fork flag passed to reshape array, I've corrected in second series.


> 'reshape_array', so reshape_array will fork and continue in the
> background.
> Why does Grow_continue need to fork as well??
> 
> 
> > For external metadata reshape_array requires container name parameter.
> 
> Yep.
> 
> >
> > For reshape invoked from assembly reshape_array cannot start reshape
> (this would push md to call i.e. start_reshape
> > vector from personality). Staring reshape is based on run() mechanism
> in md so reshape_array should not configure or start reshape.
> 
> I think you just need to change the call:
> -       err = start_reshape(sra, (info->reshape_active && !st->ss-
> >external));
> 
> to
> 
> +       err = start_reshape(sra, info->reshape_active);
> 
> to fix that, don't you?

I'll check if this will be enough. Thank.

BR
Adam

> 
> 
> > It should monitor check-pointing only.
> >
> >
> > BR
> > Adam
> >
> >
> > ---
> >
> > Adam Kwolek (5):
> >       FIX: Do not configure and start, already started reshape
> >       FIX: Continue reshape in the background
> 
> The above 2 I have not applied.
> 
> >       FIX: Set readonly state in Grow_continue() when necessary
> >       FIX: Pass container name to reshape array for external meta data
> >       FIX: Spelling error in dprintf output
> 
> There 3 I have applied.
> 
> Thanks,
> NeilBrown
> 
> >
> >
> >  Grow.c |   53 ++++++++++++++++++++++++++++++++++++++++-------------
> >  1 files changed, 40 insertions(+), 13 deletions(-)
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
