Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B0ACA0FF8
	for <linux-raid@archiver.kernel.org>; Sat,  2 Sep 2023 07:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351671AbjIBHNP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 2 Sep 2023 03:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235906AbjIBHNO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 2 Sep 2023 03:13:14 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15F910F3
        for <linux-raid@vger.kernel.org>; Sat,  2 Sep 2023 00:13:10 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Rd5hf243Mz4f3lVv
        for <linux-raid@vger.kernel.org>; Sat,  2 Sep 2023 15:13:06 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgA3xqiA4PJkyTetCA--.27669S3;
        Sat, 02 Sep 2023 15:13:05 +0800 (CST)
Subject: Re: RADI10 slower than SINGLE drive - tests with fio for block device
 (no filesystem in use) - 18.5k vs 26k iops
To:     CoolCold <coolthecold@gmail.com>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <CAGqmV7ojxmsMVStS2LWzfeN+A565z4U=d9kUBUnAfCGq5TGtsw@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Cc:     "yukuai (C)" <yukuai3@huawei.com>,
        "yangerkun@huawei.com" <yangerkun@huawei.com>
Message-ID: <c22e4c16-ad15-b358-ac42-778675aeb5ad@huaweicloud.com>
Date:   Sat, 2 Sep 2023 15:13:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAGqmV7ojxmsMVStS2LWzfeN+A565z4U=d9kUBUnAfCGq5TGtsw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgA3xqiA4PJkyTetCA--.27669S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZFykCF4xKFWfuFyxGF1UAwb_yoW7Gr4Dpa
        4kJF4Fq3yxW347C397A3y0g3WxuryUJa45Cr1ft3y2yay3XrZ5t3WDAr45W3y2vFs3Ga43
        Zws7Jr909ryIg37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
        j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
        kEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAK
        I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
        xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xII
        jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
        0EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
        1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/09/02 14:56, CoolCold 写道:
> Good day!
> 2nd part of the question, in relation of hardware/system from previous
> thread -  "raid10, far layout initial sync slow + XFS question"
> https://www.spinics.net/lists/raid/msg74907.html - Ubuntu 20.04 with
> kernel "5.4.0-153-generic #170-Ubuntu" on Hetzner AX161 / AMD EPYC
> 7502P 32-Core Processor
> 
> Gist: issuing the same load on RAID10 4 drives N2 16kb chunk is slower
> than running the same load on a single member of that RAID
> Question: is such kind of behavior normal and expected? Am I doing
> something terribly wrong?

Write will be slower is normal, because each write to the array must
write to all the rdev and wait for these write be be done.

On the other hand, read should be faster, because raid10 only need to
choose one rdev to read.

Thanks,
Kuai

