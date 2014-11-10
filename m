From: "P. Gautschi" <linuxlist@gautschi.net>
Subject: Disks never stop spinning
Date: Mon, 10 Nov 2014 19:44:24 +0100
Message-ID: <54610788.6060103@gautschi.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050104050903010509040204"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------050104050903010509040204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I've got an array (on kubuntu 14.10) with 5 WD-RED drives and would like
them to stop rotating when there is no access for 10 minutes.

I used hdparm -S 120 for all of them but they keep on running.

I stopped the arrays but this does not help either. The problem might therefor
be unrelated to mdadm. However stopping idle disks on notebooks and desktops
too should be common and I would assume that the general mechanisms are
working. Also for NAS stopping disks should be widely used.

Any ideas why the disks never enter standby or sleep state or how to solve
the problem?

Patrick

PS: I found a hint mentioning SMART tests running in the background could cause
this problem. As far as I understand the output of smartctl, no tests are running
on my disks.

--------------050104050903010509040204
Content-Type: text/plain;
 name="hdinfo.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="hdinfo.txt"


/dev/sdf:

 Model=WDC WD60EFRX-68MYMN1, FwRev=82.00A82, SerialNo=WD-WX11D4415118
 Config={ HardSect NotMFM HdSw>15uSec SpinMotCtl Fixed DTR>5Mbs FmtGapReq }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=0
 BuffType=unknown, BuffSize=unknown, MaxMultSect=16, MultSect=16
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=11721045168
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio3 pio4 
 DMA modes:  mdma0 mdma1 mdma2 
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 *udma6 
 AdvancedPM=no WriteCache=enabled
 Drive conforms to: Reserved:  ATA/ATAPI-1,2,3,4,5,6,7

 * signifies the current active mode


ATA device, with non-removable media
	Model Number:       WDC WD60EFRX-68MYMN1                    
	Serial Number:      WD-WX11D4415118
	Firmware Revision:  82.00A82
	Transport:          Serial, SATA 1.0a, SATA II Extensions, SATA Rev 2.5, SATA Rev 2.6, SATA Rev 3.0
Standards:
	Used: unknown (minor revision code 0x001f) 
	Supported: 9 8 7 6 5 
	Likely used: 9
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  268435455
	LBA48  user addressable sectors:11721045168
	Logical  Sector size:                   512 bytes
	Physical Sector size:                  4096 bytes
	Logical Sector-0 offset:                  0 bytes
	device size with M = 1024*1024:     5723166 MBytes
	device size with M = 1000*1000:     6001175 MBytes (6001 GB)
	cache/buffer size  = unknown
	Nominal Media Rotation Rate: 5700
Capabilities:
	LBA, IORDY(can be disabled)
	Queue depth: 32
	Standby timer values: spec'd by Standard, with device specific minimum
	R/W multiple sector transfer: Max = 16	Current = 16
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6 
	     Cycle time: min=120ns recommended=120ns
	PIO: pio0 pio1 pio2 pio3 pio4 
	     Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	    	Security Mode feature set
	   *	Power Management feature set
	   *	Write cache
	   *	Look-ahead
	   *	Host Protected Area feature set
	   *	WRITE_BUFFER command
	   *	READ_BUFFER command
	   *	NOP cmd
	   *	DOWNLOAD_MICROCODE
	    	Power-Up In Standby feature set
	   *	SET_FEATURES required to spinup after power up
	    	SET_MAX security extension
	   *	48-bit Address feature set
	   *	Device Configuration Overlay feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SMART error logging
	   *	SMART self-test
	    	Media Card Pass-Through
	   *	General Purpose Logging feature set
	   *	64-bit World wide name
	   *	URG for READ_STREAM[_DMA]_EXT
	   *	URG for WRITE_STREAM[_DMA]_EXT
	   *	IDLE_IMMEDIATE with UNLOAD
	   *	WRITE_UNCORRECTABLE_EXT command
	   *	{READ,WRITE}_DMA_EXT_GPL commands
	   *	Segmented DOWNLOAD_MICROCODE
	   *	Gen1 signaling speed (1.5Gb/s)
	   *	Gen2 signaling speed (3.0Gb/s)
	   *	Gen3 signaling speed (6.0Gb/s)
	   *	Native Command Queueing (NCQ)
	   *	Host-initiated interface power management
	   *	Phy event counters
	   *	Idle-Unload when NCQ is active
	   *	NCQ priority information
	   *	READ_LOG_DMA_EXT equivalent to READ_LOG_EXT
	   *	DMA Setup Auto-Activate optimization
	   *	Device-initiated interface power management
	   *	Software settings preservation
	   *	SMART Command Transport (SCT) feature set
	   *	SCT Write Same (AC2)
	   *	SCT Error Recovery Control (AC3)
	   *	SCT Features Control (AC4)
	   *	SCT Data Tables (AC5)
	    	unknown 206[12] (vendor specific)
	    	unknown 206[13] (vendor specific)
	   *	DOWNLOAD MICROCODE DMA command
	   *	WRITE BUFFER DMA command
	   *	READ BUFFER DMA command
