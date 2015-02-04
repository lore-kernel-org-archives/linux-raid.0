From: =?UTF-8?Q?=22J=C3=B6rg_Habenicht=22?= <j.habenicht@gmx.de>
Subject: Aw: Re: Array died during grow; now resync stopped
Date: Wed, 4 Feb 2015 12:58:06 +0100
Message-ID: <trinity-85824e10-6eeb-490e-91e9-29cac6bb884e-1423051086472@3capp-gmx-bs24>
References: <loom.20150202T100454-579@post.gmane.org>
 <20150203064056.5dbba8c5@notabene.brown>
 <trinity-d6d8d6b9-e19b-4ff6-a39f-3748b5fb2e13-1422959753855@3capp-gmx-bs42>,
 <20150204174556.426eb865@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150204174556.426eb865@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It works! :-)) The array syncs!


> > >What does
> > >cat /proc/1671/stack
> > >cat /proc/1672/stack
> > >show?
> > 
> > $ cat /proc/1671/stack
> > cat: /proc/1671/stack: No such file or directory
> 
> I guess you don't have that feature compiled into your kernel.

Guess so. I'm going to look to the missing CONFIG_ line.

> > >Alternatively,
> > >echo w > /proc/sysrq-trigger
> > >and see what appears in 'dmesg'.
> > 
> > No good:
> 
> Quite the reverse, this is exactly what I wanted.  It shows the stack trace
> of pid 1671 and 1672..

Ahh, OK. I thought it being a crash dump.

> > 
> > [99166.625796] SysRq : Show Blocked State
> > [99166.625829]   task                        PC stack   pid father
> > [99166.625845] md0_reshape     D ffff88006cb81e08     0  1671      2 0x00000000
> > [99166.625854]  ffff88006a17fb30 0000000000000046 000000000000a000 ffff88006cc9b7e0
> > [99166.625861]  ffff88006a17ffd8 ffff88006cc9b7e0 ffff88006fc11830 ffff88006fc11830
> > [99166.625866]  0000000000000001 ffffffff81068670 ffff88006ca56848 ffff88006fc11830
> > [99166.625871] Call Trace:
> > [99166.625884]  [<ffffffff81068670>] ? __dequeue_entity+0x40/0x50
> > [99166.625891]  [<ffffffff8106b966>] ? pick_next_task_fair+0x56/0x1b0
> > [99166.625898]  [<ffffffff813f4a50>] ? __schedule+0x2a0/0x820
> > [99166.625905]  [<ffffffff8106273d>] ? ttwu_do_wakeup+0xd/0x80
> > [99166.625914]  [<ffffffffa027b4c5>] ? get_active_stripe+0x185/0x5c0 [raid456]
> > [99166.625922]  [<ffffffff81072110>] ? __wake_up_sync+0x10/0x10
> > [99166.625929]  [<ffffffffa027e83a>] ? reshape_request+0x21a/0x860 [raid456]
> > [99166.625935]  [<ffffffff81072110>] ? __wake_up_sync+0x10/0x10
> > [99166.625942]  [<ffffffffa02744f6>] ? sync_request+0x236/0x380 [raid456]
> > [99166.625955]  [<ffffffffa01557ad>] ? md_do_sync+0x82d/0xd00 [md_mod]
> > [99166.625961]  [<ffffffff810684b4>] ? update_curr+0x64/0xe0
> > [99166.625971]  [<ffffffffa0152197>] ? md_thread+0xf7/0x110 [md_mod]
> > [99166.625977]  [<ffffffff81072110>] ? __wake_up_sync+0x10/0x10
> > [99166.625985]  [<ffffffffa01520a0>] ? md_register_thread+0xf0/0xf0 [md_mod]
> > [99166.625991]  [<ffffffff81059de8>] ? kthread+0xb8/0xd0
> > [99166.625997]  [<ffffffff81059d30>] ? kthread_create_on_node+0x180/0x180
> > [99166.626003]  [<ffffffff813f837c>] ? ret_from_fork+0x7c/0xb0
> > [99166.626008]  [<ffffffff81059d30>] ? kthread_create_on_node+0x180/0x180
> 
> That's not surprise.  Whenever anything goes wrong in raid5, something gets
> stuck in get_active_stripe()...
> 
> 
> > [99166.626012] udevd           D ffff88006cb81e08     0  1672   1289 0x00000004
> > [99166.626017]  ffff88006a1819e8 0000000000000086 000000000000a000 ffff88006c4967a0
> > [99166.626022]  ffff88006a181fd8 ffff88006c4967a0 0000000000000000 0000000000000000
> > [99166.626027]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
> > [99166.626032] Call Trace:
> > [99166.626039]  [<ffffffff810c24ed>] ? zone_statistics+0x9d/0xa0
> > [99166.626044]  [<ffffffff810c24ed>] ? zone_statistics+0x9d/0xa0
> > [99166.626050]  [<ffffffff810b13e7>] ? get_page_from_freelist+0x507/0x850
> > [99166.626057]  [<ffffffffa027b4c5>] ? get_active_stripe+0x185/0x5c0 [raid456]
> > [99166.626063]  [<ffffffff81072110>] ? __wake_up_sync+0x10/0x10
> > [99166.626069]  [<ffffffffa027f627>] ? make_request+0x7a7/0xa00 [raid456]
> > [99166.626075]  [<ffffffff81080afd>] ? ktime_get_ts+0x3d/0xd0
> > [99166.626080]  [<ffffffff81072110>] ? __wake_up_sync+0x10/0x10
> > [99166.626089]  [<ffffffffa014ea12>] ? md_make_request+0xd2/0x210 [md_mod]
> > [99166.626096]  [<ffffffff811e649d>] ? generic_make_request_checks+0x23d/0x270
> > [99166.626100]  [<ffffffff810acc68>] ? mempool_alloc+0x58/0x140
> > [99166.626106]  [<ffffffff811e7238>] ? generic_make_request+0xa8/0xf0
> > [99166.626111]  [<ffffffff811e72e7>] ? submit_bio+0x67/0x130
> > [99166.626117]  [<ffffffff8112a638>] ? bio_alloc_bioset+0x1b8/0x2a0
> > [99166.626123]  [<ffffffff81126a57>] ? _submit_bh+0x127/0x200
> > [99166.626129]  [<ffffffff8112815d>] ? block_read_full_page+0x1fd/0x290
> > [99166.626133]  [<ffffffff8112b680>] ? I_BDEV+0x10/0x10
> > [99166.626140]  [<ffffffff810aad2b>] ? add_to_page_cache_locked+0x6b/0xc0
> > [99166.626146]  [<ffffffff810b5520>] ? __do_page_cache_readahead+0x1b0/0x220
> > [99166.626152]  [<ffffffff810b5812>] ? force_page_cache_readahead+0x62/0xa0
> > [99166.626159]  [<ffffffff810ac936>] ? generic_file_aio_read+0x4b6/0x6c0
> > [99166.626166]  [<ffffffff810f9f87>] ? do_sync_read+0x57/0x90
> > [99166.626172]  [<ffffffff810fa571>] ? vfs_read+0xa1/0x180
> > [99166.626178]  [<ffffffff810fb0ab>] ? SyS_read+0x4b/0xc0
> > [99166.626183]  [<ffffffff813f7f72>] ? page_fault+0x22/0x30
> > [99166.626190]  [<ffffffff813f8422>] ? system_call_fastpath+0x16/0x1b
> 
> And this is stuck in the same place.... what what is consuming all the
> stripes I wonder....

