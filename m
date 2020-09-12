Return-Path: <SRS0=Qcx5=CV=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B57AC43461
	for <linux-raid@archiver.kernel.org>; Sat, 12 Sep 2020 14:21:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1734220855
	for <linux-raid@archiver.kernel.org>; Sat, 12 Sep 2020 14:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgILOV4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 12 Sep 2020 10:21:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:35296 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgILOVu (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 12 Sep 2020 10:21:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7153DAAC7;
        Sat, 12 Sep 2020 14:22:04 +0000 (UTC)
Subject: Re: unexpected 'mdadm -S' hang with I/O pressure testing
From:   Coly Li <colyli@suse.de>
To:     linux-raid@vger.kernel.org
Cc:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <songliubraving@fb.com>, xiao ni <xni@redhat.com>
References: <a5f14765-4da8-e965-beed-3d01ac496c61@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Message-ID: <0be1a9cf-3a8a-4ed9-91b8-d15787528acf@suse.de>
Date:   Sat, 12 Sep 2020 22:21:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <a5f14765-4da8-e965-beed-3d01ac496c61@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

One thing to correct: the hang is not forever - after I posted the
previous email, all commands returns and the array stopped. It takes
around 40 minutes -- still quite unexpected and suspicious.

Thanks.

Coly Li

On 2020/9/12 22:06, Coly Li wrote:
> Unexpected Behavior:
> - With Linux v5.9-rc4 mainline kernel and latest mdadm upstream code
> - After running fio with 10 jobs, 16 iodpes and 64K block size for a
> while, try to stop the fio process by 'Ctrl + c', the main fio process
> hangs.
> - Then try to stop the md raid 5 array by 'mdadm -S /dev/md0', the mdad
> process hangs.
> - Reboot the system by 'echo b > /proc/sysrq-trigger', this md raid5
> array is assembled but inactive. /proc/mdstat shows,
> 	Personalities : [raid6] [raid5] [raid4]
> 	md127 : inactive sdc[0] sde[3] sdd[1]
> 	      35156259840 blocks super 1.2
> 
> Expectation:
> - The fio process can stop with 'Ctrl + c'
> - The raid5 array can be stopped by 'mdadm -S /dev/md0'
> - This md raid5 array may continue to work (resync and being active)
> after reboot
> 
> 
> How to reproduce:
> 1) Create md raid5 with 3 hard drives (12TB for each SATA spinning disk)
>   # mdadm -C /dev/md0 -l 5 -n 3 /dev/sd{c,d,e}
>   # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sde[3] sdd[1] sdc[0]
>       23437506560 blocks super 1.2 level 5, 512k chunk, algorithm 2
> [3/2] [UU_]
>       [>....................]  recovery =  0.0% (2556792/11718753280)
> finish=5765844.7min speed=33K/sec
>       bitmap: 2/88 pages [8KB], 65536KB chunk
> 
> 2) Run fio for random write on the raid5 array
>   fio job file content:
> [global]
> thread=1
> ioengine=libaio
> random_generator=tausworthe64
> 
> [job]
> filename=/dev/md0
> readwrite=randwrite
> blocksize=64K
> numjobs=10
> iodepth=16
> runtime=1m
>   # fio ./raid5.fio
> 
> 3) Wait for 10 seconds after the above fio runs, then type 'Ctrl + c' to
> stop the fio process:
> x:/home/colyli/fio_test/raid5 # fio ./raid5.fio
> job: (g=0): rw=randwrite, bs=(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.0KiB,
> (T) 64.0KiB-64.0KiB, ioengine=libaio, iodepth=16
> ...
> fio-3.23-10-ge007
> Starting 12 threads
> ^Cbs: 12 (f=12): [w(12)][3.3%][w=6080KiB/s][w=95 IOPS][eta 14m:30s]
> fio: terminating on signal 2
> ^C
> fio: terminating on signal 2
> ^C
> fio: terminating on signal 2
> Jobs: 11 (f=11): [w(5),_(1),w(4),f(1),w(1)][7.5%][eta 14m:20s]
> ^C
> fio: terminating on signal 2
> Jobs: 11 (f=11): [w(5),_(1),w(4),f(1),w(1)][70.5%][eta 15m:00s]
> 
> Now the fio process is hang forever.
> 
> 4) try to stop this md raid5 array by mdadm
>   # mdadm -S /dev/md0
>   Now the mdadm process hangs for ever
> 
> 
> Kernel versions to reproduce
> - Use latest upstream mdadm source code
> - I tried Linux v5.9-rc4, and Linux v4.12, both of them may stable
> reproduce the above unexpected behavior.
>   Therefore I assume maybe at least from v4.12 to v5.9 may have such issue.
> 
> Just for your information, hope you may have a look into it. Thanks in
> advance.
> 
> Coly Li
> 

