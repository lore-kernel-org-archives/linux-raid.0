From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: Persistent failures with simple md setup
Date: Mon, 04 Feb 2013 21:43:29 +0100
Message-ID: <2286786.BnthJ2WIKW@xrated>
References: <1565063.1kpR7lz4Ph@xrated> <5108E2CC.4010806@profitbricks.com> <2432282.A1IPyQ9pEc@xrated>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart19433612.vMEs1lTuFL"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2432282.A1IPyQ9pEc@xrated>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.

--nextPart19433612.vMEs1lTuFL
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Mittwoch, 30. Januar 2013, 18:12:46 schrieb Hans-Peter Jansen:
> 
> Hmm, according to mdadm from openSUSE:12.1:Update, the relevant fixes should
> be in place. It might be an unfortunate combination of this issue and the
> asynchronously applied updates, interfered by the *switching* behavior.
> 
> I started with regenerating the initrds now, and a first reboot succeeded so
> far. Good.
> 
> Will ask my friend to reboot the system a dozen times tonight.

After a few reboots, the issue reappeared. I really believe now, that by
driving the md in degraded mode for some time and with the switching behavior, 
just re-adding the devices resulted in unsynced raid1 devices.

Next, my friend managed to create a nearby data disaster: I've explained him,
how he would be able to re-add a device himself. He did so on sunday with his
home partition, and since there appeared no progress bar in /proc/mdstat, he 
immediately repeated the command. 

