From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: raid0 over 2 h/w raid5's OOPSing at mkfs
Date: Mon, 15 May 2006 14:47:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.0605151440080.29380@chaos.egr.duke.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've got a x86_64 system with 2 3ware 9550SX-12s, each set up as a raid5 
w/ a hot spare.  Over that, I do a software raid0 stripe via:

mdadm -C /dev/md0 -c 512 -l 0 -n 2 /dev/sd[bc]1

Whenever I try to format md0 (I've tried both mke2fs and mkfs.xfs), the 
system OOPSes.  I'm running centos-4 with the default kernel, but I've 
upgraded the 3ware driver/firmware to the most recent versions.  Based on 
the OOPS I'll paste below, who should I be blaming for this crash?  Any 
ideas on how to fix it?  Thanks.

Unable to handle kernel NULL pointer dereference at 0000000000000027 RIP:
<ffffffffa0194ab6>{:raid0:raid0_make_request+448}
PML4 3e913067 PGD 7b652067 PMD 0
Oops: 0000 [1] SMP
CPU 1
Modules linked in: raid0 md5 ipv6 parport_pc lp parport i2c_dev i2c_core sunrpc ipt_REJECT ipt_state ip_conntrack iptable_filter ip_tables dm_mirror dm_mod button battery ac ohci_hcd hw_random tg3 floppy ext3 jbd 3w_9xxx(U) 3w_xxxx sd_mod scsi_mod
Pid: 2955, comm: mke2fs Not tainted 2.6.9-34.ELsmp
RIP: 0010:[<ffffffffa0194ab6>] <ffffffffa0194ab6>{:raid0:raid0_make_request+448}
RSP: 0018:000001007cee1a38  EFLAGS: 00010246
RAX: 000001007f3cd780 RBX: 0000010051277400 RCX: 0000000000002460
RDX: ffffffffffffffff RSI: 00000000000003ff RDI: 000001007f3cd7a8
RBP: 0000000000000009 R08: 0000000000001230 R09: 00000000003d0900
R10: 000000007f1b5440 R11: 00000000f4240000 R12: 000001007f3cd7c0
R13: 00000100416af4a0 R14: 00000000f4240000 R15: 000000001e848000
FS:  0000002a955662e0(0000) GS:ffffffff804d7b80(0000) knlGS:00000000f7fef6c0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000027 CR3: 000000007ffa2000 CR4: 00000000000006e0
Process mke2fs (pid: 2955, threadinfo 000001007cee0000, task 000001003f5e77f0)
Stack: 0000000100000000 0000000000000246 0000000000000246 0000000000000008
        0000010051277400 0000000000000100 00000002e9081800 ffffffff8024acea
        ffffffff80134df2 000001007cee1ab0
Call Trace:<ffffffff8024acea>{generic_make_request+355} <ffffffff80134df2>{autoremove_wake_function+0}
        <ffffffff80160400>{cache_init_objs+60} <ffffffff8024adf6>{submit_bio+247}
        <ffffffff8017c1e0>{bio_alloc+288} <ffffffff8017e36f>{blkdev_get_block+0}
        <ffffffff8017a0f6>{submit_bh+255} <ffffffff8017e36f>{blkdev_get_block+0}
        <ffffffff8017a17a>{ll_rw_block+100} <ffffffff8017b60a>{__block_prepare_write+638}
        <ffffffff8017e36f>{blkdev_get_block+0} <ffffffff8017b79b>{block_prepare_write+26}
        <ffffffff8015a769>{generic_file_buffered_write+440}
        <ffffffff8013bd7f>{current_fs_time+89} <ffffffff8015af36>{__generic_file_aio_write_nolock+731}
        <ffffffff8015b1d4>{generic_file_aio_write_nolock+32}
        <ffffffff8015b3a2>{generic_file_write_nolock+158} <ffffffff801d1f8b>{selinux_file_permission+298}
        <ffffffff80134df2>{autoremove_wake_function+0} <ffffffff80229b05>{write_chan+0}
        <ffffffff8017f2fc>{blkdev_file_write+26} <ffffffff80177c60>{vfs_write+207}
        <ffffffff80177d48>{sys_write+69} <ffffffff801101c6>{system_call+126}


Code: 48 8b 42 28 48 89 43 10 48 03 4a 40 b8 01 00 00 00 48 89 0b
RIP <ffffffffa0194ab6>{:raid0:raid0_make_request+448} RSP <000001007cee1a38>
CR2: 0000000000000027
  <0>Kernel panic - not syncing: Oops



-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
