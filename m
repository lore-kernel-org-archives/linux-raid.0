From: David Greaves <david@dgreaves.com>
Subject: Re: Problems with multiple Promise SATA150 TX4 cards
Date: Thu, 26 Jan 2006 14:22:01 +0000
Message-ID: <43D8DB09.2010005@dgreaves.com>
References: <Pine.LNX.4.44.0601240132560.32305-100000@coffee.psychology.mcmaster.ca>	 <43D5EF58.9010807@wasp.net.au>  <43D66681.708@dgreaves.com> <1138183485.27604.49.camel@localhost.localdomain> <43D81750.3060405@nighthawkrad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43D81750.3060405@nighthawkrad.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Smith <csmith@nighthawkrad.net>
Cc: Erik Slagter <erik@slagter.name>, linux-raid@vger.kernel.org, IDE Linux <linux-ide@vger.kernel.org>, hahn@physics.mcmaster.ca, mlaks@verizon.net, Soeren Sonnenburg <kernel@nn7.de>
List-Id: linux-raid.ids

Christopher Smith wrote:

> Erik Slagter wrote:
>
>> On Tue, 2006-01-24 at 17:40 +0000, David Greaves wrote:
>>
>>>>> sounds like a spinup time on marginal power to me.
>>>>
>>>> No, it's a limitation of the Promise BIOS on the cards, it will only
>>>> detect a maximum of 8 drives. I had a quick convo with tech support
>>>> from Promise over this and they told me they don't support more than
>>>> one card in a machine in any case. (Which is odd given they advertise
>>>> the ability to RAID-5 across 2 cards!)
>>>
>>>> <snipped the rest about power issues>
>>>
>> I'd really consider the PSU. I had all sorts of weird problems with my
>> promise SATA150 TX2plus until I replaced the PSU. Apparently it doesn't
>> suffice to supply _enough_ power.
>
>
> I've since setup the machine so only the motherboard and boot drive
> are powered from the system PSU and the 12 SATA drives are powered
> from a separate PSU.
>
> Since the machine has previously been running with 8 drives fine on
> just the system PSU, I feel confident saying power supply has nothing
> to do with my problems.

And I've bought a new (expensive and high quality) 460W PSU and have
exactly the same problems I had previously.
(http://marc.theaimsgroup.com/?l=linux-kernel&m=113769509617034&w=2)

and I'm not running Promise - I'm running sata_via and sata_sil (not as
modules)

David

PS A Bit rushed as in a few hours I'm away on holiday for a week - if
someone has time to have a scan through recent postings on the ide and
raid lists they'll find quite a few problems that seem - to my untrained
eye - to be similar. I've gathered some individuals together on the cc
(hope that's OK) to see if the symptoms could be compared. If this isn't
done next week then I'll try and do it when I get back (or maybe if I
get net access next week)

PPS Note that Mitchell's on verizon.net and mails to him from non-US
ISPs may bounce (grr)

-- 

