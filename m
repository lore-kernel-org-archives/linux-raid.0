From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: Maximizing failed disk replacement on a RAID5 array
Date: Mon, 06 Jun 2011 23:54:41 +0800
Message-ID: <4DECF841.1060906@fnarfbargle.com>
References: <BANLkTimBYFhjQ-sC9DhTMO+PG-Ox+A9S2Q@mail.gmail.com> <BANLkTimOxCF7diZfeFgtqCBWKZVF2pxyLg@mail.gmail.com> <BANLkTi=px08AWxfJJq+zNepCZM8aAsKECA@mail.gmail.com> <4DECF025.9040006@fnarfbargle.com> <BANLkTi=jPiXLySacVZqDkeThdG80K_HTxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=jPiXLySacVZqDkeThdG80K_HTxQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: Durval Menezes <durval.menezes@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/06/11 23:37, Drew wrote:
>> Now, if I'm off the wall and missing something blindingly obvious feel free
>> to thump me with a clue bat (it would not be the first time).
>>
>> I've lost 2 arrays recently. 8TB to a dodgy controller (thanks SIL), and 2TB
>> to complete idiocy on my part, so I know the sting of lost or corrupted
>> data.
> I think you've covered the process in more detail, including pitfalls,
> then I have. :-) Only catch is where would you find a cheap 2-3TB
> drive right now?

I bought 10 recently for about $90 each. It's all relative, but I consider ~$45 / TB cheap.

> I also know the sting of mixing stupidity and dd. ;-) A friend was
> helping me do some complex rework with dd on one of my disks. Being
> the n00b I followed his instructions exactly, and him being the expert
> (and assuming I wasn't the n00b I was back then) didn't double check
> my work. Net result was I backed the MBR/Partition Table up using dd,
> but did so to a partition on the drive we were working on. There may
> have been some alcohol involved (I was in University), the revised
> data we inserted failed, and next thing you know I'm running Partition
> Magic (the gnu tools circa 2005 failed to detect anything) to try and
> recover the partition table. No backups obviously. ;-)

Similar to my

dd if=/dev/zero of=/dev/sdb bs=1M count=100

except instead of the target disk, it was to a raid array member that was currently active. To its 
credit, ext3 and fsck managed to give me most of my data back, even if I had to spend months 
intermittently sorting/renaming inode numbers from lost+found into files and directories.

I'd like to claim Alcohol as a mitigating factor (hell, it gets people off charges in our court 
system all the time) but unfortunately I was just stupid.

