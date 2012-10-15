From: joystick <joystick@shiftmail.org>
Subject: MD hangs while removing spare
Date: Mon, 15 Oct 2012 14:39:38 +0200
Message-ID: <507C040A.5030706@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Here is a bug report where MD hanged while removing a spare disk.

Kernel is 3.0.43 vanilla
I had to hard reset the machine to restore functionality.
I cannot make further tests because the machine is in production, 
however I hope I have collected enough information before resetting.

Here is what happened:

I had a defective disk giving me a lot of messages like this:

         [758175.598298] sd 4:0:8:0: task abort: SUCCESS 
scmd(ffff8818249a6c00)
         [758475.599357] sd 4:0:8:0: attempting task abort! 
scmd(ffff88181b32e200)
         [758475.599365] sd 4:0:8:0: [sdac] CDB: Inquiry: 12 00 00 00 24 00
         [758475.599379] scsi target4:0:8: handle(0x0019), 
sas_address(0x4433221108000000), phy(8)
     .....
         [758511.407803] scsi target4:0:8: 
enclosure_logical_id(0x500062b2000c2f80), slot(8)
         [758515.407738] scsi target4:0:8: target reset: SUCCESS 
scmd(ffff88181b32e200)
         [758525.406852] sd 4:0:8:0: attempting task abort! 
scmd(ffff88181b32e200)
         [758525.406858] sd 4:0:8:0: [sdac] CDB: Test Unit Ready: 00 00 
00 00 00 00
         [758525.406868] scsi target4:0:8: handle(0x0019), 
sas_address(0x4433221108000000), phy(8)
         [758525.406872] scsi target4:0:8: 
enclosure_logical_id(0x500062b2000c2f80), slot(8)
         [758529.407457] sd 4:0:8:0: task abort: SUCCESS 
scmd(ffff88181b32e200)
         [758529.407465] mpt2sas0: attempting host reset! 
scmd(ffff88181b32e200)
         [758529.407469] sd 4:0:8:0: [sdac] CDB: Inquiry: 12 00 00 00 24 00
         [758529.407532] mpt2sas0: sending diag reset !!
         [758530.550786] mpt2sas0: diag reset: SUCCESS
         [758530.783419] mpt2sas0: LSISAS2116: FWVersion(12.00.00.00), 
ChipRevision(0x02), BiosVersion(07.23.01.00)
         [758530.783423] mpt2sas0: Protocol=(Initiator,Target), 
