From: Jaakko Niemi <liiwi@lonesom.pp.fi>
Subject: dac960 problem
Date: Mon, 07 Apr 2003 17:05:00 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <871y0ejtdf.fsf@jumper.lonesom.pp.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 Happened this morning after few months uptime:

EXT3 FS 2.4-0.9.19, 19 August 2002 on dac960(48,1), internal journal
ip_tables: (C) 2000-2002 Netfilter core team
eth0: Tx FIFO error! CSR0=02e3
eth0: Tx FIFO error! CSR0=02e3
eth0: Tx FIFO error! CSR0=02eb
eth0: Tx FIFO error! CSR0=02eb
eth0: Tx FIFO error! CSR0=02eb
attempt to access beyond end of device
30:01: rw=0, want=536870924, limit=8007664
EXT3-fs error (device dac960(48,1)): read_block_bitmap: Cannot read block bitmap - block_group = 0, block_bitmap = 134217730
Aborting journal on device dac960(48,1).
Remounting filesystem read-only
EXT3-fs error (device dac960(48,1)) in ext3_prepare_write: IO failure
EXT3-fs error (device dac960(48,1)) in start_transaction: Journal has aborted
EXT3-fs error (device dac960(48,1)) in start_transaction: Journal has aborted
EXT3-fs error (device dac960(48,1)) in start_transaction: Journal has aborted
EXT3-fs error (device dac960(48,1)) in start_transaction: Journal has aborted
EXT3-fs error (device dac960(48,1)) in start_transaction: Journal has aborted
EXT3-fs error (device dac960(48,1)) in start_transaction: Journal has aborted
EXT3-fs error (device dac960(48,1)) in start_transaction: Journal has aborted
EXT3-fs error (device dac960(48,1)) in start_transaction: Journal has aborted
EXT3-fs error (device dac960(48,1)) in start_transaction: Journal has aborted

# cat /proc/rd/c0/current_status 
***** DAC960 RAID Driver Version 2.4.11 of 11 October 2001 *****
Copyright 1998-2001 by Leonard N. Zubkoff <lnz@dandelion.com>
Configuring Mylex DAC960PG PCI RAID Controller
  Firmware Version: 4.08-0-33, Channels: 2, Memory Size: 8MB
  PCI Bus: 1, Device: 4, Function: 1, I/O Address: Unassigned
  PCI Address: 0x9300000 mapped at 0xC8800000, IRQ Channel: 9
  Controller Queue Depth: 60, Maximum Blocks per Command: 128
  Driver Queue Depth: 59, Scatter/Gather Limit: 33 of 33 Segments
  Stripe Size: 64KB, Segment Size: 8KB, BIOS Geometry: 128/32
  Physical Devices:
    0:0  Vendor: IBM       Model: DORS-32160        Revision: WA6A
         Serial Number: 5U621689        
         Disk Status: Standby, 4225024 blocks
    0:1  Vendor: IBM       Model: DORS-32160        Revision: WA6A
         Serial Number: 5U620817        
         Disk Status: Online, 4225024 blocks
    1:0  Vendor: IBM       Model: DORS-32160        Revision: WA6A
         Serial Number: 5U610523        
         Disk Status: Online, 4225024 blocks, 1 resets
    1:1  Vendor: IBM       Model: DORS-32160        Revision: WA6A
         Serial Number: 5U620358        
         Disk Status: Online, 4225024 blocks, 1 resets
    1:2  Vendor: IBM       Model: DORS-32160        Revision: WA6A
         Serial Number: 5U5X9523        
         Disk Status: Online, 4225024 blocks, 1 resets
    1:3  Vendor: IBM       Model: DORS-32160        Revision: WA6A
         Serial Number: 5U620988        
         Disk Status: Online, 4225024 blocks, 1 resets
  Logical Drives:
    /dev/rd/c0d0: RAID-5, Online, 16900096 blocks, Write Back
  No Rebuild or Consistency Check in Progress

# uname -a
Linux hurina 2.4.21-pre4-ac4 #1 SMP Mon Feb 17 18:04:35 EET 2003 i586 unknown

                             --j
