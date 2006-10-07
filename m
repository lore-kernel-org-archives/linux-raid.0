From: linux@horizon.com
Subject: Re: IDE panic, 2.6.18
Date: 7 Oct 2006 16:32:22 -0400
Message-ID: <20061007203222.24846.qmail@science.horizon.com>
References: <20061005211112.1800.qmail@science.horizon.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20061005211112.1800.qmail@science.horizon.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org
Cc: linux-raid@vger.kernel.org, linux@horizon.com
List-Id: linux-raid.ids

I got two more kernel panics while playing with drives.  (To be precise,
I was taking them off-line one at a time to use DOS-based vendor
diagnostics on them.)  I was cold-swapping them at the time (mdadm
/dev/mdX -f /dev/hdeY; hdparm -Y /dev/hde; unplug), which wasn't the
safest thing in the world, but I still don't expect kernel panics.

The first one is a copy of what I saw the other day.  For the second
one I forgot to disable hddtemp and smartd, which I thought might have
triggered the problem.  For the third, I was quite sure that nothing
was accessing the drive.

All are hand-typed from photographs of the console after panic.

I think it's an IDE problem more than a RAID problem, but I've Cc:ed
the linux-raid list just in case someone there has any ideas.

i686 processor, 440BX motherboard, 1 GB ECC memory (you can see
from the kernel addresses that I'm using a 2.75/1.25 G memory split),
has been in production with excellent stability for a long time.
non-modular 2.6.18 + linuxpps patches.


=== Panic # 1 ===
Call Trace:
 [<b0248228>] ata_output_data+0x4d/0x64
 [<b024a60f>] ide_pio_sector+0xcd/0x102
 [<b024af35>] ide_pio_datablock+0x46/0x5c
 [<b024b160>] pre_task_out_intr+0x9a/0xa5
 [<b0246812>] ide_do_request+0x52b/0x6e0
 [<b01cb5c3>] __generic_unplug_device+0x1d/0x1f
 [<b01cbe7b>] generic_unplug_device+0x6/0x8
 [<b0263252>] unplug_slaves+0x4b/0x7a
 [<b02650c8>] raid1d+0xa51/0xac0
 [<b026f123>] md_thread+0xd6/0xef
 [<b0120db7>] kthread+0x1d/0xda
 [<b0100b3d>] kernel_thread_helper+0x5/0xb
DWARF2 unwinder stuck at kernel_thread_helper+0x5/0xb
Leftover inexact backtrace:
Code: c3 89 c2 ed c3 57 89 d7 89 c2 f3 6d 5f c3 89 d0 89 ca ee c3 0f b7 c0 66 ef c3 56 89 d6 89 c2 f3 66 6f 5e c3 ef c3 56 89 d6 89 c2 <f3> 6f 5e c3 c7 80 00 05 00 00 45 82 24 b0 c7 80 04 05 00 00 52
EIP: [<b024726f>] ide_outsl+0x5/0x9 SS:ESP 0068:eff4ddf0
 <1>BUG: unable to handle kernel paging request at virtual address 30000200
 printing eip:
b024726f
*pde = 00000000
Oops: 0000 [#2]
CPU:    0
EIP:    0060:[<b024726f>]    Not tainted VLI
EFLAGS: 00010246   (2.6.18 #4)
EIP is at ide_outsl+0x5/0x9
eax: 0000b000   ebx: b0444d18   ecx: 00000080   edx: 0000b000
esi: 30000200   edi: b0444d18   ebp: 00000080   esp: b0421f3c
ds: 007b   es: 007b   ss: 0068
Process klogd (pid: 1146, ti=b0421000 task=eff08ad0 task.ti=b1a2b000)
Stack: b0444dac b0248228 30000200 b0444d18 30000200 b0444dac b0444d18 b024a60f
       00000020 00000200 00000001 0000000f b0444dac 00000001 b0444d18 b024af35
       ffffffff b0444dac c2baef38 b024afc5 b190ef04 b0444dac 00000286 b190eee0
Call Trace:
 [<b0248228>] ata_output_data+0x4d/0x64
 [<b024a60f>] ide_pio_sector+0xcd/0x102
 [<b024af35>] ide_pio_datablock+0x46/0x5c
 [<b024afc5>] task_out_intr+0x7a/0x9c
 [<b02471e1>] ide_intr+0x13d/0x188
 [<b012795e>] handle_IRQ_event+0x23/0x49
 [<b01279e2>] __do_IRQ+0x5e/0xa4
 [<b0142ca2>] do_IRQ+0x91/0xaf
Code: c3 89 c2 ed c3 57 89 d7 89 c2 f3 6d 5f c3 89 d0 89 ca ee c3 0f b7 c0 66 ef c3 56 89 d6 89 c2 f3 66 6f 5e c3 ef c3 56 89 d6 89 c2 <f3> 6f 5e c3 c7 80 00 05 00 00 45 82 24 b0 c7 80 04 05 00 00 52
EIP: [<b024726f>] ide_outsl+0x5/0x9 SS:ESP 0068:b0421f3c
 <0>Kernel panic - not syncing: Fatal exception in interrupt


=== Panic # 2 ===
Call Trace:
 [<b0248228>] ata_output_data+0x4d/0x64
 [<b024a60f>] ide_pio_sector+0xcd/0x102
 [<b024af35>] ide_pio_datablock+0x46/0x5c
 [<b024b160>] pre_task_out_intr+0x9a/0xa5
 [<b0246812>] ide_do_request+0x52b/0x6e0
 [<b01cb5c3>] __generic_unplug_device+0x1d/0x1f
 [<b01cbe7b>] generic_unplug_device+0x6/0x8
 [<b0263252>] unplug_slaves+0x4b/0x7a
 [<b02650c8>] raid1d+0xa51/0xac0
 [<b026f123>] md_thread+0xd6/0xef
 [<b0120db7>] kthread+0x1d/0xda
 [<b0100b3d>] kernel_thread_helper+0x5/0xb
DWARF2 unwinder stuck at kernel_thread_helper+0x5/0xb
Leftover inexact backtrace:
Code: c3 89 c2 ed c3 57 89 d7 89 c2 f3 6d 5f c3 89 d0 89 ca ee c3 0f b7 c0 66 ef c3 56 89 d6 89 c2 f3 66 6f 5e c3 ef c3 56 89 d6 89 c2 <f3> 6f 5e c3 c7 80 00 05 00 00 45 82 24 b0 c7 80 04 05 00 00 52
EIP: [<b024726f>] ide_outsl+0x5/0x9 SS:ESP 0068:efcd7df0
 <1>BUG: unable to handle kernel paging request at virtual address 30000200
 printing eip:
b024726f
*pde = 00000000
Oops: 0000 [#2]
CPU:    0
EIP:    0060:[<b024726f>]    Not tainted VLI
EFLAGS: 00010246   (2.6.18 #4)
EIP is at ide_outsl+0x5/0x9
eax: 0000a000   ebx: b0445400   ecx: 00000080   edx: 0000a000
esi: 30000200   edi: b0445400   ebp: 00000080   esp: b0421f3c
ds: 007b   es: 007b   ss: 0068
Process swapper (pid: 0, ti=b0421000 task=b0349b40 task.ti=b03f4000)
Stack: b0445494 b0248228 30000200 b0445400 30000200 b0445494 b0445400 b024a60f
       00000020 00000200 00000001 0000000f b0445494 00000001 b0445400 b024af35
       ffffffff b0445494 ebff2e94 b024afc5 efeffe04 b0445494 00000286 efeffde0
Call Trace:
 [<b0248228>] ata_output_data+0x4d/0x64
 [<b024a60f>] ide_pio_sector+0xcd/0x102
 [<b024af35>] ide_pio_datablock+0x46/0x5c
 [<b024afc5>] task_out_intr+0x7a/0x9c
 [<b02471e1>] ide_intr+0x13d/0x188
 [<b012795e>] handle_IRQ_event+0x23/0x49
 [<b01279e2>] __do_IRQ+0x5e/0xa4
 [<b0142ca2>] do_IRQ+0x91/0xaf
Code: c3 89 c2 ed c3 57 89 d7 89 c2 f3 6d 5f c3 89 d0 89 ca ee c3 0f b7 c0 66 ef c3 56 89 d6 89 c2 f3 66 6f 5e c3 ef c3 56 89 d6 89 c2 <f3> 6f 5e c3 c7 80 00 05 00 00 45 82 24 b0 c7 80 04 05 00 00 52
EIP: [<b024726f>] ide_outsl+0x5/0x9 SS:ESP 0068:b0421f3c
 <0>Kernel panic - not syncing: Fatal exception in interrupt


=== Panic # 3 ===
 [<b0142ca2>] do_IRQ+0x91/0xaf
 [<b01027aa>] common_interrupt+0x1a/0x20
DWARF2 unwinder stuck at common_interrupt+0x1a/0x20
Leftover inexact backtrace:
 [<b0127952>] handle_IRQ_event+0x17/0x49
 [<b01279e2>] __do_IRQ+0x5e/0xa4
 [<b01042ca>] do_IRQ+0x91/0xaf
 =======================
 [<b01027aa>] common_interrupt+0x1a/0x20
 [<b027007b>] bitmap_startwrite+0xa4/0x121
 [<b0116db6>] __do_softirq+0x2c/0x75
 [<b0104326>] do_softirq+0x32/0x90
 =======================
 [<b0102e94>] show_stack_log_lvl+0x9d/9xa5
 [<b01042dc>] do_IRQ+0xa3/0xaf
 [<b01027aa>] common_interrupt+0x1a/0x20
 [<b0103218>] die+0x182/0x1cb
 [<b010ca37>] do_page_fault+0x3c8/0x49d
 [<b010c66f>] do_page_fault+0x0/0x49d
 [<b010285d>] error_code+0x39/0x40
 [<b024726f>] ide+outsl+0x5/0x9
 [<b0248228>] ata_output_data+0x4d/0x64
 [<b024a60f>] ide_pio_sector+0xcd/0x102
 [<b024af35>] ide_pio_datablock+0x46/0x5c
 [<b024b160>] pre_task_out_intr+0x9a/0xa5
 [<b0246812>] ide_do_request+0x52b/0x6e0
 [<b01cabb3>] generic_make_request+0x159/0x169
 [<b0110bf8>] __wake_up+0x11/0x1a
 [<b01cb59a>] blk_remove_plug+0x4e/0x5a
 [<b026ef2e>] md_check_recovery+0x3ad/0x3b5
 [<b01cb5c3>] __generic_unplug_device+0x1d/0x1f
 [<b01cbe7b>] generic_unplug_device+0x6/0x8
 [<b0263252>] unplug_slaves+0x4b/0x7a
 [<b02650c8>] raid1d+0xa51/0xac0
 [<b01042dc>] do_IRQ+0xa3/0xaf
 [<b02fc360>] schedule+0x46a/0x4ce
 [<b02fc8f9>] schedule_timeout+0x13/0xa0
 [<b0265132>] raid1d+0xabb/0xac0
 [<b026f123>] md_thread+0xd6/0xef
 [<b0120f1c>] autoremove_wake_function+0x0/0x35
 [<b026f04d>] md_thread+0x0/0xef
 [<b0120db7>] kthread+0xad/0xda
 [<b0120d0a>] kthread+0x0/0xda
 [<b0100b3d>] kernel_thread_helper+0x5/0xb
Code: c3 89 c2 ed c3 57 89 d7 89 c2 f3 6d 5f c3 89 d0 89 ca ee c3 0f b7 c0 66 ef c3 56 89 d6 89 c2 f3 66 6f 5e c3 ef c3 56 89 d6 89 c2 <f3> 6f 5e c3 c7 80 00 05 00 00 45 82 24 b0 c7 80 04 05 00 00 52
EIP: [<b024726f>] ide_outsl+0x5/0x9 SS:ESP 0068:b0421ebc
 <0>Kernel panic - not syncing: Fatal exception in interrupt
