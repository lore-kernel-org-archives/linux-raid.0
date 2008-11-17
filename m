From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6 question.
Date: Mon, 17 Nov 2008 08:09:50 -0800
Message-ID: <4921974E.8050508@zytor.com>
References: <alpine.DEB.1.10.0811100653060.21263@p34.internal.lan> <alpine.DEB.1.10.0811101101530.25411@p34.internal.lan> <4920BB05.3050206@zytor.com> <alpine.DEB.1.10.0811170440001.26146@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811170440001.26146@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Justin Piszcz wrote:
> 
> Yeah, one core was pegged at 100% for the resync, another (md_raidX)
> process
> was at ~35% on the second core.  The third and fourth core were unused
> but immediately when I start the resync it definitley slowed down the
> system quite a bit and hurt interactivity and as I mentioned before
> *without* specifying a lower rebuild speed than the system's maximum I/O
> the system is unusable until the rebuild completes, perhaps its a
> combination of using all of the one core for the resync where raid5 may
> not?  I recall w/raid5 I did not have to specify a lower limit for
> max_rebuild KiB/s..
> 

RAID-5 recovery can use the normal accelerated functions, whereas RAID-6
recovery can't (only a handful of CPUs have the operations needed to
accelerate dual-disk recovery, and even for those it is not implemented
at this point.)

	-hpa
