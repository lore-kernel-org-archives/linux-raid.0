From: =?ISO-8859-1?Q?Marc_Recht=E9?= <marc3@rechte.fr>
Subject: hdparm standby timeout stopped working
Date: Fri, 18 Feb 2011 10:47:36 +0100
Message-ID: <ijlf7c$f9k$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I had sucessfully set the standby timeout on recent Hitachi SATA drives 
(actually 3 of them in a PMP enclosure, using hdparm -S 5 /dev/sd?). The 
drive were entering standby mode confirmed by hdparm -C.

Suddenly all the drives stopped entering automatically standby mode, 
even when not mounted, although forcing standby with hdparm -y is still 
working...

I tried to boot in single mode (s) to be sure fewer services are 
running. Same thing.

I cannot see what I changed on the system. Day - 1 is was working fine...

Thanks

Kernel is 2.6.32-71.14.1.el6.i686

[root@homecine ~]# hdparm -I /dev/sdb

/dev/sdb:

ATA device, with non-removable media
         Model Number:       Hitachi HDS723030ALA640
         Serial Number:      MK0311YHG3X51A
         Firmware Revision:  MKAOA3B0
         Transport:          Serial, ATA8-AST, SATA 1.0a, SATA II 
Extensions, SATA Rev 2.5, SATA Rev 2.6; Revision: ATA8-AST T13 Project 
D1697 Revision 0b
Standards:
         Used: unknown (minor revision code 0x0029)
         Supported: 8 7 6 5
         Likely used: 8
Configuration:
         Logical         max     current
         cylinders       16383   16383
         heads           16      16
         sectors/track   63      63
         --
         CHS current addressable sectors:   16514064
         LBA    user addressable sectors:  268435455
         LBA48  user addressable sectors: 5860533168
         Logical  Sector size:                   512 bytes
         Physical Sector size:                   512 bytes
         device size with M = 1024*1024:     2861588 MBytes
         device size with M = 1000*1000:     3000592 MBytes (3000 GB)
         cache/buffer size  = unknown
         Form Factor: 3.5 inch
         Nominal Media Rotation Rate: 7200
Capabilities:
         LBA, IORDY(can be disabled)
         Queue depth: 32
         Standby timer values: spec'd by Standard, no device specific 
minimum
         R/W multiple sector transfer: Max = 16  Current = 0
         Advanced power management level: disabled
         DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
              Cycle time: min=120ns recommended=120ns
         PIO: pio0 pio1 pio2 pio3 pio4
              Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
         Enabled Supported:
            *    SMART feature set
                 Security Mode feature set
            *    Power Management feature set
            *    Write cache
            *    Look-ahead
            *    Host Protected Area feature set
            *    WRITE_BUFFER command
            *    READ_BUFFER command
            *    NOP cmd
            *    DOWNLOAD_MICROCODE
                 Advanced Power Management feature set
                 Power-Up In Standby feature set
            *    SET_FEATURES required to spinup after power up
                 SET_MAX security extension
            *    48-bit Address feature set
            *    Device Configuration Overlay feature set
            *    Mandatory FLUSH_CACHE
            *    FLUSH_CACHE_EXT
            *    SMART error logging
            *    SMART self-test
                 Media Card Pass-Through
            *    General Purpose Logging feature set
            *    WRITE_{DMA|MULTIPLE}_FUA_EXT
            *    64-bit World wide name
            *    URG for READ_STREAM[_DMA]_EXT
            *    URG for WRITE_STREAM[_DMA]_EXT
            *    WRITE_UNCORRECTABLE_EXT command
            *    {READ,WRITE}_DMA_EXT_GPL commands
            *    Segmented DOWNLOAD_MICROCODE
                 unknown 119[7]
            *    Gen1 signaling speed (1.5Gb/s)
            *    Gen2 signaling speed (3.0Gb/s)
            *    unknown 76[3]
            *    Native Command Queueing (NCQ)
            *    Host-initiated interface power management
            *    Phy event counters
            *    NCQ priority information
                 Non-Zero buffer offsets in DMA Setup FIS
            *    DMA Setup Auto-Activate optimization
                 Device-initiated interface power management
                 In-order data delivery
            *    Software settings preservation
            *    SMART Command Transport (SCT) feature set
            *    SCT LBA Segment Access (AC2)
            *    SCT Error Recovery Control (AC3)
            *    SCT Features Control (AC4)
            *    SCT Data Tables (AC5)
Security:
         Master password revision code = 65534
                 supported
         not     enabled
         not     locked
         not     frozen
         not     expired: security count
         not     supported: enhanced erase
         128min for SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 5000cca225c1c6d5
         NAA             : 5
         IEEE OUI        : 000cca
         Unique ID       : 225c1c6d5
Checksum: correct