Do you like me to collect more information?

> > >
> > > The system got 2G RAM and 2G swap. Is this sufficient to complete?
> > 
> > >Memory shouldn't be a problem.
> > >However it wouldn't hurt to see what value is in
> > >/sys/block/md0/md/stripe_cache_size
> > >and double it.
> > 
> > $ cat /sys/block/md0/md/stripe_cache_size
> > 256
> 
> 
> You are setting the chunk size to 1M, which is 256 4K pages.
> So this stripe_cache only just has enough space to store one full stripe at
> the new chunk size.  That isn't enough.
> 
> If you double it, the problem should go away.
> 
> mdadm should  do that for you .... I wonder why it didn't.
> 

Do you like to have more test results?

> > 
> > I did not change it due to the crash in md_reshape
> 
> What crash is that?  The above stack traces that you said "No good" about?
> That isn't a crash.  That is the kernel showing you stack traces because you
> asked for them.

Ok, Thanks, learned something more :-)

> 
>  echo 1024 > /sys/block/md0/md/stripe_cache_size
> 
> should make it work.

Yes it did!

$ echo 1024 > /sys/block/md0/md/stripe_cache_size
$ cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 sde1[0] sdg1[9] sdc1[6] sdb1[7] sdd1[8] sdf1[5]
      5860548608 blocks super 1.0 level 5, 256k chunk, algorithm 2 [6/6] [UUUUUU]
      [=====>...............]  reshape = 28.0% (410341376/1465137152) finish=29602912.5min speed=0K/sec
      
unused devices: <none>
$ cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 sde1[0] sdg1[9] sdc1[6] sdb1[7] sdd1[8] sdf1[5]
      5860548608 blocks super 1.0 level 5, 256k chunk, algorithm 2 [6/6] [UUUUUU]
      [=====>...............]  reshape = 28.0% (410656252/1465137152) finish=7746625.6min speed=2K/sec
      
unused devices: <none>
$ cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 sde1[0] sdg1[9] sdc1[6] sdb1[7] sdd1[8] sdf1[5]
      5860548608 blocks super 1.0 level 5, 256k chunk, algorithm 2 [6/6] [UUUUUU]
      [=====>...............]  reshape = 28.0% (410851328/1465137152) finish=5314609.8min speed=3K/sec
      
unused devices: <none>
$ cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 sde1[0] sdg1[9] sdc1[6] sdb1[7] sdd1[8] sdf1[5]
      5860548608 blocks super 1.0 level 5, 256k chunk, algorithm 2 [6/6] [UUUUUU]
      [=====>...............]  reshape = 28.4% (416577276/1465137152) finish=870.3min speed=20079K/sec
      
unused devices: <none>

Immediatly it starts to sync.
I wonder why it got stuck at 27% and not at 0%? Shouldn't it get stuck at the beginning if the cache size is not sufficient?
Or is it because of a reboot which happened at 27% sync status?


Anyways,
Thank you for your help.

> 
> NeilBrown
> 
> 

cu,
Joerg


