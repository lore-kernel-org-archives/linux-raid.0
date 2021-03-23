Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A2BDC433DB
	for <linux-raid@archiver.kernel.org>; Tue, 23 Mar 2021 07:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA28B61993
	for <linux-raid@archiver.kernel.org>; Tue, 23 Mar 2021 07:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhCWHmC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 23 Mar 2021 03:42:02 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14432 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhCWHll (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 23 Mar 2021 03:41:41 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F4NYp0KD9zkdh3;
        Tue, 23 Mar 2021 15:39:58 +0800 (CST)
Received: from [10.174.179.174] (10.174.179.174) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Tue, 23 Mar 2021 15:41:30 +0800
Subject: Re: raid5 crash on system which PAGE_SIZE is 64KB
To:     Song Liu <song@kernel.org>
CC:     Xiao Ni <xni@redhat.com>, linux-raid <linux-raid@vger.kernel.org>,
        "Nigel Croxon" <ncroxon@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        <kent.overstreet@gmail.com>
References: <225718c0-475c-7bd7-e067-778f7097a923@redhat.com>
 <cdb11ed6-646e-85e6-79f7-cbf38c92b324@huawei.com>
 <CAPhsuW5hV_-0+hcoK4b18h8gP6yy8UffV=wRQKtoCZbfXVu6fw@mail.gmail.com>
From:   Yufen Yu <yuyufen@huawei.com>
Message-ID: <de820ff9-4ae7-2f83-d8c6-58a78322b2a7@huawei.com>
Date:   Tue, 23 Mar 2021 15:41:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW5hV_-0+hcoK4b18h8gP6yy8UffV=wRQKtoCZbfXVu6fw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.174]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

hi

On 2021/3/23 1:28, Song Liu wrote:
> On Tue, Mar 16, 2021 at 2:20 AM Yufen Yu <yuyufen@huawei.com> wrote:
>>
>>
>>
>> On 2021/3/15 21:44, Xiao Ni wrote:
>>> Hi all
>>>
>>> We encounter one raid5 crash problem on POWER system which PAGE_SIZE is 64KB.
>>> I can reproduce this problem 100%.  This problem can be reproduced with latest upstream kernel.
>>>
>>> The steps are:
>>> mdadm -CR /dev/md0 -l5 -n3 /dev/sda1 /dev/sdc1 /dev/sdd1
>>> mkfs.xfs /dev/md0 -f
>>> mount /dev/md0 /mnt/test
>>>
>>> The error message is:
>>> mount: /mnt/test: mount(2) system call failed: Structure needs cleaning.
>>>
>>> We can see error message in dmesg:
>>> [ 6455.761545] XFS (md0): Metadata CRC error detected at xfs_agf_read_verify+0x118/0x160 [xfs], xfs_agf block 0x2105c008
>>> [ 6455.761570] XFS (md0): Unmount and run xfs_repair
>>> [ 6455.761575] XFS (md0): First 128 bytes of corrupted metadata buffer:
>>> [ 6455.761581] 00000000: fe ed ba be 00 00 00 00 00 00 00 02 00 00 00 00  ................
>>> [ 6455.761586] 00000010: 00 00 00 00 00 00 03 c0 00 00 00 01 00 00 00 00  ................
>>> [ 6455.761590] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>> [ 6455.761594] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>> [ 6455.761598] 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>> [ 6455.761601] 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>> [ 6455.761605] 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>> [ 6455.761609] 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>> [ 6455.761662] XFS (md0): metadata I/O error in "xfs_read_agf+0xb4/0x1a0 [xfs]" at daddr 0x2105c008 len 8 error 74
>>> [ 6455.761673] XFS (md0): Error -117 recovering leftover CoW allocations.
>>> [ 6455.761685] XFS (md0): Corruption of in-memory data detected. Shutting down filesystem
>>> [ 6455.761690] XFS (md0): Please unmount the filesystem and rectify the problem(s)
>>>
>>> This problem doesn't happen when creating raid device with --assume-clean. So the crash only happens when sync and normal
>>> I/O write at the same time.
>>>
>>> I tried to revert the patch set "Save memory for stripe_head buffer" and the problem can be fixed. I'm looking at this problem,
>>> but I haven't found the root cause. Could you have a look?
>>
>> Thanks for reporting this bug. Please give me some times to debug it,
>> recently time is very limited for me.
>>
>> Thanks,
>> Yufen
> 
> Hi Yufen,
> 
> Have you got time to look into this?
> 

I can also reproduce this problem on my qemu vm system, with 3 10G disks.
But, there is no problem when I change mkfs.xfs option 'agcount' (default
value is 16 for my system). For example, if I set agcount=15, there is no
problem when mount xfs, likely:

mkfs.xfs -d agcount=15 -f /dev/md0
mount /dev/md0 /mnt/test

In addition, I try to write a 128MB file to /dev/md0 and then read it out
during md resync, they are same by checking md5sum, likely:

dd if=randfile of=/dev/md0 bs=1M count=128 oflag=direct seek=10240
dd if=/dev/md0 of=out.randfile bs=1M count=128 oflag=direct skip=10240

BTW, I found mkfs.xfs have some options related to raid device, such as
sunit, su, swidth, sw. I guess this problem may be caused by data alignment.
But, I have no idea how it happen. More time may needed.

Thanks
Yufen

