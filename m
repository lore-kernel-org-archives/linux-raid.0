From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: And again help on deciphering an error (continued)
Date: Fri, 14 Nov 2008 19:23:20 +0100
Message-ID: <491DC218.9010301@rabbit.us>
References: <4907A5FA.7050903@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4907A5FA.7050903@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> Hello,
> 
> I need help with understanding what is going on here
> (full log):
> 
> 
> Oct 27 11:33:41 Arzamas kernel: ata6.00: exception Emask 0x10 SAct 0x0
> SErr 0x80000 action 0xe frozen
> Oct 27 11:33:41 Arzamas kernel: ata6.00: irq_stat 0x01100010, PHY RDY
> changed
> Oct 27 11:33:41 Arzamas kernel: ata6: SError: { 10B8B }
> Oct 27 11:33:41 Arzamas kernel: ata6.00: cmd
> ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> Oct 27 11:33:41 Arzamas kernel: res 06/37:00:00:00:00/00:00:00:00:06/00
> Emask 0x12 (ATA bus error)
> Oct 27 11:33:41 Arzamas kernel: ata6.00: error: { IDNF ABRT }
> Oct 27 11:33:41 Arzamas kernel: ata6: hard resetting link
> Oct 27 11:33:46 Arzamas kernel: ata6: SATA link up 3.0 Gbps (SStatus 123
> SControl 0)
> Oct 27 11:33:46 Arzamas kernel: ata6.00: configured for UDMA/100
> Oct 27 11:33:46 Arzamas kernel: ata6: EH complete
> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] 488397168 512-byte
> hardware sectors (250059 MB)
> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Write Protect is off
> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Write cache: enabled,
> read cache: enabled, doesn't support DPO or FUA
> Oct 27 11:33:46 Arzamas kernel: end_request: I/O error, dev sde, sector
> 488166955

The saga continues. After replacing the drive (and I didn't make a
mistake as the serial numbers don't match) I got _exaclty_ the same
error a week later. I have replaced the cable for the drive in question,
 will see what happens. The controller is:

02:03.0 Mass storage controller: Silicon Image, Inc. SiI 3124 PCI-X
Serial ATA Controller (rev 02)
	Subsystem: Silicon Image, Inc. SiI 3124 PCI-X Serial ATA Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr+
Stepping+ SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 25
	Region 0: Memory at fc5fd800 (64-bit, non-prefetchable) [size=128]
	Region 2: Memory at fc5f0000 (64-bit, non-prefetchable) [size=32K]
	Region 4: I/O ports at b000 [size=16]
	Expansion ROM at fc480000 [disabled] [size=512K]
	Capabilities: [64] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [40] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=512 OST=12
		Status: Dev=ff:1f.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048
DMOST=12 DMCRS=128 RSCEM- 266MHz- 533MHz-
	Capabilities: [54] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: sata_sil24


Anyone has any bright ideas?

Thanks

New log follows:

Nov  8 15:41:18 Arzamas kernel: ata6.00: exception Emask 0x10 SAct 0x0
SErr 0x80000 action 0xe frozen
Nov  8 15:41:18 Arzamas kernel: ata6.00: irq_stat 0x01100010, PHY RDY
changed
Nov  8 15:41:18 Arzamas kernel: ata6: SError: { 10B8B }
Nov  8 15:41:18 Arzamas kernel: ata6.00: cmd
ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
Nov  8 15:41:18 Arzamas kernel: res 06/37:00:00:00:00/00:00:00:00:06/00
Emask 0x12 (ATA bus error)
Nov  8 15:41:18 Arzamas kernel: ata6.00: error: { IDNF ABRT }
Nov  8 15:41:18 Arzamas kernel: ata6: hard resetting link
Nov  8 15:41:22 Arzamas kernel: ata6: SATA link up 3.0 Gbps (SStatus 123
SControl 0)
Nov  8 15:41:22 Arzamas kernel: ata6.00: configured for UDMA/100
Nov  8 15:41:22 Arzamas kernel: ata6: EH complete
Nov  8 15:41:22 Arzamas kernel: sd 6:0:0:0: [sde] 488397168 512-byte
hardware sectors (250059 MB)
Nov  8 15:41:22 Arzamas kernel: sd 6:0:0:0: [sde] Write Protect is off
Nov  8 15:41:22 Arzamas kernel: sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
Nov  8 15:41:22 Arzamas kernel: sd 6:0:0:0: [sde] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Nov  8 15:41:22 Arzamas kernel: end_request: I/O error, dev sde, sector
488166955
Nov  8 15:41:22 Arzamas kernel: md: super_written gets error=-5, uptodate=0
Nov  8 15:41:22 Arzamas kernel: raid10: Disk failure on sde2, disabling
device.
Nov  8 15:41:22 Arzamas kernel: raid10: Operation continuing on 3 devices.


smartctl -a of new drive:

smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Second Generation Serial ATA family
Device Model:     WDC WD2500AAJS-08B4A0
Serial Number:    WD-WMAT14036837
Firmware Version: 01.03A01
User Capacity:    250,059,350,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Fri Nov 14 13:22:23 2008 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84)	Offline data collection activity
					was suspended by an interrupting command from host.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine
completed
					without error or no self-test has ever
					been run.
Total time to complete Offline
data collection: 		 (5580) seconds.
Offline data collection
capabilities: 			 (0x7b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 (  68) minutes.
Conveyance self-test routine
recommended polling time: 	 (   5) minutes.
SCT capabilities: 	       (0x303f)	SCT Status supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always
      -       0
  3 Spin_Up_Time            0x0027   174   174   021    Pre-fail  Always
      -       2266
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always
      -       9
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always
      -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Always
      -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always
      -       329
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Always
      -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Always
      -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always
      -       7
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always
      -       6
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always
      -       9
194 Temperature_Celsius     0x0022   106   103   000    Old_age   Always
      -       37
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always
      -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always
      -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always
      -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%        20
     -
# 2  Extended offline    Completed without error       00%        14
     -
# 3  Short offline       Completed without error       00%         1
     -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.
