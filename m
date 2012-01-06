From: Phil Turmel <philip@turmel.org>
Subject: Re: SMART, RAID and real world experience of failures.
Date: Fri, 06 Jan 2012 08:38:49 -0500
Message-ID: <4F06F969.1010205@turmel.org>
References: <4F063808.6040000@crc.id.au> <20230.55643.346235.891308@tree.ty.sabi.co.UK> <4F06DDAC.1050501@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F06DDAC.1050501@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/06/2012 06:40 AM, Steven Haigh wrote:
> On 6/01/2012 10:22 PM, Peter Grandi wrote:
>> [ ... ]
>> 
>>> I got a SMART error email yesterday from my home server with a 4
>>> x 1Tb RAID6. [ ... ]
>> 
>> That's an (euphemism alert) imaginative setup. Why not a 4 drive 
>> RAID10? In general there are vanishingly few cases in which RAID6
>> makes sense, and in the 4 drive case a RAID10 makes even more sense
>> than usual. Especially with the really cool setup options that MD
>> RAID10 offers.

In this case, the raid6 can suffer the loss of any two drives and
continue operating.  Raid10 cannot, unless you give up more space
for triple redundancy.

Basic trade-off:  speed vs. safety.

> The main reason is the easy ability to grow the RAID6 to an extra
> drive when I need the space. I've just about allocated all of the
> array to various VMs and file storage. One thats full, its easier to
> add another 1Tb drive, grow the RAID, grow the PV and then either add
> more LVs or grow the ones that need it. Sadly, I don't have the cash
> flow to just replace the 1Tb drives with 2Tb drives or whatever the
> flavour of the month is after 2 years.

Watch out for the change in SCTERC support.  I replaced some 1T Seagate
desktop drives on a home server with newer 2T desktop drives, which
appeared to be Seagate's recommended successors to the older models.  

But no SCTERC support.  My fault for not rechecking the spec sheet, but
still.  Shouldn't have been pitched as a "successor", IMO.

Some Hitachi desktop drives still show STCERC on their specs, but I fear
that'll change before I'm ready to spend again.

>>> This makes me ponder. Has the drive recovered? Has the sector 
>>> with the read failure been remapped and hidden from view? Is it
>>> still (more?)  likely to fail in the near future?
>> 
>> Uhmmm, slightly naive questions. A 1TB drive has almost 2 billion
>> sectors, so "bad" sectors should be common.
>> 
>> But the main point is that what is a "bad" sector is a messy story,
>> and most "bad" sectors are really marginal (and an argument can be
>> made that most sectors are marginal or else PRML encoding would not
>> be necessary). So many things can go wrong, and not all fatally.
>> For example when writing some "bad" sectors the drive was vibrating
>> a bit more and the head was accordingly a little bit off, etc.
>> 
>> Writing-over some marginal sectors often refreshes the recording,
>> and it is no longer marginal, and otherwise as you guessed the
>> drive can substitute the sector with a spare (something that it
>> cannot really do on reading of course).

Also keep in mind that modern hard drives have manufacturing defects
that are mapped at the factory, and excluded from all further use.
Those don't show in the statistics.

> This is what I was wondering... The drive has been running for about
> 1.9 years - pretty much 24/7. From checking the seagate web site, its
> still under warranty until the end of 2012.
> 
> I guess it seems that the best thing to do is monitor the drive as I
> have been doing and see if its a once off or becomes a regular
> occurrence. My system does a check of the RAID every week as part of
> the cron setup, so I'd hope things like this get picked up before it
> starts losing any redundancy.

You might also want to perform a "repair" scrub the next time this kind
of problem appears.  ("check" is most appropriate in the cron job,
though.) It might have saved you a bunch of time, while maintaining the
extra redundancy on the rest of the array.

Phil
 

