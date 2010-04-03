From: MRK <mrk@shiftmail.org>
Subject: Re: Linux Raid performance
Date: Sat, 03 Apr 2010 20:14:04 +0200
Message-ID: <4BB7856C.30808@shiftmail.org>
References: <r2v7efa8a7d1003311242vfa92024ar93ad2123a7b49806@mail.gmail.com>
 <20100331201539.GA19395@rap.rap.dk>
 <g2s7efa8a7d1004012007ibe8b42b6k28a6d2a531fb6103@mail.gmail.com>
 <20100402110506.GA16294@rap.rap.dk>
 <x2q7efa8a7d1004021055oe2e832ccl8877e9171b8f3442@mail.gmail.com>
 <l2j5bdc1c8b1004021739z969b99v6011fcc6fddd470a@mail.gmail.com>
 <4BB69670.3040303@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4BB69670.3040303@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Mark Knecht <markknecht@gmail.com>, Learner Study <learner.study@gmail.com>, linux-raid@vger.kernel.org, keld@dkuug.dk
List-Id: linux-raid.ids

Richard Scobie wrote:
> Mark Knecht wrote:
>
>> Once all of that is in place then possibly more cores will help, but I
>> suspect even then it probably hard to use 4 billion CPU cycles/second
>> doing nothing but disk I/O. SATA controllers are all doing DMA so CPU
>> overhead is relatively *very* low.
>
> There is the RAID5/6 parity calculations to be considered on writes 
> and this appears to be single threaded. There is an experimental 
> multicore kernel option I believe, but recent discussion indicates 
> there may be some problems with it.
>
> A very quick test on a box here on a Xeon E5440 (4 x 2.8GHz) and a SAS 
> attached 16 x 750GB SATA md RAID6. The array is 72% full and probably 
> quite fragmented and currently the system is idle.
>
> dd if=/dev/zero of=/mnt/storage/dump bs=1M count=20000
> 20000+0 records in
> 20000+0 records out
> 20971520000 bytes (21 GB) copied, 87.2374 s, 240 MB/s
>
> Looking at the outputs of vmstat 5 and mpstat -P ALL 5 during this, 
> one core (probably doing parity generation) was around 7.56% idle and 
> the other 3 were around 88.5, 67.5 and 51.8% idle.
>
> The same test run when the system was commissioned and the array was 
> empty, acheived 565MB/s writes.

I was able to achieve about 430MB/sec on a 24 disks raid-6 with dd on an 
XFS filesystem which was 70% full. I don't think it made great 
difference even if it was empty. It was a 54xx Xeon CPU.
I spent some time trying to optimize it but that was the best I could 
get. Anyway both my benchmark and Richard's one imply a very significant 
bottleneck somehwere.
16 SATA disks have aggregated I/O streaming performance of about 
1.4GB/sec so getting 500MB/sec it's 3 times slower.
Raid-0 does not have this problem: there is an old post of Mark Delfman 
on this ML in which he was able to obtain about 1.7GB/sec with 10 SAS 
disks (15Krpm) in RAID-0, which is much higher than 500MB/s and it's 
about the bare disk speed.
I always thought the reason of the slower raid 5/6 was the parity 
computation but now that Nicolae has pointed out that the parity 
computation speed is so high, the reason must be elsewhere.
Could that be RAM I/O? Raid 5/6 copies data, then probably reads it 
again for the parity computation and then writes the parity out... the 
CPU cache is too small to hold a stripe for large arrays so it's at 
least 3 RAM accesses but yet it should be way faster than this imho.

MRK
