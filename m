From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: =?UTF-8?B?562U5aSN77yabWQgcmFpZDUgcGVyZm9ybWFjZSA2eCBTU0QgUkE=?=
 =?UTF-8?B?SUQ1?=
Date: Wed, 27 Nov 2013 22:41:49 -0600
Message-ID: <5296C98D.8000302@hardwarefreak.com>
References: <1385118796.8091.31.camel@bews002.euractiv.com>	<528FBBE5.80404@hardwarefreak.com>	<1385369796.2076.16.camel@bews002.euractiv.com>	<5293EF32.9090301@hardwarefreak.com>	<20131126025210.GL8803@dastard>	<52941C5D.1000305@hardwarefreak.com> <20131126061458.GM8803@dastard>,529455CB.6050907@hardwarefreak.com,3c94e3bd-c74f-44ed-a1da-443b08edc43e@aliyun.com <36ffd6f7-bfb0-4298-a18c-f45b07cab326@aliyun.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <36ffd6f7-bfb0-4298-a18c-f45b07cab326@aliyun.com>
Sender: linux-raid-owner@vger.kernel.org
To: lilofile <lilofile@aliyun.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/27/2013 7:51 AM, lilofile wrote:
> additional: CPU: Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz
>                 memory:32GB
...
> when I create raid5 which use six SSD(sTEC s840),
> when the stripe_cache_size is set 4096. 
> root@host1:/sys/block/md126/md# cat /proc/mdstat 
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
> md126 : active raid5 sdg[6] sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
>       3906404480 blocks super 1.2 level 5, 128k chunk, algorithm 2 [6/6] [UUUUUU]
> 
> the single ssd read/write performance :
> 
> root@host1:~# dd if=/dev/sdb of=/dev/zero count=100000 bs=1M
> ^C76120+0 records in
> 76119+0 records out
> 79816556544 bytes (80 GB) copied, 208.278 s, 383 MB/s
> 
> root@host1:~# dd of=/dev/sdb if=/dev/zero count=100000 bs=1M
> 100000+0 records in
> 100000+0 records out
> 104857600000 bytes (105 GB) copied, 232.943 s, 450 MB/s
> 
> the raid read and write performance is  approx 1.8GB/s read and 1.1GB/s write performance
> root@sc0:/sys/block/md126/md# dd if=/dev/zero of=/dev/md126 count=100000 bs=1M
> 100000+0 records in
> 100000+0 records out
> 104857600000 bytes (105 GB) copied, 94.2039 s, 1.1 GB/s
> 
> 
> root@sc0:/sys/block/md126/md# dd of=/dev/zero if=/dev/md126 count=100000 bs=1M
> 100000+0 records in
> 100000+0 records out
> 104857600000 bytes (105 GB) copied, 59.5551 s, 1.8 GB/s
> 
> why the performance is so bad?  especially the write performace.

There are 3 things that could be, or are, limiting performance here.

1.  The RAID5 write thread peaks one CPU core as it is single threaded
2.  A 4KB stripe cache is too small for 6 SSDs, try 8KB
3.  dd issues IOs serially and will thus never saturate the hardware

#1 will eventually be addressed with a multi-thread patch to the various
RAID drivers including RAID5.  There is no workaround at this time.

To address #3 use FIO or a similar testing tool that can issue IOs in
parallel.  With SSD based storage you will never reach maximum
throughput with a serial data stream.

-- 
Stan

