From: "David Lethe" <david@santools.com>
Subject: RE: new bottleneck section in wiki
Date: Wed, 2 Jul 2008 17:07:37 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97CF200D3@34093-C3-EVS3.exchange.rackspace.com>
References: <20080702155603.GA11156@rap.rap.dk> <A20315AE59B5C34585629E258D76A97CF1FCCC@34093-C3-EVS3.exchange.rackspace.com> <20080702190337.GA2311@sewage.raw-sewage.fake> <cccedfc60807021210y2b47917ap227e46fd1666755e@mail.gmail.com> <20080702193527.GA13186@rap.rap.dk> <cccedfc60807021238w2fdb2a60i5d6c4c8a901071e2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <cccedfc60807021238w2fdb2a60i5d6c4c8a901071e2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>, Keld J?rn Simonsen <keld@dkuug.dk>
Cc: Matt Garman <matthew.garman@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----Original Message-----
From: jnelson@jamponi.net [mailto:jnelson@jamponi.net] On Behalf Of Jon
Nelson
Sent: Wednesday, July 02, 2008 2:38 PM
To: Keld J?rn Simonsen
Cc: Matt Garman; David Lethe; linux-raid@vger.kernel.org
Subject: Re: new bottleneck section in wiki

>> This motherboard (EPoX MF570SLI) uses PCI-E.
>
> PCI-E is quite different architecturally from PCI-X.
>
>> It has a plain old PCI video card in it:
>> Trident Microsystems TGUI 9660/938x/968x
>> and yet I appear to be able to sustain plenty of disk bandwidth to 4
drives:
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
===========================
Not true, Jon.  The test above was limited by the amount of data that a
single drive head can push to the controller with 100% sequential reads
of 64KB.  You can't say anything about chipset bottlenecks, because you
haven't created a condition where the chipset could even be a
bottleneck.  I/O is constrained by the disk drives.

Now, if you attached industrial class SSDs that operate at media speeds
with access time in the NS range, then you could be in a position to
benchmark chipset performance.  

David

