From: Nick Black <dank@reflexsecurity.com>
Subject: kernel BUG with ext3+raid5, 2.6.5-rc1
Date: Mon, 3 May 2004 13:48:39 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040503174839.GA7244@suburbanjihad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I can try with something newer if that's necessary.  Running unrar x on a
390M file resulted in a segfault and this BUG.  Neither the input or
output used the RAID5 array, so I'm not sure how applicable this list is;
let me know if I should go elsewhere.  Here's the dmesg output, relevant
startup info and content of /proc/mdstat:

svc: bad direction 65536, dropping request
Assertion failure in journal_unmap_buffer() at fs/jbd/transaction.c:1855: "transaction == journal->j_running_transaction"
------------[ cut here ]------------
kernel BUG at fs/jbd/transaction.c:1855!
invalid operand: 0000 [#1]
CPU:    0
EIP:    0060:[<c0179155>]    Not tainted
EFLAGS: 00010282   (2.6.5-rc1)
EIP is at journal_unmap_buffer+0x55/0x140
eax: 0000007d   ebx: c328fb80   ecx: c032ff44   edx: c3b4df6c
esi: c32a8260   edi: c358fee0   ebp: 00000001   esp: c29b9e9c
ds: 007b   es: 007b   ss: 0068
Process unrar (pid: 2247, threadinfo=c29b8000 task=c3724cc0)
Stack: c027cdc0 c026c178 c027a9f9 0000073f c027f160 c328fb80 c328fb80 00001000
       c1086420 c01792b5 00000001 c328fb80 00000000 c40a0bc0 c1086420 00000003
       c1086420 c30ffcc0 c012fc14 c1086420 c012fc7d 00000234 c012fdca c29b8000
Call Trace:
 [<c01792b5>] journal_invalidatepage+0x75/0x120
 [<c012fc14>] do_invalidatepage+0x14/0x20
 [<c012fc7d>] truncate_complete_page+0x5d/0x60
 [<c012fdca>] truncate_inode_pages+0xca/0x260
 [<c0152f08>] generic_delete_inode+0xa8/0xc0
 [<c015308d>] iput+0x4d/0x60
 [<c014af5a>] sys_unlink+0xda/0x120
 [<c0106a47>] syscall_call+0x7/0xb
 
Code: 0f 0b 3f 07 f9 a9 27 c0 83 c4 14 89 f2 89 f8 e8 37 ff ff ff

---------------------------------

Personalities : [raid5]
md0 : active raid5 sdb1[1] sda1[0] hdc1[2]
      488391808 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
             
unused devices: <none>

---------------------------------

Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX3: IDE controller at PCI slot 0000:00:07.1
PIIX3: chipset revision 0
PIIX3: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:pio, hdd:pio
hda: WDC WD307AA, ATA DISK drive
Using anticipatory io scheduler
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdc: Maxtor 5A250J0, ATA DISK drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 60074784 sectors (30758 MB) w/2048KiB Cache, CHS=59598/16/63
 hda: hda1 hda2 hda3 < hda5 hda6 hda7 hda8 >
hdc: max request size: 1024KiB
hdc: 490234752 sectors (251000 MB) w/2048KiB Cache, CHS=30515/255/63
 hdc: hdc1
libata version 1.01 loaded.
sata_promise version 0.91
ata1: SATA max UDMA/133 cmd 0xC5000200 ctl 0xC5000238 bmdma 0x0 irq 9
ata2: SATA max UDMA/133 cmd 0xC5000280 ctl 0xC50002B8 bmdma 0x0 irq 9
ata3: SATA max UDMA/133 cmd 0xC5000300 ctl 0xC5000338 bmdma 0x0 irq 9
ata4: SATA max UDMA/133 cmd 0xC5000380 ctl 0xC50003B8 bmdma 0x0 irq 9
ata1: dev 0 cfg 49:2f00 82:346b 83:7f21 84:4003 85:3469 86:3c01 87:4003 88:203f
ata1: dev 0 ATA, max UDMA/100, 488397168 sectors (lba48)
ata1: dev 0 configured for UDMA/100
scsi0 : sata_promise
ata2: dev 0 cfg 49:2f00 82:346b 83:7f21 84:4003 85:3469 86:3c01 87:4003 88:203f
ata2: dev 0 ATA, max UDMA/100, 488397168 sectors (lba48)
ata2: dev 0 configured for UDMA/100
scsi1 : sata_promise
ata3: no device found (phy stat 00000000)
ata3: thread exiting
scsi2 : sata_promise
ata4: no device found (phy stat 00000000)
ata4: thread exiting
scsi3 : sata_promise
  Vendor: ATA       Model: WDC WD2500JD-00G  Rev: 1.01
  Type:   Direct-Access                      ANSI SCSI revision: 05
  Vendor: ATA       Model: WDC WD2500JD-00G  Rev: 1.01
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sda: drive cache: write through
 sda: sda1
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sdb: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdb: drive cache: write through
 sdb: sdb1
Attached scsi disk sdb at scsi1, channel 0, id 0, lun 0
md: raid5 personality registered as nr 4
raid5: measuring checksumming speed
   8regs     :   316.000 MB/sec
   8regs_prefetch:   260.000 MB/sec
   32regs    :   148.000 MB/sec
   32regs_prefetch:   156.000 MB/sec
   pII_mmx   :   360.000 MB/sec
   p5_mmx    :   336.000 MB/sec
raid5: using function: pII_mmx (360.000 MB/sec)
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdb1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md:  adding hdc1 ...
md: created md0
md: bind<hdc1>
md: bind<sda1>
md: bind<sdb1>
md: running: <sdb1><sda1><hdc1>
raid5: device sdb1 operational as raid disk 1
raid5: device sda1 operational as raid disk 0
raid5: device hdc1 operational as raid disk 2
raid5: allocated 3146kB for md0
raid5: raid level 5 set md0 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3 fd:0
 disk 0, o:1, dev:sda1
 disk 1, o:1, dev:sdb1
 disk 2, o:1, dev:hdc1
md: ... autorun DONE.

-- 
nick black <dank@reflexsecurity.com>
"np:  nondeterministic polynomial-time
the class of dashed hopes and idle dreams." - the complexity zoo
