From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: raid1 boot regression in 2.6.37 [bisected]
Date: Mon, 28 Mar 2011 14:53:53 +0200
Message-ID: <201103281453.53382.thomas.jarosch@intra2net.com>
References: <201103251725.21180.thomas.jarosch@intra2net.com> <20110328075937.GB16530@htj.dyndns.org> <201103281302.20219.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201103281302.20219.thomas.jarosch@intra2net.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hi,

here's a backtrace from vanilla 2.6.38:

--------------------------------------------
BUG: soft lockup - CPU#0 stuck for 64s! [blkid:1143]
Modules linked in: ahci libahci libata dm_mod [last unloaded: scsi_wait_scan]
irq event stamp: 981226512
hardirqs last  enabled at (981226511): [<c12dc764>] __mutex_unlock_slowpath+0xb4
/0x150
hardirqs last disabled at (981226512): [<c12deeeb>] apic_timer_interrupt+0x2f/0x
3c
softirqs last  enabled at (981207466): [<c103dbfd>] __do_softirq+0xed/0x140
softirqs last disabled at (981207451): [<c100558d>] do_softirq+0x9d/0xf0
Modules linked in: ahci libahci libata dm_mod [last unloaded: scsi_wait_scan]

Pid: 1143, comm: blkid Not tainted 2.6.38 #26 MSI MS-7349/MS-7349
EIP: 0060:[<c12dc768>] EFLAGS: 00000246 CPU: 0
EIP is at __mutex_unlock_slowpath+0xb8/0x150
EAX: 00000246 EBX: c14252a0 ECX: 00000001 EDX: 00000001
ESI: c14252c4 EDI: 00000246 EBP: f568fd8c ESP: f568fd80
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process blkid (pid: 1143, ti=f568e000 task=f615c030 task.ti=f568e000)
Stack:
 00000000 f545a9c0 00900000 f568fd94 c12dc808 f568fdc0 c11c4451 c11323b0
 f568fdf0 f55e2e00 00000009 f61ae800 00000000 00000000 f568fdf0 f5df7490
 f568fdd0 c11331b8 f5df7480 f55e2e00 f568fe00 c10e85aa f615c030 00000000
Call Trace:
 [<c12dc808>] mutex_unlock+0x8/0x10
 [<c11c4451>] kobj_lookup+0xe1/0x140
 [<c11323b0>] ? exact_match+0x0/0x10
 [<c11331b8>] get_gendisk+0x98/0xb0
 [<c10e85aa>] __blkdev_get+0xca/0x320
 [<c10e8843>] blkdev_get+0x43/0x2c0
 [<c12de75d>] ? _raw_spin_unlock+0x1d/0x20
 [<c10e8b12>] blkdev_open+0x52/0x70
 [<c10bb12d>] __dentry_open+0x9d/0x240
 [<c10bb3c6>] nameidata_to_filp+0x66/0x80
 [<c10e8ac0>] ? blkdev_open+0x0/0x70
 [<c10c781f>] finish_open+0xaf/0x190
 [<c10c8a24>] ? do_path_lookup+0x44/0xe0
 [<c10c9920>] do_filp_open+0x210/0x6d0
 [<c10672e9>] ? lock_release_non_nested+0x59/0x2f0
 [<c12de75d>] ? _raw_spin_unlock+0x1d/0x20
 [<c10d47d8>] ? alloc_fd+0xb8/0xf0
 [<c10baf45>] do_sys_open+0x55/0xf0
 [<c10bb049>] sys_open+0x29/0x40
 [<c1002e9f>] sysenter_do_call+0x12/0x38
Code: 00 00 39 c6 74 11 89 d8 89 f2 e8 14 5a d8 ff 8b 46 08 e8 4c 75 d5 ff fe 43
 04 f7 c7 00 02 00 00 74 21 e8 6c 7f d8 ff 89 f8 50 9d <66> 66 66 90 8b 1c 24 8b
 74 24 04 8b 7c 24 08 89 ec 5d c3 90 8d
Call Trace:
 [<c12dc808>] mutex_unlock+0x8/0x10
 [<c11c4451>] kobj_lookup+0xe1/0x140
 [<c11323b0>] ? exact_match+0x0/0x10
 [<c11331b8>] get_gendisk+0x98/0xb0
 [<c10e85aa>] __blkdev_get+0xca/0x320
 [<c10e8843>] blkdev_get+0x43/0x2c0
 [<c12de75d>] ? _raw_spin_unlock+0x1d/0x20
 [<c10e8b12>] blkdev_open+0x52/0x70
 [<c10bb12d>] __dentry_open+0x9d/0x240
 [<c10bb3c6>] nameidata_to_filp+0x66/0x80
 [<c10e8ac0>] ? blkdev_open+0x0/0x70
 [<c10c781f>] finish_open+0xaf/0x190
 [<c10c8a24>] ? do_path_lookup+0x44/0xe0
 [<c10c9920>] do_filp_open+0x210/0x6d0
 [<c10672e9>] ? lock_release_non_nested+0x59/0x2f0
 [<c12de75d>] ? _raw_spin_unlock+0x1d/0x20
 [<c10d47d8>] ? alloc_fd+0xb8/0xf0
 [<c10baf45>] do_sys_open+0x55/0xf0
 [<c10bb049>] sys_open+0x29/0x40
 [<c1002e9f>] sysenter_do_call+0x12/0x38
