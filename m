Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B40C41513
	for <linux-raid@archiver.kernel.org>; Mon,  7 Aug 2023 02:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjHGCJM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 6 Aug 2023 22:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjHGCJL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 6 Aug 2023 22:09:11 -0400
Received: from juniper.fatooh.org (juniper.fatooh.org [173.255.221.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B3C1701
        for <linux-raid@vger.kernel.org>; Sun,  6 Aug 2023 19:09:09 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPS id B59CA403E5;
        Sun,  6 Aug 2023 19:09:09 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        by juniper.fatooh.org (Postfix) with ESMTP id 84DA4403F3;
        Sun,  6 Aug 2023 19:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:subject:to:cc:references:from:in-reply-to
        :content-type:content-transfer-encoding; s=dkim; bh=2iJcMSXfcV9p
        E0haAtyTMqohZvs=; b=V+mrNiVKLSHsTD7vg6gRhg78IY8qWp+vXBxnhKhO8NMr
        GW953rWsTqkFxsN3meXRc6nln4yfwBVSls0lLD5+mTdHmK+hvJhC9fiawNsMi6KQ
        KbcY/gK1clKPIH1dHw37TxPKUrkLv8MWChNCXQGDe3TpAaZUne6Dg/gRk/21RLY=
DomainKey-Signature: a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:subject:to:cc:references:from:in-reply-to
        :content-type:content-transfer-encoding; q=dns; s=dkim; b=dmoOJ+
        JqQPpkLESBAXNTWPVdvm5QXCzU/KUHINmAELTfZeWHnHMt13aixICdcslrfWmj4+
        Mh+oCand+tUB/f3wVpyhaJs1np6rJfkV4RUP/lxt38dlcX/NAdfVbw3a3RFo1no0
        QKiFegdxUeKYzYB0ifgzUuisbcwHyrKlhSBnA=
Received: from [198.18.0.3] (unknown [104.184.153.121])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPSA id 627E1403E5;
        Sun,  6 Aug 2023 19:09:09 -0700 (PDT)
Message-ID: <428ed674-6e8c-471b-93d7-0532549fb218@fatooh.org>
Date:   Sun, 6 Aug 2023 19:09:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: NULL pointer dereference with MD write-back journal, where
 journal device is RAID-1
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>,
        'Linux RAID' <linux-raid@vger.kernel.org>
Cc:     "yukuai (C)" <yukuai3@huawei.com>
References: <7c57f3a8-36e9-4805-b1ea-a4fd3406f7bb@fatooh.org>
 <f8b858cc-8762-6b53-43ec-7f509a971f16@huaweicloud.com>
From:   Corey Hickey <bugfood-ml@fatooh.org>
In-Reply-To: <f8b858cc-8762-6b53-43ec-7f509a971f16@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2023-08-06 18:02, Yu Kuai wrote:
>> Here are the errors reported by the kernel:
>> --------------------------------------------------------------------
>> [ 2566.222104] BUG: kernel NULL pointer dereference, address:
>> 0000000000000157
>> [ 2566.222111] #PF: supervisor read access in kernel mode
>> [ 2566.222114] #PF: error_code(0x0000) - not-present page
>> [ 2566.222117] PGD 0 P4D 0
>> [ 2566.222121] Oops: 0000 [#1] PREEMPT SMP NOPTI
>> [ 2566.222125] CPU: 1 PID: 5415 Comm: md10_raid5 Not tainted 6.4.8 #3
>> [ 2566.222129] Hardware name: ASUS System Product Name/ROG CROSSHAIR VII
>> HERO (WI-FI), BIOS 4603 09/13/2021
>> [ 2566.222132] RIP: 0010:submit_bio_noacct+0x182/0x5c0
> 
> Can you provide addr2line result? This will be helpful to locate the
> problem.

I have not done this before; I struggled a bit until I found this:
https://lwn.net/Articles/592724/

These are run within the kernel source tree, which I have not
modified since the original compilation.


$ scripts/decode_stacktrace.sh vmlinux < /tmp/trace1
[ 2566.222171] ? __die (arch/x86/kernel/dumpstack.c:421 arch/x86/kernel/dumpstack.c:434)
[ 2566.222176] ? page_fault_oops (arch/x86/mm/fault.c:707)
[ 2566.222180] ? update_load_avg (kernel/sched/fair.c:3920 kernel/sched/fair.c:4255)
[ 2566.222185] ? exc_page_fault (./arch/x86/include/asm/paravirt.h:695 arch/x86/mm/fault.c:1494 arch/x86/mm/fault.c:1542)
[ 2566.222190] ? asm_exc_page_fault (./arch/x86/include/asm/idtentry.h:570)
[ 2566.222196] ? submit_bio_noacct (block/blk-throttle.h:198 block/blk-throttle.h:210 block/blk-core.c:800)
[ 2566.222201] handle_active_stripes.isra.0 (drivers/md/raid5.c:6709 (discriminator 1)) raid456
[ 2566.222220] raid5d (drivers/md/raid5.c:6821) raid456
[ 2566.222234] ? __schedule (kernel/sched/core.c:6677)
[ 2566.222240] ? _raw_spin_lock_irqsave (./arch/x86/include/asm/atomic.h:202 (discriminator 4) ./include/linux/atomic/atomic-instrumented.h:543 (discriminator 4) ./include/asm-generic/qspinlock.h:111 (discriminator 4) ./include/linux/spinlock.h:186 (discriminator 4) ./include/linux/spinlock_api_smp.h:111 (discriminator 4) kernel/locking/spinlock.c:162 (discriminator 4))
[ 2566.222245] ? preempt_count_add (./include/linux/ftrace.h:976 kernel/sched/core.c:5793 kernel/sched/core.c:5790 kernel/sched/core.c:5818)
[ 2566.222248] ? _raw_spin_lock_irqsave (./arch/x86/include/asm/atomic.h:202 (discriminator 4) ./include/linux/atomic/atomic-instrumented.h:543 (discriminator 4) ./include/asm-generic/qspinlock.h:111 (discriminator 4) ./include/linux/spinlock.h:186 (discriminator 4) ./include/linux/spinlock_api_smp.h:111 (discriminator 4) kernel/locking/spinlock.c:162 (discriminator 4))
[ 2566.222254] ? __pfx_md_thread (drivers/md/md.c:7862) md_mod
[ 2566.222273] md_thread (drivers/md/md.c:7898) md_mod
[ 2566.222293] ? __pfx_autoremove_wake_function (kernel/sched/wait.c:418)
[ 2566.222299] kthread (kernel/kthread.c:379)
[ 2566.222304] ? __pfx_kthread (kernel/kthread.c:332)
[ 2566.222309] ret_from_fork (arch/x86/entry/entry_64.S:314)



$ scripts/decode_stacktrace.sh vmlinux < /tmp/trace2
[ 2566.436288] ? do_exit (kernel/exit.c:818 (discriminator 1))
[ 2566.436292] ? __warn (kernel/panic.c:673)
[ 2566.436298] ? do_exit (kernel/exit.c:818 (discriminator 1))
[ 2566.436301] ? report_bug (lib/bug.c:180 lib/bug.c:219)
[ 2566.436308] ? handle_bug (arch/x86/kernel/traps.c:303)
[ 2566.436312] ? exc_invalid_op (arch/x86/kernel/traps.c:345 (discriminator 1))
[ 2566.436316] ? asm_exc_invalid_op (./arch/x86/include/asm/idtentry.h:568)
[ 2566.436321] ? do_exit (kernel/exit.c:818 (discriminator 1))
[ 2566.436325] ? do_exit (kernel/exit.c:818 (discriminator 1))
[ 2566.436329] make_task_dead (kernel/exit.c:972)
[ 2566.436333] rewind_stack_and_make_dead (??:?)



Is that what you are looking for?

Thanks,
Corey
