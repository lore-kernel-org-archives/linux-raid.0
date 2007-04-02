From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: raid10 kernel panic on sparc64
Date: Mon, 2 Apr 2007 02:15:57 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704020211380.1245@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: sparclinux@vger.kernel.org
List-Id: linux-raid.ids

Hi,


just when I did
# mdadm -C /dev/md2 -b internal -e 1.0 -l 10 -n 4 /dev/sd[cdef]4
(created)
# mdadm -D /dev/md2
Killed

dmesg filled up with a kernel oops. A few seconds later, the box
locked solid. Since I was only in by ssh and there is not (yet) any
possibility to reset it remotely, this is all I can give right now,
the last 80x25 screen:

l4: 0000000000000000 l5: 0000000000000000 l6: 0000000000000000
l7: 0000000000000i0: fffff8007f218d18 i1: fffff8002e3d9608
i2: 000000000047f974 i3: 0000000000000i4: 0000000000000000
i5: 00000000006e2800 i6: fffff80008c12a41 i7: 0000000000526
I7: <elv_next_request+0x94/0x188>
Caller[00000000005263e8]: elv_next_request+0x94/0x188
Caller[0000000010086618]: scsi_request_fn+0x60/0x3f4 [scsi_mod]
Caller[0000000000529b70]: __generic_unplug_device+0x34/0x3c
Caller[000000000052a7d4]: generic_unplug_device+0x14/0x2c
Caller[0000000000526e48]: blk_backing_dev_unplug+0x20/0x28
Caller[00000000004a464c]: block_sync_page+0x64/0x6c
Caller[000000000047f9d0]: sync_page+0x64/0x74
Caller[0000000000677e48]: __wait_on_bit_lock+0x58/0x90
Caller[000000000047f86c]: __lock_page+0x54/0x5c
Caller[00000000004802ec]: do_generic_mapping_read+0x204/0x49c
Caller[0000000000480d68]: __generic_file_aio_read+0x120/0x18c
Caller[0000000000481fdc]: generic_file_read+0x70/0x94
Caller[00000000004a3920]: vfs_read+0xa0/0x14c
Caller[00000000004a3c8c]: sys_read+0x34/0x60
Caller[0000000000406c54]: linux_sparc_syscall32+0x3c/0x40
Caller[000000000003c6b4]: 0x3c6bc
Instruction DUMP: 921022bd  7c0e4ea2  90122098 <91d02005> 80a0a020  1848000c
80 [0000000010281cdc] sync_request+0x898/0x8e4 [raid10]
 [00000000005f6fb4] md_do_sync+0x454/0x89c
 [00000000005f69ec] md_thread+0x100/0x11c

Kernel is kernel-smp-2.6.16-1.2128sp4.sparc64.rpm from Aurora Corona.
Perhaps it helps, otherwise hold your breath until I reproduce it.


Thanks,
Jan
-- 
