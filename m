From: "Scott T. Smith" <scott@gelatinous.com>
Subject: Re: 3Ware 7506-8, anyone have any luck?  I don't...
Date: Fri, 15 Oct 2004 11:55:03 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1097866503.13982.81.camel@tinny.home.foo>
References: <ckoj1a$pls$1@sea.gmane.org>
	 <Pine.CYG.4.58.0410151323230.2068@buggz4>
	 <1097862002.13597.57.camel@tinny.home.foo>
	 <20041015181205.GB3035@inara.maison.net>
	 <1097864507.13828.70.camel@tinny.home.foo>
	 <20041015184410.GC3035@inara.maison.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041015184410.GC3035@inara.maison.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2004-10-15 at 11:44, KELEMEN Peter wrote:
> [ Please do not address answers directly to me; I read the list. ]

then filter out email based on duplicate message-ids! :-P

> > [...] and we get the same crappy performance from that one too.
> 
> Define `crappy': I get 770 MiB/s read with 3x 3ware 9500S-8MI.
> (RAID00 hw-sw)

When issueing random reads of 1 megabyte each, I get 2 gigabits/sec from
the Highpoint, and 1.5 gigabits/sec from the 3ware, when using a single
controller and 8 disks (WD 250GB).  No RAID, just JBOD mode, all disks
in use at once.

> > Worse yet, the 9xxx series wants to hijack your disks unless you
> > go out of your way to enable 'export JBOD' mode.  You can't take
> > a disk from a 9xxx controller and put it in a box with an 8506
> > -- the controller won't recognize it!
> 
> Have you tried zapping the first and the last megabyte of the
> disk?

the 8506 won't even let me set the disk up as a JBOD.  In order to zap
it, I need yet another controller!  (The Highpoint controller is "nice"
in that it will recognize the 3ware superblock and not absorb it
either!)

> As I said, attractive pricing.  Cannot get stellar hardware RAID
> performance with crappy chipsets. :-)  There's a turnover point
> where you are killed by PCI bandwith limit when using a lot of
> disks.

That's the funny thing about the 3ware 12 disk controllers; they don't
even have the bandwidth to support all 12 disks!

It truly depends on what you want to use it for.  If you want RAID5, you
most likely want a hardware solution, so yeah, 3ware would be the way to
go.  If you want JBOD though, I'd go with Highpoint.

Anyone know how the Adaptec holds up?  I've heard they have better
random IO support than the 3ware, and I think they're a hardware only
solution too.

	Scott


