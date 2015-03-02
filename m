From: "Wilson, Jonathan" <piercing_male@hotmail.com>
Subject: Riad scrub generated errors, should I worry?
Date: Mon, 2 Mar 2015 14:36:51 +0000
Message-ID: <BLU436-SMTP203777F3704141DF5C096B898100@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

While the monthly scrub was running the following errors (at the bottom
of the post, copied from syslog) were issued.

I ran a full test smartctl -l selftest /dev/sdf and no errors were
found.

I did notice that the drive also upped its "raw read error rate" by a
value of 4 from zero, but has since issued no further errors or
problems.


> === START OF INFORMATION SECTION ===
> Model Family:     Western Digital Red (AF)
> Device Model:     WDC WD30EFRX-68EUZN0
> Serial Number:    WD-WMC4N0990925
> LU WWN Device Id: 5 0014ee 603e8733c
> Firmware Version: 80.00A80
> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    5400 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ACS-2 (minor revision not indicated)
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
> Local Time is:    Mon Mar  2 14:26:46 2015 GMT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> 
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
> 
> General SMART Values:
> Offline data collection status:  (0x00)	Offline data collection activity
> 					was never started.
> 					Auto Offline Data Collection: Disabled.
> Self-test execution status:      (   0)	The previous self-test routine completed
> 					without error or no self-test has ever 
> 					been run.
> Total time to complete Offline 
> data collection: 		(40860) seconds.
> Offline data collection
> capabilities: 			 (0x7b) SMART execute Offline immediate.
> 					Auto Offline data collection on/off support.
> 					Suspend Offline collection upon new
> 					command.
> 					Offline surface scan supported.
> 					Self-test supported.
> 					Conveyance Self-test supported.
> 					Selective Self-test supported.
> SMART capabilities:            (0x0003)	Saves SMART data before entering
> 					power-saving mode.
> 					Supports SMART auto save timer.
> Error logging capability:        (0x01)	Error logging supported.
> 					General Purpose Logging supported.
> Short self-test routine 
> recommended polling time: 	 (   2) minutes.
> Extended self-test routine
> recommended polling time: 	 ( 410) minutes.
> Conveyance self-test routine
> recommended polling time: 	 (   5) minutes.
> SCT capabilities: 	       (0x703d)	SCT Status supported.
> 					SCT Error Recovery Control supported.
> 					SCT Feature Control supported.
> 					SCT Data Table supported.
> 
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       4
>   3 Spin_Up_Time            0x0027   186   179   021    Pre-fail  Always       -       5683
>   4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       156
>   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
>   7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Always       -       0
>   9 Power_On_Hours          0x0032   085   085   000    Old_age   Always       -       10965
>  10 Spin_Retry_Count        0x0032   100   100   000    Old_age   Always       -       0
>  11 Calibration_Retry_Count 0x0032   100   100   000    Old_age   Always       -       0
>  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       156
> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       91
> 193 Load_Cycle_Count        0x0032   199   199   000    Old_age   Always       -       4453
> 194 Temperature_Celsius     0x0022   118   111   000    Old_age   Always       -       32
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       0
> 198 Offline_Uncorrectable   0x0030   100   253   000    Old_age   Offline      -       0
> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       0
> 200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offline      -       0
> 
> SMART Error Log Version: 1
> No Errors Logged
> 
> SMART Self-test log structure revision number 1
> Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
> # 1  Extended offline    Completed without error       00%     10949         -
> # 2  Extended offline    Completed without error       00%      5486         -
> # 3  Short offline       Completed without error       00%      5478         -
> 
> SMART Selective self-test log data structure revision number 1
>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>     1        0        0  Not_testing
>     2        0        0  Not_testing
>     3        0        0  Not_testing
>     4        0        0  Not_testing
>     5        0        0  Not_testing
> Selective self-test flags (0x0):
>   After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute delay.

As you can see above the extended off line completed without error.

I'm guessing it might be a case of "watch and see" if more errors start
to happen then look at RMA'ing it? Or is the RRER a non
issue/manufacture specific doesn't mean much in its own rights value?

