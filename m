From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Raid performance problems (pdflush / raid5 eats 100%)
Date: Tue, 2 Oct 2007 12:19:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710021218490.10536@p34.internal.lan>
References: <87sl4tlefa.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87sl4tlefa.fsf@informatik.uni-tuebingen.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 2 Oct 2007, Goswin von Brederlow wrote:

> Hi,
>
> we (Q-Leap networks) are in the process of setting up a high speed
> storage cluster and we are having some problems getting proper
> performance.
>
> Our test system consists of a 2x dual core system with 2 dual channel
> UW scsi controlers connected to 2 external raid boxes and we use
> iozone with 16GB data on an lustre (ldiskfs) filesystem as speed test
> below. The raid boxes internally run raid6 and are split in 2
> partitions, one maped to each scsi port. Read-Ahead is set to 32768.
>
> sdb system controler 1: box 1 controler 1
> sdc system controler 1: box 2 controler 1
> sdd system controler 2: box 1 controler 2
> sde system controler 2: box 2 controler 2
>
> Plain disks: sdb1 sdc1 sdd1 sde1
> --------------------------------
>           write  rewrite read   reread
> 1 Thread : 225204 269084  288718 288219
> 2 Threads: 401154 414525  441005 440564
> 3 Threads: 515818 528943  598863 599455
> 4 Threads: 587184 638971  737094 730850
>
> raid1 [sdb1 sde1] [sdc1 sdd1] chunk=8192
> ----------------------------------------
>           write  rewrite read   reread
> 1 Thread : 179262 271810  293111 293593
> 2 Threads: 326260 345276  496189 498250
> 4 Threads: 333085 308820  686983 679123
> 8 Threads: 348458 277097  643260 673025
>
> raid10 f2 [sdb1 sdc1 sdd1 sde1] chunk=8192
> ------------------------------------------
>           write  rewrite read   reread
> 1 Thread : 215560 323921  466460 436195
> 2 Threads: 288001 304094  611157 586583
> 4 Threads: 336072 298115  639925 662107
> 8 Threads: 243053 183969  665743 638512
>
>
> As you can see adding an raid1 or raid10 layer already costs a certain
> amount of performance. But all within reason. Now the real problem comes:
>
>
> raid5 [sdb1 sdc1 sdd1 sde1] chunk=64, stripe_cache_size=32768
> -----------------------------------------------------------------------
>           write  rewrite read   reread
> 1 Thread : 178540 176061  384928 384653
> 2 Threads: 218113 214308  379950 376312
> 4 Threads: 225560 160209  359628 359170
> 8 Threads: 232252 165669  261981 274043
>
> The performance is totaly limited by pdflush (>80% cpu during write)
> with md0_raid5 eating up a substantial percentage too.
>
>
> raid5 [sdb1 sdc1 sdd1 sde1] chunk=8192, stripe_cache_size=32768
> -----------------------------------------------------------
>           write  rewrite read   reread
> 1 Thread : 171138 185105  424504 428974
> 2 Threads: 165225 141431  553976 545088
> 4 Threads: 178189 110153  582999 581266
> 8 Threads: 177892  99679  568720 594580
>
> This is even stranger. Now pdflush uses less cpu (10-70%) but
> md0_raid5 is blocking with >95% cpu during write.
>
>
>
> Three questions:
>
> 1) pdflush is limited to one thread per filesystem. For our useage
> that is a bottleneck. Can anything be done there?
>
> 2) Why is read performance so lousy with small chunk size?
>
> 3) Why does raid5 take so much more cpu time on write with larger
> chunk size? The amount of data to checksumm is the same (same speed)
> but the cpu time used goes way up. There are no read-modify-write
> cycles in there according to vmstat, plain continious writes.
>
> MfG
>        Goswin
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Have you tried a 1024k stripe and 16384k stripe_cache_size?

I'd be curious what kind of performance/write speed you get with that 
configuration.

Justin.
