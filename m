From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: BUG - raid 1 deadlock on handle_read_error / wait_barrier
Date: Thu, 30 May 2013 17:30:31 +0300
Message-ID: <CAGRgLy5m8KxKPxJE+AbtYbBDzo9uo81wez1ba=H4VY3Jiq32WQ@mail.gmail.com>
References: <1361487504.4863.54.camel@linux-lxtg.site>
	<20130225094350.4b8ef084@notabene.brown>
	<20130225110458.2b1b1e2d@notabene.brown>
	<1361808662.20264.4.camel@148>
	<alpine.DEB.2.02.1302260905390.1736@jlaw-desktop.mno.stratus.com>
	<CAGRgLy45byT7fxLBOqU6ZNjpOL0Xmq6nNsiwJSCTq+kd1Ya7Jg@mail.gmail.com>
	<20130520171753.002f07d9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130520171753.002f07d9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
Cc: Tregaron Bayly <tbayly@bluehost.com>, Shyam Kaushik <shyam@zadarastorage.com>
List-Id: linux-raid.ids

Hi Neil,

On Mon, May 20, 2013 at 10:17 AM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 16 May 2013 17:07:04 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
> wrote:
>
>> Hello Neil,
>> we are hitting issue that looks very similar; we are on kernel 3.8.2.
>> The array is a 2-device raid1, which experienced a drive failure, but
>> then drive was removed and re-added back to the array (although
>> rebuild never started). Relevant parts of the kernel log:
>>
>> May 16 11:12:14  kernel: [46850.090499] md/raid1:md2: Disk failure on
>> dm-6, disabling device.
>> May 16 11:12:14  kernel: [46850.090499] md/raid1:md2: Operation
>> continuing on 1 devices.
>> May 16 11:12:14  kernel: [46850.090511] md: super_written gets
>> error=-5, uptodate=0
>> May 16 11:12:14  kernel: [46850.090676] md/raid1:md2: dm-6:
>> rescheduling sector 18040736
>> May 16 11:12:14  kernel: [46850.090764] md/raid1:md2: dm-6:
>> rescheduling sector 20367040
>> May 16 11:12:14  kernel: [46850.090826] md/raid1:md2: dm-6:
>> rescheduling sector 17613504
>> May 16 11:12:14  kernel: [46850.090883] md/raid1:md2: dm-6:
>> rescheduling sector 18042720
>> May 16 11:12:15  kernel: [46850.229970] md/raid1:md2: redirecting
>> sector 18040736 to other mirror: dm-13
>> May 16 11:12:15  kernel: [46850.257687] md/raid1:md2: redirecting
>> sector 20367040 to other mirror: dm-13
>> May 16 11:12:15  kernel: [46850.268731] md/raid1:md2: redirecting
>> sector 17613504 to other mirror: dm-13
>> May 16 11:12:15  kernel: [46850.398242] md/raid1:md2: redirecting
>> sector 18042720 to other mirror: dm-13
>> May 16 11:12:23  kernel: [46858.448465] md: unbind<dm-6>
>> May 16 11:12:23  kernel: [46858.456081] md: export_rdev(dm-6)
>> May 16 11:23:19  kernel: [47515.062547] md: bind<dm-6>
>>
>> May 16 11:24:28  kernel: [47583.920126] INFO: task md2_raid1:15749
>> blocked for more than 60 seconds.
>> May 16 11:24:28  kernel: [47583.921829] "echo 0 >
>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> May 16 11:24:28  kernel: [47583.923361] md2_raid1       D
>> 0000000000000001     0 15749      2 0x00000000
>> May 16 11:24:28  kernel: [47583.923367]  ffff880097c23c28
>> 0000000000000046 ffff880000000002 00000000982c43b8
>> May 16 11:24:28  kernel: [47583.923372]  ffff880097c23fd8
>> ffff880097c23fd8 ffff880097c23fd8 0000000000013f40
>> May 16 11:24:28  kernel: [47583.923376]  ffff880119b11740
>> ffff8800a5489740 ffff880097c23c38 ffff88011609d3c0
>> May 16 11:24:28  kernel: [47583.923381] Call Trace:
>> May 16 11:24:28  kernel: [47583.923395]  [<ffffffff816eb399>] schedule+0x29/0x70
>> May 16 11:24:28  kernel: [47583.923402]  [<ffffffffa0516736>]
>> raise_barrier+0x106/0x160 [raid1]
>> May 16 11:24:28  kernel: [47583.923410]  [<ffffffff8107fcc0>] ?
>> add_wait_queue+0x60/0x60
>> May 16 11:24:28  kernel: [47583.923415]  [<ffffffffa0516af7>]
>> raid1_add_disk+0x197/0x200 [raid1]
>> May 16 11:24:28  kernel: [47583.923421]  [<ffffffff81567fa4>]
>> remove_and_add_spares+0x104/0x220
>> May 16 11:24:28  kernel: [47583.923426]  [<ffffffff8156a02d>]
>> md_check_recovery.part.49+0x40d/0x530
>> May 16 11:24:28  kernel: [47583.923429]  [<ffffffff8156a165>]
>> md_check_recovery+0x15/0x20
>> May 16 11:24:28  kernel: [47583.923433]  [<ffffffffa0517e42>]
>> raid1d+0x22/0x180 [raid1]
>> May 16 11:24:28  kernel: [47583.923439]  [<ffffffff81045cd9>] ?
>> default_spin_lock_flags+0x9/0x10
>> May 16 11:24:28  kernel: [47583.923443]  [<ffffffff81045cd9>] ?
>> default_spin_lock_flags+0x9/0x10
>> May 16 11:24:28  kernel: [47583.923449]  [<ffffffff815624ed>]
>> md_thread+0x10d/0x140
>> May 16 11:24:28  kernel: [47583.923453]  [<ffffffff8107fcc0>] ?
>> add_wait_queue+0x60/0x60
>> May 16 11:24:28  kernel: [47583.923457]  [<ffffffff815623e0>] ?
>> md_rdev_init+0x140/0x140
>> May 16 11:24:28  kernel: [47583.923461]  [<ffffffff8107f0d0>] kthread+0xc0/0xd0
>> May 16 11:24:28  kernel: [47583.923465]  [<ffffffff8107f010>] ?
>> flush_kthread_worker+0xb0/0xb0
>> May 16 11:24:28  kernel: [47583.923472]  [<ffffffff816f506c>]
>> ret_from_fork+0x7c/0xb0
>> May 16 11:24:28  kernel: [47583.923476]  [<ffffffff8107f010>] ?
>> flush_kthread_worker+0xb0/0xb0
>>
>> dm-13 is the good drive, dm-6 is the one that failed.
>>
>> At this point, we have several threads calling submit_bio and all
>> stuck like this:
>>
>> cat /proc/16218/stack
>> [<ffffffffa0516d6e>] wait_barrier+0xbe/0x160 [raid1]
>> [<ffffffffa0518627>] make_request+0x87/0xa90 [raid1]
>> [<ffffffff81561ed0>] md_make_request+0xd0/0x200
>> [<ffffffff8132bcaa>] generic_make_request+0xca/0x100
>> [<ffffffff8132bd5b>] submit_bio+0x7b/0x160
>> ...
>>
>> And md raid1 thread stuck like this:
>>
>> cat /proc/15749/stack
>> [<ffffffffa0516736>] raise_barrier+0x106/0x160 [raid1]
>> [<ffffffffa0516af7>] raid1_add_disk+0x197/0x200 [raid1]
>> [<ffffffff81567fa4>] remove_and_add_spares+0x104/0x220
>> [<ffffffff8156a02d>] md_check_recovery.part.49+0x40d/0x530
>> [<ffffffff8156a165>] md_check_recovery+0x15/0x20
>> [<ffffffffa0517e42>] raid1d+0x22/0x180 [raid1]
>> [<ffffffff815624ed>] md_thread+0x10d/0x140
>> [<ffffffff8107f0d0>] kthread+0xc0/0xd0
>> [<ffffffff816f506c>] ret_from_fork+0x7c/0xb0
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> We have also two user-space threads stuck:
>>
>> one is trying to read /sys/block/md2/md/array_state and its kernel stack is:
>> # cat /proc/2251/stack
>> [<ffffffff81564602>] md_attr_show+0x72/0xf0
>> [<ffffffff8120f116>] fill_read_buffer.isra.8+0x66/0xf0
>> [<ffffffff8120f244>] sysfs_read_file+0xa4/0xc0
>> [<ffffffff8119b0d0>] vfs_read+0xb0/0x180
>> [<ffffffff8119b1f2>] sys_read+0x52/0xa0
>> [<ffffffff816f511d>] system_call_fastpath+0x1a/0x1f
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> the other wants to read from /proc/mdstat and is:
>> [<ffffffff81563d2b>] md_seq_show+0x4b/0x540
>> [<ffffffff811bdd1b>] seq_read+0x16b/0x400
>> [<ffffffff811ff572>] proc_reg_read+0x82/0xc0
>> [<ffffffff8119b0d0>] vfs_read+0xb0/0x180
>> [<ffffffff8119b1f2>] sys_read+0x52/0xa0
>> [<ffffffff816f511d>] system_call_fastpath+0x1a/0x1f
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> mdadm --detail also gets stuck if attempted, in stack like this:
>> cat /proc/2864/stack
>> [<ffffffff81564602>] md_attr_show+0x72/0xf0
>> [<ffffffff8120f116>] fill_read_buffer.isra.8+0x66/0xf0
>> [<ffffffff8120f244>] sysfs_read_file+0xa4/0xc0
>> [<ffffffff8119b0d0>] vfs_read+0xb0/0x180
>> [<ffffffff8119b1f2>] sys_read+0x52/0xa0
>> [<ffffffff816f511d>] system_call_fastpath+0x1a/0x1f
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> Might your patch https://patchwork.kernel.org/patch/2260051/ fix this
>
> Probably.
>
>> issue? Is this patch alone applicable to kernel 3.8.2?
>
> Probably.

This problem still happens in 3.8.13, which contains the above fix of
yours. I am currently debugging it deeper, but still don't know what
the issue is.
The problem happens when raid1_add_disk() calls raise_barrier().
conf->nr_waiting is 0 at this point. So then raise_barrier() starts
waiting for conf->nr_pending getting to 0, but it never gets to 0.
From this point, anybody that calls wait_barrier() is also stuck.

This looks like a real deadlock in a non-ancient kernel. I realize
that 3.8.x is EOL, but still it's only one stable behind.
Can you help further with this problem?

Another problem that I see often, is when a drive fails in RAID1, and
then rdev is marked as "Blocked", but then Blocked bit never gets
cleared for some reason. So this drive is not ejected from the array.
Again, I was unable to debug it deeper at this point.

Thanks,
Alex.












>
>> Can you pls kindly comment on this.
>>
>
> NeilBrown
