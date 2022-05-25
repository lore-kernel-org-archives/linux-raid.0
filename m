Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E90E4C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 25 May 2022 09:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiEYJHe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 May 2022 05:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243970AbiEYJGC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 25 May 2022 05:06:02 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3B9980A5
        for <linux-raid@vger.kernel.org>; Wed, 25 May 2022 02:04:19 -0700 (PDT)
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1653469457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i2Xssv6BlrbZtl0FjT2Fv1Na6HFo13GEW0XqSFhnI/Q=;
        b=o0q7FWKxa8faqbGZZmydGjbtOX4fpR1jZ6r/XlZsp3cuq3VJfcNQv3sapRwHdmc2eG2zBe
        VrI1FZmapLIJrzgAkyXjPtHVOfEa9l3GBfrrMqVptbvwpWYoiWA3n2ZZGKgkYQ/n43eYUz
        CUxAEEoyg7evQYLNBQ7XJyv0hJuOY+Q=
To:     Logan Gunthorpe <logang@deltatee.com>,
        Donald Buczek <buczek@molgen.mpg.de>,
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
 <82a08e9c-e3f4-4eb6-cb06-58b96c0f01a8@deltatee.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <775d6734-2b08-21a8-a093-f750d31ce6ce@linux.dev>
Date:   Wed, 25 May 2022 17:04:13 +0800
MIME-Version: 1.0
In-Reply-To: <82a08e9c-e3f4-4eb6-cb06-58b96c0f01a8@deltatee.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/25/22 12:13 AM, Logan Gunthorpe wrote:
> On 2022-05-23 03:51, Guoqing Jiang wrote:
>> I have tried with both ubuntu 22.04 kernel which is 5.15 and vanilla
>> 5.12, none of them
>> can pass your mentioned tests.
>>
>> [root@localhost mdadm]# lsblk|grep vd
>> vda          252:0    0    1G  0 disk
>> vdb          252:16   0    1G  0 disk
>> vdc          252:32   0    1G  0 disk
>> vdd          252:48   0    1G  0 disk
>> [root@localhost mdadm]# ./test --dev=disk --disks=/dev/vd{a..d}
>> --tests=05r1-add-internalbitmap
>> Testing on linux-5.12.0-default kernel
>> /root/mdadm/tests/05r1-add-internalbitmap... succeeded
>> [root@localhost mdadm]# ./test --dev=disk --disks=/dev/vd{a..d}
>> --tests=07reshape5intr
>> Testing on linux-5.12.0-default kernel
>> /root/mdadm/tests/07reshape5intr... FAILED - see
>> /var/tmp/07reshape5intr.log and /var/tmp/fail07reshape5intr.log for details
>> [root@localhost mdadm]# ./test --dev=disk --disks=/dev/vd{a..d}
>> --tests=07revert-grow
>> Testing on linux-5.12.0-default kernel
>> /root/mdadm/tests/07revert-grow... FAILED - see
>> /var/tmp/07revert-grow.log and /var/tmp/fail07revert-grow.log for details
>> [root@localhost mdadm]# head -10  /var/tmp/07revert-grow.log | grep mdadm
>> + . /root/mdadm/tests/07revert-grow
>> *++ mdadm -CR --assume-clean /dev/md0 -l5 -n4 -x1 /dev/vda /dev/vdb
>> /dev/vdc /dev/vdd /dev/vda /dev/vdb /dev/vdc /dev/vdd --metadata=0.9**
>> *
>> The above line is clearly wrong from my understanding.
>>
>> And let's check ubuntu 22.04.
>>
>> root@vm:/home/gjiang/mdadm# lsblk|grep vd
>> vda    252:0    0     1G  0 disk
>> vdb    252:16   0     1G  0 disk
>> vdc    252:32   0     1G  0 disk
>> root@vm:/home/gjiang/mdadm# ./test --dev=disk --disks=/dev/vd{a..d}
>> --tests=05r1-failfast
>> Testing on linux-5.15.0-30-generic kernel
>> /home/gjiang/mdadm/tests/05r1-failfast... succeeded
>> root@vm:/home/gjiang/mdadm# ./test --dev=disk --disks=/dev/vd{a..c}
>> --tests=07reshape5intr
>> Testing on linux-5.15.0-30-generic kernel
>> /home/gjiang/mdadm/tests/07reshape5intr... FAILED - see
>> /var/tmp/07reshape5intr.log and /var/tmp/fail07reshape5intr.log for details
>> root@vm:/home/gjiang/mdadm# ./test --dev=disk --disks=/dev/vd{a..c}
>> --tests=07revert-grow
>> Testing on linux-5.15.0-30-generic kernel
>> /home/gjiang/mdadm/tests/07revert-grow... FAILED - see
>> /var/tmp/07revert-grow.log and /var/tmp/fail07revert-grow.log for details
>>
>> So I would not consider it is regression.
> I definitely had those test working (at least some of the time) before I
> rebased on md-next or if I revert 7e6ba434cc6080. You might need to try
> my branch (plus that patch reverted) and my mdadm branch as there are a
> number of fixes that may have helped with that specific test.
>
> https://github.com/lsgunth/mdadm/ bugfixes2
> https://github.com/sbates130272/linux-p2pmem md-bug

