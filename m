From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Inexpensive RAID1 controller for home server?
Date: Sun, 19 Aug 2012 16:48:41 -0500
Message-ID: <50315F39.2030404@hardwarefreak.com>
References: <CAK2H+eeLncyi6tCrM-vEhDzT7ykOA6LJP+Qka56rxUFGv2_urw@mail.gmail.com> <50306707.40302@hardwarefreak.com> <20120819153443.7f697ca6@natsu>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120819153443.7f697ca6@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Mark Knecht <markknecht@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 8/19/2012 4:34 AM, Roman Mamedov wrote:
> On Sat, 18 Aug 2012 23:09:43 -0500
> Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
>> On 8/18/2012 2:18 PM, Mark Knecht wrote:
>>> Hi,
>>>    I wonder if there is direct knowledge here about this controller?
>>>
>>> http://www.amazon.com/HighPoint-Rocket-SATA-PCI-Express-Controller/dp/B002VEWBGO
>>>
>>>    I'm looking to add an inexpensive 2-port controller for a home
>>> server that's out of ports on the MB but has room in the chassis for a
>>> couple more drives running RAID1. The machine has been successfully
>>> running mdadm for the last couple of years and the power supply is
>>> plenty big enough to take on the new hardware.
>>>
>>>    According the the Highpoint site is has native Linux support so it
>>> doesn't appear there are any major driver availability issues. The one
>>> problem I've read about that concerns me is it may conflict with
>>> existing on-board Marvell eSATA controllers which this machine has.
>>
>> Given the potential Marvell conflict issue, go with Silicon Image:
>>
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16815124027
>>
>> All Silicon Image chips are supported in mainline, have been forever.
>>
> 
> Now, maybe I am missing something and Mark Knecht is your worst enemy --
> because I see no other explanation why give him such a terrible advice.

/me rolls eyes..

> Silicon Image chips are well known for having caused data corruption to many
> people including in discussions on this list, usually this triggers when both
> ports on the card are accessed at high speed in parallel.

Yeah, you're right.  All Silicon Image ASICs suck.  That must be the
reason they ship over 10x as many chips into the market as Marvell and
the others.  This must also be why BackBlaze chose SiI, twice, over
Marvell, Jmicron, etc, for their 1st and 2nd generation pods.

http://blog.backblaze.com/2011/07/20/petabytes-on-a-budget-v2-0revealing-more-secrets/

They use 3x Syba SiI3124 4 port PCIe x1 cards per system, 3 ports per
card, with 9x SiI3726 PMPs.  They run hundreds of these pods, thousands
of SiI SATA ASICs and 3x as many SiI PMPs.  No problems reported that
I've found.  If data corruption was a pervasive issue with SiI SATA
ASICs, based simply on numbers, BackBlaze would have run into this
problem.  As they haven't, I'd say that in the cases of data corruption
you mention, the root cause didn't lay in the SiI ASICs themselves, but
either in the cards (whose QC/QA can vary widely from vendor to vendor
and batch to batch), or in a compatibility issue in the individual
hosts, either hardware or software.  There is no design flaw in the SiI
chips that causes data corruption.  Please don't repeat such BS.

That said, I personally don't use cheap SATA controllers, and normally
don't recommend them, no matter the ASIC used.  But the OP obviously
isn't in the market for a $150-$200 LSI HBA, which is what I'd normally
recommend.

> There is also a performance-related reason to avoid Silicon Image (if
> having them corrupt data isn't enough for someone):
> 
>   "Warning: the overall bottleneck of the PCIe link is 150-175MB/s, or
>   75-88MB/s/port, but the chip has a 110-120MB/s bottleneck per port. So a
>   single SATA device on a single port cannot fully use the 150-175MB/s by
>   itself, it will be bottlenecked at 110-120MB/s."
>  
>    -- http://blog.zorinaq.com/?e=10

This is a non issue for the vast majority of users with rust, as most
drives can't stream more than 110-120 anyway.

> Now, what to choose instead:
> 
> I highly doubt having two Marvell controllers in a system would lead to a
> conflict; and as the article linked above concludes, a Marvell 88SE912x would
> be an excellent choice, as it "supports PCIe gen2 [...] is also fully AHCI
> compliant, in other words robust, well-designed, and virtually compatible with
> all operating systems".
> 
> But if Mark believes there could be a conflict, and wants a non-Marvell
> recommendation, I'd say take a look at a JMicron, which is also the second
> recommendation in that article.
> http://www.newegg.com/Product/Product.aspx?Item=N82E16816124047

Yes, I always base my purchasing decisions on the opinions found in a
single blog, and unsupported conclusions that the data loss of a few
people was caused by a claimed and unconfirmed flaw in an ASIC, an ASIC
which has shipped in the tens of millions of units.  If the problem were
the ASIC, there would be thousands of such reports, and the ASIC would
be respun to fix the problems, or a new BIOS, and the issue would be
documented by the manufacturer.

Roman has a beef with SiI.  It's unfounded and unsubstantiated, but he
has one nonetheless.  He also apparently has a beef with me for
constantly correcting him on these issues.

Believe who you wish.  I simply recommend you do your homework and
independently verify everyone's claims.  Or, you can simply buy any ~$20
HBA, and if it doesn't work, return it and get a different one.

-- 
Stan

