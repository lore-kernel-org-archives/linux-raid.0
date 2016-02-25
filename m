From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: Re: mdadm 3.3.2 deadlock
Date: Thu, 25 Feb 2016 15:27:56 +0300
Message-ID: <CACaajQvN1DRq3NLFF42TeZhzPWUnW2QhF=mX+vwQuRkTJVgC-g@mail.gmail.com>
References: <CACaajQv=n4aOMfMwNrDM8_M8NeoYyxC0XejpxqZVxvivvjygJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACaajQv=n4aOMfMwNrDM8_M8NeoYyxC0XejpxqZVxvivvjygJA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2016-02-25 10:23 GMT+03:00 Vasiliy Tolstov <v.tolstov@selfip.ru>:
> Hi. I have strange deadlocked process of mdadm
> root     14495  0.0  0.0  13064  1964 ?        D    Feb24   0:00
> /sbin/mdadm --detail --export /dev/.tmp-block-259:5
>
> why this is can happen and does mdadm git repo already have fix for this?
> Thanks!


i'm use old linux 3.19.3, echo w > /proc/sysrq-trigger:
[15840064.321022] SysRq : Show Blocked State
[15840064.321072]   task                        PC stack   pid father
[15840064.321183] mdadm           D ffff880eebb02490     0 14495
8481 0x00000004
[15840064.321268]  ffff880eebb02490 ffffffff81141d69 ffff881ff8fd6a70
0000000000013b40
[15840064.321360]  0000000000013b40 ffff880eebb02490 ffff880ebb073fd8
ffff88103fffcd80
[15840064.321452]  ffff880fbb0ea418 ffff880fbb0ea41c ffff880eebb02490
ffff880fbb0ea420
[15840064.329570] Call Trace:
[15840064.329615]  [<ffffffff81141d69>] ? __d_rehash+0x19/0x4c
[15840064.329667]  [<ffffffff813e082b>] ? schedule_preempt_disabled+0x6/0x8
[15840064.329722]  [<ffffffff813e14ff>] ? __mutex_lock_slowpath+0xa8/0x104
[15840064.329786]  [<ffffffff813e1571>] ? mutex_lock+0x16/0x25
[15840064.329838]  [<ffffffff8115a59a>] ? __blkdev_get+0x92/0x3b9
[15840064.329889]  [<ffffffff8115ab94>] ? blkdev_get+0x2d3/0x2d3
[15840064.329939]  [<ffffffff8115aa4c>] ? blkdev_get+0x18b/0x2d3
[15840064.329991]  [<ffffffff811437b5>] ? __d_lookup_rcu+0x94/0xbb
[15840064.330043]  [<ffffffff8115ab94>] ? blkdev_get+0x2d3/0x2d3
[15840064.330095]  [<ffffffff81130a5e>] ? do_dentry_open+0x178/0x27e
[15840064.330147]  [<ffffffff8113bb69>] ? do_last+0x865/0xa23
[15840064.330197]  [<ffffffff8113a2c1>] ? __inode_permission+0x57/0x95
[15840064.330249]  [<ffffffff8113d15f>] ? path_openat+0x207/0x46d
[15840064.330301]  [<ffffffff8111f744>] ? __cache_free.isra.47+0x1e5/0x1f4
[15840064.330354]  [<ffffffff8113e450>] ? do_filp_open+0x2b/0x6f
[15840064.330405]  [<ffffffff811472e9>] ? __alloc_fd+0xd9/0xea
[15840064.330456]  [<ffffffff811313a3>] ? do_sys_open+0x65/0xe9
[15840064.330506]  [<ffffffff813e2ce9>] ? system_call_fastpath+0x12/0x17




-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
