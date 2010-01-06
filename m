From: Antonio Perez <ap23563m@gmx.com>
Subject: Re: embedding area is unusually small... (GRUB2 on software RAID1)
Date: Wed, 06 Jan 2010 18:23:07 -0400
Message-ID: <1894585.O4pOeKWFqe@rnqqfki.eternal-september.org>
References: <1262825627.g6ATheBPQY@rnqqfki.eternal-september.org> <932657.98441.qm@web88207.mail.re2.yahoo.com>
Reply-To: ap23563m@gmx.com
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lapohos Tibor wrote:

[...]
>> > should I create all the partitions first and build
>> > them into so many /dev/md[01234] devices separately maybe?

>> I could tell you what seems to be a reasonable setup IMO:
>> 200Mb --> {sda1,sdb1} --> md1 --> RAID1 --> use as /boot
>> 5Gb   --> {sda2,sdb2} --> md2 --> RAID1 --> use as /
>> ...
> 
> ....and that's exactly what is also on my list, and your suggestion
> enforces my thoughts, thanks. Nevertheless, it still does not explain to
> me whether multiple md devices with more underlying disk partitions or
> more md partitions with fewer underlying disk partitions are the way to
> go. To be absolutely clear, is the
> 
> /dev/sd[ab]1 => /dev/md0 => /dev/md0p[123...] [RAID1]
> /dev/sd[ab]2 => /dev/md1 => /dev/md1p[123...] [RAID0]

I never meant to say to re-partition the md device!!
Why is that needed in a small 200 MByte partition?
I really like the a KISS approach.
 
> or the

> /dev/sd[ab][123...] => /dev/md[012...] [RAID1,RAID0]

> setup the most stable, efficient and robust solution? The way I see it,
> there shall be a difference somewhere, somehow, right? About the first
> one, thanks to Michael E. pointing it out, we already know that one has to
> take care about choosing the patritions.

I can't say what differences or efficiency is there, but it doesn't work!!
So, what does it matter?
Boot your system with the SIMPLE two RAID I stated above, and then, play as 
you wish with as many raid levels and sub-partitions as you want with the 
*rest* of the disks.
 
> Furthermore, I think that the gain in speed of RAID0 would start vanishing
> if disk access is required on the RAID1 side all at the same time.

> In fact, the whole system's efficiency would degrade. The only way out
> would be to use 4 disks as
> 
> /dev/sd[ab]1 => /dev/md0 => /dev/md0p[123...] [RAID1]
> /dev/sd[cd]1 => /dev/md1 => /dev/md1p[123...] [RAID0]
> 
> Right? Keep in mind that I am not after what RAID10 can offer. I can
> afford giving up the data safety on the RAID0 side in exchange for speed.

Yes, right. Do you have four disks?

>> Having only two disks means to use only RAID1. RAID0 is too
>> risky IMO as any disk failure means a complete loss of data.

> I will be developing a numerical electromagnetics code, that will do quite
> some number crunching and dumping with 4xTesla C1060 GPUs. I will need the
> RAID0 for that purpose, for a scratch space, if you will. So it is a must
> have for me.

I was just warning about a possible loss of data, if that is not an issue in 
your system, do set up as many RAID0 as you need.

-- 
Antonio Perez

