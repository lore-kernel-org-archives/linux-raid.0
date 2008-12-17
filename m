From: Bruce Allen <ballen@gravity.phys.uwm.edu>
Subject: Re: [smartmontools-support] Velociraptor biting the dust (9th disk,
 continued to use it, and..)
Date: Tue, 16 Dec 2008 21:52:13 -0600 (CST)
Message-ID: <Pine.LNX.4.64.0812162149480.26217@gc.phys.uwm.edu>
References: <alpine.DEB.1.10.0811221638360.707@p34.internal.lan>
 <20081122215529.1973f820@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0812160625150.8812@gc.phys.uwm.edu>
 <alpine.DEB.1.10.0812160803170.725@p34.internal.lan>
 <Pine.LNX.4.64.0812160708140.9136@gc.phys.uwm.edu>
 <alpine.DEB.1.10.0812161736360.31132@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812161736360.31132@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, Smartmontools Mailing List <smartmontools-support@lists.sourceforge.net>, Alan Piszcz <ap@solarrain.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-raid.ids

Hi Justin,

OK, this looks like a problem with the disk.  The disk has 586 million 
sectors, but is reporting IDNF and end-of-device errors at around sector 
number 200 million.

Linux kernel jocks: ignore/delete this thread.  Sorry for the noise.

Cheers,
     Bruce



On Tue, 16 Dec 2008, Justin Piszcz wrote:

