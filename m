From: Coly Li <colyli@suse.de>
Subject: Re: performance of raid5 on fast devices
Date: Fri, 20 Jan 2017 22:58:40 +0800
Message-ID: <a7cf3ce7-688d-819c-60ab-a9b53e14d869@suse.de>
References: <CA+Dh761_kVPEcRdFEAo72Wif_t-G7RpgyoKGetEFveyMpaYD1w@mail.gmail.com>
 <20170117101043.78e80bdc@natsu>
 <CA+Dh763Ttvnt9CSEUZ0QwPOLCaZq6VVXmj4OoheR7WTO6o4Pbw@mail.gmail.com>
 <27fb7a94-27d0-b319-30b8-daf4dab97415@redhat.com>
 <CA+Dh761U6J6UKsGBD8dLfBR0bQHjK5T3tj3tTv889BAQWncxfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+Dh761U6J6UKsGBD8dLfBR0bQHjK5T3tj3tTv889BAQWncxfw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jake Yao <jgyao1@gmail.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2017/1/19 上午3:25, Jake Yao wrote:
> It is interesting. I do not see the similar behavior with the change
> of group_thread_cnt.
> 
> The raid5 I have is following:
> 
> md125 : active raid5 nvme0n1p1[0] nvme2n1p1[2] nvme1n1p1[1] nvme3n1p1[4]
>       943325184 blocks super 1.2 level 5, 32k chunk, algorithm 2 [4/4] [UUUU]
>       bitmap: 0/3 pages [0KB], 65536KB chunk
> 
> /dev/md125:
>         Version : 1.2
>   Creation Time : Thu Dec 15 20:11:46 2016
>      Raid Level : raid5
>      Array Size : 943325184 (899.63 GiB 965.96 GB)
>   Used Dev Size : 314441728 (299.88 GiB 321.99 GB)
>    Raid Devices : 4
>   Total Devices : 4
>     Persistence : Superblock is persistent
> 
>   Intent Bitmap : Internal
> 
>     Update Time : Wed Jan 18 16:24:52 2017
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 32K
> 
>            Name : localhost:nvme  (local to host localhost)
>            UUID : 477a94af:79f5a10a:0d513dc6:7f5e670d
>          Events : 108
> 
>     Number   Major   Minor   RaidDevice State
>        0     259        6        0      active sync   /dev/nvme0n1p1
>        1     259        8        1      active sync   /dev/nvme1n1p1
>        2     259        9        2      active sync   /dev/nvme2n1p1
>        4     259        1        3      active sync   /dev/nvme3n1p1
> 
> The fio config is:
> 
> [global]
> ioengine=libaio
> iodepth=64
> bs=96K
> direct=1
> thread=1
> time_based=1
> runtime=20
> numjobs=1

You only have 1 I/O thread, bottle neck is here. Have a try with numjobs=8.

> loops=1
> group_reporting=1
> exitall
[snip]

Coly
