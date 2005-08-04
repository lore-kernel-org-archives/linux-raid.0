From: Gordon Henderson <gordon@drogon.net>
Subject: Re: RAID read performance
Date: Thu, 4 Aug 2005 09:22:40 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0508031822040.20853@lion.drogon.net>
References: <9A6ED0928D2DE54CAD74FDC8DCE9843505DA70@asi-exchange.ASI.int>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9A6ED0928D2DE54CAD74FDC8DCE9843505DA70@asi-exchange.ASI.int>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2 Aug 2005, Boik Moon wrote:

> Hi,
>
> According to RAID theory, the READ performance with RAID0, 1 and 5
> should
> Be faster than one with non-RAID. I tested it on Redhat linux(ES) on
> Pentium PC, but they are almost same. I am using
> RocketRAID404(HPT374)PCI card to connect 4 master IDE
> Drivers.
> Ideally it must be 2 or more times faster on RAID0/1/5.

Why must it be?

There was a discussion about this here recently IIRC... Maybe the archives
have the full details.

I'm assuming you are using software RAID here and not what the card
supports...

You should be able to see a speed-up with RAID-0, but with the other
levels, it's not always obvious.

My experiences are that in general, I don't see a speed-up with RAID-1. I
tend to test systems with a RAID-0 array if possible though and then there
usually is an obvious speed-up, but a lot depends on your hardware. If you
have (eg) one card with 4 drives hung off it, then you might find that the
PCI bandwdith is the bottleneck - if you want absolute preformance, you'd
need a motherboard with separate PCI busses, etc.

AIUI, RAID-1 will read 'chunksize' off one disk, then move to the next
disk, although I'm not sure if the reads are/can be posted together. It
probably depends on how much data you are readong off the filesystem at
that time

Do make sure you have DMA enabled on each drive/controler, etc. You should
be able to use hdparm to check this - a modern drive should be able to
sustain a read speed of between 50 and 60MB/sec... You'll see this drop
down to 3-5MB/sec if theres no DMA...

I also think YMMV is the phrase to use here...

Good luck!

Gordon
