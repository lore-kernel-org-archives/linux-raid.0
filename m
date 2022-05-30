Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 906ABC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 30 May 2022 09:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbiE3J4O (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 May 2022 05:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbiE3J4N (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 May 2022 05:56:13 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49594C7A2
        for <linux-raid@vger.kernel.org>; Mon, 30 May 2022 02:56:11 -0700 (PDT)
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1653904570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZoMpYzh34zzB5ARo9PPQnq+/eblJ/Z2YLXYPvv2jr5I=;
        b=eS0Z43PNZVD10WHTgEWOFFZmi2r8aBZ+yvVXNLJNkV3oZx9gRaGyHszmYvWxZa/Kqd5ss3
        MdFnhVQVVuFa9fIPZhfYdRYjtXun+mWeAF0OPpi1dTqHcYs2g90ibUyTSSK+hFgl/w+KI+
        u0ipenVUsFRGZxM5LHYfKhbwpzQKwyI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     Donald Buczek <buczek@molgen.mpg.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
 <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
 <b4244eab-d9e2-20a0-ebce-1a96e8fadb91@deltatee.com>
 <836b2a93-65be-8d6c-8610-18373b88f86d@molgen.mpg.de>
 <5b0584a3-c128-cb53-7c8a-63744c60c667@linux.dev>
 <4edc9468-d195-6937-f550-211bccbd6756@molgen.mpg.de>
 <954f9c33-7801-b6d2-65e3-9e5237905886@linux.dev>
Message-ID: <31a9aed2-16cf-663a-5da3-0f9543ceb8c9@linux.dev>
Date:   Mon, 30 May 2022 17:55:58 +0800
MIME-Version: 1.0
In-Reply-To: <954f9c33-7801-b6d2-65e3-9e5237905886@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/23/22 5:51 PM, Guoqing Jiang wrote:
>
>
>>>>> I noticed a clear regression with mdadm tests with this patch in 
>>>>> md-next
>>>>> (7e6ba434cc6080).
>>>>>
>>>>> Before the patch, tests 07reshape5intr and 07revert-grow would fail
>>>>> fairly infrequently (about 1 in 4 runs for the former and 1 in 30 
>>>>> runs
>>>>> for the latter).
>>>>>
>>>>> After this patch, both tests always fail.
>>>>>
>>>>> I don't have time to dig into why this is, but it would be nice if
>>>>> someone can at least fix the regression. It is hard to make any 
>>>>> progress
>>>>> on these tests if we are continuing to further break them.
>
> I have tried with both ubuntu 22.04 kernel which is 5.15 and vanilla 
> 5.12, none of them
> can pass your mentioned tests.
>
> [root@localhost mdadm]# lsblk|grep vd
> vda          252:0    0    1G  0 disk
> vdb          252:16   0    1G  0 disk
> vdc          252:32   0    1G  0 disk
> vdd          252:48   0    1G  0 disk
> [root@localhost mdadm]# ./test --dev=disk --disks=/dev/vd{a..d} 
> --tests=05r1-add-internalbitmap
> Testing on linux-5.12.0-default kernel
> /root/mdadm/tests/05r1-add-internalbitmap... succeeded
> [root@localhost mdadm]# ./test --dev=disk --disks=/dev/vd{a..d} 
> --tests=07reshape5intr
> Testing on linux-5.12.0-default kernel
> /root/mdadm/tests/07reshape5intr... FAILED - see 
> /var/tmp/07reshape5intr.log and /var/tmp/fail07reshape5intr.log for 
> details
> [root@localhost mdadm]# ./test --dev=disk --disks=/dev/vd{a..d} 
> --tests=07revert-grow
> Testing on linux-5.12.0-default kernel
> /root/mdadm/tests/07revert-grow... FAILED - see 
> /var/tmp/07revert-grow.log and /var/tmp/fail07revert-grow.log for details
> [root@localhost mdadm]# head -10  /var/tmp/07revert-grow.log | grep mdadm
> + . /root/mdadm/tests/07revert-grow
> *++ mdadm -CR --assume-clean /dev/md0 -l5 -n4 -x1 /dev/vda /dev/vdb 
> /dev/vdc /dev/vdd /dev/vda /dev/vdb /dev/vdc /dev/vdd --metadata=0.9**
> *
> The above line is clearly wrong from my understanding.
>
> And let's check ubuntu 22.04.
>
> root@vm:/home/gjiang/mdadm# lsblk|grep vd
> vda    252:0    0     1G  0 disk
> vdb    252:16   0     1G  0 disk
> vdc    252:32   0     1G  0 disk
> root@vm:/home/gjiang/mdadm# ./test --dev=disk --disks=/dev/vd{a..d} 
> --tests=05r1-failfast
> Testing on linux-5.15.0-30-generic kernel
> /home/gjiang/mdadm/tests/05r1-failfast... succeeded
> root@vm:/home/gjiang/mdadm# ./test --dev=disk --disks=/dev/vd{a..c}   
> --tests=07reshape5intr
> Testing on linux-5.15.0-30-generic kernel
> /home/gjiang/mdadm/tests/07reshape5intr... FAILED - see 
> /var/tmp/07reshape5intr.log and /var/tmp/fail07reshape5intr.log for 
> details
> root@vm:/home/gjiang/mdadm# ./test --dev=disk --disks=/dev/vd{a..c} 
> --tests=07revert-grow
> Testing on linux-5.15.0-30-generic kernel
> /home/gjiang/mdadm/tests/07revert-grow... FAILED - see 
> /var/tmp/07revert-grow.log and /var/tmp/fail07revert-grow.log for details
>
> So I would not consider it is regression.

I tried with 5.18.0-rc3, no problem for 07reshape5intr (will investigate 
why it failed with this patch), but 07revert-grow still failed without
apply this one.

 From fail07revert-grow.log, it shows below issues.

[ 7856.233515] mdadm[25246]: segfault at 0 ip 000000000040fe56 sp 
00007ffdcf252800 error 4 in mdadm[400000+81000]
[ 7856.233544] Code: 00 48 8d 7c 24 30 e8 79 30 ff ff 48 8d 7c 24 30 31 
f6 31 c0 e8 db 34 ff ff 85 c0 79 77 bf 26 50 46 00 b9 04 00 00 00 48 89 
de <f3> a6 0f 97 c0 1c 00 84 c0 75 18 e8 fa 36 ff ff 48 0f be 53 04 48

[ 7866.871747] mdadm[25463]: segfault at 0 ip 000000000040fe56 sp 
00007ffe91e39800 error 4 in mdadm[400000+81000]
[ 7866.871760] Code: 00 48 8d 7c 24 30 e8 79 30 ff ff 48 8d 7c 24 30 31 
f6 31 c0 e8 db 34 ff ff 85 c0 79 77 bf 26 50 46 00 b9 04 00 00 00 48 89 
de <f3> a6 0f 97 c0 1c 00 84 c0 75 18 e8 fa 36 ff ff 48 0f be 53 04 48

[ 7876.779855] ======================================================
[ 7876.779858] WARNING: possible circular locking dependency detected
[ 7876.779861] 5.18.0-rc3-57-default #28 Tainted: G            E
[ 7876.779864] ------------------------------------------------------
[ 7876.779867] mdadm/25444 is trying to acquire lock:
[ 7876.779870] ffff991817749938 ((wq_completion)md_misc){+.+.}-{0:0}, 
at: flush_workqueue+0x87/0x470
[ 7876.779879]
                but task is already holding lock:
[ 7876.779882] ffff9917c5c1c2c0 (&mddev->reconfig_mutex){+.+.}-{3:3}, 
at: action_store+0x11a/0x2c0 [md_mod]
[ 7876.779892]
                which lock already depends on the new lock.

[ 7876.779896]
                the existing dependency chain (in reverse order) is:
[ 7876.779899]
                -> #3 (&mddev->reconfig_mutex){+.+.}-{3:3}:
[ 7876.779904]        __mutex_lock+0x8f/0x920
[ 7876.779909]        layout_store+0x47/0x120 [md_mod]
[ 7876.779914]        md_attr_store+0x7a/0xc0 [md_mod]
[ 7876.779919]        kernfs_fop_write_iter+0x135/0x1b0
[ 7876.779924]        new_sync_write+0x10c/0x190
[ 7876.779927]        vfs_write+0x30e/0x370
[ 7876.779930]        ksys_write+0xa4/0xe0
[ 7876.779933]        do_syscall_64+0x3a/0x80
[ 7876.779936]        entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 7876.779940]
                -> #2 (kn->active#359){++++}-{0:0}:
[ 7876.779945]        __kernfs_remove+0x28c/0x2e0
[ 7876.779948]        kernfs_remove_by_name_ns+0x52/0x90
[ 7876.779952]        remove_files.isra.1+0x30/0x70
[ 7876.779955]        sysfs_remove_group+0x3d/0x80
[ 7876.779958]        sysfs_remove_groups+0x29/0x40
[ 7876.779962]        __kobject_del+0x1b/0x80
[ 7876.779965]        kobject_del+0xf/0x20
[ 7876.779968]        mddev_delayed_delete+0x15/0x20 [md_mod]
[ 7876.779973]        process_one_work+0x2d8/0x650
[ 7876.779976]        worker_thread+0x2a/0x3b0
[ 7876.779979]        kthread+0xe8/0x110
[ 7876.779981]        ret_from_fork+0x22/0x30
[ 7876.779985]
                -> #1 ((work_completion)(&mddev->del_work)#2){+.+.}-{0:0}:
[ 7876.779990]        process_one_work+0x2af/0x650
[ 7876.779993]        worker_thread+0x2a/0x3b0
[ 7876.779996]        kthread+0xe8/0x110
[ 7876.779998]        ret_from_fork+0x22/0x30
[ 7876.780001]
                -> #0 ((wq_completion)md_misc){+.+.}-{0:0}:
[ 7876.780005]        __lock_acquire+0x12a0/0x1770
[ 7876.780009]        lock_acquire+0x277/0x310
[ 7876.780011]        flush_workqueue+0xae/0x470
[ 7876.780014]        action_store+0x188/0x2c0 [md_mod]
[ 7876.780019]        md_attr_store+0x7a/0xc0 [md_mod]
[ 7876.780024]        kernfs_fop_write_iter+0x135/0x1b0
[ 7876.780027]        new_sync_write+0x10c/0x190
[ 7876.780030]        vfs_write+0x30e/0x370
[ 7876.780033]        ksys_write+0xa4/0xe0
[ 7876.780036]        do_syscall_64+0x3a/0x80
[ 7876.780038]        entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 7876.780042]
                other info that might help us debug this:

