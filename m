From: maarten <maarten@ultratux.net>
Subject: Re: lilo boot problems
Date: Sat, 28 Aug 2004 00:44:55 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408280044.55286.maarten@ultratux.net>
References: <200408251458.46575.maarten@ultratux.net> <412F3175.1@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <412F3175.1@apartia.fr>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 27 August 2004 15:04, Laurent CARON wrote:
> maarten wrote:
> >Hi list,
> >
> >I've got bitten by the recent bug(?) that lilo seems to have with 2.6.x
> >kernels where, upon install, it prints:
> >
> >Fatal: Trying to map files from unnamed device 0x0000
> >
> >I've tried everything I could think of in lilo.conf to no avail.  Using
> > google there are several (but not many) threads about this specific error
> > but I've not seen a solution anywhere yet.
> >
> >A "raid-extra-boot" line doesn't help any, neither do any other options.
> >
> >At this point, I'm not even sure where the error comes from as even trying
> > to install a normal non-raid lilo.conf now fails.
>
> you have to reconstruct your array first.

Eeh...  You're joking, right ?  
The array holds no data as yet so it is possible, but several things seem too 
odd about this advice.  First, there is nothing wrong with this array, it was 
created by mdadm with all the right options. Second, this being linux (not 
windows) I can hardly believe one has to solve problems by no other means 
than starting all over ("reinstall windows") if the only error is due to the 
bootmanager interacting with the kernel (remember, this error doesn't occur 
with other, earlier, kernels).

Anyway, I chose to work around it by installing grub (and it works fine).

Thanks,
Maarten

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

