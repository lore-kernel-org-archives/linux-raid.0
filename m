From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Without tweaking ,
Date: Wed, 26 Sep 2007 17:24:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0709261715380.5907@p34.internal.lan>
References: <Pine.LNX.4.64.0709260953580.12074@filesrv1.baby-dragons.com>
 <Pine.LNX.4.64.0709261406010.24646@p34.internal.lan> <46FAB899.6050201@sauce.co.nz>
 <Pine.LNX.4.64.0709261645460.4199@p34.internal.lan> <46FAC643.4010505@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46FAC643.4010505@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Thu, 27 Sep 2007, Richard Scobie wrote:

> Justin Piszcz wrote:
>
>> If you have a good repeatable benchmark you want me to run with it on/off 
>> let me know, no I only used bonnie++/iozone/tiobench/dd but not any 
>> parallelism with those utilities.
>
> Perhaps iozone with 5 threads, NCQ on and off?
>
> Regards,
>
> Richard
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

With multiple threads, not too much difference..

NCQ OFF: iozone -l 5

         Children see throughput for  5 initial writers  =  894857.31 KB/sec
         Parent sees throughput for  5 initial writers   =    5484.80 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      =  894857.31 KB/sec
         Avg throughput per process                      =  178971.46 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for  5 rewriters        = 1289930.50 KB/sec
         Parent sees throughput for  5 rewriters         =   12722.45 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      = 1289930.50 KB/sec
         Avg throughput per process                      =  257986.10 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for  5 readers          = 1992459.00 KB/sec
         Parent sees throughput for  5 readers           =  361601.94 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      = 1992459.00 KB/sec
         Avg throughput per process                      =  398491.80 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for 5 re-readers        = 2169601.25 KB/sec
         Parent sees throughput for 5 re-readers         =  545904.86 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      = 2169601.25 KB/sec
         Avg throughput per process                      =  433920.25 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for 5 reverse readers   = 1662389.12 KB/sec
         Parent sees throughput for 5 reverse readers    =  530530.32 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      = 1662389.12 KB/sec
         Avg throughput per process                      =  332477.83 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for 5 stride readers    = 1689860.00 KB/sec
         Parent sees throughput for 5 stride readers     =  559560.28 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      = 1689860.00 KB/sec
         Avg throughput per process                      =  337972.00 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for 5 random readers    = 1640796.38 KB/sec
         Parent sees throughput for 5 random readers     =  384384.88 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      = 1640796.38 KB/sec
         Avg throughput per process                      =  328159.28 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for 5 mixed workload    = 1723771.00 KB/sec
         Parent sees throughput for 5 mixed workload     =    2954.09 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      = 1723771.00 KB/sec
         Avg throughput per process                      =  344754.20 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for 5 random writers    = 1312798.75 KB/sec
         Parent sees throughput for 5 random writers     =    3750.95 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      = 1312798.75 KB/sec
         Avg throughput per process                      =  262559.75 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for 5 pwrite writers    =  915847.19 KB/sec
         Parent sees throughput for 5 pwrite writers     =    2395.21 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      =  915847.19 KB/sec
         Avg throughput per process                      =  183169.44 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for 5 pread readers     = 1620980.12 KB/sec
         Parent sees throughput for 5 pread readers      =  272911.00 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      = 1620980.12 KB/sec
         Avg throughput per process                      =  324196.03 KB/sec
         Min xfer                                        =       0.00 KB

NCQ ON: iozone -l 5


         Children see throughput for  5 initial writers  =  867738.31 KB/sec
         Parent sees throughput for  5 initial writers   =    4722.90 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      =  867738.31 KB/sec
         Avg throughput per process                      =  173547.66 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for  5 rewriters        = 1326585.25 KB/sec
         Parent sees throughput for  5 rewriters         =   11928.29 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      = 1326585.25 KB/sec
         Avg throughput per process                      =  265317.05 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for  5 readers          = 1895721.12 KB/sec
         Parent sees throughput for  5 readers           =  334665.53 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      = 1895721.12 KB/sec
         Avg throughput per process                      =  379144.22 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for 5 re-readers        = 2091421.75 KB/sec
         Parent sees throughput for 5 re-readers         =  310473.32 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      = 2091421.75 KB/sec
         Avg throughput per process                      =  418284.35 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for 5 reverse readers   = 1630828.12 KB/sec
         Parent sees throughput for 5 reverse readers    =  260181.03 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      = 1630828.12 KB/sec
         Avg throughput per process                      =  326165.62 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for 5 stride readers    = 1647088.75 KB/sec
         Parent sees throughput for 5 stride readers     =  311644.78 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      = 1647088.75 KB/sec
         Avg throughput per process                      =  329417.75 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for 5 random readers    = 1736314.50 KB/sec
         Parent sees throughput for 5 random readers     =  547017.30 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      = 1736314.50 KB/sec
         Avg throughput per process                      =  347262.90 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for 5 mixed workload    = 1599251.25 KB/sec
         Parent sees throughput for 5 mixed workload     =   11172.20 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      = 1599251.25 KB/sec
         Avg throughput per process                      =  319850.25 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for 5 random writers    = 1333173.62 KB/sec
         Parent sees throughput for 5 random writers     =    3302.71 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      = 1333173.62 KB/sec
         Avg throughput per process                      =  266634.72 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for 5 pwrite writers    = 1117430.12 KB/sec
         Parent sees throughput for 5 pwrite writers     =   10313.44 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      = 1117430.12 KB/sec
         Avg throughput per process                      =  223486.02 KB/sec
         Min xfer                                        =       0.00 KB

         Children see throughput for 5 pread readers     = 1610042.38 KB/sec
         Parent sees throughput for 5 pread readers      =  269047.35 KB/sec
         Min throughput per process                      =       0.00 KB/sec
         Max throughput per process                      = 1610042.38 KB/sec
         Avg throughput per process                      =  322008.47 KB/sec
         Min xfer                                        =       0.00 KB

