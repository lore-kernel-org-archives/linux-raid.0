From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Software RAID on Windows using Embedded Linux?
Date: Sun, 24 Jul 2005 21:22:57 +0200
Message-ID: <62b0912f050724122234673002@mail.gmail.com>
References: <6d5bedd8050724070995073e1@mail.gmail.com>
	 <62b0912f050724075638c18d91@mail.gmail.com>
	 <6d5bedd8050724113142284b32@mail.gmail.com>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6d5bedd8050724113142284b32@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Ewan Grantham <ewan.grantham@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/24/05, Ewan Grantham <ewan.grantham@gmail.com> wrote:
> On 7/24/05, Molle Bestefich <molle.bestefich@gmail.com> wrote:
> > Ewan Grantham wrote:
> > > I know, this is borderline, but figure this is the group of folks who
> > > will know. I do a lot of audio and video stuff for myself and my
> > > family. I also have a rather unusual networking setup. Long story
> > > short, when I try to run Linux as my primary OS, I usually end up
> > > reinstalling Windows after a couple weeks because there are still
> > > holes in what I can do. That isn't the fault of Linux as much as folks
> > > who write device drivers or have video codecs that require DirectShow.
> > >
> > > However, the big thing I really miss from Linux that keeps me trying
> > > to find a way to convert is the support for Software RAID 5.
> > >
> > > It occured to me yesterday that perhaps the trick would be to use QEMU
> > > to run Knoppix or Damn Small Linux under Windows, and then setup a
> > > RAID 5 array under one of those. Not to mention then having access to
> > > Linux for some other fun stuff.
> > >
> > > I'm not sure if that's even possible, and if it is, how much trouble I
> > > would have moving files around to and from the RAID array if it's
> > > setup that way. So I'm wondering if anyone on the list has ever tried
> > > this?
> >
> > Not too much trouble, you should be able to just setup Samba in the
> > Knoppix/DSL and access your files through QEMU's network emulation.
> >
> > It will be damn slow, however :-).
> >
> > Perhaps buy a NAS device like Linksys NSLU2?
> > It's cheap and has low power consumption - but you'll need to hack it
> > to add disks (via USB).
> >
> > http://peter.korsgaard.com/articles/debian-nslu2.php
> >  or
> > http://www.tomsnetworking.com/Sections-article85-page3.php
> >
> > explains how to get into the Linux guts of the box.
> 
> Interesting idea. However, I note that it is rather slow as well -
> since you're then accessing disks over 100 Mbps rather than at full
> USB2. And it appears you can only attach 2 USB disks to it.

You should be able to hack it to accept more than 2 disks..
You're right about the 100 mbps network interface..

> Which makes me wonder just how slow you mean when you say that the
> QEMU version would be slow? Slow compared to native access? Slow
> compared to the NSLU2 solution discussed above? Or slow compared to a
> snail being attacked by one of those Hawaiian Catepillars? :-)

"Slow" as in a passing tortoise would take that system by surprise =)..

Based on QEMU being a CPU emulator, not a virtualization system, thus
penalizing performance with a factor 10 or so.

Actually, just checked their web site, and they now have a
non-open-source alternative that uses virtualization, so if you're
going to use that it just might work ok.  If you're willing to live
with the fact that MD will at times suck up some CPU.  Looking forward
to hearing whether you can live with the solution or not (if you go
that way) :-).
