From: Mark Knecht <markknecht@gmail.com>
Subject: crash/dmesg - RAID locking up?
Date: Sun, 28 Mar 2010 15:31:13 -0700
Message-ID: <5bdc1c8b1003281531r2fe1e3e5q47212843bbaa0641@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

So I'm giving up on mdadm/RAID1/WD10EARS Green Drive experiment for
the next day or two. I've tried 4 times in the last two days to see if
I can get this machine to boot using RAID. I keep running into crashes
that look like the one below. I will try a non-RAID install and see if
the hardware is stable and then come back to this later if
appropriate.

I was running a March, 2010 Gentoo install CD when this happened. One
terminal doing bash completion of all things was hung with 1 CPU stuck
in a 100% wait condition. New terminals continued to work if I didn't
try to access the hard drive. I can run things from the CD.

I have never seen a Gentoo install use nearly 2GB so something is
really going wrong here.

Cheers,
Mark

livecd ~ # cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md3 : active raid1 sdc3[2] sdb3[1] sda3[0]
      31463232 blocks [3/3] [UUU]

unused devices: <none>
livecd ~ #


livecd ~ # top

top - 06:24:39 up  1:28,  3 users,  load average: 1.95, 2.52, 2.36
Tasks: 182 total,   1 running, 181 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu3  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu4  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu5  :  0.0%us,  0.0%sy,  0.0%ni,  0.0%id,100.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   6105068k total,  1822336k used,  4282732k free,   172016k buffers
Swap: 12602964k total,        0k used, 12602964k free,  1326360k cached



livecd ~ # uname -a
Linux livecd 2.6.31-gentoo-r6 #1 SMP Thu Mar 4 13:09:55 UTC 2010
x86_64 Intel(R) Core(TM) i7 CPU 920 @ 2.67GHz GenuineIntel GNU/Linux
livecd ~ #


Adding 4200988k swap on /dev/sda2.  Priority:1 extents:1 across:4200988k
Adding 4200988k swap on /dev/sdb2.  Priority:1 extents:1 across:4200988k
Adding 4200988k swap on /dev/sdc2.  Priority:1 extents:1 across:4200988k
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md3, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
INFO: task bash:17348 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
bash          D ffff8800280d3e00     0 17348  17345 0x00000000
 ffff8801afb1a670 0000000000000082 0000000000000000 00000000000000ff
 ffff8801a788f038 0000000000004000 000000000000fe00 000000000000c878
 ffff8801af1e39b8 ffff8801af1e39d0 ffff8801af91c730 ffff8801afb1a8e8
Call Trace:
 [<ffffffff81209a92>] ? generic_make_request+0x220/0x26a
 [<ffffffff8109c248>] ? sync_buffer+0x0/0x40
 [<ffffffff8137a4fc>] ? io_schedule+0x2d/0x3a
 [<ffffffff8109c283>] ? sync_buffer+0x3b/0x40
 [<ffffffff8137a879>] ? __wait_on_bit+0x41/0x70
 [<ffffffff8109c248>] ? sync_buffer+0x0/0x40
 [<ffffffff8137a913>] ? out_of_line_wait_on_bit+0x6b/0x77
 [<ffffffff810438b2>] ? wake_bit_function+0x0/0x23
 [<ffffffff81132dff>] ? log_do_checkpoint+0x366/0x429
 [<ffffffff81132f92>] ? __log_wait_for_space+0xd0/0x176
 [<ffffffff81130e8e>] ? start_this_handle+0x2b2/0x2fb
 [<ffffffff8108a698>] ? filldir+0x0/0xb7
 [<ffffffff8108a698>] ? filldir+0x0/0xb7
 [<ffffffff8113102d>] ? journal_start+0x9a/0xce
 [<ffffffff810f3ae2>] ? ext3_dirty_inode+0x28/0x7b
 [<ffffffff8109745d>] ? __mark_inode_dirty+0x26/0xf5
 [<ffffffff8108ebca>] ? touch_atime+0x10a/0x113
 [<ffffffff8108a85c>] ? vfs_readdir+0x7a/0x97
 [<ffffffff8108a9b1>] ? sys_getdents+0x7a/0xc1
 [<ffffffff8100adab>] ? system_call_fastpath+0x16/0x1b
INFO: task kjournald:17466 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kjournald     D ffff8800280bbe00     0 17466      2 0x00000000
 ffff8801adf9d890 0000000000000046 0000000000000000 0000000000000000
 ffff8801adcbde44 0000000000004000 000000000000fe00 000000000000c878
 0000000800000050 ffff88017a99aa40 ffff8801af90a150 ffff8801adf9db08
Call Trace:
 [<ffffffff812dd063>] ? md_make_request+0xb6/0xf1
 [<ffffffff8109c248>] ? sync_buffer+0x0/0x40
 [<ffffffff8137a4fc>] ? io_schedule+0x2d/0x3a
 [<ffffffff8109c283>] ? sync_buffer+0x3b/0x40
 [<ffffffff8137a879>] ? __wait_on_bit+0x41/0x70
 [<ffffffff8109c248>] ? sync_buffer+0x0/0x40
 [<ffffffff8137a913>] ? out_of_line_wait_on_bit+0x6b/0x77
 [<ffffffff810438b2>] ? wake_bit_function+0x0/0x23
 [<ffffffff8109c637>] ? sync_dirty_buffer+0x72/0xaa
 [<ffffffff81131b8e>] ? journal_commit_transaction+0xa74/0xde2
 [<ffffffff8103abcc>] ? lock_timer_base+0x26/0x4b
 [<ffffffff81043884>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff81134804>] ? kjournald+0xe3/0x206
 [<ffffffff81043884>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff81134721>] ? kjournald+0x0/0x206
 [<ffffffff81043591>] ? kthread+0x8b/0x93
 [<ffffffff8100bd3a>] ? child_rip+0xa/0x20
 [<ffffffff81043506>] ? kthread+0x0/0x93
 [<ffffffff8100bd30>] ? child_rip+0x0/0x20
livecd ~ #
