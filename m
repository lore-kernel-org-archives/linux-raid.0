From: Louis-David Mitterrand <vindex@apartia.org>
Subject: Re: lilo boot problems
Date: Mon, 30 Aug 2004 10:26:25 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040830082625.GA9916@apartia.fr>
References: <200408251458.46575.maarten@ultratux.net> <412F3175.1@apartia.fr> <200408280044.55286.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200408280044.55286.maarten@ultratux.net>
To: maarten <maarten@ultratux.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Aug 28, 2004 at 12:44:55AM +0200, maarten wrote:
> On Friday 27 August 2004 15:04, Laurent CARON wrote:
> > maarten wrote:
> > >Hi list,
> > >
> > >I've got bitten by the recent bug(?) that lilo seems to have with 2.6.x
> > >kernels where, upon install, it prints:
> > >
> > >Fatal: Trying to map files from unnamed device 0x0000
> > >
> > >I've tried everything I could think of in lilo.conf to no avail.  Using
> > > google there are several (but not many) threads about this specific error
> > > but I've not seen a solution anywhere yet.
> > >
> > >A "raid-extra-boot" line doesn't help any, neither do any other options.
> > >
> > >At this point, I'm not even sure where the error comes from as even trying
> > > to install a normal non-raid lilo.conf now fails.
> >
> > you have to reconstruct your array first.
> 
> Eeh...  You're joking, right ?  
> The array holds no data as yet so it is possible, but several things seem too 
> odd about this advice.  First, there is nothing wrong with this array, it was 
> created by mdadm with all the right options. Second, this being linux (not 
> windows) I can hardly believe one has to solve problems by no other means 
> than starting all over ("reinstall windows") if the only error is due to the 
> bootmanager interacting with the kernel (remember, this error doesn't occur 
> with other, earlier, kernels).
> 
> Anyway, I chose to work around it by installing grub (and it works fine).

By "reconstruct" I think Laurent meant "synchronize". In effect,
degraded arrays would produce that error with lilo with certain versions
of kernel 2.6.x

-- 
        "You're cute when you're stupid"
