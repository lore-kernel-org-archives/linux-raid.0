From: Joe Landman <joe.landman@gmail.com>
Subject: Re: HBA Adaptor advice
Date: Fri, 20 May 2011 10:23:22 -0400
Message-ID: <4DD6795A.4040204@gmail.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD65C18.5090804@gmail.com> <4DD66AC8.60804@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD66AC8.60804@wildgooses.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/20/2011 09:21 AM, Ed W wrote:
> Hi
>
>> If you absolutely insist on using a large expensive RAID card as a JBOD
>> card, yeah, there are things you *can* do to keep access to the cache
>> and BBU, though they are counter-intuitive.
>
> The main issue with hardware cards is that really you need at least two
> of them... At the most inopportune moment the only single one you own
> will break and then your entire dataset becomes unavailable...

That is a risk with any proprietary design (a point we refer to in our 
marketing, relative to completely closed designs).  This said, the issue 
on the RAID side isn't all that terrible.  RAID cards, individually, 
aren't that expensive.  You can buy replacements on ebay, or from 
various used machine resellers.  That is, your data really isn't at an 
unmitigateable risk, but it at risk.

Put another way, yeah, having a spare RAID card around isn't a bad idea. 
  In most cases they don't burn out (we've seen 4 failed RAID cards in 
our time in the field, 2 of which were ... er ... customer initiated 
burnouts ... due to bad grounding).

> For sure, anyone with moderate or larger budgets, or a pool of similar
> hardware, this becomes a case of simply buying an extra one and stashing
> it.  Or at least keeping an eye on when it becomes end of line and
> unavailable to buy a new one...

And in the case of the businesses/researchers, the cost of the 
additional card in spares stock locally is (in most cases) in the noise 
level as compared to the actual cost of the gear.

That is, its not a terrible thing to do this.  If you are a home user, 
its another issue entirely.  A 1000 EUR might cost as much as the rest 
of your system.  So you want to mitigate that risk, and not have to pay 
that cost.  That decision to mitigate, by using MD raid, will come at 
some cost, though we see MD raid very much as the future of RAID 
systems.  Its all about refresh rates and economies of scale.

>> First off, the LSI 920x series has a 16 port HBA.  You can look it up on
>> their site.  SAS+SATA HBA I think.  LSI likes adorning some of their
>> HBAs with some inherent RAID capability (their IR mode).  I personally
>> prefer the IT mode, but its sometimes hard/impossible to make the switch
>> (this is usually for motherboard mounted 'RAID' units). HBAs can be used
>> as RAIDs, though the performance is abysmal (c.f. PERC*, lower end LSI
>> ... which PERC are rebranded versions of, ...)
>
> This sounds helpful, but I'm not understanding it?

The 16 port card is mostly HBA, with a little onboard logic for RAID0, 
RAID1, RAID10.

>
> Are you describing the reverse, ie taking a straight HBA card and asking
> it to do "hardware raid" of multiple disks?


LSI's HBAs have some of this capability, though we do not recommend 
using this.  We prefer to use them as straight HBAs.

>
> Or do you mean that performance is dismal even if you make X arrays of 1
> disk each in order to access their BB cache?

No ... we haven't looked into that performance as much, as this is a 
very difficult to use model, and honestly, there are no real benefits to 
this.

>
> Or to be really clear - can I take a cheapo PERC6 from ebay, and make it
> run 8x disks completely under linux MD Raid, with smartctl access to the
> individual disks and BB cache on the card - *with* high performance...
> (phew...)

I am going to pull a Clinton here, and ask you to define "high 
performance" :)  More seriously, performance is in the eye of the 
beholder ... what does it mean to you, and where do you need to be in 
performance ... and from that, you can see if MD RAID will get you there.

>> When you do this, then use mdadm atop this.  We've found, generally, by
>> doing this, we can build much faster RAIDs than the LSI 8888 units, and
>> comparible to the 9260's in terms of performance across the same number
>> of disks, at a lower price.  E.g. mdadm and the MD RAID stack are quite
>> good.
>
> What do you think stops the MD Stack being *better* than a 9260?  Also
> in very round terms what kind of performance drop do you see from going
> to linux MD raid versus a 9260?

Very little on the read side.  MD raid is as fast, if not faster than 
the 9260 on reads.  The 9260 isn't a bad card mind you, it is roughly 
midrange in LSI's lineup.  The write side ... I think the 9260 has a 
deeply pipelined XOR engine you need for the GF(256) calculations.  So 
we see about a 2x better write performance on the 9260 than we do on the 
MD raid.


>> The additional cache doesn't buy you much for this arrangement. Might
>> work against you if the card CPU is slow (as most of the hardware RAID
>> chips are).
>
> Hopefully not a silly question, but surely the CPU would have to be
> extremely slow indeed not to keep up with a sorted bunch of writes that
> are being issued to spinning rust drives with multi-ms seek latencies?
> Are they really that slow..?

Many of the low end cards run processors at 200-800 MHz.  Yeah ... some 
of them are really ... really ... slow.  MD RAID runs circles around 
them.  And soon, I think it will be running circles around the midrange 
(and probably higher end cards as well).

Regards,

Joe

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
