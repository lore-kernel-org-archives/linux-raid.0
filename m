Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E4EECAAD8
	for <linux-raid@archiver.kernel.org>; Wed, 21 Sep 2022 23:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiIUXpJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Sep 2022 19:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiIUXpH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Sep 2022 19:45:07 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019657C75D
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 16:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:References:Cc:To:From:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=grNQPG2I9ArYp8q0qJJz0p4TpplHT7L9+8XYBh5efHk=; b=iAMw2MEz68vTfK/D6MrQ/HoNOB
        ZM77x56Lnws8ApyIL0jHjBJraeUdk7+VdoPRlzlaaX+iF4vIUWqPcFR0mt5SFf+rRrOh0H8Jqbb+/
        xcx8SRkNo2wUSRwVdM+U9qufzrbAzGnABc+IUrP/A6U0AWzyU8TRFapgbMfzwN7U3E4sYpoJ+3nbw
        KozmVi031eV7dfpH1paafUa9AamaFMSyvPQ59J0HfpSeRSqY+K5LlbYPy7uNJm4xq1R+2SNCxc58A
        B6iI/INx4w2mSWQJ/VVfppiuEu+zmB7EPBiaK9IxChY8RfzO3cCoJDob0H3f74cdBgyCl5z49uHnI
        v8QubgyQ==;
Received: from s0106ac1f6bb1ecac.cg.shawcable.net ([70.73.163.230] helo=[192.168.11.155])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1ob9Oo-007Jqx-UC; Wed, 21 Sep 2022 17:45:04 -0600
Message-ID: <80560b23-c124-c8ce-d66b-a7afe5b7fa41@deltatee.com>
Date:   Wed, 21 Sep 2022 17:44:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
From:   Logan Gunthorpe <logang@deltatee.com>
To:     Song Liu <songliubraving@fb.com>, Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     David Sloan <david.sloan@eideticom.com>,
        Yu Kuai <yukuai3@huawei.com>,
        Mateusz Grzonka <mateusz.grzonka@intel.com>,
        Saurabh Sengar <ssengar@linux.microsoft.com>,
        XU pengfei <xupengfei@nfschina.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Zhou nan <zhounan@nfschina.com>
References: <9C523D34-6134-4F86-A357-5F306AC3DD07@fb.com>
 <b347b8e9-d136-3430-5be0-b4b14d067dc4@deltatee.com>
In-Reply-To: <b347b8e9-d136-3430-5be0-b4b14d067dc4@deltatee.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 70.73.163.230
X-SA-Exim-Rcpt-To: songliubraving@fb.com, axboe@kernel.dk, linux-raid@vger.kernel.org, david.sloan@eideticom.com, yukuai3@huawei.com, mateusz.grzonka@intel.com, ssengar@linux.microsoft.com, xupengfei@nfschina.com, guoqing.jiang@linux.dev, zhounan@nfschina.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [GIT PULL] md-next 20220921
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-09-21 16:37, Logan Gunthorpe wrote:
> 
> 
> On 2022-09-21 15:33, Song Liu wrote:
>> Hi Jens, 
>>
>> Please consider pulling the following changes for md-next on top of your
>> for-6.1/block branch (for-6.1/drivers branch doesn't exist yet). 
>>
>> The major changes are:
>>
>> 1. Various raid5 fix and clean up, by Logan Gunthorpe and David Sloan.
>> 2. Raid10 performance optimization, by Yu Kuai. 
>> 3. Generate CHANGE uevents for md device, by Mateusz Grzonka. 
> 
> I may have hit a bug with my tests on the latest md-next branch. Still
> trying to hit it again. The last tests I ran for several days with some
> patches on the previous md-next branch, but I didn't have Mateusz's
> changes, and it also looks like the branch was rebased today so it could
> be caused by either of those things. I'll let you know when I know more.

Yes, ok, I've found two separate issues and both are fixed by reverting

   21023a82bff7 ("md: generate CHANGE uevents for md device")

I suggest we drop that patch for this cycle so we can sort them out.

The issues are:

1) The concrete issue comes when running mdadm test 01r1fail. I get the
kernel bugs at the end of this email. It seems we cannot call
kobject_uevent() in at least one of the contexts that md_new_event() is
called in because it sleeps in a critical section.

2) With our custom test suite that creates and destroys arrays, adds and
removes disks, and runs data through them repeatedly, I randomly start
seeing these warnings:

   mdadm: Fail to create md0 when using
/sys/module/md_mod/parameters/new_array, fallback to creation via node

And then very occasionally get that warning paired with this error:

   mdadm: unexpected failure opening /dev/md0

Which stops the test because it fails to create an array. I also see a
lot of the same bugs as below so it may be related.

Logan

--

 BUG: sleeping function called from invalid context at
include/linux/sched/mm.h:274
 in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 853, name: mdadm
 preempt_count: 0, expected: 0
 RCU nest depth: 1, expected: 0
 1 lock held by mdadm/853:
  #0: ffffffff98c623c0 (rcu_read_lock){....}-{1:2}, at:
md_ioctl+0x8f0/0x2670
 CPU: 2 PID: 853 Comm: mdadm Not tainted
6.0.0-rc2-eid-vmlocalyes-dbg-00096-g9859e343daaf #2680
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2
04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x5a/0x74
  dump_stack+0x10/0x12
  __might_resched.cold+0x146/0x17e
  __might_sleep+0x66/0xc0
  kmem_cache_alloc_trace+0x2f8/0x400
  kobject_uevent_env+0x121/0xa30
  kobject_uevent+0xb/0x10
  md_new_event+0x6b/0x80
  md_error+0x168/0x1b0
  md_ioctl+0x989/0x2670
  blkdev_ioctl+0x24d/0x450
  __x64_sys_ioctl+0xc0/0x100
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

 =============================
 [ BUG: Invalid wait context ]
 6.0.0-rc2-eid-vmlocalyes-dbg-00096-g9859e343daaf #2680 Tainted: G
  W
 -----------------------------
 mdadm/853 is trying to lock:
 ffffffff990e4950 (uevent_sock_mutex){+.+.}-{3:3}, at:
kobject_uevent_env+0x460/0xa30
 other info that might help us debug this:
 context-{4:4}
 1 lock held by mdadm/853:
  #0: ffffffff98c623c0 (rcu_read_lock){....}-{1:2}, at:
md_ioctl+0x8f0/0x2670
 stack backtrace:
 CPU: 2 PID: 853 Comm: mdadm Tainted: G        W
6.0.0-rc2-eid-vmlocalyes-dbg-00096-g9859e343daaf #2680
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2
04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x5a/0x74
  dump_stack+0x10/0x12
  __lock_acquire.cold+0x2f2/0x31a
  lock_acquire+0x183/0x440
  __mutex_lock+0x125/0xe20
  mutex_lock_nested+0x1b/0x20
  kobject_uevent_env+0x460/0xa30
  kobject_uevent+0xb/0x10
  md_new_event+0x6b/0x80
  md_error+0x168/0x1b0
  md_ioctl+0x989/0x2670
  blkdev_ioctl+0x24d/0x450
  __x64_sys_ioctl+0xc0/0x100
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x46/0xb0