Security: 
	Master password revision code = 65534
		supported
	not	enabled
	not	locked
		frozen
	not	expired: security count
		supported: enhanced erase
Logical Unit WWN Device Identifier: 50014ee0ae896953
	NAA		: 5
	IEEE OUI	: 0014ee
	Unique ID	: 0ae896953
Checksum: correct

--------------050104050903010509040204
Content-Type: text/plain;
 name="smart.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="smart.txt"

smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-24-generic] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD60EFRX-68MYMN1
Serial Number:    WD-WX11D4415118
LU WWN Device Id: 5 0014ee 0ae896953
Firmware Version: 82.00A82
User Capacity:    6'001'175'126'016 bytes [6.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5700 rpm
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Nov 10 18:20:06 2014 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00)	Offline data collection activity
					was never started.
					Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		( 5204) seconds.
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
recommended polling time: 	 ( 705) minutes.
Conveyance self-test routine
recommended polling time: 	 (   5) minutes.
SCT capabilities: 	       (0x303d)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
  3 Spin_Up_Time            POS--K   201   201   021    -    8925
  4 Start_Stop_Count        -O--CK   100   100   000    -    11
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   100   100   000    -    16
 10 Spin_Retry_Count        -O--CK   100   253   000    -    0
 11 Calibration_Retry_Count -O--CK   100   253   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    6
192 Power-Off_Retract_Count -O--CK   200   200   000    -    3
193 Load_Cycle_Count        -O--CK   200   200   000    -    11
194 Temperature_Celsius     -O---K   121   113   000    -    31
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   100   253   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   100   253   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb6  GPL,SL  VS       1  Device vendor specific log
0xb7       GPL,SL  VS      40  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
No Errors Logged

SMART Error Log Version: 1
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]


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

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    31 Celsius
Power Cycle Min/Max Temperature:     28/31 Celsius
Lifetime    Min/Max Temperature:     20/39 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (50)

Index    Estimated Time   Temperature Celsius
  51    2014-11-10 10:23    35  ****************
 ...    ..(125 skipped).    ..  ****************
 177    2014-11-10 12:29    35  ****************
 178    2014-11-10 12:30    34  ***************
 ...    ..(247 skipped).    ..  ***************
 426    2014-11-10 16:38    34  ***************
 427    2014-11-10 16:39     ?  -
 428    2014-11-10 16:40    34  ***************
 ...    ..(  2 skipped).    ..  ***************
 431    2014-11-10 16:43    34  ***************
 432    2014-11-10 16:44    33  **************
 ...    ..(  6 skipped).    ..  **************
 439    2014-11-10 16:51    33  **************
 440    2014-11-10 16:52     ?  -
 441    2014-11-10 16:53    20  *
 ...    ..(  2 skipped).    ..  *
 444    2014-11-10 16:56    20  *
 445    2014-11-10 16:57    21  **
 446    2014-11-10 16:58     ?  -
 447    2014-11-10 16:59    21  **
 448    2014-11-10 17:00    22  ***
 449    2014-11-10 17:01    22  ***
 450    2014-11-10 17:02    23  ****
 451    2014-11-10 17:03    23  ****
 452    2014-11-10 17:04    23  ****
 453    2014-11-10 17:05    24  *****
 454    2014-11-10 17:06    24  *****
 455    2014-11-10 17:07    24  *****
 456    2014-11-10 17:08     ?  -
 457    2014-11-10 17:09    25  ******
 458    2014-11-10 17:10    25  ******
 459    2014-11-10 17:11    25  ******
 460    2014-11-10 17:12    26  *******
 ...    ..(  4 skipped).    ..  *******
 465    2014-11-10 17:17    26  *******
 466    2014-11-10 17:18    27  ********
 ...    ..(  6 skipped).    ..  ********
 473    2014-11-10 17:25    27  ********
 474    2014-11-10 17:26     ?  -
 475    2014-11-10 17:27    28  *********
 ...    ..(  3 skipped).    ..  *********
   1    2014-11-10 17:31    28  *********
   2    2014-11-10 17:32    29  **********
 ...    ..(  3 skipped).    ..  **********
   6    2014-11-10 17:36    29  **********
   7    2014-11-10 17:37    30  ***********
 ...    ..(  3 skipped).    ..  ***********
  11    2014-11-10 17:41    30  ***********
  12    2014-11-10 17:42    31  ************
 ...    ..( 37 skipped).    ..  ************
  50    2014-11-10 18:20    31  ************

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

Device Statistics (GP Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2            2  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            3  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4         3231  Vendor specific


--------------050104050903010509040204--
