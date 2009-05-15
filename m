From: Neil Brown <neilb@suse.de>
Subject: Re: resync duration ?
Date: Fri, 15 May 2009 11:22:30 +1000
Message-ID: <18956.50134.658843.652060@notabene.brown>
References: <1308264373.20090514150647@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Rainer Fuegenstein on Thursday May 14
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 14, rfu@kaneda.iguw.tuwien.ac.at wrote:
> Hi guys,
> 
> I'm a but confused about the duration of a raid5 resync:
> 
> - occasionally, my server with 4*750 gb sata raid5 crashed (because of
> problems with the power supply); after rebooting it took about 10 to 12
> hours to resync the raid5 (guess it just re-created some parity
> information or however it works internally, but didn't have to copy
> any data)

A resync reads all the data and checks the parity.  If it find bad
parity (which is likely to be very rare) then it corrects it.
So resync should run at the full speed of the hardware, just reading.

> 
> - right now I replaced one 750GB disk with a 1.5TB disk, but now
> resyncing (according to /proc/mdstat) it is supposed to take only 160
> minutes ?! although it needs top copy data to a blank disk ?
> 
> is this normal or should I be worried, especially before I pull out
> the next 750GB disk and replace it with the next 1.5TB disk ?

recovery reads N-1 drives and writes the N'th drive.  So it shuffles
exactly the same amount of data as sync, and performs just as many IO
operations, though some of them are writes rather than reads.  I
believe that (on rotating drives) writes go at much the same speed as
reads.
So you would expect this to take exactly as long as the resync.

As others have said, 3 hours it a reasonable ball-part for 750Gig.
10-12 hours is definitely longer than I would expect.

Of course, if use are using the array then resync (or recovery) will
back off and let the regular IO have priority.  So if you were
actively using the array during the 10-12 hours resync, then it makes
perfect sense.

NeilBrown
