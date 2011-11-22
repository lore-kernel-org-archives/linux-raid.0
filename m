From: Konrad Rzepecki <krzepecki@dentonet.pl>
Subject: Disk identity crisis on RAID10 recovery (3.1.0)
Date: Tue, 22 Nov 2011 11:15:37 +0100
Message-ID: <4ECB7649.6080505@dentonet.pl>
Reply-To: krzepecki@dentonet.pl
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

    Hi

My system is Slackware-current x86_64 with 3.1.0 kernel
Gigabyte GA-880GA-UD3H/GA-880GA-UD3H Mainboard
8 x Seagate ST1500DL003-9VT16L 1.5TB disks
ext4 on LVM on RAID10



I have 8 devices RADI10 (2 near) and huge problem with its recovery.

It contain partitions from sda2 to sdh2 in this order.

Some days ago i found that sdc2 is inactive from some reason [UU_UUUUU], 
so I decided to readd (zero, add) it to the RAID since smart shows no 
problems at it. RAID begin to resync but device status looks strange 
[_U_UUUUU]. I ignore this then, but after resync raid still have 
incomplete status [UU_UUUUU]. I try to do it again but, system claims 
that sdc2 is busy - so I restart machine. This lead me to BIG problem. 
System did not stand up. It claims that superblock on sda2 and sdc2 are 
this same. So I zero sdc2 and reboot. In that moment BIOS smart check 
found that sdb disk is failing. System starts up but /var partition 
occurs broken beyond repair. I think then that this sdb failure cause 
/var crash, but I doubt in it now. I fail and remove sdb2 and have 
following status raid [U__UUUUU].

Broken sdb is now removed so it cause device renaming, so strange 
working sdc2 become now sdb2, and so on.

I recover, all important data and try to fix raid further. So I try to 
zero and add sdb2 (previously sdc2) again. This was big mistake. It was 
add as spare but raid status starts looks that [___UUUUU]. In this 
moment filesystems begins to failing. Removing it (sdb2) from array not 
help. After restart no filesystem are mounted. When I disconnect this 
sdb drive and reset, even raid doesn't stand up it claims that it have 5 
working and 1 spare device.

Now I have there only very limited initrd busysbox system so I cannot 
provide detailed logs. Only thing I have is dmesg left on my xterm:

