From: Jens Axboe <axboe@suse.de>
Subject: Re: NCQ general question
Date: Wed, 1 Mar 2006 14:55:47 +0100
Message-ID: <20060301135547.GV4816@suse.de>
References: <5d96567b0602282304o558fb564jd72784bafdd289f5@mail.gmail.com> <440561CB.30201@yahoo.de> <4405A656.1030602@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4405A656.1030602@rtr.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Gentoopower <gentoopower@yahoo.de>, "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Mar 01 2006, Mark Lord wrote:
> Gentoopower wrote:
> >Raz Ben-Jehuda(caro) wrote:
> >>i am thinking of buying a promise card sataII pcix.
> >>they have two types, a card which support NCQ
> >>and another that does not.
> >>What is the bennifit of buying  a card with NCQ tagging ?
> >>  
> >How about: http://en.wikipedia.org/wiki/Native_command_queueing
> 
> Yuck.. what a lousy wiki entry.

Yeah, it's pretty bogus.

> NCQ vs. TCQ:  NCQ has a much more efficient low-level protocol,
> making the host-side (controller, operating-system) quite a bit
> simpler than with NCQ.

Or in laymens terms - TCQ sucks and NCQ doesn't :-)
NCQ has many more advantages than TCQ, apart from both a more efficient
low level protocol and ease of implementation. TCQ basically just allows
the drive to do some reordering, it still serializes everything and
requires too many interrupts.

> Both use 32-deep queue depths, and neither of them are worth a
> damn on Linux yet.  Except possibly in the libata ahci driver,
> or vendor-provided drivers (open source, even) for some chipsets.

Eh strange statement, NCQ works just fine in Linux with the NCQ patch.
On AHCI only of course, as that is the only docu I had available.

> In theory, NCQ/TCQ can speed up a very busy fileserver that is
> handling mostly tiny I/O requests.  Practically no measurable
> benefit for single-user systems.

Even single user systems easily have more than on pending request, I'd
say results are very measurable for random 4kb io. In real life the
casual single user wont see much benefit, mainly because he doesn't do a
whole lot of io. I have seen over 30% benefit in "micro" io benchmarks,
though.

-- 
Jens Axboe

