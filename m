From: Coly Li <colyli@suse.de>
Subject: Re: performance of raid5 on fast devices
Date: Tue, 24 Jan 2017 15:11:05 +0800
Message-ID: <ecbeb158-da62-7a27-a5f6-5cc2a6652ae6@suse.de>
References: <CA+Dh761_kVPEcRdFEAo72Wif_t-G7RpgyoKGetEFveyMpaYD1w@mail.gmail.com>
 <20170117101043.78e80bdc@natsu>
 <CA+Dh763Ttvnt9CSEUZ0QwPOLCaZq6VVXmj4OoheR7WTO6o4Pbw@mail.gmail.com>
 <27fb7a94-27d0-b319-30b8-daf4dab97415@redhat.com>
 <CA+Dh761U6J6UKsGBD8dLfBR0bQHjK5T3tj3tTv889BAQWncxfw@mail.gmail.com>
 <a7cf3ce7-688d-819c-60ab-a9b53e14d869@suse.de>
 <CA+Dh761AoRa3g3O4hztTACe5M1sbNRz3_hQQKgikupxLNLVQ8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+Dh761AoRa3g3O4hztTACe5M1sbNRz3_hQQKgikupxLNLVQ8g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jake Yao <jgyao1@gmail.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Jake,

Hmm, is the hardware powerful enough ? When I did similar testing, I
used a machine with 2x10 core XEON CPU, and 80GB memory.
And could you please try bs=64K? I got a good performance number with
64KB blocksize.

And could you have a look at top out put, are all the CPUs 100%
utilized, or still idle on some CPUs ?

Coly

On 2017/1/24 上午6:20, Jake Yao wrote:
> I run tests with multiple IO threads, but it looks like it does not
> affect the overall performance.
> 
> In this run with 8 io threads,
> 
> [global]
> ioengine=libaio
> iodepth=64
> bs=192k
> direct=1
> thread=1
> time_based=1
> runtime=20
> numjobs=8
> loops=1
> group_reporting=1
> rwmixread=70
> rwmixwrite=30
> exitall
> #
> # end of global
> #
> [nvme_md_write]
> rw=write
> filename=/dev/md127
> runtime=20
> 
> [nvme_drv_write]
> rw=write
> filename=/dev/nvme1n1p2
> runtime=20
> 
> I got following for nvme based raid5 and single drive:
> 
> md thrd-cnt 0: write: io=27992MB, bw=1397.5MB/s, iops=7452, runt= 20031msec
> md thrd-cnt 1: write: io=43065MB, bw=2148.6MB/s, iops=11458, runt= 20044msec
> md thrd-cnt 2: write: io=43209MB, bw=2155.9MB/s, iops=11497, runt= 20043msec
> md thrd-cnt 3: write: io=43163MB, bw=2153.9MB/s, iops=11487, runt= 20040msec
> md thrd-cnt 4: write: io=43316MB, bw=2163.2MB/s, iops=11536, runt= 20024msec
> md thrd-cnt 5: write: io=43390MB, bw=2164.7MB/s, iops=11544, runt= 20045msec
> md thrd-cnt 6: write: io=43295MB, bw=2160.2MB/s, iops=11521, runt= 20042msec
> single drive: write: io=36004MB, bw=1795.4MB/s, iops=9575, runt= 20054msec
> 
> It also does not show little effect on ssd based raid5 and single
> drive. Same fio config as above, just changing the corresponding
> device filenames. The result is following:
> 
> md thrd-cnt 0: write: io=13646MB, bw=696242KB/s, iops=3626, runt= 20070msec
> md thrd-cnt 1: write: io=24519MB, bw=1221.5MB/s, iops=6514, runt= 20074msec
> md thrd-cnt 2: write: io=24780MB, bw=1234.9MB/s, iops=6585, runt= 20068msec
> md thrd-cnt 3: write: io=24890MB, bw=1240.2MB/s, iops=6613, runt= 20072msec
> md thrd-cnt 4: write: io=24937MB, bw=1242.5MB/s, iops=6626, runt= 20071msec
> md thrd-cnt 5: write: io=24948MB, bw=1242.9MB/s, iops=6628, runt= 20073msec
> md thrd-cnt 6: write: io=24701MB, bw=1230.1MB/s, iops=6564, runt= 20068msec
> single drive: write: io=8389.4MB, bw=428184KB/s, iops=2230, runt= 20063msec
> 
> In the ssd case, raid5 array is 3x better than a single drive.
> 
> On Fri, Jan 20, 2017 at 9:58 AM, Coly Li <colyli@suse.de> wrote:
>> On 2017/1/19 上午3:25, Jake Yao wrote:
>>> It is interesting. I do not see the similar behavior with the change
>>> of group_thread_cnt.
>>>
>>> The raid5 I have is following:
>>>
>>> md125 : active raid5 nvme0n1p1[0] nvme2n1p1[2] nvme1n1p1[1] nvme3n1p1[4]
>>>       943325184 blocks super 1.2 level 5, 32k chunk, algorithm 2 [4/4] [UUUU]
>>>       bitmap: 0/3 pages [0KB], 65536KB chunk
>>>
>>> /dev/md125:
>>>         Version : 1.2
>>>   Creation Time : Thu Dec 15 20:11:46 2016
>>>      Raid Level : raid5
>>>      Array Size : 943325184 (899.63 GiB 965.96 GB)
>>>   Used Dev Size : 314441728 (299.88 GiB 321.99 GB)
>>>    Raid Devices : 4
>>>   Total Devices : 4
>>>     Persistence : Superblock is persistent
>>>
>>>   Intent Bitmap : Internal
>>>
>>>     Update Time : Wed Jan 18 16:24:52 2017
>>>           State : clean
>>>  Active Devices : 4
>>> Working Devices : 4
>>>  Failed Devices : 0
>>>   Spare Devices : 0
>>>
>>>          Layout : left-symmetric
>>>      Chunk Size : 32K
>>>
>>>            Name : localhost:nvme  (local to host localhost)
>>>            UUID : 477a94af:79f5a10a:0d513dc6:7f5e670d
>>>          Events : 108
>>>
>>>     Number   Major   Minor   RaidDevice State
>>>        0     259        6        0      active sync   /dev/nvme0n1p1
>>>        1     259        8        1      active sync   /dev/nvme1n1p1
>>>        2     259        9        2      active sync   /dev/nvme2n1p1
>>>        4     259        1        3      active sync   /dev/nvme3n1p1
>>>
>>> The fio config is:
>>>
>>> [global]
>>> ioengine=libaio
>>> iodepth=64
>>> bs=96K
>>> direct=1
>>> thread=1
>>> time_based=1
>>> runtime=20
>>> numjobs=1
>>
>> You only have 1 I/O thread, bottle neck is here. Have a try with numjobs=8.
>>
>>> loops=1
>>> group_reporting=1
>>> exitall
>> [snip]
>>
>> Coly

