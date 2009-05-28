From: Kyle Liddell <kyle@foobox.homelinux.net>
Subject: Re: forcing check of RAID1 arrays causes lockup
Date: Thu, 28 May 2009 05:17:26 -0400
Message-ID: <20090528091726.GA8067@athlon>
References: <20090526234523.GB14974@foobox.homelinux.net> <4A1C986A.7040403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A1C986A.7040403@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 26, 2009 at 08:33:30PM -0500, Roger Heflin wrote:
> Not what you are going to want to hear but badly designed hardware.
> 
> On a machine I had with 4 disks (2 on a build-in via, 2 on other 
> ports--either a built-in promise, or a sil pci card), when the 2 
> build-in via sata ports got used heavily at the same times as any 
...
>    It appeared to me as designed the via chipsets (And think your 
> chipset is pretty close to the one I was using) did not appear to deal 
> with with high levels of traffic to several devices at once, and would 
> become unstable.
> 
> Once I figured out the issue, I could duplicate it in under 5 minutes, 
> and the only working solution was to not use the via ports.
> 
> My mb at the time was a Asus k8v se deluxe with a K8T800 chipset, and 
> so long as it was not heavily used it was stable, but under heavy use 
> it was junk.

That does sound like my problem, and the hardware is similar.  However, I don't think it's the VIA controller that's the problem here:  I moved the two drives off the on-board VIA controller and placed them as slaves on the Promise card.  I was able to install fedora, which was an improvement, but once installed, I was able to bring the system down again by forcing a check.  I've got a spare Promise IDE controller, so I tried swapping it out, with no change.

I suppose it's a weird hardware bug, although it still is strange that certain combinations of kernels (which makes a little sense) + distributions (which makes no sense) will work.  I just went back to debian on the machine, and it works fine.  

I'm trying to reproduce the problem on another machine, but I'm not too hopeful.