Capabilities=(TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
         [758530.783489] mpt2sas0: sending port enable !!
         [758546.955835] mpt2sas0: port enable: SUCCESS
         [758546.956038] mpt2sas0: _scsih_search_responding_sas_devices
         [758546.957472] scsi target4:0:0: handle(0x0011), 
sas_addr(0x4433221100000000), enclosure logical id(0x500062b2000c2f80), 
slot(0)
         [758546.957554] scsi target4:0:1: handle(0x0012), 
sas_addr(0x4433221101000000), enclosure logical id(0x500062b2000c2f80), 
slot(1)
         [758546.957634] scsi target4:0:2: handle(0x0013), 
sas_addr(0x4433221102000000), enclosure logical id(0x500062b2000c2f80), 
slot(2)
         [758546.957711] scsi target4:0:3: handle(0x0014), 
sas_addr(0x4433221103000000), enclosure logical id(0x500062b2000c2f80), 
slot(3)
         [758546.957788] scsi target4:0:4: handle(0x0015), 
sas_addr(0x4433221104000000), enclosure logical id(0x500062b2000c2f80), 
slot(4)
         [758546.957865] scsi target4:0:5: handle(0x0016), 
sas_addr(0x4433221105000000), enclosure logical id(0x500062b2000c2f80), 
slot(5)
         [758546.957976] scsi target4:0:6: handle(0x0017), 
sas_addr(0x4433221106000000), enclosure logical id(0x500062b2000c2f80), 
slot(6)
         [758546.958061] scsi target4:0:7: handle(0x0018), 
sas_addr(0x4433221107000000), enclosure logical id(0x500062b2000c2f80), 
slot(7)
         [758546.958138] scsi target4:0:9: handle(0x0019), 
sas_addr(0x4433221109000000), enclosure logical id(0x500062b2000c2f80), 
slot(9)
         [758546.958141]         handle changed from(0x001a)!!!
         [758546.958218] scsi target4:0:10: handle(0x001a), 
sas_addr(0x443322110a000000), enclosure logical id(0x500062b2000c2f80), 
slot(10)
         [758546.958222]         handle changed from(0x001b)!!!
         [758546.958297] scsi target4:0:11: handle(0x001b), 
sas_addr(0x443322110b000000), enclosure logical id(0x500062b2000c2f80), 
slot(11)
         [758546.958300]         handle changed from(0x001c)!!!
         [758546.958375] scsi target4:0:12: handle(0x001c), 
sas_addr(0x443322110c000000), enclosure logical id(0x500062b2000c2f80), 
slot(12)
         [758546.958379]         handle changed from(0x001d)!!!
         [758546.958454] scsi target4:0:13: handle(0x001d), 
sas_addr(0x443322110d000000), enclosure logical id(0x500062b2000c2f80), 
slot(13)
         [758546.958457]         handle changed from(0x001e)!!!
         [758546.958537] scsi target4:0:14: handle(0x001e), 
sas_addr(0x443322110e000000), enclosure logical id(0x500062b2000c2f80), 
slot(14)
         [758546.958541]         handle changed from(0x001f)!!!
         [758546.958673] scsi target4:0:15: handle(0x001f), 
sas_addr(0x443322110f000000), enclosure logical id(0x500062b2000c2f80), 
slot(15)
         [758546.958677]         handle changed from(0x0020)!!!
         [758546.959302] scsi target4:0:8: handle(0x0020), 
sas_addr(0x4433221108000000), enclosure logical id(0x500062b2000c2f80), 
slot(8)
         [758546.959306]         handle changed from(0x0019)!!!
         [758546.959488] mpt2sas0: _scsih_search_responding_raid_devices
         [758546.959491] mpt2sas0: _scsih_search_responding_expanders
         [758546.959496] mpt2sas0: host reset: SUCCESS 
scmd(ffff88181b32e200)

and smartctl -a on that disk would take a very long time to complete.

That was a spare on array md23 .
md23 is a raid5 array with active internal bitmaps.

I proceeded to remove it.

I admit I have not chosen the cleanest way to remove it: I simply pulled 
it out. I had an udev script to notify MD of drive removals which 
detects drives disappearing and invokes "mdadm -If drivename" which is 
invoked just after the drive is pulled out of the slot and not before 
(obviously). Well, this script hanged, with all MD with it.
The udev script and hence mdadm -If is called twice, once for sdac and 
once for sdac1 (array is on sdac1). Both are hanged, in different places 
as you can see below

In dmesg I could see:
[857683.687448] br0: topology change detected, propagating
[858132.445242] sd 4:0:8:0: [sdac] Synchronizing SCSI cache
[858132.445286] sd 4:0:8:0: [sdac]  Result: hostbyte=DID_NO_CONNECT 
driverbyte=DRIVER_OK
[858132.537116] md/raid:md23: Disk failure on sdac1, disabling device.
[858132.537118] md/raid:md23: Operation continuing on 5 devices.
[858132.581365] md: unbind<sdac1>
[858192.476427] INFO: rcu_sched_state detected stall on CPU 3 (t=15000 
jiffies)
[858356.198809] INFO: task fsnotify_mark:93 blocked for more than 120 
seconds.
[858356.206685] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[858356.215653] fsnotify_mark   D ffff880c24da03c0     0    93 2 0x00000000
[858356.215664]  ffff880c24da9c50 0000000000000046 00000000000004ae 
0000000000000000
[858356.215680]  0000000000012a80 ffff880c24da9fd8 ffff880c24da8010 
0000000000012a80
[858356.215694]  ffff880c24da9fd8 0000000000012a80 ffff880c273d5bc0 
ffff880c24da0000
[858356.215709] Call Trace:
[858356.215722]  [<ffffffff815ec4ff>] schedule+0x3f/0x60
[858356.215730]  [<ffffffff815ec9ad>] schedule_timeout+0x1fd/0x2e0
[858356.215742]  [<ffffffff81106c61>] ? 
__perf_event_task_sched_out+0x31/0x60
[858356.215751]  [<ffffffff815ec33b>] wait_for_common+0xdb/0x180
[858356.215762]  [<ffffffff8105b1d0>] ? try_to_wake_up+0x2b0/0x2b0
[858356.215773]  [<ffffffff810d8de0>] ? synchronize_rcu_bh+0x60/0x60
[858356.215781]  [<ffffffff815ec4bd>] wait_for_completion+0x1d/0x20
[858356.215789]  [<ffffffff810d8e37>] synchronize_sched+0x57/0x60
[858356.215799]  [<ffffffff81081ba0>] ? alloc_pid+0x210/0x210
[858356.215810]  [<ffffffff8108a8c4>] __synchronize_srcu+0x74/0xd0
[858356.215819]  [<ffffffff8108a955>] synchronize_srcu+0x15/0x20
[858356.215829]  [<ffffffff811ab72d>] fsnotify_mark_destroy+0x9d/0x170
[858356.215838]  [<ffffffff81085210>] ? wake_up_bit+0x40/0x40
[858356.215846]  [<ffffffff811ab690>] ? 
fsnotify_set_mark_ignored_mask_locked+0x40/0x40
[858356.215856]  [<ffffffff81084ca6>] kthread+0x96/0xa0
[858356.215866]  [<ffffffff815f7a24>] kernel_thread_helper+0x4/0x10
[858356.215875]  [<ffffffff81084c10>] ? kthread_worker_fn+0x190/0x190
[858356.215884]  [<ffffffff815f7a20>] ? gs_change+0x13/0x13
.......

I have kept record of where the most important processes of the system 
hanged:

mdadm -If sdac1
15644 (mdadm) D 15639 926 926 0 -1 4202752 380 0 5 0 0 2 0 0 20 0 1 0 
85814051 13864960 288 18446744073709551615 4194304 4735876 
140736053491552 140736053487896 140710797018000 0 0 0 0 
18446744071579733559 0 0 17 18 0 0 4 0 0
             [<ffffffff810d8e37>] synchronize_sched+0x57/0x60
             [<ffffffff814a3d3d>] unbind_rdev_from_array+0xad/0x140
             [<ffffffff814aa3d6>] kick_rdev_from_array+0x16/0x30
             [<ffffffff814ab792>] state_store+0xa2/0x1b0
             [<ffffffff814a3325>] rdev_attr_store+0xb5/0xd0
             [<ffffffff811e213f>] sysfs_write_file+0xef/0x170
             [<ffffffff8116ff98>] vfs_write+0xc8/0x190
             [<ffffffff81170151>] sys_write+0x51/0x90
             [<ffffffff815f6902>] system_call_fastpath+0x16/0x1b
             [<ffffffffffffffff>] 0xffffffffffffffff


mdadm -If sdac
15736 (mdadm) S 15731 926 926 0 -1 4202496 305 0 0 0 0 0 0 0 20 0 1 0 
85820253 13660160 226 18446744073709551615 4194304 4735876 
140734908711920 140734908709416 139865605182256 0 0 0 0 
18446744071583714500 0 0 17 18 0 0 0 0 0
             [<ffffffff814a4cc4>] md_seq_show+0x104/0x5b0
             [<ffffffff81191e31>] seq_read+0x291/0x420
             [<ffffffff811cdcd1>] proc_reg_read+0x81/0xc0
             [<ffffffff81170255>] vfs_read+0xc5/0x190
             [<ffffffff81170421>] sys_read+0x51/0x90
             [<ffffffff815f6902>] system_call_fastpath+0x16/0x1b
             [<ffffffffffffffff>] 0xffffffffffffffff


/sbin/mdadm--monitor--pid-file/var/run/mdadm/monitor.pid--daemonise--scan--syslog
5349 (mdadm) S 1 5349 5349 0 -1 4202816 1108 0 0 0 71 60 0 0 20 0 1 0 
4331 13930496 229 18446744073709551615 4194304 4735876 140735159219488 
140735159212296 140547278258103 0 0 0 0 18446744071583745807 0 0 17 20 0 
0 0 0 0
             [<ffffffff814ac70f>] md_ioctl+0x8f/0x800
             [<ffffffff812e31c8>] __blkdev_driver_ioctl+0x28/0x30
             [<ffffffff812e36de>] blkdev_ioctl+0x22e/0x750
             [<ffffffff811a415c>] block_ioctl+0x3c/0x40
             [<ffffffff81181939>] do_vfs_ioctl+0x99/0x350
             [<ffffffff81181c91>] sys_ioctl+0xa1/0xb0
             [<ffffffff815f6902>] system_call_fastpath+0x16/0x1b
             [<ffffffffffffffff>] 0xffffffffffffffff

md (kernel thread)
86 (md) S 2 0 0 0 -1 2216722496 0 0 0 0 0 0 0 0 0 -20 1 0 301 0 0 
18446744073709551615 0 0 0 0 0 0 0 2147483647 0 18446744071579363557 0 0 
17 15 0 0 0 0 0
             [<ffffffff8107e8e5>] rescuer_thread+0x2a5/0x2d0
             [<ffffffff81084ca6>] kthread+0x96/0xa0
             [<ffffffff815f7a24>] kernel_thread_helper+0x4/0x10
             [<ffffffffffffffff>] 0xffffffffffffffff


md23_raid5 (kernel thread) (the hanged array)
2195 (md23_raid5) S 2 0 0 0 -1 2149613632 0 0 0 0 0 331114 0 0 20 0 1 0 
1637 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483391 256 
18446744071583719808 0 0 17 9 0 0 8061 0 0
             [<ffffffff814a6180>] md_thread+0xf0/0x150
             [<ffffffff81084ca6>] kthread+0x96/0xa0
             [<ffffffff815f7a24>] kernel_thread_helper+0x4/0x10
             [<ffffffffffffffff>] 0xffffffffffffffff

md22_raid5 (kerrnel thread, another array, for comparison)
2188 (md22_raid5) S 2 0 0 0 -1 2149613632 0 0 0 0 0 345593 0 0 20 0 1 0 
1635 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483391 256 
18446744071583719808 0 0 17 0 0 0 21179 0 0
             [<ffffffff814a6180>] md_thread+0xf0/0x150
             [<ffffffff81084ca6>] kthread+0x96/0xa0
             [<ffffffff815f7a24>] kernel_thread_helper+0x4/0x10
             [<ffffffffffffffff>] 0xffffffffffffffff


Even cat or less /proc/mdstat hang!

less /proc/mdstat
15647 (less) S 15201 15647 15187 34819 15647 4202496 340 1491 0 0 0 0 0 
0 20 0 1 0 85815132 11137024 228 18446744073709551615 4194304 4324420 
140735276042320 140735276041400 139882379309872 0 0 4 134742018 
18446744071583714500 0 0 17 2 0 0 0 0 0
             [<ffffffff814a4cc4>] md_seq_show+0x104/0x5b0
             [<ffffffff81191e31>] seq_read+0x291/0x420
             [<ffffffff811cdcd1>] proc_reg_read+0x81/0xc0
             [<ffffffff81170255>] vfs_read+0xc5/0x190
             [<ffffffff81170421>] sys_read+0x51/0x90
             [<ffffffff815f6902>] system_call_fastpath+0x16/0x1b
             [<ffffffffffffffff>] 0xffffffffffffffff


cat /proc/mdstat
15696 (cat) S 15678 15696 15678 34830 15696 4202496 201 0 0 0 0 0 0 0 20 
0 1 0 85818279 4415488 89 18446744073709551615 4194304 4235996 
140734384763456 140734384762776 139684953469744 0 0 0 0 
18446744071583714500 0 0 17 18 0 0 0 0 0
             [<ffffffff814a4cc4>] md_seq_show+0x104/0x5b0
             [<ffffffff81191e31>] seq_read+0x291/0x420
             [<ffffffff811cdcd1>] proc_reg_read+0x81/0xc0
             [<ffffffff81170255>] vfs_read+0xc5/0x190
             [<ffffffff81170421>] sys_read+0x51/0x90
             [<ffffffff815f6902>] system_call_fastpath+0x16/0x1b
             [<ffffffffffffffff>] 0xffffffffffffffff


cat /sys/block/md23/md/dev-sdac1/state
         cat: state: Device or resource busy
cat /sys/block/md23/md/dev-sdh1/state
         HANGS!

note: sdac1 is the drive being removed, while sdh1 is a good drive in 
the same array

Unfortunately I do not have stack traces for the last two cat processes 
above.
Other arrays except md23 respond properly when reading files from 
/sys/block/md*/md/*


After a while I could see a bunch of these in dmesg:
         [860714.133908] INFO: rcu_sched_state detected stall on CPU 3 
(t=645421 jiffies)
         [860894.252091] INFO: rcu_sched_state detected stall on CPU 3 
(t=690451 jiffies)
         [861074.370274] INFO: rcu_sched_state detected stall on CPU 3 
(t=735481 jiffies)
         [861254.488788] INFO: rcu_sched_state detected stall on CPU 3 
(t=780511 jiffies)
         ....


And as said, since most interaction with MD hanged (especially those 
involving md23, and even cat /proc/mdstat), I had to hard-reset the 
machine to restore functionality.

I hope this is enough information to track down the bug.

I am also interested in advice on how to remove drives from MD.
What I did was considered safe?
I assumed that MD does not need the drive to be removed to be present in 
the system in order to perform the removal. I.e. I assumed "mdadm -If 
<drivename>" was able to work correctly even when <drivename> was not 
available anymore.
Is this assumption wrong?


Thank you
Joystick
