Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6EAC43331
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 09:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F1B365027
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 09:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235995AbhCPJU2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Mar 2021 05:20:28 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13544 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235961AbhCPJUQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 16 Mar 2021 05:20:16 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F073z4NWpzNmvP;
        Tue, 16 Mar 2021 17:17:51 +0800 (CST)
Received: from [10.174.179.174] (10.174.179.174) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Tue, 16 Mar 2021 17:20:12 +0800
Subject: Re: raid5 crash on system which PAGE_SIZE is 64KB
To:     Xiao Ni <xni@redhat.com>, <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Nigel Croxon <ncroxon@redhat.com>
CC:     Heinz Mauelshagen <heinzm@redhat.com>, <kent.overstreet@gmail.com>
References: <225718c0-475c-7bd7-e067-778f7097a923@redhat.com>
From:   Yufen Yu <yuyufen@huawei.com>
Message-ID: <cdb11ed6-646e-85e6-79f7-cbf38c92b324@huawei.com>
Date:   Tue, 16 Mar 2021 17:20:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <225718c0-475c-7bd7-e067-778f7097a923@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.174]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2021/3/15 21:44, Xiao Ni wrote:
> Hi all
> 
> We encounter one raid5 crash problem on POWER system which PAGE_SIZE is 64KB.
> I can reproduce this problem 100%.  This problem can be reproduced with latest upstream kernel.
> 
> The steps are:
> mdadm -CR /dev/md0 -l5 -n3 /dev/sda1 /dev/sdc1 /dev/sdd1
> mkfs.xfs /dev/md0 -f
> mount /dev/md0 /mnt/test
> 
> The error message is:
> mount: /mnt/test: mount(2) system call failed: Structure needs cleaning.
> 
> We can see error message in dmesg:
> [ 6455.761545] XFS (md0): Metadata CRC error detected at xfs_agf_read_verify+0x118/0x160 [xfs], xfs_agf block 0x2105c008
> [ 6455.761570] XFS (md0): Unmount and run xfs_repair
> [ 6455.761575] XFS (md0): First 128 bytes of corrupted metadata buffer:
> [ 6455.761581] 00000000: fe ed ba be 00 00 00 00 00 00 00 02 00 00 00 00  ................
> [ 6455.761586] 00000010: 00 00 00 00 00 00 03 c0 00 00 00 01 00 00 00 00  ................
> [ 6455.761590] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [ 6455.761594] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [ 6455.761598] 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [ 6455.761601] 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [ 6455.761605] 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [ 6455.761609] 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [ 6455.761662] XFS (md0): metadata I/O error in "xfs_read_agf+0xb4/0x1a0 [xfs]" at daddr 0x2105c008 len 8 error 74
> [ 6455.761673] XFS (md0): Error -117 recovering leftover CoW allocations.
> [ 6455.761685] XFS (md0): Corruption of in-memory data detected. Shutting down filesystem
> [ 6455.761690] XFS (md0): Please unmount the filesystem and rectify the problem(s)
> 
> This problem doesn't happen when creating raid device with --assume-clean. So the crash only happens when sync and normal
> I/O write at the same time.
> 
> I tried to revert the patch set "Save memory for stripe_head buffer" and the problem can be fixed. I'm looking at this problem,
> but I haven't found the root cause. Could you have a look?

Thanks for reporting this bug. Please give me some times to debug it,
recently time is very limited for me.

Thanks,
Yufen

> 
> By the way, there is a place that I can't understand. Is it a bug? Should we do in this way:
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 5d57a5b..4a5e8ae 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1479,7 +1479,7 @@ static struct page **to_addr_page(struct raid5_percpu *percpu, int i)
>   static addr_conv_t *to_addr_conv(struct stripe_head *sh,
>                                   struct raid5_percpu *percpu, int i)
>   {
> -       return (void *) (to_addr_page(percpu, i) + sh->disks + 2);
> +       return (void *) (to_addr_page(percpu, i) + sizeof(struct page*)*(sh->disks + 2));
>   }
> 
>   /*
> @@ -1488,7 +1488,7 @@ static addr_conv_t *to_addr_conv(struct stripe_head *sh,
>   static unsigned int *
>   to_addr_offs(struct stripe_head *sh, struct raid5_percpu *percpu)
>   {
> -       return (unsigned int *) (to_addr_conv(sh, percpu, 0) + sh->disks + 2);
> +       return (unsigned int *) (to_addr_conv(sh, percpu, 0) + sizeof(addr_conv_t)*(sh->disks + 2));
>   }
> 
> This is introduced by commit b330e6a49d (md: convert to kvmalloc)
> 
> Regards
> Xiao
> 
> 
> 
> 
> .
