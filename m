From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: new bottleneck section in wiki
Date: Wed, 2 Jul 2008 14:38:03 -0500
Message-ID: <cccedfc60807021238w2fdb2a60i5d6c4c8a901071e2@mail.gmail.com>
References: <20080702155603.GA11156@rap.rap.dk>
	 <A20315AE59B5C34585629E258D76A97CF1FCCC@34093-C3-EVS3.exchange.rackspace.com>
	 <20080702190337.GA2311@sewage.raw-sewage.fake>
	 <cccedfc60807021210y2b47917ap227e46fd1666755e@mail.gmail.com>
	 <20080702193527.GA13186@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080702193527.GA13186@rap.rap.dk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Keld J?rn Simonsen <keld@dkuug.dk>
Cc: Matt Garman <matthew.garman@gmail.com>, David Lethe <david@santools.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> This motherboard (EPoX MF570SLI) uses PCI-E.
>
> PCI-E is quite different architecturally from PCI-X.
>
>> It has a plain old PCI video card in it:
>> Trident Microsystems TGUI 9660/938x/968x
>> and yet I appear to be able to sustain plenty of disk bandwidth to 4 drives:
>> (dd if=/dev/sd[b,c,d,e] of=/dev/null bs=64k)
>> vmstat 1 reports:
>> 290000 to 310000 "blocks in", hovering around 300000.
>>
>> 4x70 would be more like 280, 4x75 is 300. Clearly the system is not
>> bandwidth challenged.
>> (This is with 4500 context switches/second, BTW.)
>
> Possibly you are using an on-board disk controller, and then it most
> likely does not use the PCI-E bus for disk IO.

I only point it out to show how this setup scales. If there were
bottlenecks in the chipset, they'd have shown up in the test.

-- 
Jon