>
>
> On Tue, 16 Dec 2008, Bruce Allen wrote:
>
>>>>>> [632714.975844] ata1.00: status: { DRDY ERR }
>>>>>> [632714.975847] ata1.00: error: { IDNF }
>>
>>>>> IDNF - ID not found, usually these days means 'asked for a sector out of
>>>>> range'
>>
>>>> Justin, was this error provoked for example by you using a 'dd' command to
>>>> try and read stuff past the end of the disk?  Because the md device driver
>>>> should not try and do something like that.  The md device driver knows how
>>>> many LBAs are available on the disk and should never issue a read or write
>>>> past the end of the device.
>>>>
>>>> Justin, I have the impression that this IDNF error was NOT due to you
>>>> issuing
>>>> dd commands or similar, but was part of 'normal' md operation.
>>>>
>> When you say 'the errors occured' do you mean specifically the 'IDNF' errors?
>> Those are the onces I am talking about.  I am NOT talking about other types
>> of errors like UNC or ABORT.  I am ONLY talking about the IDNF errors.
>>
>> It is easy to check if the IDNF errors are from the disk firmware or the
>> Linux kernel.
>>
>> The kernel error message for IDNF should report the LBA which provoked that
>> IDNF error.  Please compare that with the maximum LBA on the disk, which you
>> can get either via hdparm or smartctl -i (divide total capacity in bytes by
>> 512).
>>
>> If the LBA reported in the kernel error message is greater than the maximum
>> LBA on the disk, then the problem is in the Linux kernel.  If the LBA
>> reported by the kernel is less than the maximum LBA on the disk, then the
>> problem is the disk firmware (or perhaps the disk has its capacity 'clipped'
>> with the 'Host Protected Area' feature set.  But the Linux kernel should know
>> about this, so that would be a kernel bug again, not a disk firmware bug).
>>
>
> Going to plug-in one of the disks to a test system, I dare not use them in
> a real host anymore.. ok, plugged in:
>
> syslog-Nov 25 02:53:25 p34 kernel: [842756.834250] end_request: I/O error, dev sda, sector 213221352
>
> smartctl -i
>
> # smartctl -i /dev/sdg
> smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 Bruce Allen
> Home page is http://smartmontools.sourceforge.net/
>
> === START OF INFORMATION SECTION ===
> Device Model:     WDC WD3000GLFS-01F8U0
> Serial Number:    [ .. ]
> Firmware Version: 03.03V01
> User Capacity:    300,069,052,416 bytes
> Device is:        Not in smartctl database [for details use: -P showall]
> ATA Version is:   8
> ATA Standard is:  Exact ATA specification draft version not indicated
> Local Time is:    Tue Dec 16 17:44:53 2008 EST
368> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>
> 300069052416/512
> 586072368.000
> 213221352 <- error on sector (even though WD Diag Tools and smart shows the
> disk as completely 100% ok)
>
> hdparm -i
>
> # hdparm -i /dev/sdg
>
> /dev/sdg:
>
>  Model=WDC WD3000GLFS-01F8U0                   , FwRev=03.03V01, SerialNo= [..]
>  Config={ HardSect NotMFM HdSw>15uSec SpinMotCtl Fixed DTR>5Mbs FmtGapReq }
>  RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=52
>  BuffType=unknown, BuffSize=16384kB, MaxMultSect=16, MultSect=?16?
>  CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=586072368
>  IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
>  PIO modes:  pio0 pio3 pio4
>  DMA modes:  mdma0 mdma1 mdma2
>  UDMA modes: udma0 udma1 udma2 udma3 udma4 *udma5 udma6
>  AdvancedPM=no WriteCache=enabled
>  Drive conforms to: Unspecified:  ATA/ATAPI-1,2,3,4,5,6,7
>
>  * signifies the current active mode
>
> hdparm -I
>
> # hdparm -I /dev/sdg
>
> /dev/sdg:
>
> ATA device, with non-removable media
>         Model Number:       WDC WD3000GLFS-01F8U0
>         Serial Number:      [ .. ]
>         Firmware Revision:  03.03V01
>         Transport:          Serial, SATA 1.0a, SATA II Extensions, SATA Rev 2.5
> Standards:
>         Supported: 8 7 6 5
>         Likely used: 8
> Configuration:
>         Logical         max     current
>         cylinders       16383   16383
>         heads           16      16
>         sectors/track   63      63
>         --
>         CHS current addressable sectors:   16514064
>         LBA    user addressable sectors:  268435455
>         LBA48  user addressable sectors:  586072368
>         device size with M = 1024*1024:      286168 MBytes
>         device size with M = 1000*1000:      300069 MBytes (300 GB)
> Capabilities:
>         LBA, IORDY(can be disabled)
>         Queue depth: 32
>         Standby timer values: spec'd by Standard, with device specific minimum
>         R/W multiple sector transfer: Max = 16  Current = 16
>         Recommended acoustic management value: 128, current value: 254
>         DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5 udma6
>              Cycle time: min=120ns recommended=120ns
>         PIO: pio0 pio1 pio2 pio3 pio4
>              Cycle time: no flow control=120ns  IORDY flow control=120ns
> Commands/features:
>         Enabled Supported:
>            *    SMART feature set
>                 Security Mode feature set
>            *    Power Management feature set
>            *    Write cache
>            *    Look-ahead
>            *    Host Protected Area feature set
>            *    WRITE_BUFFER command
>            *    READ_BUFFER command
>            *    NOP cmd
>            *    DOWNLOAD_MICROCODE
>                 Power-Up In Standby feature set
>            *    SET_FEATURES required to spinup after power up
>                 SET_MAX security extension
>            *    Automatic Acoustic Management feature set
>            *    48-bit Address feature set
>            *    Device Configuration Overlay feature set
>            *    Mandatory FLUSH_CACHE
>            *    FLUSH_CACHE_EXT
>            *    SMART error logging
>            *    SMART self-test
>            *    General Purpose Logging feature set
>            *    WRITE_{DMA|MULTIPLE}_FUA_EXT
>            *    64-bit World wide name
>            *    WRITE_UNCORRECTABLE_EXT command
>            *    {READ,WRITE}_DMA_EXT_GPL commands
>            *    Segmented DOWNLOAD_MICROCODE
>            *    SATA-I signaling speed (1.5Gb/s)
>            *    SATA-II signaling speed (3.0Gb/s)
>            *    Native Command Queueing (NCQ)
>            *    Phy event counters
>                 DMA Setup Auto-Activate optimization
>            *    Software settings preservation
>            *    SMART Command Transport (SCT) feature set
>            *    SCT Long Sector Access (AC1)
>            *    SCT LBA Segment Access (AC2)
>            *    SCT Error Recovery Control (AC3)
>            *    SCT Features Control (AC4)
>            *    SCT Data Tables (AC5)
>                 unknown 206[12] (vendor specific)
>                 unknown 206[13] (vendor specific)
> Security:
>         Master password revision code = 65534
>                 supported
>         not     enabled
>         not     locked
>         not     frozen
>         not     expired: security count
>         not     supported: enhanced erase
>         48min for SECURITY ERASE UNIT.
> Logical Unit WWN Device Identifier: 50014ee0ab4e9a45
>         NAA             : 5
>         IEEE OUI        : 14ee
>         Unique ID       : 0ab4e9a45
> Checksum: correct
>
> Here is the information from older INDFs:
>
> syslog-Nov 25 02:53:13 p34 kernel: [842744.785524] ata1: EH complete
> syslog-Nov 25 02:53:13 p34 kernel: [842744.794100] sd 0:0:0:0: [sda] 586072368 512-byte hardware sectors (300069 MB)
> syslog-Nov 25 02:53:13 p34 kernel: [842744.794573] sd 0:0:0:0: [sda] Write Protect is off
> syslog-Nov 25 02:53:13 p34 kernel: [842744.794576] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> syslog-Nov 25 02:53:13 p34 kernel: [842744.795031] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> syslog-Nov 25 02:53:25 p34 kernel: [842756.811091] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> syslog-Nov 25 02:53:25 p34 kernel: [842756.811097] ata1.00: irq_stat 0x40000001
> syslog-Nov 25 02:53:25 p34 kernel: [842756.811104] ata1.00: cmd 35/00:d0:e8:7f:b5/00:03:0c:00:00/e0 tag 0 dma 499712 out
> syslog-Nov 25 02:53:25 p34 kernel: [842756.811106]          res 51/10:d0:e8:7f:b5/00:03:0c:00:00/e0 Emask 0x81 (invalid argument)
> syslog-Nov 25 02:53:25 p34 kernel: [842756.811110] ata1.00: status: { DRDY ERR }
> syslog:Nov 25 02:53:25 p34 kernel: [842756.811113] ata1.00: error: { IDNF }
> syslog-Nov 25 02:53:25 p34 kernel: [842756.834198] ata1.00: configured for UDMA/133
> syslog-Nov 25 02:53:25 p34 kernel: [842756.834227] sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> syslog-Nov 25 02:53:25 p34 kernel: [842756.834231] sd 0:0:0:0: [sda] Sense Key : Aborted Command [current] [descriptor]
> syslog-Nov 25 02:53:25 p34 kernel: [842756.834235] Descriptor sense data with sense descriptors (in hex):
> syslog-Nov 25 02:53:25 p34 kernel: [842756.834237]         72 0b 14 00 00 00 00 0c 00 0a 80 00 00 00 00 00
> syslog-Nov 25 02:53:25 p34 kernel: [842756.834243]         0c b5 7f e8
> syslog-Nov 25 02:53:25 p34 kernel: [842756.834246] sd 0:0:0:0: [sda] Add. Sense: Recorded entity not found
> syslog-Nov 25 02:53:25 p34 kernel: [842756.834250] end_request: I/O error, dev sda, sector 213221352
> syslog-Nov 25 02:53:25 p34 kernel: [842756.834263] __ratelimit: 118 callbacks suppressed
> syslog-Nov 25 02:53:25 p34 kernel: [842756.834265] Buffer I/O error on device sda, logical block 26652669
>
>
>
> ------------------------------------------------------------------------------
> SF.Net email is Sponsored by MIX09, March 18-20, 2009 in Las Vegas, Nevada.
> The future of the web can't happen without you.  Join us at MIX09 to help
> pave the way to the Next Web now. Learn more and register at
> http://ad.doubleclick.net/clk;208669438;13503038;i?http://2009.visitmix.com/
> _______________________________________________
> Smartmontools-support mailing list
> Smartmontools-support@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/smartmontools-support
>
