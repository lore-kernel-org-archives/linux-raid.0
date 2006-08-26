From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH-stable16] Fix a potential NULL dereference in md/raid1
Date: Sat, 26 Aug 2006 17:33:52 +0200
Message-ID: <20060826153352.GH4765@stusta.de>
References: <20060821094833.21982.patches@notabene> <1060820235013.22016@suse.de> <20060821000109.GA11651@stusta.de> <17640.63792.278940.578508@cse.unsw.edu.au> <20060821002847.GB11651@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060821002847.GB11651@stusta.de>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Aug 21, 2006 at 02:28:47AM +0200, Adrian Bunk wrote:
> On Mon, Aug 21, 2006 at 10:07:12AM +1000, Neil Brown wrote:
> > On Monday August 21, bunk@stusta.de wrote:
> > > On Mon, Aug 21, 2006 at 09:50:13AM +1000, NeilBrown wrote:
> > > 
> > > > patch for 2.6.16 stable series
> > > >...
> > > 
> > > Thanks for this patch.
> > > 
> > > It does also apply against both 2.6.17.9 and Linus' tree.
> > > 
> > > Is it not required in these trees, or are you also submitting it there?
> > 
> > I've just sent a patch to stable@kernel.org for 2.6.17.9. (it is the
> > same patch with slightly different line numbers).
> > 
> > The patch for -linus is quite different and will follow shortly (with
> > a few other patches).
> 
> OK, I'll apply this patch when it has successfully passed 2.6.17 review 
> and got included in 2.6.17.

Applied, thanks for the patch.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

