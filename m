From: Redeeman <redeeman@metanurb.dk>
Subject: Re: forcing check of RAID1 arrays causes lockup
Date: Thu, 28 May 2009 14:42:03 +0200
Message-ID: <1243514523.5740.90.camel@localhost>
References: <20090526234523.GB14974@foobox.homelinux.net>
	 <4A1C986A.7040403@gmail.com>  <20090528091726.GA8067@athlon>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090528091726.GA8067@athlon>
Sender: linux-raid-owner@vger.kernel.org
To: Kyle Liddell <kyle@foobox.homelinux.net>
Cc: Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2009-05-28 at 05:17 -0400, Kyle Liddell wrote:
> On Tue, May 26, 2009 at 08:33:30PM -0500, Roger Heflin wrote:
> > Not what you are going to want to hear but badly designed hardware.
> > 
> > On a machine I had with 4 disks (2 on a build-in via, 2 on other 
> > ports--either a built-in promise, or a sil pci card), when the 2 
> > build-in via sata ports got used heavily at the same times as any 
> ...
> >    It appeared to me as designed the via chipsets (And think your 
> > chipset is pretty close to the one I was using) did not appear to deal 
> > with with high levels of traffic to several devices at once, and would 
> > become unstable.
> > 
> > Once I figured out the issue, I could duplicate it in under 5 minutes, 
> > and the only working solution was to not use the via ports.
> > 
> > My mb at the time was a Asus k8v se deluxe with a K8T800 chipset, and 
> > so long as it was not heavily used it was stable, but under heavy use 
> > it was junk.
> 
> That does sound like my problem, and the hardware is similar.  However, I don't think it's the VIA controller that's the problem here:  I moved the two drives off the on-board VIA controller and placed them as slaves on the Promise card.  I was able to install fedora, which was an improvement, but once installed, I was able to bring the system down again by forcing a check.  I've got a spare Promise IDE controller, so I tried swapping it out, with no change.
> 
> I suppose it's a weird hardware bug, although it still is strange that certain combinations of kernels (which makes a little sense) + distributions (which makes no sense) will work.  I just went back to debian on the machine, and it works fine.  
> 
> I'm trying to reproduce the problem on another machine, but I'm not too hopeful.

I have a system with 6 drives in raid5, on such a k8v se deluxe board
with the via controller, and an additional PCI controller.

I am experiencing some weird problems on this system too, when doing
lots of read/write it will freeze for up to 10 seconds sometimes, what
happens is that one of the disks gets the bus soft reset.

Now with the old IDE driver, this would f*** up completely, and the box
had to be rebooted, however, libata was able to recover it nicely and
just continue after the freeze.

I was never able to solve the issue, and since  it wasnt a major problem
for the use, i have just ignored it.

do you suppose adding another pci card with IDE ports and discontinuing
use of the via controller entirely would fix it?

though, i have actually just replaced this box with a newer, so it wont
do me much good now, however, the small amount of money a pci ide
controller costs, would be worth it just to actually find out what was
wrong.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