Neil, is it conceivable (due to a race or the like), that repeating to add 
(re-add) a device potentially creates data salad, since that home-fs (xfs) 
gone mad a few minutes later (firefox crashed, and couldn't be started, kmail 
crashed, and so on (all those processes, that write to ~). He decided to 
reboot, and that jailed him in the emergency recovery console, because /home 
couldn't be mounted anymore.

Both parts of the mirror were affected, the "old" part was ~200kb 
undestructive xfs_repair log, the other ~900kb, hence I decided to use the 
smaller one. First I failed and removed the other part, and then attempted to 
repair it. Unfortunately, the real repair run bailed out with:

disconnected inode 2161430687, moving to lost+found
corrupt dinode 2161430687, extent total = 1, nblocks = 0.  This is a bug.
Please capture the filesystem metadata with xfs_metadump and
report it to xfs@oss.sgi.com.
cache_node_purge: refcount was 1, not zero (node=0xf867208)

fatal error -- 117 - couldn't iget disconnected inode

although I already used the (current) xfsprogs-3.1.6 version. :-(

After fixing that issue manually with xfs_db (== great fun), I was able to
recover the filesystem. It lost(+found) just a few new items, nobody cares 
about... So far, so good..

Now, the unsynced state disturbed me. Just re-adding the bad device might
result in an invalid mirror again. A "repair" run cannot be controlled. Hence
I zeroed the superblock of that partition, and added it. Et voila, it 
completely synced that mirror. Good.

Today, I hammered the raid1 partitions with "check". During one run, this 
appeared in syslog:

Feb  4 11:18:26 zaphkiel kernel: [11165.652478] ata2.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x0
Feb  4 11:18:26 zaphkiel kernel: [11165.652486] ata2.00: irq_stat 0x40000008
Feb  4 11:18:26 zaphkiel kernel: [11165.652495] ata2.00: failed command: READ FPDMA QUEUED
Feb  4 11:18:26 zaphkiel kernel: [11165.652510] ata2.00: cmd 60/80:e0:12:ef:c2/00:00:0c:00:00/40 tag 28 ncq 65536 in
Feb  4 11:18:26 zaphkiel kernel: [11165.652513]          res 41/40:53:3f:ef:c2/00:00:0c:00:00/40 Emask 0x409 (media error) <F>
Feb  4 11:18:26 zaphkiel kernel: [11165.652520] ata2.00: status: { DRDY ERR }
Feb  4 11:18:26 zaphkiel kernel: [11165.652524] ata2.00: error: { UNC }
Feb  4 11:18:26 zaphkiel kernel: [11165.652876] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x100)
Feb  4 11:18:26 zaphkiel kernel: [11165.652882] ata2.00: revalidation failed (errno=-5)
Feb  4 11:18:26 zaphkiel kernel: [11165.652890] ata2: hard resetting link
Feb  4 11:18:26 zaphkiel kernel: [11165.957043] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Feb  4 11:18:26 zaphkiel kernel: [11165.969910] ata2.00: configured for UDMA/133
Feb  4 11:18:26 zaphkiel kernel: [11165.970048] ata2: EH complete
Feb  4 11:18:28 zaphkiel kernel: [11167.949241] ata2.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x0
Feb  4 11:18:28 zaphkiel kernel: [11167.949249] ata2.00: irq_stat 0x40000008
Feb  4 11:18:28 zaphkiel kernel: [11167.949257] ata2.00: failed command: READ FPDMA QUEUED
Feb  4 11:18:28 zaphkiel kernel: [11167.949272] ata2.00: cmd 60/80:10:12:ef:c2/00:00:0c:00:00/40 tag 2 ncq 65536 in
Feb  4 11:18:28 zaphkiel kernel: [11167.949275]          res 41/40:53:3f:ef:c2/00:00:0c:00:00/40 Emask 0x409 (media error) <F>
Feb  4 11:18:28 zaphkiel kernel: [11167.949282] ata2.00: status: { DRDY ERR }
Feb  4 11:18:28 zaphkiel kernel: [11167.949287] ata2.00: error: { UNC }
Feb  4 11:18:28 zaphkiel kernel: [11167.962146] ata2.00: configured for UDMA/133
Feb  4 11:18:28 zaphkiel kernel: [11167.962206] ata2: EH complete
Feb  4 11:18:30 zaphkiel kernel: [11169.898187] ata2.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x0
Feb  4 11:18:30 zaphkiel kernel: [11169.898195] ata2.00: irq_stat 0x40000008
Feb  4 11:18:30 zaphkiel kernel: [11169.898204] ata2.00: failed command: READ FPDMA QUEUED
Feb  4 11:18:30 zaphkiel kernel: [11169.898219] ata2.00: cmd 60/80:e0:12:ef:c2/00:00:0c:00:00/40 tag 28 ncq 65536 in
Feb  4 11:18:30 zaphkiel kernel: [11169.898222]          res 41/40:53:3f:ef:c2/00:00:0c:00:00/40 Emask 0x409 (media error) <F>
Feb  4 11:18:30 zaphkiel kernel: [11169.898229] ata2.00: status: { DRDY ERR }
Feb  4 11:18:30 zaphkiel kernel: [11169.898234] ata2.00: error: { UNC }
Feb  4 11:18:30 zaphkiel kernel: [11169.912066] ata2.00: configured for UDMA/133
Feb  4 11:18:30 zaphkiel kernel: [11169.912117] ata2: EH complete
Feb  4 11:18:32 zaphkiel kernel: [11171.905192] ata2.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x0
Feb  4 11:18:32 zaphkiel kernel: [11171.905200] ata2.00: irq_stat 0x40000008
Feb  4 11:18:32 zaphkiel kernel: [11171.905208] ata2.00: failed command: READ FPDMA QUEUED
Feb  4 11:18:32 zaphkiel kernel: [11171.905223] ata2.00: cmd 60/80:10:12:ef:c2/00:00:0c:00:00/40 tag 2 ncq 65536 in
Feb  4 11:18:32 zaphkiel kernel: [11171.905226]          res 41/40:53:3f:ef:c2/00:00:0c:00:00/40 Emask 0x409 (media error) <F>
Feb  4 11:18:32 zaphkiel kernel: [11171.905233] ata2.00: status: { DRDY ERR }
Feb  4 11:18:32 zaphkiel kernel: [11171.905238] ata2.00: error: { UNC }
Feb  4 11:18:32 zaphkiel kernel: [11171.919099] ata2.00: configured for UDMA/133
Feb  4 11:18:32 zaphkiel kernel: [11171.919152] ata2: EH complete
Feb  4 11:18:34 zaphkiel kernel: [11173.912191] ata2.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x0
Feb  4 11:18:34 zaphkiel kernel: [11173.912199] ata2.00: irq_stat 0x40000008
Feb  4 11:18:34 zaphkiel kernel: [11173.912208] ata2.00: failed command: READ FPDMA QUEUED
Feb  4 11:18:34 zaphkiel kernel: [11173.912223] ata2.00: cmd 60/80:e0:12:ef:c2/00:00:0c:00:00/40 tag 28 ncq 65536 in
Feb  4 11:18:34 zaphkiel kernel: [11173.912226]          res 41/40:53:3f:ef:c2/00:00:0c:00:00/40 Emask 0x409 (media error) <F>
Feb  4 11:18:34 zaphkiel kernel: [11173.912233] ata2.00: status: { DRDY ERR }
Feb  4 11:18:34 zaphkiel kernel: [11173.912238] ata2.00: error: { UNC }
Feb  4 11:18:34 zaphkiel kernel: [11173.925101] ata2.00: configured for UDMA/133
Feb  4 11:18:34 zaphkiel kernel: [11173.925159] ata2: EH complete
Feb  4 11:18:36 zaphkiel kernel: [11175.861152] ata2.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x0
Feb  4 11:18:36 zaphkiel kernel: [11175.861160] ata2.00: irq_stat 0x40000008
Feb  4 11:18:36 zaphkiel kernel: [11175.861168] ata2.00: failed command: READ FPDMA QUEUED
Feb  4 11:18:36 zaphkiel kernel: [11175.861183] ata2.00: cmd 60/80:10:12:ef:c2/00:00:0c:00:00/40 tag 2 ncq 65536 in
Feb  4 11:18:36 zaphkiel kernel: [11175.861186]          res 41/40:53:3f:ef:c2/00:00:0c:00:00/40 Emask 0x409 (media error) <F>
Feb  4 11:18:36 zaphkiel kernel: [11175.861193] ata2.00: status: { DRDY ERR }
Feb  4 11:18:36 zaphkiel kernel: [11175.861198] ata2.00: error: { UNC }
Feb  4 11:18:36 zaphkiel kernel: [11175.874052] ata2.00: configured for UDMA/133
Feb  4 11:18:36 zaphkiel kernel: [11175.874103] sd 1:0:0:0: [sdb] Unhandled sense code
Feb  4 11:18:36 zaphkiel kernel: [11175.874109] sd 1:0:0:0: [sdb]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Feb  4 11:18:36 zaphkiel kernel: [11175.874117] sd 1:0:0:0: [sdb]  Sense Key : Medium Error [current] [descriptor]
Feb  4 11:18:36 zaphkiel kernel: [11175.874125] Descriptor sense data with sense descriptors (in hex):
Feb  4 11:18:36 zaphkiel kernel: [11175.874130]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
Feb  4 11:18:36 zaphkiel kernel: [11175.874145]         0c c2 ef 3f 
Feb  4 11:18:36 zaphkiel kernel: [11175.874153] sd 1:0:0:0: [sdb]  Add. Sense: Unrecovered read error - auto reallocate failed
Feb  4 11:18:36 zaphkiel kernel: [11175.874163] sd 1:0:0:0: [sdb] CDB: Read(10): 28 00 0c c2 ef 12 00 00 80 00
Feb  4 11:18:36 zaphkiel kernel: [11175.874180] end_request: I/O error, dev sdb, sector 214101823
Feb  4 11:18:36 zaphkiel kernel: [11175.874234] ata2: EH complete
Feb  4 11:18:38 zaphkiel kernel: [11177.954091] md: md124: data-check done.

This is a classical URE, isn't it? Interestingly, nonetheless, the raid1 check 
run succeeded! (Not so good, is it?)

Before you ask, both drives have a sane timeout already:

smartctl -l scterc /dev/sda
smartctl 6.0 2012-10-10 r3643 [i686-linux-3.1.10-1.9-desktop] (SUSE RPM)
Copyright (C) 2002-12, Bruce Allen, Christian Franke, www.smartmontools.org

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)


