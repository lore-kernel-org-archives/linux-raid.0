From: Alexander Shenkin <al@shenkin.org>
Subject: Re: SMART detects pending sectors; take offline?
Date: Wed, 11 Oct 2017 11:31:22 +0100
Message-ID: <afaa1020-652d-911c-16e0-12ed87f2197a@shenkin.org>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <aae31b06-f0b7-5d58-8dee-02867fcd23ec@aei.mpg.de>
 <8caa4fe1-c51f-6f3a-e16b-8795cf1b4071@turmel.org>
 <dd9d09ef-5191-a955-5b99-0fbcaea30665@shenkin.org>
 <8cb4bb54-fadc-30c3-58b9-16e1ca460e83@thelounge.net>
 <a7a4d586-5641-80e4-06e1-5dc1b772182b@shenkin.org>
 <8da0ac59-d83b-671c-b088-8e04b13d685e@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8da0ac59-d83b-671c-b088-8e04b13d685e@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Reindl Harald <h.reindl@thelounge.net>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/10/2017 1:55 PM, Phil Turmel wrote:
> Hi Alex,
> 
> On 10/10/2017 05:56 AM, Alexander Shenkin wrote:
> 
>> Thanks Reindl.  Here's what I have installed (no evidence of raid-check
>> available on my system):
>>
>> $ cat /etc/cron.d/mdadm
>> 57 0 * * 0 root if [ -x /usr/share/mdadm/checkarray ] && [ $(date +\%d)
>> -le 7 ]; then /usr/share/mdadm/checkarray --cron --all --idle --quiet; fi
>>
> 
> This is *really* good news.  If this has been running once a month as
> shown, and you've already noted that you are dealing properly with
> timeout mismatch, then your arrays are in fact reasonably scrubbed.
> 
> Which means the pending sector found by a smartctl background scan is
> likely in a non-array data area.  And if not, the next scrub will fix
> it.  You can run checkarray yourself if you don't want to wait.

Thanks Phil.  I ran checkarray --all --idle, and it completed fine, with 
no Rebuild messages as far as I could see (looked in dmesg & 
/var/log/syslog, see below).

[4444093.042246] md: data-check of RAID array md0
[4444093.042252] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[4444093.042254] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for data-check.
[4444093.042262] md: using 128k window, over a total of 1950656k.
[4444093.192032] md: delaying data-check of md2 until md0 has finished 
(they share one or more physical units)
[4444106.854418] md: md0: data-check done.
[4444106.863292] md: data-check of RAID array md2
[4444106.863295] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[4444106.863298] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for data-check.
[4444106.863304] md: using 128k window, over a total of 2920188928k.
[4475376.852520] md: md2: data-check done.

SMART still shows those 8 unreadable sectors.  dmesg has a bunch of 
related errors, copied below.

>>>> Is this something I should run now?  I figure it's a bad idea to push
>>>> an array that is starting to degrade... haven't had a chance to
>>>> replace the drive yet, but will get to it this week.  Probably best
>>>> to start the scrubbing routines once I have 4 good drives in there I
>>>> figure...
>>>
>>> NO - never put any load you can avoid on degraded arrays
>>
>> thanks, i won't.
> 
> If I read your OP correctly, your array is *not* degraded -- it just has
> a pending URE on one drive.  You are still redundant, and your system is
> scrubbing once a month.  FWIW, I don't replace drives just for
> pending sectors -- they are expected occasionally per drive specs.  So
> long as check scrubs regularly complete, I replace drives when actual
> relocations hit double digits.

So, is there a way to tell if the array successfully "relocated" those 8 
sectors?  Or, no need to verify it?

> 
> You are fine.  Your array is fine.  Long timeouts can cause application
> timeouts and user freak-outs, so your Seagates are less than ideal, but
> your system is *fine*.
> 
> Consider using the new drive to convert to raid6.  If you have other
> reasons to stay with raid5, then add it as as spare, then use mdadm's
> --replace operation to swap out the drive with the pending sector.

Thanks - I'll look into raid6 conversion if this drive doesn't start 
upping it's unreadable sector counts more in the near future...

thanks,
allie




-------------------------------------

