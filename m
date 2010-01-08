From: "spren.gm@gmail.com" <spren.gm@gmail.com>
Subject: Re: why is md/raid5 sequential write speed so slow?
Date: Fri, 8 Jan 2010 13:39:21 +0800
Message-ID: <201001081339187349051@gmail.com>
References: <6c394cc31001072119l2619d8aap627164d34eec6806@mail.gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: dong wu <dongwucs@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> from:dong wu
>I have made a test in my server!
>raid5 capacity:80G,  disks:9
>IO type                        IOPS                   speed(M/s)
>1024k seq write            40.67                   40.67
>512k seq write              70.89                   39.45
>256k seq write             36.02                    34.00
>128k seq write             134.19                   16.77
>64k seq write               232.26                   14.52
>32k seq write              160.23                    5.01
>16k seq write              148.48                    2.32
>8k seq write                151.05                   1.18
>4k seq write                151.39                   0.59
>2k seq write                 290.90                  0.57
>1k seq write                 526.21                  0.51
>512B seq write             1076.60                0.53
>
>I don't know why raid5 seq write is so slow.
>Does delaying write cause this?
>
well, 
(1) is raid5 degraded ,recovering or resyncing ?
(2) how is the speed of members ?
(3) how do you test that (tools) and how is the cpu utilization during test?
(4) it seems that you used partitions of disks as raid members, any other read/write operations on other partitions ?
(5) try to set /sys/block/mdX/md/stripe_cache_size larger
(6) XOR calculation too slow?

------------------				 
spren.gm@gmail.com
2010-01-08


