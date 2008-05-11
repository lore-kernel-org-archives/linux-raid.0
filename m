From: Twigathy <twigathy@gmail.com>
Subject: Re: Multiple siI SATA cards and data corruption
Date: Sun, 11 May 2008 02:11:28 +0100
Message-ID: <1f0f1a960805101811i77905c79wb66c0281e4f5fbb2@mail.gmail.com>
References: <1f0f1a960805061741t16bb165fp342ceb8f97f4347d@mail.gmail.com>
	 <e9c3a7c20805062212x73a837d7l37905042d835e0a7@mail.gmail.com>
	 <1f0f1a960805070234o2f9dfe07j42a1bd005b607791@mail.gmail.com>
	 <1af518580805070648r6060ca9ase0d03e9a17ffe0c7@mail.gmail.com>
	 <1f0f1a960805070720y4908b17dqe098d969f03ec37d@mail.gmail.com>
	 <4821C052.6090105@harddata.com>
	 <1f0f1a960805070752k6ed9c4dfj8ff2382d4557b013@mail.gmail.com>
	 <29a863790805080823m296004e7p4f047b608c4d3eb6@mail.gmail.com>
	 <1f0f1a960805080836o655bc46i484c416bf3bb503@mail.gmail.com>
	 <4823826A.90303@panix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4823826A.90303@panix.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, I said I would report back on any progress...

I replaced the motherboard with a newer P31 based board and an Intel
Dual Core (Actually a core2duo with crippled cache) and 2GB RAM and
the issues have completely gone. I ditched the eSATA cards (Also 3512
based) and am using the 4 onboard motherboard ports plus the 2 port
sii 3512 card. The cables have mostly stayed the same, except for 3
disks which were connected using eSATA. I'm not too sure if the
supposed bug I found with multiple Silicon Image controller cards
actually exists or not and I don't really fancy risking my data -
however, if anyone is googling for sata_sil corruption lost interrupt
then they might find this message (And the backstory to it) :-)

The moral of the story here is: If you're going to be buying lots of
disks, do *not* skimp on cabling and controllers.

Thanks all for the helpful suggestions and "me too!" entries - my 6
disk raid5 is about a half hour away from completing resync and I've
had no nasties in dmesg. Win! :)

Twig

2008/5/8 berk walker <berk@panix.com>:
> YES!! intermittent problems ALWAYS suck.  WE need some really good diags
> which can be run as daemon, which can suspend I/O and associated times out,
> do pre-programmed things ie, notify of error, execute tests to the test
> cyl., and notify of correction which happened, if any, maybe
> possibly/probable thermal/physical/whatever tests to be run - AND have an
> associated pgm for the SU to run while executing these tests. (having come
> from industry) Maintenance engineering definitely sucks hind teat.  I would
> think that many of our readers here, who support hundreds of instantiations
> like this would/could cause a remedy.  If 10,000 disks are purchased from
> one vendor BECAUSE this is offered. I'll bet a hundred bux (U$, not worth
> much) that someone will sit up and take notice.  Somehow, I think that the
> "who owns the market" has been ignored.
>
> YOU - the BIG guys own the market.  And what you say holds sway, and we
> should support you, because, in the end we all ('specially us little guys)
> will benefit.
>
> b-
>
> Twigathy wrote:
>>
>> hm, well I have a couple more eSATA -> SATA cables on order, so I'll
>> report back once they arrive and I can test my disks with them.
>> Intermittent problems totally suck :-(
>>
>> 2008/5/8 Greg Cormier <gcormier@gmail.com>:
>>>
>>> I had scary messages in dmesg like yours above. Spent forever
>>>  troubleshooting everything. New SATA cables and they disappeared.
>>>
>>>  Greg
>>>
>>>
>>>
>>>  On Wed, May 7, 2008 at 10:52 AM, Twigathy <twigathy@gmail.com> wrote:
>>>  > PSU is a relatively reliable, if slightly old now, 380W thing. It has
>>>  > enough power on the 12v lines to power the disks and CPU, but you may
>>>  > be onto something there - all disks reading/writing at once = power
>>>  > levels higher.
>>>  >
>>>  > The new kit I've ordered for this server includes a 450W PSU, so
>>>  > perhaps that'll solve things.
>>>  >
>>>  > The trouble with debugging a problem like this is that there are so
>>>  > many variables!
>>>  >
>>>  > 2008/5/7 Maurice Hilarius <maurice@harddata.com>:
>>>  >>
>>>  >>  Twigathy wrote:
>>>  >>  It could be cables, although that wouldn't explain the disks working
>>>  >> perfectly well (Maxed out, too in the case of doing a badblocks test)
>>>  >> when they are by themselves.
>>>  >>
>>>  >>  Sounds like a current delivery issue.
>>>  >>
>>>  >>  How is your power supply?
>>>  >>
>>>  >>
>>>  >> --
>>>  >>  With our best regards,
>>>  >>
>>>  >>  Maurice W. Hilarius         Telephone: 01-780-456-9771
>>>  >>  Hard Data Ltd.                FAX:          01-780-456-9772
>>>  >>  11060 - 166 Avenue         email:maurice@harddata.com
>>>  >>  Edmonton, AB, Canada         http://www.harddata.com/
>>>  >>       T5X 1Y3
>>>  >>
>>>
>>>
>>>> --
>>>
>>>  > To unsubscribe from this list: send the line "unsubscribe linux-raid"
>>> in
>>>  > the body of a message to majordomo@vger.kernel.org
>>>  > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>  >
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
