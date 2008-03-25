From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: raid10 vs raid5 - strange performance
Date: Tue, 25 Mar 2008 23:56:56 +0100
Message-ID: <bb145bd20803251556pa416a0cs8350058a4216f6f9@mail.gmail.com>
References: <bb145bd20803251433q1018703cva56ea20e9bedf3c6@mail.gmail.com>
	 <72dbd3150803251513v28ea142ct2de229c26e888c56@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3150803251513v28ea142ct2de229c26e888c56@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>  Not surprising at all. Read performance is similar between the two
>  setups as expected (appears to be limited by the PCI bus).

Yes, reads are fine.

>  Streaming write performance is better because you are writing less
>  redundant data to disks, you can now stripe writes over 5 disks
>  instead of 3.

Sounds reasonable. Write performance SHOULD be ~5x single disk for
raid5 and ~3x single disk for raid10 in a theoretical best-case
scenario, either should hit the PCI bus cap. In reality the ratios are
more like 1x for raid5 and 0.6 -1.1x for raid10. It's just that I'd
expected ~ identical and significantly better streaming write
performance from both array configurations ... then again, if you
think it over,

raid5 will transfer 1 parity block per 5 data blocks (so 5/6 of the
PCI bw are usable = 92MB)
raid10 will transfer 3 copy blocks per 3 data blocks (so 1/2 of the
PCI bw are usable = 55MB)

Factoring in some contention / overhead my values might well be
normal. It just means that the fabled raid10 only performs if you have
high-bw buses, which this box sadly doesn't, or a hw controller where
redundant blocks don't go over the bus, which the 3ware 7506
apparently isn't.

I'll still go with raid10 for the 50% better random I/O, only less
enthusiastically.


Chris
