From: Larkin Lowrey <llowrey@gmail.com>
Subject: Stopping raid6 (with journal) hangs w/ 100%CPU
Date: Thu, 23 Nov 2017 13:22:11 -0500
Message-ID: <6fb7c56a-a78d-ebe6-e569-0d68f69469ce@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sometimes, stopping a raid6 array (with journal) hangs, the mdX_raid6 
process pegs at 100% CPU, and there is no I/O. Looks like it's stuck in 
an infinite loop.

Kernel: 4.13.13-200.fc26.x86_64

The stack trace (echo l > /proc/sysrq-trigger) is always the same:

> handle_stripe+0x10c/0x2140 [raid456]
> ? pick_next_task_fair+0x491/0x550
> handle_active_stripes.isra.60+0x3e5/0x5a0 [raid456]
> raid5d+0x42e/0x630 [raid456]
> ? prepare_to_wait_event+0x79/0x160
> md_thread+0x125/0x170
> ? md_thread+0x125/0x170
> ? finish_wait+0x80/0x80
> kthread+0x125/0x140
> ? state_show+0x2f0/0x2f0
> ? kthread_park+0x60/0x60
> ? do_syscall_64+0x67/0x140
> ret_from_fork+0x25/0x30

The array is healthy, has a journal, and writes were idle for several 
minutes prior to running 'mdadm --stop'.

> md124 : active raid6 sdt1[6] sds1[5] sdw1[1] sdx1[2] sdy1[3] sdu1[7] 
> sdv1[8] sdz1[4] md125p4[9](J)
>       23442092928 blocks super 1.2 level 6, 64k chunk, algorithm 2 
> [8/8] [UUUUUUUU]

stripe_cache_active: 2
stripe_cache_size: 32768
array_state: write-pending
journal_mode: write-through [write-back]
consistency_policy: journal

--Larkin

