From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid10 vs raid5 - strange performance
Date: Wed, 26 Mar 2008 12:29:05 -0400
Message-ID: <47EA79D1.1090607@tmr.com>
References: <bb145bd20803251433q1018703cva56ea20e9bedf3c6@mail.gmail.com>	 <72dbd3150803251513v28ea142ct2de229c26e888c56@mail.gmail.com> <bb145bd20803251556pa416a0cs8350058a4216f6f9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20803251556pa416a0cs8350058a4216f6f9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: David Rees <drees76@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Christian Pernegger wrote:
>>  Not surprising at all. Read performance is similar between the two
>>  setups as expected (appears to be limited by the PCI bus).
>>     
>
> Yes, reads are fine.
>
>   
>>  Streaming write performance is better because you are writing less
>>  redundant data to disks, you can now stripe writes over 5 disks
>>  instead of 3.
>>     
>
> Sounds reasonable. Write performance SHOULD be ~5x single disk for
> raid5 and ~3x single disk for raid10 in a theoretical best-case
> scenario, either should hit the PCI bus cap. In reality the ratios are
> more like 1x for raid5 and 0.6 -1.1x for raid10. It's just that I'd
> expected ~ identical and significantly better streaming write
> performance from both array configurations ... then again, if you
> think it over,
>
> raid5 will transfer 1 parity block per 5 data blocks (so 5/6 of the
> PCI bw are usable = 92MB)
> raid10 will transfer 3 copy blocks per 3 data blocks (so 1/2 of the
> PCI bw are usable = 55MB)
>
> Factoring in some contention / overhead my values might well be
> normal. It just means that the fabled raid10 only performs if you have
> high-bw buses, which this box sadly doesn't, or a hw controller where
> redundant blocks don't go over the bus, which the 3ware 7506
> apparently isn't.
>
> I'll still go with raid10 for the 50% better random I/O, only less
> enthusiastically.
>   

I think that you should treat 10,n2 and 10,f2 as separate 
configurations, and test them as such. behavior is quite different, and 
one or the other might be a better fit to your usage.

The ability to transfer a single copy of the data and no parity 
information is an advantage of hardware controllers.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


