From: dean gaudet <dean@arctic.org>
Subject: soft-lockup in raid5 / 2.6.24
Date: Mon, 7 Apr 2008 08:22:59 -0700 (PDT)
Message-ID: <alpine.DEB.1.10.0804070806300.7751@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

while my system was doing its monthly check (debian) i bumped into 
soft-lockups in the raid5 code.  i must mention this is a rather mature 
system, the disks are 3.5 years old at this point... so i'm not surprised 
that the check will find some bad sectors which will take the 
device/driver a while to read/correct.

all SMART events in this log are on disks which are part of /dev/md4 which 
is a raid5.  the controller is a 3ware 7508, the disks are seagate 
ST3400832A.

apparently no errors propagated all the way up to raid5, but based on the 
SMART events i'm pretty sure several sectors took a long time to finish 
being read and were probably corrected by the drive itself.

this is debian kernel image 2.6.24-1-686 version 2.6.24-4 which contains 
upstream 2.6.24.2.

-dean

root@neemlark:~# cat /sys/block/md4/md/mismatch_cnt
0

Apr  6 05:02:35 localhost smartd[17867]: Device: /dev/twe0 [3ware_disk_03], SMART Prefailure Attribute: 1 Raw_Read_Error_Rate changed from 65 to 67 
Apr  6 05:02:35 localhost smartd[17867]: Device: /dev/twe0 [3ware_disk_03], SMART Usage Attribute: 195 Hardware_ECC_Recovered changed from 65 to 67 
Apr  6 05:02:35 localhost smartd[17867]: Device: /dev/twe0 [3ware_disk_05], SMART Prefailure Attribute: 1 Raw_Read_Error_Rate changed from 65 to 67 
Apr  6 05:02:35 localhost smartd[17867]: Device: /dev/twe0 [3ware_disk_05], SMART Usage Attribute: 195 Hardware_ECC_Recovered changed from 65 to 67 
Apr  6 05:10:18 localhost kernel: BUG: soft lockup - CPU#1 stuck for 11s! [md4_raid5:4122]
Apr  6 05:10:18 localhost kernel: 
Apr  6 05:10:18 localhost kernel: Pid: 4122, comm: md4_raid5 Not tainted (2.6.24-1-686 #1)
Apr  6 05:10:18 localhost kernel: EIP: 0060:[<c02bda19>] EFLAGS: 00000296 CPU: 1
Apr  6 05:10:18 localhost kernel: EIP is at _spin_unlock_irqrestore+0xa/0x13
Apr  6 05:10:18 localhost kernel: EAX: 00000296 EBX: df86a794 ECX: 00000296 EDX: 00000200
Apr  6 05:10:18 localhost kernel: ESI: df86a6c0 EDI: d4574868 EBP: 00000000 ESP: d759df60
Apr  6 05:10:18 localhost kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Apr  6 05:10:18 localhost kernel: CR0: 8005003b CR2: b7f98000 CR3: 11bbc000 CR4: 000006d0
Apr  6 05:10:18 localhost kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Apr  6 05:10:18 localhost kernel: DR6: ffff0ff0 DR7: 00000400
Apr  6 05:10:18 localhost kernel:  [<f8850807>] raid5d+0x395/0x39c [raid456]
Apr  6 05:10:18 localhost kernel:  [<c012c72a>] del_timer_sync+0xa/0x14
Apr  6 05:10:18 localhost kernel:  [<c02bca17>] schedule_timeout+0x79/0x8d
Apr  6 05:10:18 localhost kernel:  [<c012c3fa>] process_timeout+0x0/0x5
Apr  6 05:10:18 localhost kernel:  [<c02bca09>] schedule_timeout+0x6b/0x8d
Apr  6 05:10:18 localhost kernel:  [<f881e8ac>] md_thread+0xb9/0xcf [md_mod]
Apr  6 05:10:18 localhost kernel:  [<c0135441>] autoremove_wake_function+0x0/0x35
Apr  6 05:10:18 localhost kernel:  [<f881e7f3>] md_thread+0x0/0xcf [md_mod]
Apr  6 05:10:18 localhost kernel:  [<c013537a>] kthread+0x38/0x5e
Apr  6 05:10:18 localhost kernel:  [<c0135342>] kthread+0x0/0x5e
Apr  6 05:10:18 localhost kernel:  [<c0104b0f>] kernel_thread_helper+0x7/0x10
Apr  6 05:10:18 localhost kernel:  =======================
Apr  6 05:10:48 localhost kernel: BUG: soft lockup - CPU#0 stuck for 11s! [md4_raid5:4122]
Apr  6 05:10:48 localhost kernel: 
Apr  6 05:10:48 localhost kernel: Pid: 4122, comm: md4_raid5 Not tainted (2.6.24-1-686 #1)
Apr  6 05:10:48 localhost kernel: EIP: 0060:[<c01e1d51>] EFLAGS: 00000212 CPU: 0
Apr  6 05:10:48 localhost kernel: EIP is at memcmp+0xa/0x22
Apr  6 05:10:48 localhost kernel: EAX: 00000000 EBX: d549cfdd ECX: d549cfe1 EDX: 00000000
Apr  6 05:10:48 localhost kernel: ESI: 0000001f EDI: 00000000 EBP: 00001000 ESP: d759dd80
Apr  6 05:10:48 localhost kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Apr  6 05:10:48 localhost kernel: CR0: 8005003b CR2: bfe6a000 CR3: 11bbc000 CR4: 000006d0
Apr  6 05:10:48 localhost kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Apr  6 05:10:48 localhost kernel: DR6: ffff0ff0 DR7: 00000400
Apr  6 05:10:48 localhost kernel:  [<f881420f>] async_xor_zero_sum+0x78/0xb9 [async_xor]
Apr  6 05:10:48 localhost kernel:  [<f884da2c>] ops_run_check+0x99/0xce [raid456]
Apr  6 05:10:48 localhost kernel:  [<f884e88a>] handle_stripe5+0xe29/0x104a [raid456]
Apr  6 05:10:48 localhost kernel:  [<f8886b97>] scsi_dispatch_cmd+0x1a9/0x21a [scsi_mod]
Apr  6 05:10:48 localhost kernel:  [<c01575e3>] handle_fasteoi_irq+0x9c/0xa6
Apr  6 05:10:48 localhost kernel:  [<c011ebc6>] task_rq_lock+0x3b/0x5e
Apr  6 05:10:48 localhost kernel:  [<f885040c>] handle_stripe+0xb76/0xbdc [raid456]
Apr  6 05:10:48 localhost kernel:  [<c011d482>] __wake_up_common+0x32/0x5c
Apr  6 05:10:48 localhost kernel:  [<c011eed0>] __wake_up+0x32/0x42
Apr  6 05:10:48 localhost kernel:  [<f8817c7f>] md_wakeup_thread+0x26/0x28 [md_mod]
Apr  6 05:10:48 localhost kernel:  [<f884b952>] release_stripe+0x21/0x2e [raid456]
Apr  6 05:10:48 localhost kernel:  [<f8850800>] raid5d+0x38e/0x39c [raid456]
Apr  6 05:10:48 localhost kernel:  [<c012c72a>] del_timer_sync+0xa/0x14
Apr  6 05:10:48 localhost kernel:  [<c02bca17>] schedule_timeout+0x79/0x8d
Apr  6 05:10:48 localhost kernel:  [<c012c3fa>] process_timeout+0x0/0x5
Apr  6 05:10:48 localhost kernel:  [<c02bca09>] schedule_timeout+0x6b/0x8d
Apr  6 05:10:48 localhost kernel:  [<f881e8ac>] md_thread+0xb9/0xcf [md_mod]
Apr  6 05:10:48 localhost kernel:  [<c0135441>] autoremove_wake_function+0x0/0x35
Apr  6 05:10:48 localhost kernel:  [<f881e7f3>] md_thread+0x0/0xcf [md_mod]
Apr  6 05:10:48 localhost kernel:  [<c013537a>] kthread+0x38/0x5e
Apr  6 05:10:48 localhost kernel:  [<c0135342>] kthread+0x0/0x5e
Apr  6 05:10:48 localhost kernel:  [<c0104b0f>] kernel_thread_helper+0x7/0x10
Apr  6 05:10:48 localhost kernel:  =======================
Apr  6 05:11:29 localhost kernel: BUG: soft lockup - CPU#1 stuck for 11s! [md4_raid5:4122]
Apr  6 05:11:29 localhost kernel: 
Apr  6 05:11:29 localhost kernel: Pid: 4122, comm: md4_raid5 Not tainted (2.6.24-1-686 #1)
Apr  6 05:11:29 localhost kernel: EIP: 0060:[<f880f22f>] EFLAGS: 00000206 CPU: 1
Apr  6 05:11:29 localhost kernel: EIP is at xor_sse_5+0x22f/0x3ec [xor]
Apr  6 05:11:29 localhost kernel: EAX: 00000003 EBX: d4396d00 ECX: d437ed00 EDX: d4397d00
Apr  6 05:11:29 localhost kernel: ESI: d438cd00 EDI: d438dd00 EBP: d759dcd0 ESP: d759dcac
Apr  6 05:11:29 localhost kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Apr  6 05:11:29 localhost kernel: CR0: 80050033 CR2: b7eee0a8 CR3: 11bbc000 CR4: 000006d0
Apr  6 05:11:29 localhost kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Apr  6 05:11:29 localhost kernel: DR6: ffff0ff0 DR7: 00000400
Apr  6 05:11:29 localhost kernel:  [<f880fae7>] xor_blocks+0x7d/0x85 [xor]
Apr  6 05:11:29 localhost kernel:  [<f881410b>] async_xor+0x10b/0x197 [async_xor]
Apr  6 05:11:29 localhost kernel:  [<f88141e9>] async_xor_zero_sum+0x52/0xb9 [async_xor]
Apr  6 05:11:29 localhost kernel:  [<f884da2c>] ops_run_check+0x99/0xce [raid456]
Apr  6 05:11:29 localhost kernel:  [<f884e88a>] handle_stripe5+0xe29/0x104a [raid456]
Apr  6 05:11:29 localhost kernel:  [<f888bf3c>] scsi_request_fn+0x2fb/0x345 [scsi_mod]
Apr  6 05:11:29 localhost kernel:  [<f888aab9>] scsi_next_command+0x25/0x2f [scsi_mod]
Apr  6 05:11:29 localhost kernel:  [<f885040c>] handle_stripe+0xb76/0xbdc [raid456]
Apr  6 05:11:29 localhost kernel:  [<c011d482>] __wake_up_common+0x32/0x5c
Apr  6 05:11:29 localhost kernel:  [<c011eed0>] __wake_up+0x32/0x42
Apr  6 05:11:29 localhost kernel:  [<f8817c7f>] md_wakeup_thread+0x26/0x28 [md_mod]
Apr  6 05:11:29 localhost kernel:  [<f884b952>] release_stripe+0x21/0x2e [raid456]
Apr  6 05:11:29 localhost kernel:  [<f8850800>] raid5d+0x38e/0x39c [raid456]
Apr  6 05:11:29 localhost kernel:  [<c012c72a>] del_timer_sync+0xa/0x14
Apr  6 05:11:29 localhost kernel:  [<c02bca17>] schedule_timeout+0x79/0x8d
Apr  6 05:11:29 localhost kernel:  [<c012c3fa>] process_timeout+0x0/0x5
Apr  6 05:11:29 localhost kernel:  [<c02bca09>] schedule_timeout+0x6b/0x8d
Apr  6 05:11:29 localhost kernel:  [<f881e8ac>] md_thread+0xb9/0xcf [md_mod]
Apr  6 05:11:29 localhost kernel:  [<c0135441>] autoremove_wake_function+0x0/0x35
Apr  6 05:11:29 localhost kernel:  [<f881e7f3>] md_thread+0x0/0xcf [md_mod]
Apr  6 05:11:29 localhost kernel:  [<c013537a>] kthread+0x38/0x5e
Apr  6 05:11:29 localhost kernel:  [<c0135342>] kthread+0x0/0x5e
Apr  6 05:11:29 localhost kernel:  [<c0104b0f>] kernel_thread_helper+0x7/0x10
Apr  6 05:11:29 localhost kernel:  =======================
Apr  6 05:17:12 localhost kernel: BUG: soft lockup - CPU#0 stuck for 11s! [md4_raid5:4122]
Apr  6 05:17:12 localhost kernel: 
Apr  6 05:17:12 localhost kernel: Pid: 4122, comm: md4_raid5 Not tainted (2.6.24-1-686 #1)
Apr  6 05:17:12 localhost kernel: EIP: 0060:[<c02bda19>] EFLAGS: 00000286 CPU: 0
Apr  6 05:17:12 localhost kernel: EIP is at _spin_unlock_irqrestore+0xa/0x13
Apr  6 05:17:12 localhost kernel: EAX: 00000286 EBX: e9880cec ECX: 00000286 EDX: 00000200
Apr  6 05:17:12 localhost kernel: ESI: c7116ea0 EDI: f7d608a8 EBP: 00000001 ESP: d759dbc4
Apr  6 05:17:12 localhost kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Apr  6 05:17:12 localhost kernel: CR0: 80050033 CR2: b7e70430 CR3: 1f9d3000 CR4: 000006d0
Apr  6 05:17:12 localhost kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Apr  6 05:17:12 localhost kernel: DR6: ffff0ff0 DR7: 00000400
Apr  6 05:17:12 localhost kernel:  [<f888abe7>] scsi_end_request+0x9a/0xab [scsi_mod]
Apr  6 05:17:12 localhost kernel:  [<f888b765>] scsi_io_completion+0x156/0x308 [scsi_mod]
Apr  6 05:17:12 localhost kernel:  [<c01d77ae>] blk_done_softirq+0x56/0x61
Apr  6 05:17:12 localhost kernel:  [<c0128f7b>] __do_softirq+0x66/0xd3
Apr  6 05:17:12 localhost kernel:  [<c012902d>] do_softirq+0x45/0x53
Apr  6 05:17:12 localhost kernel:  [<c0129291>] irq_exit+0x38/0x6b
Apr  6 05:17:12 localhost kernel:  [<c01066f2>] do_IRQ+0x5a/0x70
Apr  6 05:17:12 localhost kernel:  [<c01d5175>] __end_that_request_first+0x192/0x340
Apr  6 05:17:12 localhost kernel:  [<c01048c3>] common_interrupt+0x23/0x28
Apr  6 05:17:12 localhost kernel:  [<f880f22f>] xor_sse_5+0x22f/0x3ec [xor]
Apr  6 05:17:12 localhost kernel:  [<f880fae7>] xor_blocks+0x7d/0x85 [xor]
Apr  6 05:17:12 localhost kernel:  [<f881410b>] async_xor+0x10b/0x197 [async_xor]
Apr  6 05:17:12 localhost kernel:  [<f88141e9>] async_xor_zero_sum+0x52/0xb9 [async_xor]
Apr  6 05:17:12 localhost kernel:  [<f884da2c>] ops_run_check+0x99/0xce [raid456]
Apr  6 05:17:12 localhost kernel:  [<f884e88a>] handle_stripe5+0xe29/0x104a [raid456]
Apr  6 05:17:12 localhost kernel:  [<c012c904>] mod_timer+0x19/0x36
Apr  6 05:17:12 localhost kernel:  [<c01ddaa7>] cfq_completed_request+0x243/0x273
Apr  6 05:17:12 localhost kernel:  [<c01d5175>] __end_that_request_first+0x192/0x340
Apr  6 05:17:12 localhost kernel:  [<f888a512>] scsi_run_queue+0x17a/0x189 [scsi_mod]
Apr  6 05:17:12 localhost kernel:  [<f888677c>] __scsi_put_command+0x48/0x53 [scsi_mod]
Apr  6 05:17:12 localhost kernel:  [<c01d3369>] elv_queue_empty+0x1d/0x1e
Apr  6 05:17:12 localhost kernel:  [<c01d755b>] blk_run_queue+0x1f/0x63
Apr  6 05:17:12 localhost kernel:  [<c011ebc6>] task_rq_lock+0x3b/0x5e
Apr  6 05:17:12 localhost kernel:  [<f885040c>] handle_stripe+0xb76/0xbdc [raid456]
Apr  6 05:17:12 localhost kernel:  [<c011d482>] __wake_up_common+0x32/0x5c
Apr  6 05:17:12 localhost kernel:  [<c011eed0>] __wake_up+0x32/0x42
Apr  6 05:17:12 localhost kernel:  [<f8817c7f>] md_wakeup_thread+0x26/0x28 [md_mod]
Apr  6 05:17:12 localhost kernel:  [<f884b952>] release_stripe+0x21/0x2e [raid456]
Apr  6 05:17:12 localhost kernel:  [<f8850800>] raid5d+0x38e/0x39c [raid456]
Apr  6 05:17:12 localhost kernel:  [<c012c72a>] del_timer_sync+0xa/0x14
Apr  6 05:17:12 localhost kernel:  [<c02bca17>] schedule_timeout+0x79/0x8d
Apr  6 05:17:12 localhost kernel:  [<c012c3fa>] process_timeout+0x0/0x5
Apr  6 05:17:12 localhost kernel:  [<c02bca09>] schedule_timeout+0x6b/0x8d
Apr  6 05:17:12 localhost kernel:  [<f881e8ac>] md_thread+0xb9/0xcf [md_mod]
Apr  6 05:17:12 localhost kernel:  [<c0135441>] autoremove_wake_function+0x0/0x35
Apr  6 05:17:12 localhost kernel:  [<f881e7f3>] md_thread+0x0/0xcf [md_mod]
Apr  6 05:17:12 localhost kernel:  [<c013537a>] kthread+0x38/0x5e
Apr  6 05:17:12 localhost kernel:  [<c0135342>] kthread+0x0/0x5e
Apr  6 05:17:12 localhost kernel:  [<c0104b0f>] kernel_thread_helper+0x7/0x10
Apr  6 05:17:12 localhost kernel:  =======================
Apr  6 05:32:33 localhost smartd[17867]: Device: /dev/twe0 [3ware_disk_02], SMART Prefailure Attribute: 1 Raw_Read_Error_Rate changed from 66 to 68 
Apr  6 05:32:34 localhost smartd[17867]: Device: /dev/twe0 [3ware_disk_02], SMART Usage Attribute: 195 Hardware_ECC_Recovered changed from 66 to 68 
Apr  6 05:32:34 localhost smartd[17867]: Device: /dev/twe0 [3ware_disk_04], SMART Prefailure Attribute: 1 Raw_Read_Error_Rate changed from 65 to 68 
Apr  6 05:32:35 localhost smartd[17867]: Device: /dev/twe0 [3ware_disk_04], SMART Usage Attribute: 195 Hardware_ECC_Recovered changed from 65 to 68 
Apr  6 06:02:36 localhost smartd[17867]: Device: /dev/twe0 [3ware_disk_06], SMART Prefailure Attribute: 1 Raw_Read_Error_Rate changed from 47 to 48 
Apr  6 06:02:37 localhost smartd[17867]: Device: /dev/twe0 [3ware_disk_06], SMART Usage Attribute: 195 Hardware_ECC_Recovered changed from 47 to 48 
Apr  6 06:02:37 localhost smartd[17867]: Device: /dev/twe0 [3ware_disk_07], SMART Prefailure Attribute: 1 Raw_Read_Error_Rate changed from 66 to 68 
Apr  6 06:02:37 localhost smartd[17867]: Device: /dev/twe0 [3ware_disk_07], SMART Usage Attribute: 195 Hardware_ECC_Recovered changed from 66 to 68 
Apr  6 06:04:09 localhost kernel: BUG: soft lockup - CPU#1 stuck for 11s! [md4_raid5:4122]
Apr  6 06:04:09 localhost kernel: 
Apr  6 06:04:09 localhost kernel: Pid: 4122, comm: md4_raid5 Not tainted (2.6.24-1-686 #1)
Apr  6 06:04:09 localhost kernel: EIP: 0060:[<f880f16e>] EFLAGS: 00000206 CPU: 1
Apr  6 06:04:09 localhost kernel: EIP is at xor_sse_5+0x16e/0x3ec [xor]
Apr  6 06:04:09 localhost kernel: EAX: 00000009 EBX: d42f7700 ECX: d3ce3700 EDX: d3ce2700
Apr  6 06:04:09 localhost kernel: ESI: d3ce0700 EDI: d3ce1700 EBP: d759dcd0 ESP: d759dcac
Apr  6 06:04:09 localhost kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Apr  6 06:04:09 localhost kernel: CR0: 80050033 CR2: bfe6a000 CR3: 37fd7000 CR4: 000006d0
Apr  6 06:04:09 localhost kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Apr  6 06:04:09 localhost kernel: DR6: ffff0ff0 DR7: 00000400
Apr  6 06:04:09 localhost kernel:  [<f880fae7>] xor_blocks+0x7d/0x85 [xor]
Apr  6 06:04:10 localhost kernel:  [<f881410b>] async_xor+0x10b/0x197 [async_xor]
Apr  6 06:04:10 localhost kernel:  [<f88141e9>] async_xor_zero_sum+0x52/0xb9 [async_xor]
Apr  6 06:04:10 localhost kernel:  [<f884da2c>] ops_run_check+0x99/0xce [raid456]
Apr  6 06:04:10 localhost kernel:  [<f884e88a>] handle_stripe5+0xe29/0x104a [raid456]
Apr  6 06:04:10 localhost kernel:  [<c012c904>] mod_timer+0x19/0x36
Apr  6 06:04:10 localhost kernel:  [<c01ddaa7>] cfq_completed_request+0x243/0x273
Apr  6 06:04:10 localhost kernel:  [<c01968f1>] bio_endio+0x27/0x29
Apr  6 06:04:10 localhost kernel:  [<f888677c>] __scsi_put_command+0x48/0x53 [scsi_mod]
Apr  6 06:04:10 localhost kernel:  [<c01d3369>] elv_queue_empty+0x1d/0x1e
Apr  6 06:04:10 localhost kernel:  [<c01d755b>] blk_run_queue+0x1f/0x63
Apr  6 06:04:10 localhost kernel:  [<f888aab9>] scsi_next_command+0x25/0x2f [scsi_mod]
Apr  6 06:04:10 localhost kernel:  [<f885040c>] handle_stripe+0xb76/0xbdc [raid456]
Apr  6 06:04:10 localhost kernel:  [<c01292ac>] irq_exit+0x53/0x6b
Apr  6 06:04:10 localhost kernel:  [<c011eed0>] __wake_up+0x32/0x42
Apr  6 06:04:10 localhost kernel:  [<f8817c7f>] md_wakeup_thread+0x26/0x28 [md_mod]
Apr  6 06:04:10 localhost kernel:  [<f884b952>] release_stripe+0x21/0x2e [raid456]
Apr  6 06:04:10 localhost kernel:  [<f8850800>] raid5d+0x38e/0x39c [raid456]
Apr  6 06:04:10 localhost kernel:  [<c012c72a>] del_timer_sync+0xa/0x14
Apr  6 06:04:10 localhost kernel:  [<c02bca17>] schedule_timeout+0x79/0x8d
Apr  6 06:04:10 localhost kernel:  [<c012c3fa>] process_timeout+0x0/0x5
Apr  6 06:04:10 localhost kernel:  [<c02bca09>] schedule_timeout+0x6b/0x8d
Apr  6 06:04:10 localhost kernel:  [<f881e8ac>] md_thread+0xb9/0xcf [md_mod]
Apr  6 06:04:10 localhost kernel:  [<c0135441>] autoremove_wake_function+0x0/0x35
Apr  6 06:04:10 localhost kernel:  [<f881e7f3>] md_thread+0x0/0xcf [md_mod]
Apr  6 06:04:10 localhost kernel:  [<c013537a>] kthread+0x38/0x5e
Apr  6 06:04:10 localhost kernel:  [<c0135342>] kthread+0x0/0x5e
Apr  6 06:04:10 localhost kernel:  [<c0104b0f>] kernel_thread_helper+0x7/0x10
Apr  6 06:04:10 localhost kernel:  =======================
Apr  6 06:04:37 localhost kernel: BUG: soft lockup - CPU#0 stuck for 11s! [md4_raid5:4122]
Apr  6 06:04:37 localhost kernel: 
Apr  6 06:04:37 localhost kernel: Pid: 4122, comm: md4_raid5 Not tainted (2.6.24-1-686 #1)
Apr  6 06:04:37 localhost kernel: EIP: 0060:[<f880f105>] EFLAGS: 00000202 CPU: 0
Apr  6 06:04:37 localhost kernel: EIP is at xor_sse_5+0x105/0x3ec [xor]
Apr  6 06:04:37 localhost kernel: EAX: 0000000b EBX: d4317500 ECX: d42c7500 EDX: d42c6500
Apr  6 06:04:37 localhost kernel: ESI: d42c4500 EDI: d42c5500 EBP: d759dcd0 ESP: d759dcac
Apr  6 06:04:37 localhost kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Apr  6 06:04:37 localhost kernel: CR0: 80050033 CR2: bfe6a000 CR3: 2eaf0000 CR4: 000006d0
Apr  6 06:04:37 localhost kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Apr  6 06:04:37 localhost kernel: DR6: ffff0ff0 DR7: 00000400
Apr  6 06:04:37 localhost kernel:  [<f88f89d0>] ohci_irq+0x214/0x289 [ohci_hcd]
Apr  6 06:04:37 localhost kernel:  [<f880fae7>] xor_blocks+0x7d/0x85 [xor]
Apr  6 06:04:37 localhost kernel:  [<f881410b>] async_xor+0x10b/0x197 [async_xor]
Apr  6 06:04:37 localhost kernel:  [<f88141e9>] async_xor_zero_sum+0x52/0xb9 [async_xor]
Apr  6 06:04:37 localhost kernel:  [<f884da2c>] ops_run_check+0x99/0xce [raid456]
Apr  6 06:04:37 localhost kernel:  [<f884e88a>] handle_stripe5+0xe29/0x104a [raid456]
Apr  6 06:04:37 localhost kernel:  [<f8a9aeae>] snd_complete_urb+0x4b/0x76 [snd_usb_audio]
Apr  6 06:04:37 localhost kernel:  [<f88b2c95>] usb_hcd_giveback_urb+0x67/0x97 [usbcore]
Apr  6 06:04:37 localhost kernel:  [<c011ebc6>] task_rq_lock+0x3b/0x5e
Apr  6 06:04:37 localhost kernel:  [<c011ebc6>] task_rq_lock+0x3b/0x5e
Apr  6 06:04:37 localhost kernel:  [<f885040c>] handle_stripe+0xb76/0xbdc [raid456]
Apr  6 06:04:37 localhost kernel:  [<c01293e3>] tasklet_action+0x58/0xb8
Apr  6 06:04:37 localhost kernel:  [<c011d482>] __wake_up_common+0x32/0x5c
Apr  6 06:04:37 localhost kernel:  [<c011eed0>] __wake_up+0x32/0x42
Apr  6 06:04:37 localhost kernel:  [<f8817c7f>] md_wakeup_thread+0x26/0x28 [md_mod]
Apr  6 06:04:37 localhost kernel:  [<f884b952>] release_stripe+0x21/0x2e [raid456]
Apr  6 06:04:37 localhost kernel:  [<f8850800>] raid5d+0x38e/0x39c [raid456]
Apr  6 06:04:37 localhost kernel:  [<c012c72a>] del_timer_sync+0xa/0x14
Apr  6 06:04:37 localhost kernel:  [<c02bca17>] schedule_timeout+0x79/0x8d
Apr  6 06:04:37 localhost kernel:  [<c012c3fa>] process_timeout+0x0/0x5
Apr  6 06:04:37 localhost kernel:  [<c02bca09>] schedule_timeout+0x6b/0x8d
Apr  6 06:04:37 localhost kernel:  [<f881e8ac>] md_thread+0xb9/0xcf [md_mod]
Apr  6 06:04:37 localhost kernel:  [<c0135441>] autoremove_wake_function+0x0/0x35
Apr  6 06:04:37 localhost kernel:  [<f881e7f3>] md_thread+0x0/0xcf [md_mod]
Apr  6 06:04:37 localhost kernel:  [<c013537a>] kthread+0x38/0x5e
Apr  6 06:04:37 localhost kernel:  [<c0135342>] kthread+0x0/0x5e
Apr  6 06:04:37 localhost kernel:  [<c0104b0f>] kernel_thread_helper+0x7/0x10
Apr  6 06:04:37 localhost kernel:  =======================
Apr  6 06:05:22 localhost kernel: BUG: soft lockup - CPU#1 stuck for 11s! [md4_raid5:4122]
Apr  6 06:05:22 localhost kernel: 
Apr  6 06:05:23 localhost kernel: Pid: 4122, comm: md4_raid5 Not tainted (2.6.24-1-686 #1)
Apr  6 06:05:23 localhost kernel: EIP: 0060:[<c01e1d62>] EFLAGS: 00000202 CPU: 1
Apr  6 06:05:23 localhost kernel: EIP is at memcmp+0x1b/0x22
Apr  6 06:05:23 localhost kernel: EAX: 00000000 EBX: d518c617 ECX: d518c61b EDX: 00000000
Apr  6 06:05:23 localhost kernel: ESI: 000009e5 EDI: 00000000 EBP: 00001000 ESP: d759dd80
Apr  6 06:05:23 localhost kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Apr  6 06:05:23 localhost kernel: CR0: 8005003b CR2: bfe6a000 CR3: 003b5000 CR4: 000006d0
Apr  6 06:05:23 localhost kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Apr  6 06:05:23 localhost kernel: DR6: ffff0ff0 DR7: 00000400
Apr  6 06:05:23 localhost kernel:  [<f881420f>] async_xor_zero_sum+0x78/0xb9 [async_xor]
Apr  6 06:05:23 localhost kernel:  [<f884da2c>] ops_run_check+0x99/0xce [raid456]
Apr  6 06:05:23 localhost kernel:  [<f884e88a>] handle_stripe5+0xe29/0x104a [raid456]
Apr  6 06:05:23 localhost kernel:  [<f8a9aeae>] snd_complete_urb+0x4b/0x76 [snd_usb_audio]
Apr  6 06:05:23 localhost kernel:  [<f88b2c95>] usb_hcd_giveback_urb+0x67/0x97 [usbcore]
Apr  6 06:05:23 localhost kernel:  [<f88f64c4>] finish_urb+0x5d/0x83 [ohci_hcd]
Apr  6 06:05:23 localhost kernel:  [<c011ebc6>] task_rq_lock+0x3b/0x5e
Apr  6 06:05:23 localhost kernel:  [<c011ebc6>] task_rq_lock+0x3b/0x5e
Apr  6 06:05:23 localhost kernel:  [<f885040c>] handle_stripe+0xb76/0xbdc [raid456]
Apr  6 06:05:23 localhost kernel:  [<c011d482>] __wake_up_common+0x32/0x5c
Apr  6 06:05:23 localhost kernel:  [<c011eed0>] __wake_up+0x32/0x42
Apr  6 06:05:23 localhost kernel:  [<f8817c7f>] md_wakeup_thread+0x26/0x28 [md_mod]
Apr  6 06:05:23 localhost kernel:  [<f884b952>] release_stripe+0x21/0x2e [raid456]
Apr  6 06:05:23 localhost kernel:  [<f8850800>] raid5d+0x38e/0x39c [raid456]
Apr  6 06:05:23 localhost kernel:  [<c012c72a>] del_timer_sync+0xa/0x14
Apr  6 06:05:23 localhost kernel:  [<c02bca17>] schedule_timeout+0x79/0x8d
Apr  6 06:05:23 localhost kernel:  [<c012c3fa>] process_timeout+0x0/0x5
Apr  6 06:05:23 localhost kernel:  [<c02bca09>] schedule_timeout+0x6b/0x8d
Apr  6 06:05:23 localhost kernel:  [<f881e8ac>] md_thread+0xb9/0xcf [md_mod]
Apr  6 06:05:23 localhost kernel:  [<c0135441>] autoremove_wake_function+0x0/0x35
Apr  6 06:05:23 localhost kernel:  [<f881e7f3>] md_thread+0x0/0xcf [md_mod]
Apr  6 06:05:23 localhost kernel:  [<c013537a>] kthread+0x38/0x5e
Apr  6 06:05:23 localhost kernel:  [<c0135342>] kthread+0x0/0x5e
Apr  6 06:05:23 localhost kernel:  [<c0104b0f>] kernel_thread_helper+0x7/0x10
Apr  6 06:05:23 localhost kernel:  =======================
Apr  6 06:32:36 localhost smartd[17867]: Device: /dev/twe0 [3ware_disk_06], SMART Prefailure Attribute: 1 Raw_Read_Error_Rate changed from 48 to 47 
Apr  6 06:32:36 localhost smartd[17867]: Device: /dev/twe0 [3ware_disk_06], SMART Usage Attribute: 195 Hardware_ECC_Recovered changed from 48 to 47 
Apr  6 07:02:35 localhost smartd[17867]: Device: /dev/twe0 [3ware_disk_02], SMART Prefailure Attribute: 1 Raw_Read_Error_Rate changed from 68 to 67 
Apr  6 07:02:36 localhost smartd[17867]: Device: /dev/twe0 [3ware_disk_02], SMART Usage Attribute: 195 Hardware_ECC_Recovered changed from 68 to 67 
Apr  6 07:02:37 localhost smartd[17867]: Device: /dev/twe0 [3ware_disk_03], SMART Prefailure Attribute: 7 Seek_Error_Rate changed from 63 to 64 
Apr  6 07:02:37 localhost smartd[17867]: Device: /dev/twe0 [3ware_disk_04], SMART Prefailure Attribute: 1 Raw_Read_Error_Rate changed from 68 to 67 
Apr  6 07:02:37 localhost smartd[17867]: Device: /dev/twe0 [3ware_disk_04], SMART Usage Attribute: 195 Hardware_ECC_Recovered changed from 68 to 67 
