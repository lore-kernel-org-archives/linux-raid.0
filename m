From: Andrea Righi <righi.andrea@gmail.com>
Subject: multipath: I/O hanging forever
Date: Sun, 28 Feb 2016 18:53:33 -0700
Message-ID: <20160229015333.GA3101@Dell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Hello,

if I try to do I/O on a mdadm/multipath volume the task is hunging
forever and it never completes.

Anybody else has noticed the same problem?

I'm using 4.5.0-rc5+, from Linus' git. I'll try to do a git bisect
later, I'm pretty sure this problem has been introduced recently (i.e.,
I've never seen this issue with 4.1.x).

Example:

  # mdadm -C /dev/md0 --level=multipath --raid-devices=2 /dev/sdb /dev/sdc
  # cat /proc/mdstat
  Personalities : [multipath]
  md0 : active multipath sdb[0] sdc[1]
        4042740 blocks super 1.2 [2/2] [UU]
  # mkfs.xfs /dev/md0
  meta-data=/dev/md0               isize=256    agcount=4, agsize=252672
  blks
           =                       sectsz=512   attr=2, projid32bit=0
  data     =                       bsize=4096   blocks=1010685, imaxpct=25
           =                       sunit=0      swidth=0 blks
  naming   =version 2              bsize=4096   ascii-ci=0
  log      =internal log           bsize=4096   blocks=2560, version=2
           =                       sectsz=512   sunit=0 blks, lazy-count=1
  realtime =none                   extsz=4096   blocks=0, rtextents=0
  ^C^C^C

 # cat /proc/`pidof mkfs.xfs`/stack
 [<ffffffff8126f53c>] do_blockdev_direct_IO+0x1adc/0x2300
 [<ffffffff8126fda3>] __blockdev_direct_IO+0x43/0x50
 [<ffffffff8126accc>] blkdev_direct_IO+0x4c/0x50
 [<ffffffff811a2014>] generic_file_direct_write+0xa4/0x160
 [<ffffffff811a2190>] __generic_file_write_iter+0xc0/0x1e0
 [<ffffffff8126afc0>] blkdev_write_iter+0x80/0x100
 [<ffffffff81228c3d>] __vfs_write+0xad/0xe0
 [<ffffffff81229a85>] vfs_write+0xa5/0x1a0
 [<ffffffff8122aacc>] SyS_pwrite64+0x6c/0xa0
 [<ffffffff818281f2>] entry_SYSCALL_64_fastpath+0x12/0x76
 [<ffffffffffffffff>] 0xffffffffffffffff

Thanks,
-Andrea
