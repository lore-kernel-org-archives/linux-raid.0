From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Low cost PCI-E unRAID - Supermicro AOC-SASLP-MV8 Driver/LBA
 questions for HW owners/users
Date: Sat, 22 Jan 2011 19:19:38 -0800
Message-ID: <AANLkTimNjvKE2T=QUZTvmWQNJ4BvYWtqf4k1-1Wccmha@mail.gmail.com>
References: <AANLkTimp7xxQTv419oL7x6L-sbrhv1ZcEqLq+CfY6gs5@mail.gmail.com>
 <4D39D8B5.1090901@hardwarefreak.com> <AANLkTin2UZJc8yP6DGf2fgcDemQHznch5rGozmnL+V_u@mail.gmail.com>
 <4D3B0009.6020006@hardwarefreak.com> <AANLkTimqNjq6H5X5dPnM8Aw5W3NWtdY7ptGqQJ3ogJmO@mail.gmail.com>
 <4D3B6B05.1020303@shiftmail.org> <4D3B9617.9010800@tomt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D3B9617.9010800@tomt.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Tomt <andre@tomt.net>
Cc: Spelic <spelic@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Jan 22, 2011 at 6:44 PM, Andre Tomt <andre@tomt.net> wrote:
> On 01/23/2011 12:40 AM, Spelic wrote:
>>
>> On 01/22/2011 09:36 PM, Michael Evans wrote:
>>>
>>> Also, you are half right about this being a 'dream' system. For years
>>> I've been using a carefully selected 6 port motherboard, and 3 PCI-e
>>> 1x cards to get a total of 12 ports.
>>
>> So you are trying to reach 12 ports?
>> C'mon don't be cheap, there are lightning-fast 16-ports HBA controllers
>> from LSI, at 6.0gbit/sec, $350 or so. $25 per port is not much; it is
>> much less than the cost of the disk you are attaching to it.
>> This frees you from the choice of the mainboard, and this is important,
>> firstly because you can save $$$ in there, and secondly because if the
>> mainboard fails, what are you going to do? you are going to buy another
>> one with 6 ports? Difficult to find... and expensive also.
>> Also using 2 different controllers for your disks (part from mainboard,
>> part from addon card) is a bit of pain in the *** for administration
>> things, also performances would be the slowest of the two for every
>> request.
>
> Since we're talking about "non hardware raid" usage, I don't really
> understand how it would be harder to manage mixed controllers? Care to
> explain? I can't quite get the performance statement to compute, either..
> Its not like the same I/O goes out to all controllers. If your other
> controller is slower, just put fewer drives on it. Balance it out.
>
> Anyways, If you settle for SATA and a desktop motherboard, most mid to high
> end s1156/1155 motherboards nowadays are fitted with 6 to 8 SATA ports.
> They're in now way hard to come by - even 8 ports seems to be available at
> $130 (I spent 10 seconds looking on newegg). But then again not all of them
> will *boot* off 3TB drives - at least many of the 1156 ones.
>
> As for on board performance, integrated Intel ICH's AHCI controllers tend to
> top out at around 750MB/s aggregate. 6 ports are usually on the Intel, the
> rest on some AHCI compatible chip from Marvell. In general you can expect
> around 1GB/s aggregated from the on board controllers at the same time on a
> standard socket 1156/1155 desktop class intel chipset based motherboard.
>
> Regarding the AOC-SASLP-MV8, yes, they're not worth it - the mvsas driver is
> still buggy when used with SATA. I have heaps of issues with mine - at least
> when using Seagate 7200.11 1.5TB drives on 2.6.36.3. Keeps stalling and
> throwing IO errors (no corruption yet, though). The card also tops out at
> ~700MB/s aggregate - and we can't have any of that can we ;-)
>
> So yeah, the LSI based cards are seems like a good bet if you go the SAS HBA
> route. Even the previous 3Gb/s generation can do a cool 1600-1700MB/s if you
> give them 8 pcie lanes. If he ever plan to expand into expander (he he)
> territory, that bandwidth is good to have. Well, in a "dream system" anyway,
> any normal workloads are generally more random and much, much lower in
> throughput. But hey, we're going for bragging rights here, right? :-)
>

Oh I'm extremely frugal.  I typically wind up going with AMD chipped
systems since they support all the nice CPU features across everything
(well, I don't know about semprons, but honestly spend a tiny bit more
for a dual core).  Sure they've not been the most power efficient
since the Core architecture came out, but they're still priced so that
they offer excellent results dollar for dollar.

The number of ports is more in relation to the cost per gigabyte
sweetspot and what I can spare on storage.  Currently said sweetspot
seems to be 2TB drives, if I were to buy RIGHT now I'd go for a
Samsung Spinpoint F4 since IIRC out of Seagate, WD, and Samsung only
Samsung still enables scterc to alter the timeout/recovery time.

As it's a personal array for everything (data backups, networked media
storage for set top boxes, etc) I don't really need killer
performance; once I saturate the gigabit link I'm happy that way.
What I really need is a good way of using raid6 to get the most cost
effective volume of storage while still tolerating failure.

I'm more interested in waiting for the 3TB drives to migrate down to
the 100-150 range though; support for even larger drives is something
I'll need in an upgrade cycle or two (which is still within my planned
lifespan for the card).
