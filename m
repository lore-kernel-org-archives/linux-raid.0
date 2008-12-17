From: "David Lethe" <david@santools.com>
Subject: RE: upgrade advice
Date: Wed, 17 Dec 2008 08:28:20 -0600
Message-ID: <A20315AE59B5C34585629E258D76A97C030D4837@34093-C3-EVS3.exchange.rackspace.com>
References: <d5fe39840812160310t45e822c1geb633f805cf5388e@mail.gmail.com> <alpine.DEB.1.10.0812160641130.725@p34.internal.lan> <1229428184.22331.43.camel@localhost> <alpine.DEB.1.10.0812160807200.725@p34.internal.lan> <1229436950.22331.45.camel@localhost> <cccedfc60812160757x2af73afbv4a69eac31d212062@mail.gmail.com> <alpine.DEB.1.10.0812161829490.31132@p34.internal.lan> <cccedfc60812161608y29e6c645n6ff7df5c87292374@mail.gmail.com> <1229497160.22331.73.camel@localhost> <cccedfc60812170526l43c661ddgff95c99ea883f362@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <cccedfc60812170526l43c661ddgff95c99ea883f362@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>, Redeeman <redeeman@metanurb.dk>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Jon Nelson
> Sent: Wednesday, December 17, 2008 7:27 AM
> To: Redeeman
> Cc: Justin Piszcz; linux-raid@vger.kernel.org
> Subject: Re: upgrade advice
> 
> > What sort of volume of disks are you using, and what loads? (24/7
> with
> > high load?)
> 
> It's a home server. It's up 24/7. Load probably 80% of the time is
> low, the rest of the time it's bursty.
> 
> --
> Jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Read the specs on the disks.  Most consumer class drives are rated for
only 2400 hours annual duty cycle ... so I guess you turn the computer
off in April? :)

Other differences include number of ECC correction bits, so you will
absolutely get more grown bad blocks with cheap drives.

Consider also how many people complain about botched rebuilds due to
multiple drive failures on rebuilds and bad blocks on surviving disks.
I can't remember anybody who bought enterprise class disks asking for
such help recently, it always seems to be people who buy consumer
drives.   No wonder several fail within days of each other, they all
have same model, I/O load, and generally same manufacturing batch.

If you are hell-bent on getting cheap drives, then at least factor in
cost of an additional drive so you can implement RAID6, and automate a
daemon to check/repair consistency often.

Life is short.  Spend the extra money and get disks designed to run in
servers, not PCs. Unless, of course, you have a rather large autochanger
and love to use it.


David
 

