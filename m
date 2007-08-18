From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: raid5:md3: kernel BUG ,  followed by ,  Silent halt .
Date: Sat, 18 Aug 2007 14:41:14 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0708181328510.14169@filesrv1.baby-dragons.com>
References: <Pine.LNX.4.64.0707141658210.16611@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707141658210.16611@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello All ,  Here we go again .  Again attempting to do bonnie++ testing 
on a small array .
 	Kernel 2.6.22.1
 	Patches involved ,
 	IOP1 ,  2.6.22.1-iop1 for improved sequential write performance 
(stripe-queue) ,  Dan Williams <dan.j.williams@intel.com>
 	[SCSI] Addition to pci_ids.h for ATTO Technology, Inc. 
linux/kernel/git/jejb/scsi-misc-2.6.git , 
commit: d43639784817e4c9acaffd0952a1dc8ab6ecc076
 	[SCSI] mpt fusion: Add support for ATTO 4LD: Rebranded LSI 53C1030 
linux/kernel/git/jejb/scsi-misc-2.6.git , 
commit: 5e394a08b72f40b059d05c44268769ce87ded11a


  root@(none):~ # ------------[ cut here ]------------
kernel BUG at drivers/md/raid5.c:562!
invalid opcode: 0000 [#1]
SMP
Modules linked in:
CPU:    7
EIP:    0060:[<c06e8864>]    Not tainted VLI
EFLAGS: 00010002   (2.6.22.1-iop1 #2)
EIP is at init_queue+0x164/0x190
eax: 00000001   ebx: f61cda30   ecx: 00000001   edx: 00000010
esi: f70fde00   edi: f61cda30   ebp: f7605b08   esp: f7605ad8
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process pdflush (pid: 377, ti=f7604000 task=f7cd6030 task.ti=f7604000)
Stack: f61cda30 f7605af8 c0405cdc 00000001 f70fde04 f70fde00 f70fde00 000b78e8
        00000000 f61cda30 f70fde00 f70fdfa0 f7605b50 c06e8ad7 00000007 00000003
        f70fdf1c 000b78e8 00000000 00000286 f7605b38 00000286 f7605bbc f70fdf40
Call Trace:
  [<c010385a>] show_trace_log_lvl+0x1a/0x30
  [<c010392a>] show_stack_log_lvl+0x9a/0xc0
  [<c0103b86>] show_registers+0x1d6/0x2e0
  [<c0103dfe>] die+0x10e/0x210
  [<c0103f91>] do_trap+0x91/0xd0
  [<c0104239>] do_invalid_op+0x89/0xa0
  [<c08056f2>] error_code+0x72/0x78
  [<c06e8ad7>] get_active_queue+0x147/0x1a0
  [<c06ef5c0>] make_request+0x1a0/0x3f0
  [<c03f8665>] generic_make_request+0x1d5/0x2c0
  [<c03f879f>] submit_bio+0x4f/0xf0
  [<c03860ae>] xfs_submit_ioend_bio+0x1e/0x30
  [<c03862e2>] xfs_submit_ioend+0xf2/0x100
  [<c0387110>] xfs_page_state_convert+0x430/0x640
  [<c0387383>] xfs_vm_writepage+0x63/0x100
  [<c015b23b>] __writepage+0xb/0x30
  [<c015b136>] write_cache_pages+0x206/0x300
  [<c015b28f>] generic_writepages+0x2f/0x40
  [<c0387444>] xfs_vm_writepages+0x24/0x60
  [<c015b2ce>] do_writepages+0x2e/0x50
  [<c019588b>] __sync_single_inode+0x5b/0x1a0
  [<c0195a14>] __writeback_single_inode+0x44/0x1e0
  [<c0195cdd>] sync_sb_inodes+0x12d/0x250
  [<c0195ecc>] writeback_inodes+0xcc/0xe0
  [<c015ac8e>] background_writeout+0x7e/0xb0
  [<c015b91b>] __pdflush+0xcb/0x1a0
  [<c015ba1c>] pdflush+0x2c/0x30
  [<c013729c>] kthread+0x5c/0xa0
  [<c01036e7>] kernel_thread_helper+0x7/0x10
  =======================
Code: 8b 45 ec c7 04 24 6e 53 9b c0 89 44 24 04 e8 74 b0 a3 ff 0f 0b eb fe 0f 0b 
eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe <0f> 0b eb fe 8b 55 e8 89 
f8 83 c2 04 e8 fb d0 d1 ff 85 db 0f 85
EIP: [<c06e8864>] init_queue+0x164/0x190 SS:ESP 0068:f7605ad8


 	Build .config .
http://www.baby-dragons.com/linux-2.6.22.1d-reiser-xfs-lmsensors-EMMENSE-DEBUGGING_minus-I_oat-W_iop-patches-atto-ul4d-patch.config

 	Build log .
http://www.baby-dragons.com/linux-2.6.22.1d-reiser-xfs-lmsensors-EMMENSE-DEBUGGING_minus-I_oat-W_iop-patches-atto-ul4d-patch.log



  root@filesrv2:~ # /usr/src/linux/scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux filesrv2 2.6.22.1-iop1 #2 SMP Sat Aug 18 19:52:15 UTC 2007 i686 pentium4 
i386 GNU/Linux

Gnu C                  3.4.6
Gnu make               3.81
binutils               2.15.92.0.2
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.38
jfsutils               1.1.11
reiserfsprogs          3.6.19
xfsprogs               2.8.10
pcmciautils            014
pcmcia-cs              3.2.8
quota-tools            3.13.
PPP                    2.4.4
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Linux C++ Library      6.0.3
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
oprofile               0.9.1
Sh-utils               5.97
udev                   097
Modules Loaded


-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
