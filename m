From: Sterpu Victor <victor@ambra.ro>
Subject: raid 5 kernel error
Date: Wed, 13 Sep 2006 14:17:09 +0300
Message-ID: <4507E8B5.8090802@ambra.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I made a raid 5.
When  the raid was building I received the some errors from the kernel, 
and after this the raid stopped rebuilding.
The command cat /proc/mdstat shows this:

Personalities : [raid5]
md0 : active raid5 hda6[0] hdd6[4] hdc6[2] hdb6[1]
      579664896 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
      [========>............]  recovery = 44.2% (85521060/193221632) 
finish=7130.7min speed=251K/sec
unused devices: <none>

There are 7130 minutes to completion of recovery, and this number is 
only increasing.
The raid will not advance after procent 44.2.
I suspenct oane of the hdd's is broken, but I can't find any reference 
to one specific device in the mesages I received.

Message in /var/log/kernel/errors
May 31 11:18:22 localhost kernel: audit(1022858289.060:0): initialized
May 31 11:18:22 localhost kernel: swsusp: Suspend partition has wrong 
signature?
May 31 11:18:22 localhost kernel: raid5: raid level 5 set md0 active 
with 3 out of 4 devices, algorithm 2
May 31 11:36:03 localhost kernel: FAT: bogus number of reserved sectors
May 31 12:29:18 localhost kernel: Unable to handle kernel paging request 
at virtual address 0001c3c9
May 31 12:29:18 localhost kernel:  printing eip:
May 31 12:29:18 localhost kernel: *pde = 37db8001
May 31 12:29:18 localhost kernel: Oops: 0000 [#1]

Message in /var/log/kernel/warnings
May 31 12:29:18 localhost kernel: f88392c2
May 31 12:29:18 localhost kernel: Modules linked in: vfat fat md5 ipv6 
8139too mii af_packet floppy usbhid video thermal tc1100_wmi processor 
fan container button battery ac ide_cd loop supermount via_agp agpgart 
tsdev ehci_hcd uhci_hcd usbcore evdev ext3 jbd sd_mod sata_via libata 
scsi_mod raid5 xor dm_snapshot dm_zero dm_mirror dm_mod
May 31 12:29:18 localhost kernel: CPU:    0
May 31 12:29:18 localhost kernel: EIP:    
0060:[pg0+943293122/1068880896]    Not tainted VLI
May 31 12:29:18 localhost kernel: EIP:    0060:[<f88392c2>]    Not 
tainted VLI
May 31 12:29:18 localhost kernel: EFLAGS: 00010002   (2.6.12-12mdk)
May 31 12:29:18 localhost kernel: EIP is at __find_stripe+0x52/0x80 [raid5]
May 31 12:29:18 localhost kernel: eax: 0a31cb66   ebx: 0001c3b5   ecx: 
0a31cbf6   edx: 0001c3b6
May 31 12:29:18 localhost kernel: esi: 0a31e548   edi: 00000000   ebp: 
f74efdf0   esp: f74efde4
May 31 12:29:18 localhost kernel: ds: 007b   es: 007b   ss: 0068
May 31 12:29:18 localhost kernel: Process md0_resync (pid: 838, 
threadinfo=f74ee000 task=f7c7d5e0)
May 31 12:29:18 localhost kernel: Stack: f7c1dae0 00000001 f7c1db38 
f74efe60 f8839329 f7c1dae0 0a31e548 00000000
May 31 12:29:18 localhost kernel:        00000000 00000000 00000001 
00000000 00000000 f74ee000 f7c1db40 f7b7f050
May 31 12:29:18 localhost kernel:        00000000 00000000 00000000 
f74ee000 ffffff90 00000150 00000003 0000007b
May 31 12:29:18 localhost kernel: Call Trace:
May 31 12:29:18 localhost kernel:  [show_stack+171/240] show_stack+0xab/0xf0
May 31 12:29:18 localhost kernel:  [<c0103e9b>] show_stack+0xab/0xf0
May 31 12:29:18 localhost kernel:  [show_registers+364/512] 
show_registers+0x16c/0x200
May 31 12:29:18 localhost kernel:  [<c010406c>] show_registers+0x16c/0x200
May 31 12:29:18 localhost kernel:  [die+200/336] die+0xc8/0x150
May 31 12:29:18 localhost kernel:  [<c0104278>] die+0xc8/0x150
May 31 12:29:18 localhost kernel:  [do_page_fault+609/1921] 
do_page_fault+0x261/0x781
May 31 12:29:18 localhost kernel:  [<c0116fe1>] do_page_fault+0x261/0x781
May 31 12:29:18 localhost kernel:  [error_code+79/84] error_code+0x4f/0x54
May 31 12:29:18 localhost kernel:  [<c0103ab3>] error_code+0x4f/0x54
May 31 12:29:18 localhost kernel:  [pg0+943293225/1068880896] 
get_active_stripe+0x39/0x300 [raid5]
May 31 12:29:18 localhost kernel:  [<f8839329>] 
get_active_stripe+0x39/0x300 [raid5]
May 31 12:29:18 localhost kernel:  [pg0+943304961/1068880896] 
sync_request+0x141/0x200 [raid5]
May 31 12:29:18 localhost kernel:  [<f883c101>] sync_request+0x141/0x200 
[raid5]
May 31 12:29:18 localhost kernel:  [md_do_sync+1026/2400] 
md_do_sync+0x402/0x960
May 31 12:29:18 localhost kernel:  [<c02d5ee2>] md_do_sync+0x402/0x960
May 31 12:29:18 localhost kernel:  [md_thread+295/368] md_thread+0x127/0x170
May 31 12:29:18 localhost kernel:  [<c02d4d07>] md_thread+0x127/0x170
May 31 12:29:18 localhost kernel:  [kernel_thread_helper+5/12] 
kernel_thread_helper+0x5/0xc
May 31 12:29:18 localhost kernel:  [<c0101349>] kernel_thread_helper+0x5/0xc
May 31 12:29:18 localhost kernel: Code: 00 8b 00 8b 1c 90 85 db 74 37 8b 
43 14 89 f9 8b 53 18 31 f0 31 d1 09 c1 75 21 89 d8 8b 74 24 04 8b 1c 24 
8b 7c 24 08 89 ec 5d c3 <8b> 43 14 89 f9 8b 53 18 31 f0 31 d1 09 c1 74 
df 8b 1b 85 db 75




