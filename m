From: Asdo <asdo@shiftmail.org>
Subject: Re: MD write performance issue - found Catalyst patches
Date: Thu, 29 Oct 2009 09:08:53 +0100
Message-ID: <4AE94D95.4060303@shiftmail.org>
References: <66781b10910180300j2006a4b7q21444bb27dd9434e@mail.gmail.com>
 <19177.14609.138378.581065@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <19177.14609.138378.581065@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> I've had a look at this and asked around and I'm afraid there doesn't
> seem to be an easy answer.
>
> The most likely difference between 'before' and 'after' those patches
> is that more pages are being written per call to generic_writepages in
> the 'before' case.  This would generally improve throughput,
> particularly with RAID5 which would get more full stripes.
>
> However that is largely a guess as the bugs which were fixed by the
> patch could interact in interesting ways with XFS (which decrements
> ->nr_to_write itself) and it isn't immediately clear to me that more
> pages would be written... 
>
> In any case, the 'after' code is clearly correct, so if throughput can
> really be increased, the change should be somewhere else.
>   
Thank you Neil for looking into this

How can "writing less pages" be more correct than "writing more pages"?
I can see the first as an optimization to the second, however if this 
reduces throughput then the optimization doesn't work...
Isn't it possible to "fix" it so to write more pages and still be 
semantically correct?


Thomas Fjellstrom wrote:
> I don't suppose this causes "bursty" writeout like I've been seeing lately? 
> For some reason writes go full speed for a short while and then just stop 
> for a short time, which averages out to 2-4x slower than what the array 
> should be capable of.
>   
I have definitely seen this bursty behaviour on 2.6.31.

It would be interesting to know what are the CPUs doing or waiting for 
in the pause times. But I am not a kernel expert :-( how could one check 
this?

Thank you