[    3.916469] md: md1 stopped.
[    3.918847] md: bind<sdc2>
[    3.920380] md: bind<sdd2>
[    3.921886] md: bind<sde2>
[    3.923158] md: bind<sdf2>
[    3.924603] md: bind<sdg2>
[    3.926060] md: bind<sda2>
[    3.927876] md/raid10:md1: active with 6 out of 8 devices
[    3.928958] md1: detected capacity change from 0 to 5996325896192
[    3.932456]  md1: unknown partition table
[249638.274101] md: bind<sdb2>
[249638.309805] RAID10 conf printout:
[249638.309807]  --- wd:6 rd:8
[249638.309814]  disk 0, wo:1, o:1, dev:sdb2
[249638.309816]  disk 3, wo:0, o:1, dev:sdc2
[249638.309817]  disk 4, wo:0, o:1, dev:sdd2
[249638.309818]  disk 5, wo:0, o:1, dev:sde2
[249638.309820]  disk 6, wo:0, o:1, dev:sdf2
[249638.309821]  disk 7, wo:0, o:1, dev:sdg2
[249638.309826] ------------[ cut here ]------------
[249638.309831] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x8c/0xa1()
[249638.309832] Hardware name: GA-880GA-UD3H
[249638.309834] sysfs: cannot create duplicate filename 
'/devices/virtual/block/md1/md/rd0'
[249638.309835] Modules linked in: it87_wdt it87 hwmon_vid k10temp
[249638.309840] Pid: 1126, comm: md1_raid10 Not tainted 3.1.0-Slackware #1
[249638.309841] Call Trace:
[249638.309845]  [<ffffffff81030852>] ? warn_slowpath_common+0x78/0x8c
[249638.309848]  [<ffffffff81030907>] ? warn_slowpath_fmt+0x45/0x4a
[249638.309850]  [<ffffffff8110929d>] ? sysfs_add_one+0x8c/0xa1
[249638.309857]  [<ffffffff8110997f>] ? sysfs_do_create_link+0xef/0x187
[249638.309860]  [<ffffffff812155d2>] ? sprintf+0x43/0x48
[249638.309863]  [<ffffffff813b4a49>] ? sysfs_link_rdev+0x36/0x3f
[249638.309866]  [<ffffffff813b007a>] ? raid10_add_disk+0x145/0x151
[249638.309869]  [<ffffffff813baf9d>] ? md_check_recovery+0x3af/0x502
[249638.309871]  [<ffffffff813b0c86>] ? raid10d+0x27/0x8f4
[249638.309874]  [<ffffffff81025a4e>] ? need_resched+0x1a/0x23
[249638.309877]  [<ffffffff814dd795>] ? __schedule+0x5b2/0x5c9
[249638.309879]  [<ffffffff814ddc84>] ? schedule_timeout+0x1d/0xce
[249638.309882]  [<ffffffff814deadc>] ? _raw_spin_lock_irqsave+0x9/0x1f
[249638.309884]  [<ffffffff813b8506>] ? md_thread+0xfa/0x118
[249638.309887]  [<ffffffff81046793>] ? wake_up_bit+0x23/0x23
[249638.309889]  [<ffffffff813b840c>] ? md_rdev_init+0xef/0xef
[249638.309891]  [<ffffffff813b840c>] ? md_rdev_init+0xef/0xef
[249638.309893]  [<ffffffff8104637c>] ? kthread+0x7a/0x82
[249638.309896]  [<ffffffff814e07f4>] ? kernel_thread_helper+0x4/0x10
[249638.309898]  [<ffffffff81046302>] ? kthread_worker_fn+0x135/0x135
[249638.309900]  [<ffffffff814e07f0>] ? gs_change+0xb/0xb
[249638.309902] ---[ end trace 71d9cf6e5c21d5f2 ]---
[249638.309938] md: recovery of RAID array md1
[249638.309941] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[249638.309943] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[249638.309947] md: using 128k window, over a total of 1463946752k.
[249638.310044] md/raid10:md1: insufficient working devices for recovery.
[249638.310110] md: md1: recovery done.
[249638.544763] RAID10 conf printout:
[249638.544765]  --- wd:6 rd:8
[249638.544767]  disk 0, wo:1, o:1, dev:sdb2
[249638.544768]  disk 3, wo:0, o:1, dev:sdc2
[249638.544770]  disk 4, wo:0, o:1, dev:sdd2
[249638.544771]  disk 5, wo:0, o:1, dev:sde2
[249638.544772]  disk 6, wo:0, o:1, dev:sdf2
[249638.544773]  disk 7, wo:0, o:1, dev:sdg2
[249638.552051] RAID10 conf printout:
[249638.552053]  --- wd:6 rd:8
[249638.552055]  disk 3, wo:0, o:1, dev:sdc2
[249638.552056]  disk 4, wo:0, o:1, dev:sdd2
[249638.552057]  disk 5, wo:0, o:1, dev:sde2
[249638.552058]  disk 6, wo:0, o:1, dev:sdf2
[249638.552060]  disk 7, wo:0, o:1, dev:sdg2
[249702.798860] ------------[ cut here ]------------
[249702.798865] WARNING: at fs/buffer.c:1150 mark_buffer_dirty+0x25/0x80()
[249702.798867] Hardware name: GA-880GA-UD3H
[249702.798868] Modules linked in: it87_wdt it87 hwmon_vid k10temp
[249702.798873] Pid: 1530, comm: jbd2/dm-5-8 Tainted: G        W 
3.1.0-Slackware #1
[249702.798874] Call Trace:
[249702.798879]  [<ffffffff81030852>] ? warn_slowpath_common+0x78/0x8c
[249702.798881]  [<ffffffff810d80c7>] ? mark_buffer_dirty+0x25/0x80
[249702.798884]  [<ffffffff8116bd81>] ? 
__jbd2_journal_unfile_buffer+0x9/0x1a
[249702.798887]  [<ffffffff8116e628>] ? 
jbd2_journal_commit_transaction+0xbb6/0xe3a
[249702.798891]  [<ffffffff8103a8c6>] ? lock_timer_base.clone.23+0x25/0x4c
[249702.798893]  [<ffffffff81170dab>] ? kjournald2+0xc0/0x20d
[249702.798896]  [<ffffffff81046793>] ? wake_up_bit+0x23/0x23
[249702.798898]  [<ffffffff81170ceb>] ? commit_timeout+0xd/0xd
[249702.798900]  [<ffffffff81170ceb>] ? commit_timeout+0xd/0xd
[249702.798902]  [<ffffffff8104637c>] ? kthread+0x7a/0x82
[249702.798904]  [<ffffffff814e07f4>] ? kernel_thread_helper+0x4/0x10
[249702.798907]  [<ffffffff81046302>] ? kthread_worker_fn+0x135/0x135
[249702.798909]  [<ffffffff814e07f0>] ? gs_change+0xb/0xb
[249702.798910] ---[ end trace 71d9cf6e5c21d5f3 ]---
[250297.275053] md/raid10:md1: Disk failure on sdb2, disabling device.
[250297.275054] md/raid10:md1: Operation continuing on 6 devices.
[250350.689633] md: unbind<sdb2>
[250350.705066] md: export_rdev(sdb2)

I've deleted from it ext4 and lvm i/o errors.


All this leads me to conclusion that from some strange reason drive sdb 
(named earlier sdc) when added shadows sda. It seems zeroing sdb 
superblock have no effect on this issue.

Probaly this is not controller error because smartctl shows different 
data on both devices. Also other RAID1 (md0: sda1 - sdh1) behaves correctly.

Similar problem described Brad Campbell in "2 drive RAID10 rebuild 
issue" on 14 Oct.


-- 
    Konrad Rzepecki