> 
> RAID10: 18.5k iops
> SINGLE DRIVE: 26k iops
> 
> raw data:
> 
> RAID config
> root@node2:/data# cat /proc/mdstat
> Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
> [raid4] [raid10]
> md3 : active raid10 nvme5n1[3] nvme3n1[2] nvme4n1[1] nvme0n1[0]
>        7501212320 blocks super 1.2 16K chunks 2 near-copies [4/4] [UUUU]
> 
> Single drive with:
> root@node2:/data# mdadm /dev/md3 --fail /dev/nvme5n1 --remove /dev/nvme5n1
> mdadm: set /dev/nvme5n1 faulty in /dev/md3
> mdadm: hot removed /dev/nvme5n1 from /dev/md3
> 
> mdadm --zero-superblock /dev/nvme5n1
> 
> TEST COMMANDS
> RADI10:              fio --rw=write --ioengine=sync --fdatasync=1
> --filename=/dev/md3 --size=8200m --bs=16k --name=mytest
> SINGLE DRIVE: fio --rw=write --ioengine=sync --fdatasync=1
> --filename=/dev/nvme5n1 --size=8200m --bs=16k --name=mytest
> 
> FIO output:
> 
> RAID10:
> root@node2:/mnt# fio --rw=write --ioengine=sync --fdatasync=1
> --filename=/dev/md3 --size=8200m --bs=16k --name=mytest
> mytest: (g=0): rw=write, bs=(R) 16.0KiB-16.0KiB, (W) 16.0KiB-16.0KiB,
> (T) 16.0KiB-16.0KiB, ioengine=sync, iodepth=1
> fio-3.16
> Starting 1 process
> Jobs: 1 (f=1): [W(1)][100.0%][w=298MiB/s][w=19.0k IOPS][eta 00m:00s]
> mytest: (groupid=0, jobs=1): err= 0: pid=2130392: Sat Sep  2 08:21:39 2023
>    write: IOPS=18.5k, BW=290MiB/s (304MB/s)(8200MiB/28321msec); 0 zone resets
>      clat (usec): min=5, max=745, avg=12.12, stdev= 7.30
>       lat (usec): min=6, max=746, avg=12.47, stdev= 7.34
>      clat percentiles (usec):
>       |  1.00th=[    8],  5.00th=[    9], 10.00th=[   10], 20.00th=[   10],
>       | 30.00th=[   10], 40.00th=[   11], 50.00th=[   11], 60.00th=[   11],
>       | 70.00th=[   12], 80.00th=[   13], 90.00th=[   16], 95.00th=[   20],
>       | 99.00th=[   39], 99.50th=[   55], 99.90th=[  100], 99.95th=[  116],
>       | 99.99th=[  147]
>     bw (  KiB/s): min=276160, max=308672, per=99.96%, avg=296354.86,
> stdev=6624.06, samples=56
>     iops        : min=17260, max=19292, avg=18522.18, stdev=414.00, samples=56
> 
> Run status group 0 (all jobs):
>    WRITE: bw=290MiB/s (304MB/s), 290MiB/s-290MiB/s (304MB/s-304MB/s),
> io=8200MiB (8598MB), run=28321-28321msec
> 
> 
>                                                Disk stats (read/write):
> 
>                                       md3: ios=0/2604727, merge=0/0,
> ticks=0/0, in_queue=0, util=0.00%, aggrios=25/262403,
> aggrmerge=0/787199, aggrticks=1/5563, aggrin_queue=0, aggrutil=98.10%
>    nvme0n1: ios=40/262402, merge=1/787200, ticks=3/5092, in_queue=0, util=98.09%
>    nvme3n1: ios=33/262404, merge=1/787198, ticks=2/5050, in_queue=0, util=98.08%
>    nvme5n1: ios=15/262404, merge=0/787198, ticks=1/6061, in_queue=0, util=98.08%
>    nvme4n1: ios=12/262402, merge=0/787200, ticks=1/6052, in_queue=0, util=98.10%
> 
> 
> SINGLE DRIVE:
> root@node2:/mnt# fio --rw=write --ioengine=sync --fdatasync=1
> --filename=/dev/nvme5n1 --size=8200m --bs=16k --name=mytest
> mytest: (g=0): rw=write, bs=(R) 16.0KiB-16.0KiB, (W) 16.0KiB-16.0KiB,
> (T) 16.0KiB-16.0KiB, ioengine=sync, iodepth=1
> fio-3.16
> Starting 1 process
> Jobs: 1 (f=1): [W(1)][100.0%][w=414MiB/s][w=26.5k IOPS][eta 00m:00s]
> mytest: (groupid=0, jobs=1): err= 0: pid=2155313: Sat Sep  2 08:26:23 2023
>    write: IOPS=26.2k, BW=410MiB/s (430MB/s)(8200MiB/20000msec); 0 zone resets
>      clat (usec): min=4, max=848, avg=11.25, stdev= 7.15
>       lat (usec): min=5, max=848, avg=11.50, stdev= 7.17
>      clat percentiles (usec):
>       |  1.00th=[    7],  5.00th=[    9], 10.00th=[    9], 20.00th=[    9],
>       | 30.00th=[   10], 40.00th=[   10], 50.00th=[   10], 60.00th=[   11],
>       | 70.00th=[   11], 80.00th=[   12], 90.00th=[   15], 95.00th=[   18],
>       | 99.00th=[   43], 99.50th=[   62], 99.90th=[   95], 99.95th=[  108],
>       | 99.99th=[  133]
>     bw (  KiB/s): min=395040, max=464480, per=99.90%, avg=419438.95,
> stdev=17496.05, samples=39
>     iops        : min=24690, max=29030, avg=26214.92, stdev=1093.56, samples=39
> 
> Run status group 0 (all jobs):
>    WRITE: bw=423MiB/s (444MB/s), 423MiB/s-423MiB/s (444MB/s-444MB/s),
> io=8200MiB (8598MB), run=19379-19379msec
> 
> Disk stats (read/write):
>    nvme5n1: ios=49/518250, merge=0/1554753, ticks=2/10629, in_queue=0,
> util=99.61%
> 