[4038193.380403] INFO: task md2_raid5:247 blocked for more than 120 seconds.
[4038193.380473]       Not tainted 4.4.0-81-generic #104~14.04.1-Ubuntu
[4038193.380526] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[4038193.380591] md2_raid5       D ffff8800af01fbe0     0   247      2 
0x00000000
[4038193.380599]  ffff8800af01fbe0 ffff8800980f5400 ffff8802229b8e00 
ffff8800af020000
[4038193.380604]  ffff880222017298 ffffea0002bc0300 ffff880222017018 
ffff880222017000
[4038193.380609]  ffff8800af01fbf8 ffffffff81808f75 ffff880222017000 
ffff8800af01fc40
[4038193.380613] Call Trace:
[4038193.380625]  [<ffffffff81808f75>] schedule+0x35/0x80
[4038193.380631]  [<ffffffff81681a17>] md_super_wait+0x47/0x80
[4038193.380638]  [<ffffffff810bf660>] ? prepare_to_wait_event+0xf0/0xf0
[4038193.380643]  [<ffffffff816892d5>] write_page+0x1f5/0x310
[4038193.380648]  [<ffffffff81688fe8>] bitmap_update_sb+0x138/0x150
[4038193.380652]  [<ffffffff81681d79>] md_update_sb.part.51+0x329/0x800
[4038193.380657]  [<ffffffff81682275>] md_update_sb+0x25/0x30
[4038193.380661]  [<ffffffff8168292d>] md_check_recovery+0x1dd/0x4a0
[4038193.380670]  [<ffffffffc00e6765>] raid5d+0x45/0x740 [raid456]
[4038193.380675]  [<ffffffff810e7b08>] ? del_timer_sync+0x48/0x50
[4038193.380680]  [<ffffffff8180b86b>] ? schedule_timeout+0x16b/0x2d0
[4038193.380685]  [<ffffffff810e75f0>] ? 
trace_event_raw_event_tick_stop+0xd0/0xd0
[4038193.380691]  [<ffffffff8167a957>] md_thread+0x117/0x130
[4038193.380696]  [<ffffffff810bf660>] ? prepare_to_wait_event+0xf0/0xf0
[4038193.380702]  [<ffffffff8167a840>] ? find_pers+0x70/0x70
[4038193.380707]  [<ffffffff8109cd56>] kthread+0xd6/0xf0
[4038193.380711]  [<ffffffff8109cc80>] ? kthread_park+0x60/0x60
[4038193.380715]  [<ffffffff8180cb8f>] ret_from_fork+0x3f/0x70
[4038193.380719]  [<ffffffff8109cc80>] ? kthread_park+0x60/0x60
[4038193.380723] INFO: task jbd2/md2-8:261 blocked for more than 120 
seconds.
[4038193.380779]       Not tainted 4.4.0-81-generic #104~14.04.1-Ubuntu
[4038193.380834] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[4038193.380898] jbd2/md2-8      D ffff8800af017a30     0   261      2 
0x00000000
[4038193.380903]  ffff8800af017a30 ffff880225a44600 ffff880225b4d400 
ffff8800af018000
[4038193.380908]  ffff880222017298 ffff880222017290 ffff88014970c400 
0000000000000000
[4038193.380912]  ffff8800af017a48 ffffffff81808f75 ffff880222017000 
ffff8800af017a98
[4038193.380917] Call Trace:
[4038193.380922]  [<ffffffff81808f75>] schedule+0x35/0x80
[4038193.380926]  [<ffffffff8167f94d>] md_write_start+0x9d/0x180
[4038193.380931]  [<ffffffff810bf660>] ? prepare_to_wait_event+0xf0/0xf0
[4038193.380939]  [<ffffffffc00e307a>] make_request+0x7a/0xcc0 [raid456]
[4038193.380944]  [<ffffffff8128a6f0>] ? ext4_map_blocks+0x2c0/0x4e0
[4038193.380950]  [<ffffffff810bf660>] ? prepare_to_wait_event+0xf0/0xf0
[4038193.380954]  [<ffffffff8167b13c>] md_make_request+0xec/0x240
[4038193.380959]  [<ffffffff813aee08>] generic_make_request+0xf8/0x2a0
[4038193.380962]  [<ffffffff813af027>] submit_bio+0x77/0x150
[4038193.380967]  [<ffffffff813a6821>] ? bio_alloc_bioset+0x181/0x2c0
[4038193.380971]  [<ffffffff81237ecf>] submit_bh_wbc+0x12f/0x160
[4038193.380975]  [<ffffffff81237f32>] submit_bh+0x12/0x20
[4038193.380980]  [<ffffffff812db465>] 
jbd2_journal_commit_transaction+0x5e5/0x1970
[4038193.380984]  [<ffffffff810b315f>] ? update_curr+0xdf/0x170
[4038193.380989]  [<ffffffff810e7a9f>] ? try_to_del_timer_sync+0x4f/0x70
[4038193.380994]  [<ffffffff812e01eb>] kjournald2+0xbb/0x230
[4038193.380999]  [<ffffffff810bf660>] ? prepare_to_wait_event+0xf0/0xf0
[4038193.381004]  [<ffffffff812e0130>] ? commit_timeout+0x10/0x10
[4038193.381007]  [<ffffffff8109cd56>] kthread+0xd6/0xf0
[4038193.381011]  [<ffffffff8109cc80>] ? kthread_park+0x60/0x60
[4038193.381015]  [<ffffffff8180cb8f>] ret_from_fork+0x3f/0x70
[4038193.381019]  [<ffffffff8109cc80>] ? kthread_park+0x60/0x60
[4038193.381055] INFO: task kworker/u16:1:4795 blocked for more than 120 
seconds.
[4038193.381114]       Not tainted 4.4.0-81-generic #104~14.04.1-Ubuntu
[4038193.381167] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[4038193.381231] kworker/u16:1   D ffff880003b777b0     0  4795      2 
0x00000000
[4038193.381240] Workqueue: writeback wb_workfn (flush-9:2)
[4038193.381243]  ffff880003b777b0 ffffffff81e13500 ffff88022023d400 
ffff880003b78000
[4038193.381247]  ffff880222017298 0000000000000001 ffff8800afaef500 
ffff88020e88e570
[4038193.381252]  ffff880003b777c8 ffffffff81808f75 ffff880222017000 
ffff880003b77818
[4038193.381256] Call Trace:
[4038193.381261]  [<ffffffff81808f75>] schedule+0x35/0x80
[4038193.381265]  [<ffffffff8167f94d>] md_write_start+0x9d/0x180
[4038193.381271]  [<ffffffff810bf660>] ? prepare_to_wait_event+0xf0/0xf0
[4038193.381278]  [<ffffffffc00e307a>] make_request+0x7a/0xcc0 [raid456]
[4038193.381282]  [<ffffffff813a6844>] ? bio_alloc_bioset+0x1a4/0x2c0
[4038193.381288]  [<ffffffff810bf660>] ? prepare_to_wait_event+0xf0/0xf0
[4038193.381292]  [<ffffffff8167b13c>] md_make_request+0xec/0x240
[4038193.381296]  [<ffffffff810bf184>] ? __wake_up+0x44/0x50
[4038193.381300]  [<ffffffff813aee08>] generic_make_request+0xf8/0x2a0
[4038193.381304]  [<ffffffff813af027>] submit_bio+0x77/0x150
[4038193.381309]  [<ffffffff8129198e>] ext4_io_submit+0x3e/0x60
[4038193.381313]  [<ffffffff8128da43>] ext4_writepages+0x553/0xcd0
[4038193.381318]  [<ffffffff8180b86b>] ? schedule_timeout+0x16b/0x2d0
[4038193.381323]  [<ffffffff81095343>] ? __queue_delayed_work+0x83/0x180
[4038193.381329]  [<ffffffff8119186e>] do_writepages+0x1e/0x30
[4038193.381333]  [<ffffffff8122e885>] __writeback_single_inode+0x45/0x340
[4038193.381338]  [<ffffffff818099a8>] ? 
wait_for_completion_io_timeout+0xa8/0x120
[4038193.381343]  [<ffffffff8122f0bb>] writeback_sb_inodes+0x26b/0x5c0
[4038193.381347]  [<ffffffff8122f496>] __writeback_inodes_wb+0x86/0xc0
[4038193.381351]  [<ffffffff8122f722>] wb_writeback+0x252/0x2e0
[4038193.381355]  [<ffffffff8122ff12>] wb_workfn+0x2c2/0x3d0
[4038193.381359]  [<ffffffff810b3f55>] ? put_prev_entity+0x35/0x670
[4038193.381365]  [<ffffffff81096d20>] process_one_work+0x150/0x3f0
[4038193.381370]  [<ffffffff8109749a>] worker_thread+0x11a/0x470
[4038193.381375]  [<ffffffff81097380>] ? rescuer_thread+0x310/0x310
[4038193.381378]  [<ffffffff8109cd56>] kthread+0xd6/0xf0
[4038193.381382]  [<ffffffff8109cc80>] ? kthread_park+0x60/0x60
[4038193.381386]  [<ffffffff8180cb8f>] ret_from_fork+0x3f/0x70
[4038193.381390]  [<ffffffff8109cc80>] ? kthread_park+0x60/0x60
[4038193.381400] INFO: task updatedb.mlocat:16442 blocked for more than 
120 seconds.
[4038193.381461]       Not tainted 4.4.0-81-generic #104~14.04.1-Ubuntu
[4038193.381512] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[4038193.381576] updatedb.mlocat D ffff880206e2b968     0 16442  16441 
0x00000000
[4038193.381581]  ffff880206e2b968 ffff880225a41c00 ffff880049599c00 
ffff880206e2c000
[4038193.381586]  0000000000000000 7fffffffffffffff ffff88022efb2ce8 
ffffffff818096b0
[4038193.381590]  ffff880206e2b980 ffffffff81808f75 ffff88022ec96e00 
ffff880206e2ba28
[4038193.381594] Call Trace:
[4038193.381599]  [<ffffffff818096b0>] ? bit_wait+0x50/0x50
[4038193.381604]  [<ffffffff81808f75>] schedule+0x35/0x80
[4038193.381608]  [<ffffffff8180b937>] schedule_timeout+0x237/0x2d0
[4038193.381613]  [<ffffffff8159dd7f>] ? scsi_request_fn+0x3f/0x630
[4038193.381618]  [<ffffffff813a8121>] ? elv_rb_add+0x61/0x70
[4038193.381624]  [<ffffffff810f028c>] ? ktime_get+0x3c/0xb0
[4038193.381628]  [<ffffffff818096b0>] ? bit_wait+0x50/0x50
[4038193.381633]  [<ffffffff81808556>] io_schedule_timeout+0xa6/0x110
[4038193.381637]  [<ffffffff818096cb>] bit_wait_io+0x1b/0x60
[4038193.381642]  [<ffffffff81809310>] __wait_on_bit+0x60/0x90
[4038193.381646]  [<ffffffff818096b0>] ? bit_wait+0x50/0x50
[4038193.381650]  [<ffffffff818093b2>] out_of_line_wait_on_bit+0x72/0x80
[4038193.381655]  [<ffffffff810bf6a0>] ? autoremove_wake_function+0x40/0x40
[4038193.381661]  [<ffffffff81236922>] __wait_on_buffer+0x32/0x40
[4038193.381665]  [<ffffffff812885c3>] __ext4_get_inode_loc+0x1c3/0x3f0
[4038193.381669]  [<ffffffff8128b7bf>] ext4_iget+0x8f/0xb80
[4038193.381673]  [<ffffffff8128c2e0>] ext4_iget_normal+0x30/0x40
[4038193.381677]  [<ffffffff812964b1>] ext4_lookup+0xf1/0x230
[4038193.381682]  [<ffffffff8120ac7d>] lookup_real+0x1d/0x50
[4038193.381686]  [<ffffffff8120b093>] __lookup_hash+0x33/0x40
[4038193.381690]  [<ffffffff8120d967>] walk_component+0x177/0x230
[4038193.381695]  [<ffffffff8120e9f0>] path_lookupat+0x60/0x110
[4038193.381699]  [<ffffffff8121087c>] filename_lookup+0x9c/0x150
[4038193.381704]  [<ffffffff811ded1f>] ? kmem_cache_alloc+0x19f/0x200
[4038193.381708]  [<ffffffff812104bf>] ? getname_flags+0x4f/0x1f0
[4038193.381713]  [<ffffffff812109e6>] user_path_at_empty+0x36/0x40
[4038193.381719]  [<ffffffff81205f93>] vfs_fstatat+0x53/0xa0
[4038193.381724]  [<ffffffff81206462>] SYSC_newlstat+0x22/0x40
[4038193.381729]  [<ffffffff81216555>] ? SyS_poll+0x65/0xf0
[4038193.381733]  [<ffffffff8120667e>] SyS_newlstat+0xe/0x10
[4038193.381737]  [<ffffffff8180c7f6>] entry_SYSCALL_64_fastpath+0x16/0x75
[4038193.381741] INFO: task nmbd:16462 blocked for more than 120 seconds.
[4038193.381794]       Not tainted 4.4.0-81-generic #104~14.04.1-Ubuntu
[4038193.381846] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[4038193.381910] nmbd            D ffff880098197b38     0 16462   6615 
0x00000000
[4038193.381915]  ffff880098197b38 ffff880225a43800 ffff88004959d400 
ffff880098198000
[4038193.381920]  0000000000000000 7fffffffffffffff ffff88022efba0f8 
ffffffff818096b0
[4038193.381924]  ffff880098197b50 ffffffff81808f75 ffff88022ed16e00 
ffff880098197bf8
[4038193.381928] Call Trace:
[4038193.381933]  [<ffffffff818096b0>] ? bit_wait+0x50/0x50
[4038193.381937]  [<ffffffff81808f75>] schedule+0x35/0x80
[4038193.381942]  [<ffffffff8180b937>] schedule_timeout+0x237/0x2d0
[4038193.381946]  [<ffffffff811de8dc>] ? ___slab_alloc+0x1cc/0x470
[4038193.381951]  [<ffffffff810f028c>] ? ktime_get+0x3c/0xb0
[4038193.381956]  [<ffffffff818096b0>] ? bit_wait+0x50/0x50
[4038193.381960]  [<ffffffff81808556>] io_schedule_timeout+0xa6/0x110
[4038193.381965]  [<ffffffff818096cb>] bit_wait_io+0x1b/0x60
[4038193.381969]  [<ffffffff81809310>] __wait_on_bit+0x60/0x90
[4038193.381974]  [<ffffffff818096b0>] ? bit_wait+0x50/0x50
[4038193.381978]  [<ffffffff818093b2>] out_of_line_wait_on_bit+0x72/0x80
[4038193.381983]  [<ffffffff810bf6a0>] ? autoremove_wake_function+0x40/0x40
[4038193.381988]  [<ffffffff812d9943>] do_get_write_access+0x273/0x490
[4038193.381992]  [<ffffffff812d9b91>] 
jbd2_journal_get_write_access+0x31/0x60
[4038193.381997]  [<ffffffff812bdb0b>] 
__ext4_journal_get_write_access+0x3b/0x80
[4038193.382001]  [<ffffffff81298ba4>] ext4_orphan_add+0xa4/0x260
[4038193.382006]  [<ffffffff81299db8>] ext4_unlink+0x338/0x350
[4038193.382010]  [<ffffffff8120c93a>] vfs_unlink+0xda/0x190
[4038193.382015]  [<ffffffff8137881b>] ? wrap_apparmor_path_unlink+0x1b/0x20
[4038193.382020]  [<ffffffff81211127>] do_unlinkat+0x257/0x2a0
[4038193.382025]  [<ffffffff81211ae6>] SyS_unlink+0x16/0x20
[4038193.382029]  [<ffffffff8180c7f6>] entry_SYSCALL_64_fastpath+0x16/0x75
[4038242.602780] ata3.00: exception Emask 0x40 SAct 0x7fffffff SErr 
0x800 action 0x6 frozen
[4038242.602856] ata3: SError: { HostInt }
[4038242.602892] ata3.00: failed command: READ FPDMA QUEUED
[4038242.602943] ata3.00: cmd 60/08:00:d0:a3:3f/00:00:28:01:00/40 tag 0 
ncq 4096 in
[4038242.602943]          res 40/00:01:09:4f:c2/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.603063] ata3.00: status: { DRDY }
[4038242.603097] ata3.00: failed command: READ FPDMA QUEUED
[4038242.603146] ata3.00: cmd 60/08:08:d8:a3:3f/00:00:28:01:00/40 tag 1 
ncq 4096 in
[4038242.603146]          res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.603266] ata3.00: status: { DRDY }
[4038242.603299] ata3.00: failed command: READ FPDMA QUEUED
[4038242.603348] ata3.00: cmd 60/08:10:e0:a3:3f/00:00:28:01:00/40 tag 2 
ncq 4096 in
[4038242.603348]          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.603466] ata3.00: status: { DRDY }
[4038242.603500] ata3.00: failed command: READ FPDMA QUEUED
[4038242.603549] ata3.00: cmd 60/08:18:e8:a3:3f/00:00:28:01:00/40 tag 3 
ncq 4096 in
[4038242.603549]          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.603667] ata3.00: status: { DRDY }
[4038242.603700] ata3.00: failed command: READ FPDMA QUEUED
[4038242.603749] ata3.00: cmd 60/08:20:f8:a3:3f/00:00:28:01:00/40 tag 4 
ncq 4096 in
[4038242.603749]          res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.603867] ata3.00: status: { DRDY }
[4038242.603901] ata3.00: failed command: READ FPDMA QUEUED
[4038242.603950] ata3.00: cmd 60/08:28:f0:a3:3f/00:00:28:01:00/40 tag 5 
ncq 4096 in
[4038242.603950]          res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 
0x44 (timeout)
[4038242.604070] ata3.00: status: { DRDY }
[4038242.604104] ata3.00: failed command: READ FPDMA QUEUED
[4038242.604153] ata3.00: cmd 60/08:30:08:a3:3f/00:00:28:01:00/40 tag 6 
ncq 4096 in
[4038242.604153]          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.604271] ata3.00: status: { DRDY }
[4038242.606329] ata3.00: failed command: READ FPDMA QUEUED
[4038242.608395] ata3.00: cmd 60/08:38:10:a3:3f/00:00:28:01:00/40 tag 7 
ncq 4096 in
[4038242.608395]          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.612513] ata3.00: status: { DRDY }
[4038242.614535] ata3.00: failed command: READ FPDMA QUEUED
[4038242.616547] ata3.00: cmd 60/08:40:18:a3:3f/00:00:28:01:00/40 tag 8 
ncq 4096 in
[4038242.616547]          res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 
0x44 (timeout)
[4038242.620545] ata3.00: status: { DRDY }
[4038242.622544] ata3.00: failed command: READ FPDMA QUEUED
[4038242.624503] ata3.00: cmd 60/08:48:20:a3:3f/00:00:28:01:00/40 tag 9 
ncq 4096 in
[4038242.624503]          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.628406] ata3.00: status: { DRDY }
[4038242.630330] ata3.00: failed command: READ FPDMA QUEUED
[4038242.632245] ata3.00: cmd 60/08:50:28:a3:3f/00:00:28:01:00/40 tag 10 
ncq 4096 in
[4038242.632245]          res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.636058] ata3.00: status: { DRDY }
[4038242.637942] ata3.00: failed command: READ FPDMA QUEUED
[4038242.639818] ata3.00: cmd 60/08:58:30:a3:3f/00:00:28:01:00/40 tag 11 
ncq 4096 in
[4038242.639818]          res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.643555] ata3.00: status: { DRDY }
[4038242.645413] ata3.00: failed command: READ FPDMA QUEUED
[4038242.647270] ata3.00: cmd 60/08:60:38:a3:3f/00:00:28:01:00/40 tag 12 
ncq 4096 in
[4038242.647270]          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.650999] ata3.00: status: { DRDY }
[4038242.652859] ata3.00: failed command: READ FPDMA QUEUED
[4038242.654718] ata3.00: cmd 60/08:68:40:a3:3f/00:00:28:01:00/40 tag 13 
ncq 4096 in
[4038242.654718]          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.658458] ata3.00: status: { DRDY }
[4038242.660326] ata3.00: failed command: READ FPDMA QUEUED
[4038242.662189] ata3.00: cmd 60/08:70:48:a3:3f/00:00:28:01:00/40 tag 14 
ncq 4096 in
[4038242.662189]          res 40/00:01:06:4f:c2/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.665951] ata3.00: status: { DRDY }
[4038242.667827] ata3.00: failed command: READ FPDMA QUEUED
[4038242.669696] ata3.00: cmd 60/08:78:50:a3:3f/00:00:28:01:00/40 tag 15 
ncq 4096 in
[4038242.669696]          res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 
0x44 (timeout)
[4038242.673441] ata3.00: status: { DRDY }
[4038242.675319] ata3.00: failed command: READ FPDMA QUEUED
[4038242.677189] ata3.00: cmd 60/08:80:58:a3:3f/00:00:28:01:00/40 tag 16 
ncq 4096 in
[4038242.677189]          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.680935] ata3.00: status: { DRDY }
[4038242.682816] ata3.00: failed command: READ FPDMA QUEUED
[4038242.684689] ata3.00: cmd 60/08:88:60:a3:3f/00:00:28:01:00/40 tag 17 
ncq 4096 in
[4038242.684689]          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.688450] ata3.00: status: { DRDY }
[4038242.690328] ata3.00: failed command: READ FPDMA QUEUED
[4038242.692208] ata3.00: cmd 60/08:90:68:a3:3f/00:00:28:01:00/40 tag 18 
ncq 4096 in
[4038242.692208]          res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.695989] ata3.00: status: { DRDY }
[4038242.697872] ata3.00: failed command: READ FPDMA QUEUED
[4038242.699753] ata3.00: cmd 60/08:98:70:a3:3f/00:00:28:01:00/40 tag 19 
ncq 4096 in
[4038242.699753]          res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.703534] ata3.00: status: { DRDY }
[4038242.705417] ata3.00: failed command: READ FPDMA QUEUED
[4038242.707310] ata3.00: cmd 60/08:a0:78:a3:3f/00:00:28:01:00/40 tag 20 
ncq 4096 in
[4038242.707310]          res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 
0x44 (timeout)
[4038242.711100] ata3.00: status: { DRDY }
[4038242.712986] ata3.00: failed command: READ FPDMA QUEUED
[4038242.714874] ata3.00: cmd 60/08:a8:80:a3:3f/00:00:28:01:00/40 tag 21 
ncq 4096 in
[4038242.714874]          res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.718671] ata3.00: status: { DRDY }
[4038242.720557] ata3.00: failed command: READ FPDMA QUEUED
[4038242.722432] ata3.00: cmd 60/08:b0:88:a3:3f/00:00:28:01:00/40 tag 22 
ncq 4096 in
[4038242.722432]          res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.726213] ata3.00: status: { DRDY }
[4038242.728109] ata3.00: failed command: READ FPDMA QUEUED
[4038242.729996] ata3.00: cmd 60/08:b8:90:a3:3f/00:00:28:01:00/40 tag 23 
ncq 4096 in
[4038242.729996]          res 40/00:01:06:4f:c2/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.733776] ata3.00: status: { DRDY }
[4038242.735680] ata3.00: failed command: READ FPDMA QUEUED
[4038242.737564] ata3.00: cmd 60/08:c0:98:a3:3f/00:00:28:01:00/40 tag 24 
ncq 4096 in
[4038242.737564]          res 40/00:01:09:4f:c2/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.741366] ata3.00: status: { DRDY }
[4038242.743276] ata3.00: failed command: READ FPDMA QUEUED
[4038242.745171] ata3.00: cmd 60/08:c8:a0:a3:3f/00:00:28:01:00/40 tag 25 
ncq 4096 in
[4038242.745171]          res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.748959] ata3.00: status: { DRDY }
[4038242.750855] ata3.00: failed command: READ FPDMA QUEUED
[4038242.752741] ata3.00: cmd 60/08:d0:a8:a3:3f/00:00:28:01:00/40 tag 26 
ncq 4096 in
[4038242.752741]          res 40/00:01:06:4f:c2/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.756528] ata3.00: status: { DRDY }
[4038242.758417] ata3.00: failed command: READ FPDMA QUEUED
[4038242.760304] ata3.00: cmd 60/08:d8:b0:a3:3f/00:00:28:01:00/40 tag 27 
ncq 4096 in
[4038242.760304]          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.764094] ata3.00: status: { DRDY }
[4038242.765981] ata3.00: failed command: READ FPDMA QUEUED
[4038242.767867] ata3.00: cmd 60/08:e0:b8:a3:3f/00:00:28:01:00/40 tag 28 
ncq 4096 in
[4038242.767867]          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.771670] ata3.00: status: { DRDY }
[4038242.773566] ata3.00: failed command: READ FPDMA QUEUED
[4038242.775454] ata3.00: cmd 60/08:e8:c0:a3:3f/00:00:28:01:00/40 tag 29 
ncq 4096 in
[4038242.775454]          res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.779246] ata3.00: status: { DRDY }
[4038242.781133] ata3.00: failed command: READ FPDMA QUEUED
[4038242.783020] ata3.00: cmd 60/08:f0:c8:a3:3f/00:00:28:01:00/40 tag 30 
ncq 4096 in
[4038242.783020]          res 40/00:01:06:4f:c2/00:00:00:00:00/00 Emask 
0x44 (timeout)
[4038242.786812] ata3.00: status: { DRDY }
[4038242.788703] ata3: hard resetting link
[4038243.278780] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[4038243.329279] ata3.00: configured for UDMA/133
[4038243.329314] sd 2:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[4038243.329320] sd 2:0:0:0: [sda] tag#0 Sense Key : Illegal Request 
[current] [descriptor]
[4038243.329326] sd 2:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
[4038243.329332] sd 2:0:0:0: [sda] tag#0 CDB: Read(16) 88 00 00 00 00 01 
28 3f a3 d0 00 00 00 08 00 00
[4038243.329336] blk_update_request: I/O error, dev sda, sector 4970226640
[4038243.331303] sd 2:0:0:0: [sda] tag#1 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[4038243.331309] sd 2:0:0:0: [sda] tag#1 Sense Key : Illegal Request 
[current] [descriptor]
[4038243.331314] sd 2:0:0:0: [sda] tag#1 Add. Sense: Unaligned write command
[4038243.331319] sd 2:0:0:0: [sda] tag#1 CDB: Read(16) 88 00 00 00 00 01 
28 3f a3 d8 00 00 00 08 00 00
[4038243.331323] blk_update_request: I/O error, dev sda, sector 4970226648
[4038243.333204] sd 2:0:0:0: [sda] tag#2 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[4038243.333209] sd 2:0:0:0: [sda] tag#2 Sense Key : Illegal Request 
[current] [descriptor]
[4038243.333214] sd 2:0:0:0: [sda] tag#2 Add. Sense: Unaligned write command
[4038243.333218] sd 2:0:0:0: [sda] tag#2 CDB: Read(16) 88 00 00 00 00 01 
28 3f a3 e0 00 00 00 08 00 00
[4038243.333221] blk_update_request: I/O error, dev sda, sector 4970226656
[4038243.335072] sd 2:0:0:0: [sda] tag#3 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[4038243.335077] sd 2:0:0:0: [sda] tag#3 Sense Key : Illegal Request 
[current] [descriptor]
[4038243.335081] sd 2:0:0:0: [sda] tag#3 Add. Sense: Unaligned write command
[4038243.335086] sd 2:0:0:0: [sda] tag#3 CDB: Read(16) 88 00 00 00 00 01 
28 3f a3 e8 00 00 00 08 00 00
[4038243.335089] blk_update_request: I/O error, dev sda, sector 4970226664
[4038243.336908] sd 2:0:0:0: [sda] tag#5 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[4038243.336914] sd 2:0:0:0: [sda] tag#5 Sense Key : Illegal Request 
[current] [descriptor]
[4038243.336918] sd 2:0:0:0: [sda] tag#5 Add. Sense: Unaligned write command
[4038243.336923] sd 2:0:0:0: [sda] tag#5 CDB: Read(16) 88 00 00 00 00 01 
28 3f a3 f0 00 00 00 08 00 00
[4038243.336926] blk_update_request: I/O error, dev sda, sector 4970226672
[4038243.338720] sd 2:0:0:0: [sda] tag#6 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[4038243.338725] sd 2:0:0:0: [sda] tag#6 Sense Key : Illegal Request 
[current] [descriptor]
[4038243.338730] sd 2:0:0:0: [sda] tag#6 Add. Sense: Unaligned write command
[4038243.338734] sd 2:0:0:0: [sda] tag#6 CDB: Read(16) 88 00 00 00 00 01 
28 3f a3 08 00 00 00 08 00 00
[4038243.338737] blk_update_request: I/O error, dev sda, sector 4970226440
[4038243.340502] sd 2:0:0:0: [sda] tag#7 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[4038243.340506] sd 2:0:0:0: [sda] tag#7 Sense Key : Illegal Request 
[current] [descriptor]
[4038243.340511] sd 2:0:0:0: [sda] tag#7 Add. Sense: Unaligned write command
[4038243.340516] sd 2:0:0:0: [sda] tag#7 CDB: Read(16) 88 00 00 00 00 01 
28 3f a3 10 00 00 00 08 00 00
[4038243.340519] blk_update_request: I/O error, dev sda, sector 4970226448
[4038243.342229] sd 2:0:0:0: [sda] tag#8 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[4038243.342234] sd 2:0:0:0: [sda] tag#8 Sense Key : Illegal Request 
[current] [descriptor]
[4038243.342239] sd 2:0:0:0: [sda] tag#8 Add. Sense: Unaligned write command
[4038243.342244] sd 2:0:0:0: [sda] tag#8 CDB: Read(16) 88 00 00 00 00 01 
28 3f a3 18 00 00 00 08 00 00
[4038243.342247] blk_update_request: I/O error, dev sda, sector 4970226456
[4038243.343950] sd 2:0:0:0: [sda] tag#9 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[4038243.343955] sd 2:0:0:0: [sda] tag#9 Sense Key : Illegal Request 
[current] [descriptor]
[4038243.343960] sd 2:0:0:0: [sda] tag#9 Add. Sense: Unaligned write command
[4038243.343965] sd 2:0:0:0: [sda] tag#9 CDB: Read(16) 88 00 00 00 00 01 
28 3f a3 20 00 00 00 08 00 00
[4038243.343968] blk_update_request: I/O error, dev sda, sector 4970226464
[4038243.345623] sd 2:0:0:0: [sda] tag#10 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[4038243.345628] sd 2:0:0:0: [sda] tag#10 Sense Key : Illegal Request 
[current] [descriptor]
[4038243.345633] sd 2:0:0:0: [sda] tag#10 Add. Sense: Unaligned write 
command
[4038243.345637] sd 2:0:0:0: [sda] tag#10 CDB: Read(16) 88 00 00 00 00 
01 28 3f a3 28 00 00 00 08 00 00
[4038243.345640] blk_update_request: I/O error, dev sda, sector 4970226472
[4038243.347350] ata3: EH complete