[ 7876.780045] Chain exists of:
                  (wq_completion)md_misc --> kn->active#359 --> 
&mddev->reconfig_mutex

[ 7876.780052]  Possible unsafe locking scenario:

[ 7876.780054]        CPU0                    CPU1
[ 7876.780056]        ----                    ----
[ 7876.780059]   lock(&mddev->reconfig_mutex);
[ 7876.780061] lock(kn->active#359);
[ 7876.780064] lock(&mddev->reconfig_mutex);
[ 7876.780068]   lock((wq_completion)md_misc);
[ 7876.780070]
                 *** DEADLOCK ***

[ 7876.780073] 5 locks held by mdadm/25444:
[ 7876.780075]  #0: ffff9917c769a458 (sb_writers#3){.+.+}-{0:0}, at: 
ksys_write+0xa4/0xe0
[ 7876.780082]  #1: ffff9917de1a6518 (&of->prealloc_mutex){+.+.}-{3:3}, 
at: kernfs_fop_write_iter+0x5c/0x1b0
[ 7876.780088]  #2: ffff9917de1a6488 (&of->mutex){+.+.}-{3:3}, at: 
kernfs_fop_write_iter+0x103/0x1b0
[ 7876.780094]  #3: ffff99181b0d2158 (kn->active#287){++++}-{0:0}, at: 
kernfs_fop_write_iter+0x10c/0x1b0
[ 7876.780100]  #4: ffff9917c5c1c2c0 
(&mddev->reconfig_mutex){+.+.}-{3:3}, at: action_store+0x11a/0x2c0 [md_mod]
[ 7876.780108]
                stack backtrace:
[ 7876.780111] CPU: 1 PID: 25444 Comm: mdadm Tainted: G E     
5.18.0-rc3-57-default #28
[ 7876.780115] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
rel-1.14.0-0-g155821a-rebuilt.opensuse.org 04/01/2014
[ 7876.780120] Call Trace:
[ 7876.780122]  <TASK>
[ 7876.780124]  dump_stack_lvl+0x55/0x6d
[ 7876.780128]  check_noncircular+0x105/0x120
[ 7876.780133]  ? __lock_acquire+0x12a0/0x1770
[ 7876.780136]  ? lockdep_lock+0x21/0x90
[ 7876.780139]  __lock_acquire+0x12a0/0x1770
[ 7876.780143]  lock_acquire+0x277/0x310
[ 7876.780146]  ? flush_workqueue+0x87/0x470
[ 7876.780149]  ? __raw_spin_lock_init+0x3b/0x60
[ 7876.780152]  ? lockdep_init_map_type+0x58/0x250
[ 7876.780156]  flush_workqueue+0xae/0x470
[ 7876.780158]  ? flush_workqueue+0x87/0x470
[ 7876.780161]  ? _raw_spin_unlock+0x29/0x40
[ 7876.780166]  ? action_store+0x188/0x2c0 [md_mod]
[ 7876.780171]  action_store+0x188/0x2c0 [md_mod]
[ 7876.780176]  md_attr_store+0x7a/0xc0 [md_mod]
[ 7876.780182]  kernfs_fop_write_iter+0x135/0x1b0
[ 7876.780186]  new_sync_write+0x10c/0x190
[ 7876.780190]  vfs_write+0x30e/0x370
[ 7876.780193]  ksys_write+0xa4/0xe0
[ 7876.780197]  do_syscall_64+0x3a/0x80
[ 7876.780200]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 7876.780203] RIP: 0033:0x7f7cd43f9c03
[ 7876.780206] Code: 2d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b3 0f 
1f 80 00 00 00 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 01 00 00 00 0f 
05 <48> 3d 00 f0 ff ff 77 55 f3 c3 0f 1f 00 41 54 55 49 89 d4 53 48 89
[ 7876.780213] RSP: 002b:00007fff35b600b8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000001
[ 7876.780218] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 
00007f7cd43f9c03
[ 7876.780221] RDX: 0000000000000004 RSI: 00000000004669a7 RDI: 
0000000000000003
[ 7876.780224] RBP: 00000000004669a7 R08: 000000000000000b R09: 
00000000ffffffff
[ 7876.780227] R10: 0000000000000000 R11: 0000000000000246 R12: 
000000000183d730
[ 7876.780231] R13: 00000000ffffffff R14: 0000000000001800 R15: 
0000000000000000
[ 7876.780236]  </TASK>
[ 7876.781007] md: reshape of RAID array md0
[ 7876.785949] md: md0: reshape interrupted.
[ 7877.193686] md0: detected capacity change from 107520 to 0
[ 7877.193694] md: md0 stopped.
[ 7877.314438] debugfs: Directory 'md0' with parent 'block' already present!
[ 7877.649549] md: array md0 already has disks!
[ 7877.665188] md/raid:md0: device loop0 operational as raid disk 0
[ 7877.665193] md/raid:md0: device loop3 operational as raid disk 3
[ 7877.665197] md/raid:md0: device loop2 operational as raid disk 2
[ 7877.665199] md/raid:md0: device loop1 operational as raid disk 1
[ 7877.665202] md/raid:md0: device loop4 operational as raid disk 4
[ 7877.665205] md/raid:md0: force stripe size 512 for reshape
[ 7877.667172] md/raid:md0: raid level 5 active with 4 out of 4 devices, 
algorithm 2
[ 7877.667360] md0: detected capacity change from 0 to 107520
[ 7878.107865] mdadm[25693]: segfault at 0 ip 000000000040fe56 sp 
00007fff7a845d50 error 4 in mdadm[400000+81000]
[ 7878.107878] Code: 00 48 8d 7c 24 30 e8 79 30 ff ff 48 8d 7c 24 30 31 
f6 31 c0 e8 db 34 ff ff 85 c0 79 77 bf 26 50 46 00 b9 04 00 00 00 48 89 
de <f3> a6 0f 97 c0 1c 00 84 c0 75 18 e8 fa 36 ff ff 48 0f be 53 04 48
[ 7878.428298] md: reshape of RAID array md0
[ 7880.552543] md: md0: reshape done.
[ 7882.053117] md0: detected capacity change from 107520 to 0
[ 7882.053124] md: md0 stopped.
[ ... ]
[ 7904.978417] md0: detected capacity change from 0 to 107520
[ 7905.346749] mdadm[26328]: segfault at 0 ip 000000000040fe56 sp 
00007ffc28540c20 error 4 in mdadm[400000+81000]
[ 7905.346764] Code: 00 48 8d 7c 24 30 e8 79 30 ff ff 48 8d 7c 24 30 31 
f6 31 c0 e8 db 34 ff ff 85 c0 79 77 bf 26 50 46 00 b9 04 00 00 00 48 89 
de <f3> a6 0f 97 c0 1c 00 84 c0 75 18 e8 fa 36 ff ff 48 0f be 53 04 48
[ 7905.476488] md: reshape of RAID array md0
[ 7907.530152] md: md0: reshape done.
[ 7909.149524] md0: detected capacity change from 107520 to 0
[ 7909.149533] md: md0 stopped.

Thanks,
Guoqing