smartctl -l scterc /dev/sdb
smartctl 6.0 2012-10-10 r3643 [i686-linux-3.1.10-1.9-desktop] (SUSE RPM)
Copyright (C) 2002-12, Bruce Allen, Christian Franke, www.smartmontools.org

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)


Attached is the result of smartctl -x of sda (good), and sdb (bad).

Could somebody from the audience have a look into it, and give me an 
assessment, how dangerous the state of this drive really is.

Last question: since I had to massage the system anyway, I've updated mdadm 
from 3.2.2 to 3.2.6. I red, that it can be dangerous to do so, what do I risk
here?

Thanks in advance,
Pete
--nextPart19433612.vMEs1lTuFL
Content-Disposition: attachment; filename="smart-sdb-20130204-140400.log"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-log; charset="UTF-8"; name="smart-sdb-20130204-140400.log"

smartctl 6.0 2012-10-10 r3643 [i686-linux-3.1.10-1.9-desktop] (SUSE RPM)
Copyright (C) 2002-12, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     SAMSUNG SpinPoint F1 RE
Device Model:     SAMSUNG HE103UJ
Serial Number:    S13VJDWS900483
LU WWN Device Id: 5 0024e9 002167ef6
Firmware Version: 1AA01118
User Capacity:    1.000.204.886.016 bytes [1,00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA/ATAPI-7, ATA8-ACS T13/1699-D revision 3b
Local Time is:    Mon Feb  4 14:04:00 2013 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Disabled
APM feature is:   Disabled
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]

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
data collection: 		(12124) seconds.
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
recommended polling time: 	 ( 203) minutes.
Conveyance self-test routine
recommended polling time: 	 (  22) minutes.
SCT capabilities: 	       (0x003f)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   099   099   051    -    531
  3 Spin_Up_Time            POS---   073   073   011    -    9000
  4 Start_Stop_Count        -O--CK   099   099   000    -    1278
  5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
  7 Seek_Error_Rate         POSR--   100   100   051    -    0
  8 Seek_Time_Performance   P-S--K   100   100   015    -    0
  9 Power_On_Hours          -O--CK   097   097   000    -    16416
 10 Spin_Retry_Count        PO--CK   100   100   051    -    0
 11 Calibration_Retry_Count -O--C-   100   100   000    -    0
 12 Power_Cycle_Count       -O--CK   099   099   000    -    1277
 13 Read_Soft_Error_Rate    -OSR--   099   099   000    -    528