I also read that it can sometimes be caused by bad cables or noise bleed
from unshielded cables, but would that hold true when the device it self
knows a problem of some description related to it self has happened as
opposed to the kernel throwing a wobbler but the drive not reporting
anything. (I have had old/cheap sata cables cause intermittent kernel
floods along the line of "device ata, resetting, link down" but none of
these caused the drive it self to issue/know of any problems.

>  12:50:44 borgCube kernel: [253970.367307] ata6.00: exception Emask 0x0 SAct 0x1e00 SErr 0x0 action 0x0
> Mar  1 12:50:44 borgCube kernel: [253970.367309] ata6.00: irq_stat 0x40000008
> Mar  1 12:50:44 borgCube kernel: [253970.367311] ata6.00: failed command: READ FPDMA QUEUED
> Mar  1 12:50:44 borgCube kernel: [253970.367313] ata6.00: cmd 60/00:48:d0:b9:96/04:00:52:01:00/40 tag 9 ncq 524288 in
> Mar  1 12:50:44 borgCube kernel: [253970.367313]          res 41/40:00:d8:bc:96/00:00:52:01:00/40 Emask 0x409 (media error) <F>
> Mar  1 12:50:44 borgCube kernel: [253970.367314] ata6.00: status: { DRDY ERR }
> Mar  1 12:50:44 borgCube kernel: [253970.367314] ata6.00: error: { UNC }
> Mar  1 12:50:44 borgCube kernel: [253970.368337] ata6.00: configured for UDMA/133
> Mar  1 12:50:44 borgCube kernel: [253970.368365] sd 5:0:0:0: [sdf] Unhandled sense code
> Mar  1 12:50:44 borgCube kernel: [253970.368366] sd 5:0:0:0: [sdf]  
> Mar  1 12:50:44 borgCube kernel: [253970.368366] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Mar  1 12:50:44 borgCube kernel: [253970.368367] sd 5:0:0:0: [sdf]  
> Mar  1 12:50:44 borgCube kernel: [253970.368368] Sense Key : Medium Error [current] [descriptor]
> Mar  1 12:50:44 borgCube kernel: [253970.368369] Descriptor sense data with sense descriptors (in hex):
> Mar  1 12:50:44 borgCube kernel: [253970.368369]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
> Mar  1 12:50:44 borgCube kernel: [253970.368372]         52 96 bc d8 
> Mar  1 12:50:44 borgCube kernel: [253970.368374] sd 5:0:0:0: [sdf]  
> Mar  1 12:50:44 borgCube kernel: [253970.368375] Add. Sense: Unrecovered read error - auto reallocate failed
> Mar  1 12:50:44 borgCube kernel: [253970.368375] sd 5:0:0:0: [sdf] CDB: 
> Mar  1 12:50:44 borgCube kernel: [253970.368376] Read(16): 88 00 00 00 00 01 52 96 b9 d0 00 00 04 00 00 00
> Mar  1 12:50:44 borgCube kernel: [253970.368380] end_request: I/O error, dev sdf, sector 5680577752
> Mar  1 12:50:44 borgCube kernel: [253970.368391] ata6: EH complete
> Mar  1 12:50:48 borgCube kernel: [253974.067305] ata6.00: exception Emask 0x0 SAct 0x10 SErr 0x0 action 0x0
> Mar  1 12:50:48 borgCube kernel: [253974.067307] ata6.00: irq_stat 0x40000008
> Mar  1 12:50:48 borgCube kernel: [253974.067309] ata6.00: failed command: READ FPDMA QUEUED
> Mar  1 12:50:48 borgCube kernel: [253974.067311] ata6.00: cmd 60/80:20:d8:bc:96/00:00:52:01:00/40 tag 4 ncq 65536 in
> Mar  1 12:50:48 borgCube kernel: [253974.067311]          res 41/40:00:d8:bc:96/00:00:52:01:00/40 Emask 0x409 (media error) <F>
> Mar  1 12:50:48 borgCube kernel: [253974.067312] ata6.00: status: { DRDY ERR }
> Mar  1 12:50:48 borgCube kernel: [253974.067312] ata6.00: error: { UNC }
> Mar  1 12:50:48 borgCube kernel: [253974.068360] ata6.00: configured for UDMA/133
> Mar  1 12:50:48 borgCube kernel: [253974.068368] sd 5:0:0:0: [sdf] Unhandled sense code
> Mar  1 12:50:48 borgCube kernel: [253974.068369] sd 5:0:0:0: [sdf]  
> Mar  1 12:50:48 borgCube kernel: [253974.068369] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Mar  1 12:50:48 borgCube kernel: [253974.068370] sd 5:0:0:0: [sdf]  
> Mar  1 12:50:48 borgCube kernel: [253974.068371] Sense Key : Medium Error [current] [descriptor]
> Mar  1 12:50:48 borgCube kernel: [253974.068372] Descriptor sense data with sense descriptors (in hex):
> Mar  1 12:50:48 borgCube kernel: [253974.068373]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
> Mar  1 12:50:48 borgCube kernel: [253974.068375]         52 96 bc d8 
> Mar  1 12:50:48 borgCube kernel: [253974.068377] sd 5:0:0:0: [sdf]  
> Mar  1 12:50:48 borgCube kernel: [253974.068378] Add. Sense: Unrecovered read error - auto reallocate failed
> Mar  1 12:50:48 borgCube kernel: [253974.068378] sd 5:0:0:0: [sdf] CDB: 
> Mar  1 12:50:48 borgCube kernel: [253974.068379] Read(16): 88 00 00 00 00 01 52 96 bc d8 00 00 00 80 00 00
> Mar  1 12:50:48 borgCube kernel: [253974.068383] end_request: I/O error, dev sdf, sector 5680577752
> Mar  1 12:50:48 borgCube kernel: [253974.068392] ata6: EH complete
> Mar  1 12:50:48 borgCube kernel: [253974.238221] md/raid:md51: read error corrected (8 sectors at 5478837464 on sdf5)
> Mar  1 12:50:48 borgCube kernel: [253974.238226] md/raid:md51: read error corrected (8 sectors at 5478837472 on sdf5)
> Mar  1 12:50:48 borgCube kernel: [253974.238227] md/raid:md51: read error corrected (8 sectors at 5478837480 on sdf5)
> Mar  1 12:50:48 borgCube kernel: [253974.238228] md/raid:md51: read error corrected (8 sectors at 5478837488 on sdf5)
> Mar  1 12:50:48 borgCube kernel: [253974.238229] md/raid:md51: read error corrected (8 sectors at 5478837496 on sdf5)
> Mar  1 12:50:48 borgCube kernel: [253974.238231] md/raid:md51: read error corrected (8 sectors at 5478837504 on sdf5)
> Mar  1 12:50:48 borgCube kernel: [253974.238232] md/raid:md51: read error corrected (8 sectors at 5478837512 on sdf5)
> Mar  1 12:50:48 borgCube kernel: [253974.238233] md/raid:md51: read error corrected (8 sectors at 5478837520 on sdf5)
> Mar  1 12:50:48 borgCube kernel: [253974.238234] md/raid:md51: read error corrected (8 sectors at 5478837528 on sdf5)
> Mar  1 12:50:48 borgCube kernel: [253974.238235] md/raid:md51: read error corrected (8 sectors at 5478837536 on sdf5)
> Mar  1 12:50:52 borgCube kernel: [253977.979357] ata6.00: exception Emask 0x0 SAct 0x60 SErr 0x0 action 0x0
> Mar  1 12:50:52 borgCube kernel: [253977.979359] ata6.00: irq_stat 0x40000008
> Mar  1 12:50:52 borgCube kernel: [253977.979361] ata6.00: failed command: READ FPDMA QUEUED
> Mar  1 12:50:52 borgCube kernel: [253977.979364] ata6.00: cmd 60/00:28:d8:c1:96/04:00:52:01:00/40 tag 5 ncq 524288 in
> Mar  1 12:50:52 borgCube kernel: [253977.979364]          res 41/40:00:18:c3:96/00:00:52:01:00/40 Emask 0x409 (media error) <F>
> Mar  1 12:50:52 borgCube kernel: [253977.979366] ata6.00: status: { DRDY ERR }
> Mar  1 12:50:52 borgCube kernel: [253977.979366] ata6.00: error: { UNC }
> Mar  1 12:50:52 borgCube kernel: [253977.980565] ata6.00: configured for UDMA/133
> Mar  1 12:50:52 borgCube kernel: [253977.980591] sd 5:0:0:0: [sdf] Unhandled sense code
> Mar  1 12:50:52 borgCube kernel: [253977.980592] sd 5:0:0:0: [sdf]  
> Mar  1 12:50:52 borgCube kernel: [253977.980593] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Mar  1 12:50:52 borgCube kernel: [253977.980594] sd 5:0:0:0: [sdf]  
> Mar  1 12:50:52 borgCube kernel: [253977.980595] Sense Key : Medium Error [current] [descriptor]
> Mar  1 12:50:52 borgCube kernel: [253977.980597] Descriptor sense data with sense descriptors (in hex):
> Mar  1 12:50:52 borgCube kernel: [253977.980598]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
> Mar  1 12:50:52 borgCube kernel: [253977.980602]         52 96 c3 18 
> Mar  1 12:50:52 borgCube kernel: [253977.980604] sd 5:0:0:0: [sdf]  
> Mar  1 12:50:52 borgCube kernel: [253977.980605] Add. Sense: Unrecovered read error - auto reallocate failed
> Mar  1 12:50:52 borgCube kernel: [253977.980606] sd 5:0:0:0: [sdf] CDB: 
> Mar  1 12:50:52 borgCube kernel: [253977.980607] Read(16): 88 00 00 00 00 01 52 96 c1 d8 00 00 04 00 00 00
> Mar  1 12:50:52 borgCube kernel: [253977.980612] end_request: I/O error, dev sdf, sector 5680579352
> Mar  1 12:50:52 borgCube kernel: [253977.980636] ata6: EH complete
> Mar  1 12:50:55 borgCube kernel: [253981.511344] ata6.00: exception Emask 0x0 SAct 0x3ff00 SErr 0x0 action 0x0
> Mar  1 12:50:55 borgCube kernel: [253981.511346] ata6.00: irq_stat 0x40000008
> Mar  1 12:50:55 borgCube kernel: [253981.511348] ata6.00: failed command: READ FPDMA QUEUED
> Mar  1 12:50:55 borgCube kernel: [253981.511350] ata6.00: cmd 60/80:40:18:c3:96/00:00:52:01:00/40 tag 8 ncq 65536 in
> Mar  1 12:50:55 borgCube kernel: [253981.511350]          res 41/40:00:18:c3:96/00:00:52:01:00/40 Emask 0x409 (media error) <F>
> Mar  1 12:50:55 borgCube kernel: [253981.511351] ata6.00: status: { DRDY ERR }
> Mar  1 12:50:55 borgCube kernel: [253981.511351] ata6.00: error: { UNC }
> Mar  1 12:50:55 borgCube kernel: [253981.512557] ata6.00: configured for UDMA/133
> Mar  1 12:50:55 borgCube kernel: [253981.512567] sd 5:0:0:0: [sdf] Unhandled sense code
> Mar  1 12:50:55 borgCube kernel: [253981.512568] sd 5:0:0:0: [sdf]  
> Mar  1 12:50:55 borgCube kernel: [253981.512569] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Mar  1 12:50:55 borgCube kernel: [253981.512570] sd 5:0:0:0: [sdf]  
> Mar  1 12:50:55 borgCube kernel: [253981.512570] Sense Key : Medium Error [current] [descriptor]
> Mar  1 12:50:55 borgCube kernel: [253981.512572] Descriptor sense data with sense descriptors (in hex):
> Mar  1 12:50:55 borgCube kernel: [253981.512572]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01 
> Mar  1 12:50:55 borgCube kernel: [253981.512575]         52 96 c3 18 
> Mar  1 12:50:55 borgCube kernel: [253981.512576] sd 5:0:0:0: [sdf]  
> Mar  1 12:50:55 borgCube kernel: [253981.512577] Add. Sense: Unrecovered read error - auto reallocate failed
> Mar  1 12:50:55 borgCube kernel: [253981.512578] sd 5:0:0:0: [sdf] CDB: 
> Mar  1 12:50:55 borgCube kernel: [253981.512579] Read(16): 88 00 00 00 00 01 52 96 c3 18 00 00 00 80 00 00
> Mar  1 12:50:55 borgCube kernel: [253981.512582] end_request: I/O error, dev sdf, sector 5680579352
> Mar  1 12:50:55 borgCube kernel: [253981.512596] ata6: EH complete
> Mar  1 12:50:55 borgCube kernel: [253981.635156] raid5_end_read_request: 6 callbacks suppressed
> Mar  1 12:50:55 borgCube kernel: [253981.635163] md/raid:md51: read error corrected (8 sectors at 5478839064 on sdf5)
> Mar  1 12:50:55 borgCube kernel: [253981.635165] md/raid:md51: read error corrected (8 sectors at 5478839072 on sdf5)
> Mar  1 12:50:55 borgCube kernel: [253981.635167] md/raid:md51: read error corrected (8 sectors at 5478839080 on sdf5)
> Mar  1 12:50:55 borgCube kernel: [253981.635168] md/raid:md51: read error corrected (8 sectors at 5478839088 on sdf5)
> Mar  1 12:50:55 borgCube kernel: [253981.635170] md/raid:md51: read error corrected (8 sectors at 5478839096 on sdf5)
> Mar  1 12:50:55 borgCube kernel: [253981.635171] md/raid:md51: read error corrected (8 sectors at 5478839104 on sdf5)
> Mar  1 12:50:55 borgCube kernel: [253981.635173] md/raid:md51: read error corrected (8 sectors at 5478839112 on sdf5)
> Mar  1 12:50:55 borgCube kernel: [253981.635174] md/raid:md51: read error corrected (8 sectors at 5478839120 on sdf5)
> Mar  1 12:50:55 borgCube kernel: [253981.635176] md/raid:md51: read error corrected (8 sectors at 5478839128 on sdf5)
> Mar  1 12:50:55 borgCube kernel: [253981.635178] md/raid:md51: read error corrected (8 sectors at 5478839136 on sdf5)
> Mar  1 13:16:42 borgCube kernel: [255528.361600] md: md51: data-check done.

