From: linux@horizon.com
Subject: 2.6.22-rc4 BUG
Date: 17 Jun 2007 07:38:33 -0400
Message-ID: <20070617113833.12181.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux@horizon.com
List-Id: linux-raid.ids

(Errors start at 09:06:56)
hdk: dma_timer_expiry: dma status == 0x20
hdk: DMA timeout retry
hdk: timeout waiting for DMA
hdk: dma_timer_expiry: dma status == 0x20
hdk: DMA timeout retry
hdk: timeout waiting for DMA
hdk: task_out_intr: status=0x58 { DriveReady SeekComplete DataRequest }
ide: failed opcode was: unknown
pdc202xx_new: Secondary channel reset.
ide5: reset: success
hdk: task_out_intr: status=0x58 { DriveReady SeekComplete DataRequest }
ide: failed opcode was: unknown
pdc202xx_new: Secondary channel reset.
ide5: reset: success
hdk: task_out_intr: status=0x58 { DriveReady SeekComplete DataRequest }
ide: failed opcode was: unknown
pdc202xx_new: Secondary channel reset.
ide5: reset: success

(repeat many times)

(Time is now 10:45:44)
ide5: reset: success
hdk: task_out_intr: status=0x50 { DriveReady SeekComplete }
ide: failed opcode was: unknown
hdk: task_out_intr: status=0x50 { DriveReady SeekComplete }
ide: failed opcode was: unknown
hdk: task_out_intr: status=0x58 { DriveReady SeekComplete DataRequest }
ide: failed opcode was: unknown
pdc202xx_new: Secondary channel reset.
ide5: reset: success
hdk: task_out_intr: status=0x50 { DriveReady SeekComplete }
ide: failed opcode was: unknown
BUG: unable to handle kernel paging request at virtual address 30000000
 printing eip:
b02554b1
*pde = 00000000
Oops: 0000 [#1]
CPU:    0
EIP:    0060:[<b02554b1>]    Not tainted VLI
EFLAGS: 00010246   (2.6.22-rc4 #27)
EIP is at ide_outsl+0x5/0x9
eax: 00009400   ebx: b0457624   ecx: 00000080   edx: 00009400
esi: 30000000   edi: b0457624   ebp: 00000080   esp: efc7dda8
ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Process md7_raid10 (pid: 360, ti=efc7d000 task=eff1e500 task.ti=efc7d000)
Stack: b04576b8 b025605d 30000000 b0457624 30000000 b0457624 b04576b8 b025875c 
       00000001 b1985000 00000004 b04576b8 00000001 b0850370 b025910f b0850370 
       b04576b8 06e94ed8 b025933a 00000000 00000019 efc7de64 b03e6520 b04576b8 
Call Trace:
 [<b025605d>] ata_output_data+0x4d/0x64
 [<b025875c>] ide_pio_sector+0xea/0x121
 [<b025910f>] ide_pio_datablock+0x46/0x5c
 [<b025933a>] pre_task_out_intr+0x9a/0xa5
 [<b0254a3b>] ide_do_request+0x6e7/0x89a
 [<b01d4505>] blk_remove_plug+0x4e/0x5a
 [<b01d452e>] __generic_unplug_device+0x1d/0x1f
 [<b01d51a8>] __make_request+0x386/0x489
 [<b01d3901>] generic_make_request+0x186/0x1b3
 [<b0290f63>] md_wakeup_thread+0x25/0x27
 [<b029640c>] md_check_recovery+0x3ff/0x407
 [<b01d535c>] generic_unplug_device+0x3e/0x44
 [<b01d4505>] blk_remove_plug+0x4e/0x5a
 [<b028eab6>] raid10d+0xaa/0x8a5
 [<b010245b>] common_interrupt+0x23/0x28
 [<b033e722>] schedule_timeout+0x13/0x95
 [<b029584b>] md_thread+0xc1/0xd7
 [<b0121405>] autoremove_wake_function+0x0/0x35
 [<b029578a>] md_thread+0x0/0xd7
 [<b01212b0>] kthread+0x36/0x5a
 [<b012127a>] kthread+0x0/0x5a
 [<b01025db>] kernel_thread_helper+0x7/0x10
 =======================
Code: 89 c2 f3 66 6d 5f c3 57 89 d7 89 c2 f3 6d 5f c3 89 d0 89 ca ee c3 0f b7 c0 66 ef c3 56 89 d6 89 c2 f3 66 6f 5e c3 56 89 d6 89 c2 <f3> 6f 5e c3 c7 80 08 05 00 00 a3 64 25 b0 c7 80 0c 05 00 00 96 
EIP: [<b02554b1>] ide_outsl+0x5/0x9 SS:ESP 0068:efc7dda8
note: md7_raid10[360] exited with preempt_count 1

This is 2.6.22-rv4 + linuxpps, on a venerable and stable 32-bit system
(P3 processor, 400BX motherboard, ECC RAM).  That drive has been giving me
hassles from time to time...
