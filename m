From: "Michael Gilroy" <mgilroy@a2etech.com>
Subject: hardware raid 6
Date: Thu, 2 Feb 2006 15:20:30 -0000
Message-ID: <007301c6280c$3457dd90$0a00a8c0@emachine>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm trying to adapet the software RAID 6 driver to support some hardware
I've been developing. The hardware works and is reliable. However,  I can
not get the hardware to work properly with the software driver due to the
locking mechanisms used. I've made 4 changes to the operation of the driver.

1. If the hardware is detected, use it for RAID 6 calculations

2. Added functions to setup and use hardware to perform RAID calculations

3. Replaced spin_lock(&sh->lock) in raid6main.c with a mutex (to allow
software to await hardware interrupt)

4. The hardware can calculate both missing disks at once so I pass it the
memory location for the known data and it calcualtes the missing data.

 This appeared to work OK at first, however as I increased the array size I
found that I sometimes get an oops due to the
spin_lock_irq(&conf->device_lock) already being set. The locking tends to
occur in the get_active_strip() and raid6d() functions. Does anyone have any
idea if I should be replacing the spin_lock_irq or do I need to write a
completely new driver?

thanks,

mike

Unable to handle kernel paging request at virtual address 34343438
printing eip:

f8b1929d

*pde = 00000000

Oops: 0002 [#1]

Modules linked in: raid6 xor radeon drm parport_pc lp parport autofs4
i2c_dev i2c_core sunrpc ipt_REJECT ipt_state ip_conntrack iptable_filter
ip_tables dm_mod video button battery ac ipv6 ohci_hcd hw_random sata_sil24
tg3 floppy ext3 jbd sata_sil libata sd_mod scsi_mod

CPU: 0

EIP: 0060:[<f8b1929d>] Tainted: GF VLI

EFLAGS: 00010002 (2.6.13-rc7)

EIP is at remove_hash+0xd/0x20 [raid6]

eax: eb81b000 ebx: f6362180 ecx: 34343434 edx: 34343434

esi: eb81b000 edi: 00000000 ebp: f6362180 esp: f1156d7c

ds: 007b es: 007b ss: 0068

Process md0_resync (pid: 4718, threadinfo=f1156000 task=eea71550)

Stack: f8b192e1 00000000 00000000 f8b19648 f884d140 f6362224 00000287
00000001

00000003 00000002 eb81b240 f6362224 f63621e0 f63621d8 00000000 f1156000

001d9878 00000000 00000292 ffffffff 00000000 00000004 f6362180 eb81b200

Call Trace:

[<f8b192e1>] get_free_stripe+0x31/0x50 [raid6]

[<f8b19648>] get_active_stripe+0x288/0x560 [raid6]

[<f884d140>] scsi_done+0x0/0x20 [scsi_mod]

[<f8b1d7cd>] sync_request+0x19d/0x270 [raid6]

[<c031924d>] md_do_sync+0x7ad/0xb90

[<c03a497c>] schedule+0x36c/0x7d0

[<c0142df0>] autoremove_wake_function+0x0/0x50

[<c0317262>] md_thread+0x132/0x180

[<c0142df0>] autoremove_wake_function+0x0/0x50

[<c0103a12>] ret_from_fork+0x6/0x14

[<c0142df0>] autoremove_wake_function+0x0/0x50

[<c0317130>] md_thread+0x0/0x180

[<c010135d>] kernel_thread_helper+0x5/0x18

Code: f9 fe ff ff 8b 43 04 8b 40 78 e8 2f e0 7f c7 e9 e9 fe ff ff 8d 76 00
8d bc 27 00 00 00 00 8b 50 04 85 d2 74 15 8b 08 85 c9 74 06 <89> 51 04 8b 50
04 89 0a c7 40 04 00 00 00 00 c3 8d 76 00 83 ec

drivers/md/raid6main.c:1933: spin_lock(drivers/md/raid6main.c:f6362224)
already locked by drivers/md/raid6main.c/311




