From: Monty Charlton <monty@fullmonty.org>
Subject: raid 5 out of sync won't mount
Date: Tue, 18 Jun 2002 08:45:45 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D0F4799.5090403@fullmonty.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I've got a helluva problem and I'm hoping someone here can possibly help 
out.

I've got raid5 (sdb1,sbc1,sdd1) on a partition, and one of the drives 
(sdd1) went bad.  So I (stupidly) hit the reset button on the computer, 
but now the partition won't mount.  Raid complains that one drive is bad 
(which it is), and that the other is out of sync.  See part of dmesg 
below...

Am I hosed?  Can I fake out raid by commenting out some of the code that 
tries to determine whether or not the drive is fresh?

Thanks,
Monty


part of dmesg:

md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
raid5: measuring checksumming speed
    8regs     :   247.600 MB/sec
    32regs    :   248.000 MB/sec
    pII_mmx   :   337.200 MB/sec
    p5_mmx    :   409.200 MB/sec
raid5: using function: p5_mmx (409.200 MB/sec)
md: raid5 personality registered as nr 4
  [events: 00000003]
  [events: 00000004]
  [events: 00000002]
md: autorun ...
md: considering sdd1 ...
md:  adding sdd1 ...
md:  adding sdc1 ...
md:  adding sdb1 ...
md: created md0
md: bind<sdb1,1>
md: bind<sdc1,2>
md: bind<sdd1,3>
md: running: <sdd1><sdc1><sdb1>
md: sdd1's event counter: 00000002
md: sdc1's event counter: 00000004
md: sdb1's event counter: 00000003
md: superblock update time inconsistency -- using the most recent one
md: freshest: sdc1
md: kicking non-fresh sdd1 from array!
md: unbind<sdd1,2>
md: export_rdev(sdd1)
md0: kicking faulty sdb1!
md: unbind<sdb1,1>
md: export_rdev(sdb1)
md0: removing former faulty sdd1!
md: md0: raid array is not clean -- starting background reconstruction
md0: max total readahead window set to 496k
md0: 2 data-disks, max readahead per data-disk: 248k
raid5: device sdc1 operational as raid disk 1
raid5: not enough operational devices for md0 (2/3 failed)
RAID5 conf printout:
  --- rd:3 wd:1 fd:2
  disk 0, s:0, o:0, n:0 rd:0 us:1 dev:[dev 00:00]
  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdc1
  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev 00:00]
raid5: failed to run raid set md0
md: pers->run() failed ...
md :do_md_run() returned -22
md: md0 stopped.
md: unbind<sdc1,0>
md: export_rdev(sdc1)
md: ... autorun DONE.