183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
184 End-to-End_Error        PO--CK   100   100   000    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    1052
188 Command_Timeout         -O--CK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   076   059   000    -    24 (Min/Max 12/24)
194 Temperature_Celsius     -O---K   077   058   000    -    23 (Min/Max 12/26)
195 Hardware_ECC_Recovered  -O-RC-   100   100   000    -    19500704
196 Reallocated_Event_Count -O--CK   100   100   000    -    0
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----CK   100   100   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   253   253   000    -    0
200 Multi_Zone_Error_Rate   -O-R--   100   100   000    -    0
201 Soft_Read_Error_Rate    -O-R--   099   099   000    -    12
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
GP/S  Log at address 0x00 has    1 sectors [Log Directory]
SMART Log at address 0x01 has    1 sectors [Summary SMART error log]
SMART Log at address 0x02 has    2 sectors [Comprehensive SMART error log]
GP    Log at address 0x03 has    2 sectors [Ext. Comprehensive SMART error log]
GP    Log at address 0x04 has    2 sectors [Device Statistics log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
GP    Log at address 0x07 has    2 sectors [Extended self-test log]
SMART Log at address 0x09 has    1 sectors [Selective self-test log]
GP    Log at address 0x10 has    1 sectors [NCQ Command Error log]
GP    Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
GP    Log at address 0x20 has    2 sectors [Streaming performance log]
GP    Log at address 0x21 has    1 sectors [Write stream error log]
GP    Log at address 0x22 has    1 sectors [Read stream error log]
GP/S  Log at address 0x80 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x81 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x82 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x83 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x84 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x85 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x86 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x87 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x88 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x89 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x90 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x91 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x92 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x93 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x94 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x95 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x96 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x97 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x98 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x99 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log Version: 1 (2 sectors)
Device Error Count: 6
	CR     = Command Register
	FEATR  = Features Register
	COUNT  = Count (was: Sector Count) Register
	LBA_48 = Upper bytes of LBA High/Mid/Low Registers ]  ATA-8
	LH     = LBA High (was: Cylinder High) Register    ]   LBA
	LM     = LBA Mid (was: Cylinder Low) Register      ] Register
	LL     = LBA Low (was: Sector Number) Register     ]
	DV     = Device (was: Device/Head) Register
	DC     = Device Control Register
	ER     = Error register
	ST     = Status register
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 6 [5] occurred at disk power-on lifetime: 16413 hours (683 days + 21 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  00 -- 42 00 00 00 00 0c c2 ef 3e 40 00   at LBA = 0x0cc2ef3e = 214101822

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 80 00 00 00 c2 f2 92 40 00     03:06:50.480  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 f3 12 40 00     03:06:50.480  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 f3 92 40 00     03:06:50.480  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 f6 92 40 00     03:06:50.480  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 f7 12 40 00     03:06:50.480  READ FPDMA QUEUED

Error 5 [4] occurred at disk power-on lifetime: 16413 hours (683 days + 21 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  00 -- 42 00 00 00 00 0c c2 ef 3e 40 00   at LBA = 0x0cc2ef3e = 214101822

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 80 00 00 00 c2 f7 92 40 00     03:06:48.480  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 f5 92 40 00     03:06:48.480  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 ef 12 40 00     03:06:48.480  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 fe 12 40 00     03:06:48.480  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 fb 12 40 00     03:06:48.480  READ FPDMA QUEUED

Error 4 [3] occurred at disk power-on lifetime: 16413 hours (683 days + 21 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  00 -- 42 00 00 00 00 0c c2 ef 3e 40 00   at LBA = 0x0cc2ef3e = 214101822

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 80 00 00 00 c2 f2 92 40 00     03:06:46.470  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 f3 12 40 00     03:06:46.470  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 f3 92 40 00     03:06:46.470  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 f6 92 40 00     03:06:46.470  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 f7 12 40 00     03:06:46.470  READ FPDMA QUEUED

Error 3 [2] occurred at disk power-on lifetime: 16413 hours (683 days + 21 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  00 -- 42 00 00 00 00 0c c2 ef 3e 40 00   at LBA = 0x0cc2ef3e = 214101822

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 80 00 00 00 c2 f7 92 40 00     03:06:44.520  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 f5 92 40 00     03:06:44.520  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 ef 12 40 00     03:06:44.520  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 fe 12 40 00     03:06:44.520  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 fb 12 40 00     03:06:44.520  READ FPDMA QUEUED

Error 2 [1] occurred at disk power-on lifetime: 16413 hours (683 days + 21 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  00 -- 42 00 00 00 00 0c c2 ef 3e 40 00   at LBA = 0x0cc2ef3e = 214101822

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 80 00 00 00 c2 f2 92 40 00     03:06:42.530  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 f3 12 40 00     03:06:42.530  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 f3 92 40 00     03:06:42.530  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 f6 92 40 00     03:06:42.530  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 f7 12 40 00     03:06:42.530  READ FPDMA QUEUED

Error 1 [0] occurred at disk power-on lifetime: 16413 hours (683 days + 21 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  00 -- 42 00 00 00 00 0c c2 ef 3e 40 00   at LBA = 0x0cc2ef3e = 214101822

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 80 00 00 00 c2 fb 92 40 00     03:06:40.150  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 fb 12 40 00     03:06:40.150  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 fa 92 40 00     03:06:40.150  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 fa 12 40 00     03:06:40.150  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 c2 f9 92 40 00     03:06:40.150  READ FPDMA QUEUED

SMART Extended Self-test Log Version: 1 (2 sectors)
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

SCT Status Version:                  2
SCT Version (vendor specific):       256 (0x0100)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                 23 Celsius
Power Cycle Max Temperature:         26 Celsius
Lifetime    Max Temperature:         63 Celsius
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:     -4/72 Celsius
Min/Max Temperature Limit:           -9/77 Celsius
Temperature History Size (Index):    128 (4)

Index    Estimated Time   Temperature Celsius
   5    2013-02-04 11:57    24  *****
 ...    ..( 32 skipped).    ..  *****
  38    2013-02-04 12:30    24  *****
  39    2013-02-04 12:31    25  ******
  40    2013-02-04 12:32    24  *****
 ...    ..( 52 skipped).    ..  *****
  93    2013-02-04 13:25    24  *****
  94    2013-02-04 13:26    23  ****
 ...    ..( 37 skipped).    ..  ****
   4    2013-02-04 14:04    23  ****

SCT Error Recovery Control:
           Read:     70 (7,0 seconds)
          Write:     70 (7,0 seconds)

ATA_READ_LOG_EXT (addr=0x04:0x00, page=0, n=1) failed: scsi error aborted command
SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2            5  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2            5  Transition from drive PhyRdy to drive PhyNRdy
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0010  2            0  R_ERR response for host-to-device data FIS, non-CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x0013  2            0  R_ERR response for host-to-device non-data FIS, non-CRC


--nextPart19433612.vMEs1lTuFL
Content-Disposition: attachment; filename="smart-sda-20130204-140400.log"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-log; charset="UTF-8"; name="smart-sda-20130204-140400.log"

smartctl 6.0 2012-10-10 r3643 [i686-linux-3.1.10-1.9-desktop] (SUSE RPM)
Copyright (C) 2002-12, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     SAMSUNG SpinPoint F1 RE
Device Model:     SAMSUNG HE103UJ
Serial Number:    S13VJDWS900475
LU WWN Device Id: 5 0024e9 002167cfe
Firmware Version: 1AA01118
User Capacity:    1.000.204.886.016 bytes [1,00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA/ATAPI-7, ATA8-ACS T13/1699-D revision 3b
Local Time is:    Mon Feb  4 14:04:00 2013 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Disabled
APM feature is:   Disabled
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]

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
data collection: 		(11933) seconds.
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
recommended polling time: 	 ( 200) minutes.
Conveyance self-test routine
recommended polling time: 	 (  21) minutes.
SCT capabilities: 	       (0x003f)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   100   100   051    -    0
  3 Spin_Up_Time            POS---   072   072   011    -    9340
  4 Start_Stop_Count        -O--CK   099   099   000    -    1278
  5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
  7 Seek_Error_Rate         POSR--   100   100   051    -    0
  8 Seek_Time_Performance   P-S--K   100   100   015    -    0
  9 Power_On_Hours          -O--CK   097   097   000    -    16415
 10 Spin_Retry_Count        PO--CK   100   100   051    -    0
 11 Calibration_Retry_Count -O--C-   100   100   000    -    0
 12 Power_Cycle_Count       -O--CK   099   099   000    -    1277
 13 Read_Soft_Error_Rate    -OSR--   100   100   000    -    0
183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
184 End-to-End_Error        PO--CK   100   100   000    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    0
188 Command_Timeout         -O--CK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   077   001   000    -    23 (Min/Max 11/23)
194 Temperature_Celsius     -O---K   078   058   000    -    22 (Min/Max 11/25)
195 Hardware_ECC_Recovered  -O-RC-   100   100   000    -    3573535
196 Reallocated_Event_Count -O--CK   100   100   000    -    0
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----CK   100   100   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   100   100   000    -    0
200 Multi_Zone_Error_Rate   -O-R--   100   100   000    -    0
201 Soft_Read_Error_Rate    -O-R--   100   100   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
GP/S  Log at address 0x00 has    1 sectors [Log Directory]
SMART Log at address 0x01 has    1 sectors [Summary SMART error log]
SMART Log at address 0x02 has    2 sectors [Comprehensive SMART error log]
GP    Log at address 0x03 has    2 sectors [Ext. Comprehensive SMART error log]
GP    Log at address 0x04 has    2 sectors [Device Statistics log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
GP    Log at address 0x07 has    2 sectors [Extended self-test log]
SMART Log at address 0x09 has    1 sectors [Selective self-test log]
GP    Log at address 0x10 has    1 sectors [NCQ Command Error log]
GP    Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
GP    Log at address 0x20 has    2 sectors [Streaming performance log]
GP    Log at address 0x21 has    1 sectors [Write stream error log]
GP    Log at address 0x22 has    1 sectors [Read stream error log]
GP/S  Log at address 0x80 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x81 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x82 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x83 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x84 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x85 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x86 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x87 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x88 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x89 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x90 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x91 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x92 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x93 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x94 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x95 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x96 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x97 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x98 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x99 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log Version: 1 (2 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (2 sectors)
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

SCT Status Version:                  2
SCT Version (vendor specific):       256 (0x0100)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                 22 Celsius
Power Cycle Max Temperature:         26 Celsius
Lifetime    Max Temperature:         55 Celsius
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:     -4/72 Celsius
Min/Max Temperature Limit:           -9/77 Celsius
Temperature History Size (Index):    128 (10)

Index    Estimated Time   Temperature Celsius
  11    2013-02-04 11:57    23  ****
 ...    ..( 31 skipped).    ..  ****
  43    2013-02-04 12:29    23  ****
  44    2013-02-04 12:30    24  *****
 ...    ..(  2 skipped).    ..  *****
  47    2013-02-04 12:33    24  *****
  48    2013-02-04 12:34    23  ****
 ...    ..( 79 skipped).    ..  ****
   0    2013-02-04 13:54    23  ****
   1    2013-02-04 13:55    22  ***
 ...    ..(  8 skipped).    ..  ***
  10    2013-02-04 14:04    22  ***

SCT Error Recovery Control:
           Read:     70 (7,0 seconds)
          Write:     70 (7,0 seconds)

ATA_READ_LOG_EXT (addr=0x04:0x00, page=0, n=1) failed: scsi error aborted command
SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2            4  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2            4  Transition from drive PhyRdy to drive PhyNRdy
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0010  2            0  R_ERR response for host-to-device data FIS, non-CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x0013  2            0  R_ERR response for host-to-device non-data FIS, non-CRC


--nextPart19433612.vMEs1lTuFL--


