From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: =?UTF-8?B?562U5aSN77ya562U5aSN77yabWQgcmFpZDUgcGVyZm9ybWFjZSA=?=
 =?UTF-8?B?NnggU1NEIFJBSUQ1?=
Date: Thu, 28 Nov 2013 20:38:20 -0600
Message-ID: <5297FE1C.6080504@hardwarefreak.com>
References: <1385118796.8091.31.camel@bews002.euractiv.com>	<528FBBE5.80404@hardwarefreak.com>	<1385369796.2076.16.camel@bews002.euractiv.com>	<5293EF32.9090301@hardwarefreak.com>	<20131126025210.GL8803@dastard>	<52941C5D.1000305@hardwarefreak.com> <20131126061458.GM8803@dastard>,529455CB.6050907@hardwarefreak.com,3c94e3bd-c74f-44ed-a1da-443b08edc43e@aliyun.com <36ffd6f7-bfb0-4298-a18c-f45b07cab326@aliyun.com>,5296C98D.8000302@hardwarefreak.com <fa7f0ec0-e7ba-46ca-a129-24bb45b52460@aliyun.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fa7f0ec0-e7ba-46ca-a129-24bb45b52460@aliyun.com>
Sender: linux-raid-owner@vger.kernel.org
To: lilofile <lilofile@aliyun.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/28/2013 4:02 AM, lilofile wrote:
> thank you  for your advise. now I have test multi-thread patch, the single raid5 performance improve 30%.
> 
> but I have another problem,when write on single raid,write performance is  approx 1.1GB/s 
...
> [1]-  Done                    dd if=/dev/zero of=/dev/md126 count=100000 bs=1M
> [2]+  Done                    dd if=/dev/zero of=/dev/md127 count=100000 bs=1M

No.  This is not a parallel IO test.

...
> To address #3 use FIO or a similar testing tool that can issue IOs in
> parallel.  With SSD based storage you will never reach maximum
> throughput with a serial data stream.

This is a parallel IO test, one command line:

~# fio --directory=/dev/md126 --zero_buffers --numjobs=16
--group_reporting --blocksize=64k --ioengine=libaio --iodepth=16
--direct=1 --size=64g --name=read --rw=read --stonewall --name=write
--rw=write --stonewall

Normally this targets a filesystem, not a raw block device.  This
command line should work for a raw md device.

-- 
Stan
