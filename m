From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance
Date: Fri, 22 Feb 2013 22:14:16 -0600
Message-ID: <51284218.70701@hardwarefreak.com>
References: <91cffde0-b154-477d-90d2-68b15e91518c@email.android.com> <5120789B.1080804@hardwarefreak.com> <5120979C.9030703@websitemanagers.com.au> <5120E1F6.2050906@hardwarefreak.com> <5120ED3F.7080904@websitemanagers.com.au> <5123351F.5030903@hardwarefreak.com> <5124FDB2.10007@websitemanagers.com.au> <51256E45.5080707@hardwarefreak.com> <51259011.1060600@websitemanagers.com.au> <5127545C.9040808@hardwarefreak.com> <20130222152526.GC5411@kevin>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130222152526.GC5411@kevin>
Sender: linux-raid-owner@vger.kernel.org
To: Charles Polisher <cpolish@surewest.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/22/2013 9:25 AM, Charles Polisher wrote:
> Stan Hoeppner wrote:
>> Not only does SuperMicro offer far more Intel server boards than Intel,
>> they also offer more AMD server boards than anyone.  Here's an
>> inexpensive server board for Opteron 3000 (AM3+) that has an integrated
>> 8 pot LSI 2308 (9207--same as yours):
>> http://www.supermicro.com/Aplus/motherboard/Opteron3000/SR56x0/H8SML-7.cfm
> 
> Following this thread avidly, it has made me late for work twice this week.

Heheh, it's not *that* interesting. ;)

> With IPMI added it seems to retail for same price (Amazon USD$399):
> http://www.supermicro.com/aplus/motherboard/opteron3000/sr56x0/h8sml-7f.cfm

The H8SML above is their bottom rung AMD server board.  The top rung is
this one:
http://www.supermicro.com/Aplus/motherboard/Opteron6000/SR56x0/H8QG7-LN4F.cfm

Quad socket G34, up to 64 cores and 1TB RAM, 16 DDR3 channels up to
192GB/s, on-board LSI MegaRAID 9265-8i w/1GB cache, quad Intel GbE, two
PCIe 2.0 x16 slots and two x8, etc.

Of course any system using this board won't rely on the on-board LSI for
main storage.  It's primarily for boot/OS RAID.

-- 
Stan