--------------------------------------------


Or this one:
--------------------------------------------
BUG: soft lockup - CPU#0 stuck for 63s! [blkid:1143]
Modules linked in: ahci libahci libata dm_mod [last unloaded: scsi_wait_scan]
irq event stamp: 2778370780
hardirqs last  enabled at (2778370779): [<c12de715>] _raw_spin_unlock_irqrestore
+0x35/0x60
hardirqs last disabled at (2778370780): [<c12deeeb>] apic_timer_interrupt+0x2f/0
x3c
softirqs last  enabled at (2778355336): [<c103dbfd>] __do_softirq+0xed/0x140
softirqs last disabled at (2778355323): [<c100558d>] do_softirq+0x9d/0xf0
Modules linked in: ahci libahci libata dm_mod [last unloaded: scsi_wait_scan]

Pid: 1143, comm: blkid Not tainted 2.6.38 #26 MSI MS-7349/MS-7349
EIP: 0060:[<c12de719>] EFLAGS: 00000286 CPU: 0
EIP is at _raw_spin_unlock_irqrestore+0x39/0x60
EAX: 00000286 EBX: f568fd54 ECX: 00000006 EDX: f615c3ac
ESI: 00000286 EDI: f568fd50 EBP: f568fccc ESP: f568fcc4
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process blkid (pid: 1143, ti=f568e000 task=f615c030 task.ti=f568e000)
Stack:
 f568fd54 00000286 f568fce8 c102cd89 00000000 00000000 00000007 00000008
 f61b0840 f568fd14 c104b9c8 001b0874 0000000b f61b08a0 00000007 00000008
 f6503100 f61b0840 00000008 f568fd44 f568fdb8 c104cd20 00000000 00000002
Call Trace:
 [<c102cd89>] complete+0x49/0x60
 [<c104b9c8>] flush_workqueue_prep_cwqs+0x138/0x200
 [<c104cd20>] flush_workqueue+0x1b0/0x430
 [<c104cb70>] ? flush_workqueue+0x0/0x430
 [<c1229e79>] md_open+0x99/0xb0
 [<c10e8557>] __blkdev_get+0x77/0x320
 [<c10e8843>] blkdev_get+0x43/0x2c0
 [<c12de75d>] ? _raw_spin_unlock+0x1d/0x20
 [<c10e8b12>] blkdev_open+0x52/0x70
 [<c10bb12d>] __dentry_open+0x9d/0x240
 [<c10bb3c6>] nameidata_to_filp+0x66/0x80
 [<c10e8ac0>] ? blkdev_open+0x0/0x70
 [<c10c781f>] finish_open+0xaf/0x190
 [<c10c8a24>] ? do_path_lookup+0x44/0xe0
 [<c10c9920>] do_filp_open+0x210/0x6d0
 [<c10672e9>] ? lock_release_non_nested+0x59/0x2f0
 [<c12de75d>] ? _raw_spin_unlock+0x1d/0x20
 [<c10d47d8>] ? alloc_fd+0xb8/0xf0
 [<c10baf45>] do_sys_open+0x55/0xf0
 [<c10bb049>] sys_open+0x29/0x40
 [<c1002e9f>] sysenter_do_call+0x12/0x38
Code: 89 74 24 04 8d 40 10 89 d6 ba 01 00 00 00 e8 7f 8e d8 ff 89 d8 e8 48 5b e7
 ff f7 c6 00 02 00 00 74 18 e8 bb 5f d8 ff 89 f0 50 9d <66> 66 66 90 8b 1c 24 8b
 74 24 04 89 ec 5d c3 89 f0 50 9d 66 66
Call Trace:
 [<c102cd89>] complete+0x49/0x60
 [<c104b9c8>] flush_workqueue_prep_cwqs+0x138/0x200
 [<c104cd20>] flush_workqueue+0x1b0/0x430
 [<c104cb70>] ? flush_workqueue+0x0/0x430
 [<c1229e79>] md_open+0x99/0xb0
 [<c10e8557>] __blkdev_get+0x77/0x320
 [<c10e8843>] blkdev_get+0x43/0x2c0
 [<c12de75d>] ? _raw_spin_unlock+0x1d/0x20
 [<c10e8b12>] blkdev_open+0x52/0x70
 [<c10bb12d>] __dentry_open+0x9d/0x240
 [<c10bb3c6>] nameidata_to_filp+0x66/0x80
 [<c10e8ac0>] ? blkdev_open+0x0/0x70
 [<c10c781f>] finish_open+0xaf/0x190
 [<c10c8a24>] ? do_path_lookup+0x44/0xe0
 [<c10c9920>] do_filp_open+0x210/0x6d0
 [<c10672e9>] ? lock_release_non_nested+0x59/0x2f0
 [<c12de75d>] ? _raw_spin_unlock+0x1d/0x20
 [<c10d47d8>] ? alloc_fd+0xb8/0xf0
 [<c10baf45>] do_sys_open+0x55/0xf0
 [<c10bb049>] sys_open+0x29/0x40
 [<c1002e9f>] sysenter_do_call+0x12/0x38

--------------------------------------------


Cheers,
Thomas
 