I would prefer to focus on block tree or md tree. With latest block tree
(commit 44d8538d7e7dbee7246acda3b706c8134d15b9cb), I get below
similar issue as Donald reported, it happened with the cmd (which did
work with 5.12 kernel).

vm79:~/mdadm> sudo ./test --dev=loop --tests=05r1-add-internalbitmap

May 25 04:48:51 vm79 kernel: Call Trace:
May 25 04:48:51 vm79 kernel:  <TASK>
May 25 04:48:51 vm79 kernel:  bfq_bic_update_cgroup+0x28/0x1b0
May 25 04:48:51 vm79 kernel:  bfq_insert_requests+0x29d/0x22d0
May 25 04:48:51 vm79 kernel:  ? ioc_find_get_icq+0x21c/0x2a0
May 25 04:48:51 vm79 kernel:  ? bfq_prepare_request+0x11/0x30
May 25 04:48:51 vm79 kernel:  blk_mq_sched_insert_request+0x8b/0x100
May 25 04:48:51 vm79 kernel:  blk_mq_submit_bio+0x44c/0x540
May 25 04:48:51 vm79 kernel:  __submit_bio+0xe8/0x160
May 25 04:48:51 vm79 kernel:  submit_bio_noacct_nocheck+0xf0/0x2b0
May 25 04:48:51 vm79 kernel:  ? submit_bio+0x3e/0xd0
May 25 04:48:51 vm79 kernel:  submit_bio+0x3e/0xd0
May 25 04:48:51 vm79 kernel:  submit_bh_wbc+0x117/0x140
May 25 04:48:51 vm79 kernel:  block_read_full_page+0x1eb/0x4f0
May 25 04:48:51 vm79 kernel:  ? blkdev_llseek+0x60/0x60
May 25 04:48:51 vm79 kernel:  ? folio_add_lru+0x51/0x80
May 25 04:48:51 vm79 kernel:  do_read_cache_folio+0x3b4/0x5e0
May 25 04:48:51 vm79 kernel:  ? kmem_cache_alloc_node+0x183/0x2e0
May 25 04:48:51 vm79 kernel:  ? alloc_vmap_area+0x9f/0x8a0
May 25 04:48:51 vm79 kernel:  read_cache_page+0x15/0x80
May 25 04:48:51 vm79 kernel:  read_part_sector+0x38/0x140
May 25 04:48:51 vm79 kernel:  read_lba+0x105/0x220
May 25 04:48:51 vm79 kernel:  efi_partition+0xed/0x7f0

Thanks,
Guoqing
