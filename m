From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Linux Raid performance
Date: Fri, 2 Apr 2010 18:32:35 -0700
Message-ID: <y2i5bdc1c8b1004021832x283f72f7uea429f24d79b6fa2@mail.gmail.com>
References: <r2v7efa8a7d1003311242vfa92024ar93ad2123a7b49806@mail.gmail.com>
	 <20100331201539.GA19395@rap.rap.dk>
	 <g2s7efa8a7d1004012007ibe8b42b6k28a6d2a531fb6103@mail.gmail.com>
	 <20100402110506.GA16294@rap.rap.dk>
	 <x2q7efa8a7d1004021055oe2e832ccl8877e9171b8f3442@mail.gmail.com>
	 <l2j5bdc1c8b1004021739z969b99v6011fcc6fddd470a@mail.gmail.com>
	 <4BB69670.3040303@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB69670.3040303@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Learner Study <learner.study@gmail.com>, linux-raid@vger.kernel.org, keld@dkuug.dk
List-Id: linux-raid.ids

On Fri, Apr 2, 2010 at 6:14 PM, Richard Scobie <richard@sauce.co.nz> wrote:
> Mark Knecht wrote:
>
>> Once all of that is in place then possibly more cores will help, but I
>> suspect even then it probably hard to use 4 billion CPU cycles/second
>> doing nothing but disk I/O. SATA controllers are all doing DMA so CPU
>> overhead is relatively *very* low.
>
> There is the RAID5/6 parity calculations to be considered on writes and this
> appears to be single threaded. There is an experimental multicore kernel
> option I believe, but recent discussion indicates there may be some problems
> with it.
>
> A very quick test on a box here on a Xeon E5440 (4 x 2.8GHz) and a SAS
> attached 16 x 750GB SATA md RAID6. The array is 72% full and probably quite
> fragmented and currently the system is idle.
>
> dd if=/dev/zero of=/mnt/storage/dump bs=1M count=20000
> 20000+0 records in
> 20000+0 records out
> 20971520000 bytes (21 GB) copied, 87.2374 s, 240 MB/s
>
> Looking at the outputs of vmstat 5 and mpstat -P ALL 5 during this, one core
> (probably doing parity generation) was around 7.56% idle and the other 3
> were around 88.5, 67.5 and 51.8% idle.
>
> The same test run when the system was commissioned and the array was empty,
> acheived 565MB/s writes.
>
> Regards,
>
> Richard

Richard,
   Good point. I was limited in my thinking to the sorts of arrays I
might use at home being no wider than 3, 4 or 5 disks. However for our
N-wide array as N approaches infinity so do the cycles required to run
it. I don think that applies to the OP but I don't know that.

   Thanks for making the point.

Cheers,
Mark
