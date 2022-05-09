Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A9AC433EF
	for <linux-raid@archiver.kernel.org>; Mon,  9 May 2022 15:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238570AbiEIPr3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 May 2022 11:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238548AbiEIPr1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 May 2022 11:47:27 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A57A1B5F97
        for <linux-raid@vger.kernel.org>; Mon,  9 May 2022 08:43:30 -0700 (PDT)
Received: from [192.168.0.7] (ip5f5aed71.dynamic.kabel-deutschland.de [95.90.237.113])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 1F57A61E6478B;
        Mon,  9 May 2022 17:43:28 +0200 (CEST)
Message-ID: <f801038e-1459-af90-679f-fc91f404aa96@molgen.mpg.de>
Date:   Mon, 9 May 2022 17:43:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: nvme raid locking up (4.18.0-348.23.1.el8_5.x86_64)
Content-Language: en-US
To:     Orion Poplawski <orion@nwra.com>
References: <d9a9516f-695e-3ead-6744-1510b13148c4@nwra.com>
Cc:     linux-raid@vger.kernel.org
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <d9a9516f-695e-3ead-6744-1510b13148c4@nwra.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Orion,


Am 09.05.22 um 17:32 schrieb Orion Poplawski:

> I have an HP DL380 Gen 9 with a RAID5 array built from 6 INTEL SSDPE2MX020T4
> devices.  That raid device makes up a volume group with a couple logical
> volumes with XFS filesystems backing VM storage.  Twice now in 2 months the
> raid array has become mostly unresponsive:
> 
> May 08 03:33:21 host kernel: INFO: task worker:1798511 blocked for more than
> 120 seconds.
> May 08 03:33:21 host kernel:       Not tainted 4.18.0-348.23.1.el8_5.x86_64 #1
> May 08 03:33:21 host kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> May 08 03:33:21 host kernel: task:worker          state:D stack:    0 pid:1798511 ppid:     1 flags:0x000043a0
> May 08 03:33:21 host kernel: Call Trace:
> May 08 03:33:21 host kernel:  __schedule+0x2bd/0x760
> May 08 03:33:21 host kernel:  ? finish_wait+0x80/0x80
> May 08 03:33:21 host kernel:  schedule+0x37/0xa0
> May 08 03:33:21 host kernel:  md_bitmap_startwrite+0x16f/0x1e0
> May 08 03:33:21 host kernel:  ? finish_wait+0x80/0x80
> May 08 03:33:21 host kernel:  add_stripe_bio+0x4a3/0x7c0 [raid456]
> May 08 03:33:21 host kernel:  raid5_make_request+0x1bf/0xb60 [raid456]
> May 08 03:33:21 host kernel:  ? finish_wait+0x80/0x80
> May 08 03:33:21 host kernel:  ? blk_queue_split+0xd4/0x660
> May 08 03:33:21 host kernel:  ? finish_wait+0x80/0x80
> May 08 03:33:21 host kernel:  md_handle_request+0x119/0x190
> May 08 03:33:21 host kernel:  md_make_request+0x84/0x160
> May 08 03:33:21 host kernel:  generic_make_request+0x25b/0x350
> May 08 03:33:21 host kernel:  submit_bio+0x3c/0x160
> May 08 03:33:21 host kernel:  iomap_submit_ioend.isra.38+0x4a/0x70
> May 08 03:33:21 host kernel:  iomap_writepage_map+0x422/0x670
> May 08 03:33:21 host kernel:  write_cache_pages+0x197/0x420
> May 08 03:33:21 host kernel:  ? iomap_invalidatepage+0xe0/0xe0
> May 08 03:33:21 host kernel:  iomap_writepages+0x1c/0x40
> May 08 03:33:21 host kernel:  xfs_vm_writepages+0x64/0x90 [xfs]
> May 08 03:33:21 host kernel:  do_writepages+0x41/0xd0
> May 08 03:33:21 host kernel:  __filemap_fdatawrite_range+0xcb/0x100
> May 08 03:33:21 host kernel:  file_write_and_wait_range+0x4c/0xa0
> May 08 03:33:21 host kernel:  xfs_file_fsync+0x69/0x200 [xfs]
> May 08 03:33:21 host kernel:  do_fsync+0x38/0x70
> May 08 03:33:21 host kernel:  __x64_sys_fdatasync+0x13/0x20
> May 08 03:33:21 host kernel:  do_syscall_64+0x5b/0x1a0
> May 08 03:33:21 host kernel:  entry_SYSCALL_64_after_hwframe+0x65/0xca
> May 08 03:33:21 host kernel: RIP: 0033:0x7f969efb858f
> May 08 03:33:21 host kernel: Code: Unable to access opcode bytes at RIP 0x7f969efb8565.
> May 08 03:33:21 host kernel: RSP: 002b:00007f94b3ffe6b0 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
> May 08 03:33:21 host kernel: RAX: ffffffffffffffda RBX: 000000000000000e RCX: 00007f969efb858f
> May 08 03:33:21 host kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000000000e
> May 08 03:33:21 host kernel: RBP: 0000563f940b5b20 R08: 0000000000000000 R09: 0000000032f01b0c
> May 08 03:33:21 host kernel: R10: 0000000e171e5000 R11: 0000000000000293 R12: 0000563f92a73bb4
> May 08 03:33:21 host kernel: R13: 0000563f940b5b88 R14: 0000563f94097eb0 R15: 00007f94b3ffe800
> May 08 03:33:21 host kernel: INFO: task worker:1799573 blocked for more than 120 seconds.
> May 08 03:33:21 host kernel:       Not tainted 4.18.0-348.23.1.el8_5.x86_64 #1
> May 08 03:33:21 host kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> May 08 03:33:21 host kernel: task:worker          state:D stack:    0 pid:1799573 ppid:     1 flags:0x000043a0
> May 08 03:33:21 host kernel: Call Trace:
> May 08 03:33:21 host kernel:  __schedule+0x2bd/0x760
> May 08 03:33:21 host kernel:  schedule+0x37/0xa0
> May 08 03:33:21 host kernel:  io_schedule+0x12/0x40
> May 08 03:33:21 host kernel:  wait_on_page_bit+0x137/0x230
> May 08 03:33:21 host kernel:  ? file_fdatawait_range+0x20/0x20
> May 08 03:33:21 host kernel:  __filemap_fdatawait_range+0x88/0xe0
> May 08 03:33:21 host kernel:  file_write_and_wait_range+0x76/0xa0
> May 08 03:33:21 host kernel:  xfs_file_fsync+0x69/0x200 [xfs]
> May 08 03:33:21 host kernel:  do_fsync+0x38/0x70
> May 08 03:33:21 host kernel:  __x64_sys_fdatasync+0x13/0x20
> May 08 03:33:21 host kernel:  do_syscall_64+0x5b/0x1a0
> May 08 03:33:21 host kernel:  entry_SYSCALL_64_after_hwframe+0x65/0xca
> May 08 03:33:21 host kernel: RIP: 0033:0x7f20c514c58f
> May 08 03:33:21 host kernel: Code: Unable to access opcode bytes at RIP 0x7f20c514c565.
> May 08 03:33:21 host kernel: RSP: 002b:00007f1ef4ff86b0 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
> May 08 03:33:21 host kernel: RAX: ffffffffffffffda RBX: 000000000000001b RCX: 00007f20c514c58f
> May 08 03:33:21 host kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000000001b
> May 08 03:33:21 host kernel: RBP: 00005594bed1f120 R08: 0000000000000000 R09: 00000000ffffffff
> May 08 03:33:21 host kernel: R10: 00007f1ef4ff86a0 R11: 0000000000000293 R12: 00005594bd72ebb4
> May 08 03:33:21 host kernel: R13: 00005594bed1f188 R14: 00005594bed31c30 R15: 00007f1ef4ff8800
> May 08 03:33:21 host kernel: INFO: task worker:871154 blocked for more than 120 seconds.
> May 08 03:33:21 host kernel:       Not tainted 4.18.0-348.23.1.el8_5.x86_64 #1
> May 08 03:33:21 host kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> May 08 03:33:21 host kernel: task:worker          state:D stack:    0 pid:871154 ppid:     1 flags:0x000043a0
> May 08 03:33:21 host kernel: Call Trace:

[…]

> I have another nearly identical system that has run without trouble, though
> not with as much IO load as this one.  Is there anything else I can check to
> see if there is a hardware issue or if this might be an issue with the linux
> RAID system?  Is there a better place to ask for help?

It’d be great, if you tested with a current Linux version. For such old 
Linux kernel version, please contact the support of your Linux 
distribution. Red Hat should offer support for the Linux kernel, you 
use, I guess.


Kind regards,

Paul
