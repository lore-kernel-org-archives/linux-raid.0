From: Tim Moore <linux-raid@nsr500.net>
Subject: Re: Maximum theoretical RAID-0 Speed
Date: Sun, 19 Dec 2004 10:53:45 -0800
Message-ID: <41C5CE39.8090702@nsr500.net>
References: <1c4.217b364e.2ef65ba7@aol.com> <41C5CBB4.1040606@nsr500.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41C5CBB4.1040606@nsr500.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: AndyLiebman@aol.com
List-Id: linux-raid.ids

I didn't see you mention what disks you were running.  Modern 7200 RPM 
drives with a >2MB cache and <10ms seek should do between 45 and 55MB/s 
sustained.  Add to the calculations a max throughput for disk groups.  For 
example, 8x50=400MB/s.

Also, test software raid against 3ware's hardware raid.  I run an older 
PATA series 6000 card which had a "firmware" RAID5 with no cache and so 
software RAID5 was 3x faster.

Also, make sure you are striping across controllers, or use software raid 
to create a RAID5, left-symmetric large group across controllers.  A 16 
drive RAID0 across two controllers should hit around 800MB/s sustained 
read.  If you are set up optimally, your Xeon should run out of gas first.

If you upgrade the board, go with AMD FX or Opteron with HyperTransport on 
the motherboard.

Cheers,

Tim Moore wrote:
> 
> 
> AndyLiebman@aol.com wrote:
> 
>> I'm wondering if anyone on this list can shed some light on a question 
>> that pertains to the maximum theoretical read speed for the RAIDS on 
>> my Linux box, and whether I have reached it. My guess is, there are 
>> about 2 people in the world who possibly understand this. Linus 
>> Torvolds, perhaps. And maybe somebody else. But I'll give this list a 
>> try. I've met some pretty sharp people here.
> 
> 
> Do some research on Garth Gibson at CMU's Parallel Computing group.
> 
>> Here's the scenario I have been testing.
>> I have a single Xeon 3.06 processor set to use Hyperthreading, 2 GB of 
>> RAM on a SuperMicro Motherboard. The motherboard has 4 PCI "bus 
>> segments" with a total of six expansion slots. There are two PCI-X 133 
>> Mhz slots (each associated 
> 
> 
> These are 64 bit slots, so 133MHz*64b/8bits/byte = 1.06GigaBytes/second 
> theoretical sustained
> 
>> with its own PCI bus segment). There is one PCI-X 100 Mhz slot (on ITS 
>> own 
> 
> 100*64/8 = 800MB/s sustained
> 
>> segment) and  three PCI-32bit 33/66 Mhz slots (all sharing the same 
>> bus segment).
> 
> 32*66/8 = 264MB/s shared
> 
>> Each of the PCI-X 133 Mhz slots also has one of the built-in GigE 
>> ports on it 
> 
> GbE = 100MB/s
> 
>> (and I put all my other Intel GigE ports on these two bus segments -- 
>> sometimes I have up to 6 ports in total on my machine). So I leave the 
>> 133 Mhz slots out of the RAIDS. 
> 
> 
>>
>> I have 16 or 24 SATA drive bays in my enclosures.
>> My basic design is to make Hardware RAID-5 arrays with 3ware 9000 
>> cards and 
> 
> 
> 64*66/8 = 528MB/s (RAID0), however I believe the 9000's drop to about 
> 400MB/s on RAID5 (>4 ports), so that's your RAID5 bottleneck.
> 
>> Serial ATA drives. Then I make a Software RAID-0 stripe on top of the 
>> Hardware RAID-5. Sometimes I work with 8-channel 3ware cards, 
>> sometimes with 12-channel cards. So far, I have always put the cards 
>> (they're 66Mhz cards) in a combination of the 3 PCI 33/66 Mhz slots 
>> and the one PCI-X 100 Mhz slot. 
> 
> 
> So your max throughput assuming a max load on each PCI/66 slot is 88MB/s 
> each, the PCI/100 is 400MB/s (3ware limit).  Put your 3ware cards on the 
> PCI/133 slots first, the the PCI/100, then the PCI/33.
> 
>> So, as I said above,  that means I don't have any drives connected to 
>> the two PCI-X 133 slots (or to the segments they correspond to) 
>> because that would slow down the bus speed for those segments and 
>> presumably hurt my network performance. 
> 
> 
>   Since the PCI/133 bandwidth available is about 1GB/s and a GbE port 
> consumes 100MB/s, that leaves 900MB/s for disk controllers that will 
> only do 400MB/s.  On the 100MHz slot you get 800MB/s.  This is the first 
> thing to change, then retest.
> 
> Cheers,

-- 
  | for direct mail add "private_" in front of user name
