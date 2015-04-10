From: Tejas Rao <raot@bnl.gov>
Subject: RAID IO stuck under heavy load (writes)
Date: Thu, 09 Apr 2015 21:54:54 -0400
Message-ID: <55272D6E.6050505@bnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We are running GPFS over md raid devices.

The GPFS storage servers each have 60 4TB jbod drives. This is setup in 
a 6 RAID6 md devices(8+2), with default chunk size 512K. We are running 
RHEL 6.5 , kernel 2.6.32-431.23.3.el6.x86_64.

stripe_cache_size for each md device is set to maximum 32768. If I set 
the stripe_cache_size to 16384 or lower, I see stuck IO even at lower 
work loads.

Under heavy write load we see IO getting stuck for several minutes (GPFS 
waiters), sometimes as long as 30 minutes, eventually they all complete. 
I see stripe_cache_active on the stuck md device close to maximum and 
not changing(stuck?).

This happens randomly on different md devices on different servers, so I 
am sure this is not a hardware problem tied to a failing disk/SAS port etc.

How can troubleshoot this further to isolate the cause? I am reproduce 
this problem 100%.

This is what I see in the /var/log/messages file. mmfslinux/mmfs26 is 
the GPFS application.

Feb 5 12:24:10 host12 kernel: Not tainted 2.6.32-431.23.3.el6.x86_64 #1
Feb 5 12:24:10 host12 kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 5 12:24:10 host12 kernel: mmfsd D 0000000000000012 0 28987 28418 
0x00000080
Feb 5 12:24:10 host12 kernel: ffff880c9f1ffbe8 0000000000000082 
0000000000000000 ffffffffa02833e8
Feb 5 12:24:10 host12 kernel: ffff880c9f1ffc48 ffffffffa088c133 
0000000000016840 ffff880872b07740
Feb 5 12:24:10 host12 kernel: ffff88007dc3faf8 ffff880c9f1fffd8 
000000000000fbc8 ffff88007dc3faf8
Feb 5 12:24:10 host12 kernel: Call Trace:
Feb 5 12:24:10 host12 kernel: [<ffffffffa02833e8>] ? 
raid5_unplug_queue+0x18/0x20 [raid456]
Feb 5 12:24:10 host12 kernel: [<ffffffffa088c133>] ? 
cxiStartIO+0x2a3/0x6b0 [mmfslinux]
Feb 5 12:24:10 host12 kernel: [<ffffffffa0888b6c>] cxiWaitIO+0x13c/0x1a0 
[mmfslinux]
Feb 5 12:24:10 host12 kernel: [<ffffffff8109afa0>] ? 
autoremove_wake_function+0x0/0x40
Feb 5 12:24:10 host12 kernel: [<ffffffffa0913c8d>] 
_ZN9DiskSched7localIOEPP15MBDoDiskIOParmsiiP15KernelOperation+0x49d/0x6d0 [mmfs26]
Feb 5 12:24:10 host12 kernel: [<ffffffffa09132d0>] ? 
_Z22LinuxIODoneIntCallbackPvj+0x0/0x2a0 [mmfs26]
Feb 5 12:24:10 host12 kernel: [<ffffffffa0913f8d>] ? 
kxLocalIO+0xcd/0x110 [mmfs26]
Feb 5 12:24:10 host12 kernel: [<ffffffff810129de>] ? 
copy_user_generic+0xe/0x20
Feb 5 12:24:10 host12 kernel: [<ffffffffa09e0755>] ? 
_Z8ss_ioctljm+0x345/0x1650 [mmfs26]
Feb 5 12:24:10 host12 kernel: [<ffffffff8100b9ce>] ? 
common_interrupt+0xe/0x13
Feb 5 12:24:10 host12 kernel: [<ffffffff8100b9ce>] ? 
common_interrupt+0xe/0x13
Feb 5 12:24:10 host12 kernel: [<ffffffffa089a199>] ? 
ss_fs_unlocked_ioctl+0x89/0x3e0 [mmfslinux]
Feb 5 12:24:10 host12 kernel: [<ffffffff8100b9ce>] ? 
common_interrupt+0xe/0x13
Feb 5 12:24:10 host12 kernel: [<ffffffff8119e532>] ? vfs_ioctl+0x22/0xa0
Feb 5 12:24:10 host12 kernel: [<ffffffff8119e6e7>] ? do_vfs_ioctl+0x97/0x580
Feb 5 12:24:10 host12 kernel: [<ffffffff8119e6d4>] ? do_vfs_ioctl+0x84/0x580
Feb 5 12:24:10 host12 kernel: [<ffffffff8119ec51>] ? sys_ioctl+0x81/0xa0
Feb 5 12:24:10 host12 kernel: [<ffffffff810e1cde>] ? 
__audit_syscall_exit+0x25e/0x290
Feb 5 12:24:10 host12 kernel: [<ffffffff8100b072>] ? 
system_call_fastpath+0x16/0x1b
