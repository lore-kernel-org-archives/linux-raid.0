From: Keith Phillips <spootsy.ootsy@gmail.com>
Subject: Fwd: Help with failed RAID-5 -> 6 migration
Date: Tue, 11 Jun 2013 01:46:23 +0930
Message-ID: <CAASLJ=7NyJHSMhfhmOFFVR8-7OT5sOp24_WJs-kd6zX54fOG7w@mail.gmail.com>
References: <CAASLJ=5ewoeNPV1-fwRm3o6rCxQjCYxuJTZ5M9g7p-vFpgDW-w@mail.gmail.com>
	<51B3B7FF.9080800@turmel.org>
	<CAASLJ=5JkQ8L9fbrOSUKH8Y-a7PZgkTcCsi6PW=rhzsUPRF6ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAASLJ=5JkQ8L9fbrOSUKH8Y-a7PZgkTcCsi6PW=rhzsUPRF6ow@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Apologies, Phil, if this is the second time you've got this now, but I
just realised I dropped the linux-raid group from the email.

I'm still looking at a degraded array that won't start, so any input
would be greatly appreciated.

---------- Forwarded message ----------
From: Keith Phillips <spootsy.ootsy@gmail.com>
Date: Sun, Jun 9, 2013 at 3:33 PM
Subject: Re: Help with failed RAID-5 -> 6 migration
To: Phil Turmel <philip@turmel.org>


Thanks for the response, Phil.

*snip*

> That's unfortunate.  I'm going to guess you'd still be getting errors if
> the array was running.  If you get more, please save them and report.

Entirely possible - if I can get the array started again I suppose
we'll see. All I can remember of it is an I/O error on something like
'/dev/md/0/8', with a big stack trace.

*snip*

> Please elaborate on your recent "check".  What method did you use, and
> did you get any I/O errors in you logs at that time?

There was Ubuntu's default monthly "check of redundancy data" -
admittedly I hadn't looked at this to see what it actually does, but I
was assuming it would verify the parity data for each stripe. mdadm is
configured to email me on detection of errors.

Also, I installed the new drive a day prior to actually adding it to
the array, and for some reason when I powered the machine back on the
existing array started rebuilding itself (took about 6 hours and
finished happily - no errors reported anywhere). Not a deliberate
process, but I assumed (wrongly?) that one of those would've issued
some warnings/errors if there was a problem.

 *snip*

> Not sure yet.  But unless the new drive is truly bad, there's no
> significant difference in going forward vs. going back.
>
>> The backup-file doesn't exist, and the stats on the array are as follows:
>
> Losing the backup file may cause some data loss, regardless of
> conversion direction.

I'm okay with a bit of data loss - most of the data isn't critical.
It'd be a real hassle to lose it all, though.

*snip*

> Meanwhile, report what you know about "error recovery control".  If it
> is "nothing", you may need to do some googling in this list's archives.
>  Suitable keywords would include: "scterc", "ure", "timeout", and "error
> recovery".
>
> Phil

Prior to looking through this list yesterday: absolutely nothing. Now:
almost nothing :)

According to smartctl, none of my drives support it. Not surprising as
they're all "green" desktop versions. When buying them I wasn't aware
of this deficiency. By my limited understanding, lack of support just
means the drives are likely to drop out of the array unnecessarily,
correct? Maybe this was the cause of the unexpected rebuild after I
added the new drive...

*edited forward* Actually, on reflection that wouldn't be it, would
it? If the drive was dropped for not responding due to it's lack of
scterc, I think I would have had to manually re-add it, which I didn't
do.

Requested info follows. FYI the new drive is now showing as
"/dev/sde/" rather than "/dev/sda".

Also, while poking yesterday I noticed I was getting warnings of the
form "Device has wrong state in superblock but /dev/sde seems ok", so
I tried a forced assemble:
mdadm --assemble /dev/md0 --force

Looks like it updated some info in the superblocks (and yes, I forgot
to save the original output first!), but the array remains inactive. I
have now sworn off poking around by myself, because I've no idea what
to do from here.

Cheers,
Keith

----------------------------
mdadm -E /dev/sd[bcde]
----------------------------
/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 830b9ec8:ca8dac63:e31946a0:4c76ccf0
           Name : muncher:0  (local to host muncher)
  Creation Time : Sun Jul 17 00:41:57 2011
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
     Array Size : 7814051840 (3726.03 GiB 4000.79 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 5d37816b:d5fb16a0:7d6a6b10:31cd6ce1

  Reshape pos'n : 28540928 (27.22 GiB 29.23 GB)
     New Layout : left-symmetric

    Update Time : Sat Jun  8 11:00:43 2013
       Checksum : 761bc532 - correct
         Events : 50599

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 830b9ec8:ca8dac63:e31946a0:4c76ccf0
           Name : muncher:0  (local to host muncher)
  Creation Time : Sun Jul 17 00:41:57 2011
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
     Array Size : 7814051840 (3726.03 GiB 4000.79 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 283edca6:910be50c:1afca18d:4cd908a6

  Reshape pos'n : 28540928 (27.22 GiB 29.23 GB)
     New Layout : left-symmetric

    Update Time : Sat Jun  8 11:00:43 2013
       Checksum : 6018796d - correct
         Events : 50599

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA. ('A' == active, '.' == missing)
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 830b9ec8:ca8dac63:e31946a0:4c76ccf0
           Name : muncher:0  (local to host muncher)
  Creation Time : Sun Jul 17 00:41:57 2011
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
     Array Size : 7814051840 (3726.03 GiB 4000.79 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : f5494aad:07c9d06a:408628c7:39d7dfcf

  Reshape pos'n : 28540928 (27.22 GiB 29.23 GB)
     New Layout : left-symmetric

    Update Time : Sat Jun  8 11:00:43 2013
       Checksum : 27cfcac6 - correct
         Events : 50599

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA. ('A' == active, '.' == missing)
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x6
     Array UUID : 830b9ec8:ca8dac63:e31946a0:4c76ccf0
           Name : muncher:0  (local to host muncher)
  Creation Time : Sun Jul 17 00:41:57 2011
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
     Array Size : 7814051840 (3726.03 GiB 4000.79 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
Recovery Offset : 28540928 sectors
          State : active
    Device UUID : 49cc8e58:0547cc5b:9c47dd19:6e510c7d

  Reshape pos'n : 28540928 (27.22 GiB 29.23 GB)
     New Layout : left-symmetric

    Update Time : Sat Jun  8 01:26:39 2013
       Checksum : c5a30022 - correct
         Events : 50598

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAA ('A' == active, '.' == missing)

----------------------------
for x in /dev/sd[acde] ; do smartctl -x $x ; done
----------------------------
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.0.0-32-server] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda Green (Adv. Format)
Device Model:     ST2000DL003-9VT166
Serial Number:    5YD4476E
LU WWN Device Id: 5 000c50 038e1b0af
Firmware Version: CC32
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sun Jun  9 13:08:39 2013 CST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)    Offline data collection activity
                    was completed without error.
                    Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (  612) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                    Auto Offline data collection on/off support.
                    Suspend Offline collection upon new
                    command.
                    Offline surface scan supported.
                    Self-test supported.
                    Conveyance Self-test supported.
                    Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                    power-saving mode.
                    Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                    General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   1) minutes.
Extended self-test routine
recommended polling time:      ( 255) minutes.
Conveyance self-test routine
recommended polling time:      (   2) minutes.
SCT capabilities:            (0x30b7)    SCT Status supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   110   100   006    -    25974592
  3 Spin_Up_Time            PO----   093   093   000    -    0
  4 Start_Stop_Count        -O--CK   100   100   020    -    7
  5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
  7 Seek_Error_Rate         POSR--   100   253   030    -    31
  9 Power_On_Hours          -O--CK   083   083   000    -    15249
 10 Spin_Retry_Count        PO--C-   100   100   097    -    0
 12 Power_Cycle_Count       -O--CK   100   100   020    -    50
183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    0
188 Command_Timeout         -O--CK   100   100   000    -    0
189 High_Fly_Writes         -O-RCK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   067   066   045    -    33 (Min/Max 33/34)
191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
192 Power-Off_Retract_Count -O--CK   100   100   000    -    28
193 Load_Cycle_Count        -O--CK   100   100   000    -    49
194 Temperature_Celsius     -O---K   033   040   000    -    33 (0 17 0 0)
195 Hardware_ECC_Recovered  -O-RC-   015   015   000    -    25974592
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
240 Head_Flying_Hours       ------   100   253   000    -    24416889077783
241 Total_LBAs_Written      ------   100   253   000    -    2021756950
242 Total_LBAs_Read         ------   100   253   000    -    1114083404
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
SMART Log at address 0x02 has    5 sectors [Comprehensive SMART error log]
GP    Log at address 0x03 has    5 sectors [Ext. Comprehensive SMART error log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
GP    Log at address 0x07 has    1 sectors [Extended self-test log]
SMART Log at address 0x09 has    1 sectors [Selective self-test log]
GP    Log at address 0x10 has    1 sectors [NCQ Command Error]
GP    Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
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
GP/S  Log at address 0xa1 has   20 sectors [Device vendor specific log]
GP    Log at address 0xa2 has 2248 sectors [Device vendor specific log]
GP/S  Log at address 0xa8 has   20 sectors [Device vendor specific log]
GP/S  Log at address 0xa9 has    1 sectors [Device vendor specific log]
GP    Log at address 0xab has    1 sectors [Device vendor specific log]
GP    Log at address 0xb0 has 2819 sectors [Device vendor specific log]
GP    Log at address 0xbd has  252 sectors [Device vendor specific log]
GP    Log at address 0xbe has 65535 sectors [Device vendor specific log]
GP    Log at address 0xbf has 65535 sectors [Device vendor specific log]
GP/S  Log at address 0xc0 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
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
SCT Version (vendor specific):       522 (0x020a)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    34 Celsius
Power Cycle Min/Max Temperature:     31/35 Celsius
Lifetime    Min/Max Temperature:     15/46 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        59 minutes
Min/Max recommended Temperature:     14/55 Celsius
Min/Max Temperature Limit:           10/60 Celsius
Temperature History Size (Index):    128 (60)

Index    Estimated Time   Temperature Celsius
  61    2013-06-04 08:00    31  ************
 ...    ..(  2 skipped).    ..  ************
  64    2013-06-04 10:57    31  ************
  65    2013-06-04 11:56    32  *************
  66    2013-06-04 12:55    31  ************
  67    2013-06-04 13:54    31  ************
  68    2013-06-04 14:53    30  ***********
  69    2013-06-04 15:52    30  ***********
  70    2013-06-04 16:51    30  ***********
  71    2013-06-04 17:50    29  **********
 ...    ..(  3 skipped).    ..  **********
  75    2013-06-04 21:46    29  **********
  76    2013-06-04 22:45    28  *********
 ...    ..(  3 skipped).    ..  *********
  80    2013-06-05 02:41    28  *********
  81    2013-06-05 03:40    29  **********
 ...    ..(  7 skipped).    ..  **********
  89    2013-06-05 11:32    29  **********
  90    2013-06-05 12:31    30  ***********
  91    2013-06-05 13:30    31  ************
 ...    ..(  3 skipped).    ..  ************
  95    2013-06-05 17:26    31  ************
  96    2013-06-05 18:25    30  ***********
  97    2013-06-05 19:24    29  **********
 ...    ..(  2 skipped).    ..  **********
 100    2013-06-05 22:21    29  **********
 101    2013-06-05 23:20    28  *********
 ...    ..(  2 skipped).    ..  *********
 104    2013-06-06 02:17    28  *********
 105    2013-06-06 03:16    29  **********
 ...    ..(  5 skipped).    ..  **********
 111    2013-06-06 09:10    29  **********
 112    2013-06-06 10:09     ?  -
 113    2013-06-06 11:08    25  ******
 114    2013-06-06 12:07    25  ******
 115    2013-06-06 13:06    32  *************
 116    2013-06-06 14:05    33  **************
 ...    ..(  9 skipped).    ..  **************
 126    2013-06-06 23:55    33  **************
 127    2013-06-07 00:54    32  *************
   0    2013-06-07 01:53    32  *************
   1    2013-06-07 02:52    33  **************
 ...    ..( 10 skipped).    ..  **************
  12    2013-06-07 13:41    33  **************
  13    2013-06-07 14:40     ?  -
  14    2013-06-07 15:39    32  *************
  15    2013-06-07 16:38    32  *************
  16    2013-06-07 17:37    33  **************
  17    2013-06-07 18:36    34  ***************
  18    2013-06-07 19:35    34  ***************
  19    2013-06-07 20:34    34  ***************
  20    2013-06-07 21:33    33  **************
  21    2013-06-07 22:32    33  **************
  22    2013-06-07 23:31    32  *************
 ...    ..(  4 skipped).    ..  *************
  27    2013-06-08 04:26    32  *************
  28    2013-06-08 05:25     ?  -
  29    2013-06-08 06:24    32  *************
  30    2013-06-08 07:23    32  *************
  31    2013-06-08 08:22     ?  -
  32    2013-06-08 09:21    26  *******
  33    2013-06-08 10:20    26  *******
  34    2013-06-08 11:19     ?  -
  35    2013-06-08 12:18    31  ************
  36    2013-06-08 13:17    31  ************
  37    2013-06-08 14:16    33  **************
  38    2013-06-08 15:15    33  **************
  39    2013-06-08 16:14    34  ***************
 ...    ..(  5 skipped).    ..  ***************
  45    2013-06-08 22:08    34  ***************
  46    2013-06-08 23:07    33  **************
  47    2013-06-09 00:06    33  **************
  48    2013-06-09 01:05    34  ***************
 ...    ..(  2 skipped).    ..  ***************
  51    2013-06-09 04:02    34  ***************
  52    2013-06-09 05:01    33  **************
 ...    ..(  7 skipped).    ..  **************
  60    2013-06-09 12:53    33  **************

Warning: device does not support SCT Error Recovery Control command
SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2            9  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS

smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.0.0-32-server] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda Green (Adv. Format)
Device Model:     ST2000DL003-9VT166
Serial Number:    5YD40GKJ
LU WWN Device Id: 5 000c50 038e29000
Firmware Version: CC32
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sun Jun  9 13:08:39 2013 CST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)    Offline data collection activity
                    was completed without error.
                    Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (  623) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                    Auto Offline data collection on/off support.
                    Suspend Offline collection upon new
                    command.
                    Offline surface scan supported.
                    Self-test supported.
                    Conveyance Self-test supported.
                    Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                    power-saving mode.
                    Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                    General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   1) minutes.
Extended self-test routine
recommended polling time:      ( 255) minutes.
Conveyance self-test routine
recommended polling time:      (   2) minutes.
SCT capabilities:            (0x30b7)    SCT Status supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   115   100   006    -    99752928
  3 Spin_Up_Time            PO----   096   096   000    -    0
  4 Start_Stop_Count        -O--CK   100   100   020    -    4
  5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
  7 Seek_Error_Rate         POSR--   100   253   030    -    24
  9 Power_On_Hours          -O--CK   083   083   000    -    15185
 10 Spin_Retry_Count        PO--C-   100   100   097    -    0
 12 Power_Cycle_Count       -O--CK   100   100   020    -    47
183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    0
188 Command_Timeout         -O--CK   100   100   000    -    0
189 High_Fly_Writes         -O-RCK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   066   066   045    -    34 (Min/Max 34/34)
191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
192 Power-Off_Retract_Count -O--CK   100   100   000    -    25
193 Load_Cycle_Count        -O--CK   100   100   000    -    46
194 Temperature_Celsius     -O---K   034   040   000    -    34 (0 16 0 0)
195 Hardware_ECC_Recovered  -O-RC-   019   019   000    -    99752928
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
240 Head_Flying_Hours       ------   100   253   000    -    72765335928851
241 Total_LBAs_Written      ------   100   253   000    -    983226830
242 Total_LBAs_Read         ------   100   253   000    -    1540468804
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
SMART Log at address 0x02 has    5 sectors [Comprehensive SMART error log]
GP    Log at address 0x03 has    5 sectors [Ext. Comprehensive SMART error log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
GP    Log at address 0x07 has    1 sectors [Extended self-test log]
SMART Log at address 0x09 has    1 sectors [Selective self-test log]
GP    Log at address 0x10 has    1 sectors [NCQ Command Error]
GP    Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
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
GP/S  Log at address 0xa1 has   20 sectors [Device vendor specific log]
GP    Log at address 0xa2 has 2248 sectors [Device vendor specific log]
GP/S  Log at address 0xa8 has   20 sectors [Device vendor specific log]
GP/S  Log at address 0xa9 has    1 sectors [Device vendor specific log]
GP    Log at address 0xab has    1 sectors [Device vendor specific log]
GP    Log at address 0xb0 has 2819 sectors [Device vendor specific log]
GP    Log at address 0xbd has  252 sectors [Device vendor specific log]
GP    Log at address 0xbe has 65535 sectors [Device vendor specific log]
GP    Log at address 0xbf has 65535 sectors [Device vendor specific log]
GP/S  Log at address 0xc0 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
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
SCT Version (vendor specific):       522 (0x020a)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    34 Celsius
Power Cycle Min/Max Temperature:     31/35 Celsius
Lifetime    Min/Max Temperature:     14/48 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        59 minutes
Min/Max recommended Temperature:     14/55 Celsius
Min/Max Temperature Limit:           10/60 Celsius
Temperature History Size (Index):    128 (51)

Index    Estimated Time   Temperature Celsius
  52    2013-06-04 08:00    33  **************
 ...    ..(  2 skipped).    ..  **************
  55    2013-06-04 10:57    33  **************
  56    2013-06-04 11:56    34  ***************
  57    2013-06-04 12:55    34  ***************
  58    2013-06-04 13:54    33  **************
  59    2013-06-04 14:53    32  *************
  60    2013-06-04 15:52    32  *************
  61    2013-06-04 16:51    32  *************
  62    2013-06-04 17:50    31  ************
 ...    ..(  4 skipped).    ..  ************
  67    2013-06-04 22:45    31  ************
  68    2013-06-04 23:44    30  ***********
 ...    ..(  2 skipped).    ..  ***********
  71    2013-06-05 02:41    30  ***********
  72    2013-06-05 03:40    31  ************
 ...    ..(  7 skipped).    ..  ************
  80    2013-06-05 11:32    31  ************
  81    2013-06-05 12:31    33  **************
  82    2013-06-05 13:30    34  ***************
  83    2013-06-05 14:29    33  **************
 ...    ..(  3 skipped).    ..  **************
  87    2013-06-05 18:25    33  **************
  88    2013-06-05 19:24    31  ************
  89    2013-06-05 20:23    31  ************
  90    2013-06-05 21:22    30  ***********
 ...    ..(  4 skipped).    ..  ***********
  95    2013-06-06 02:17    30  ***********
  96    2013-06-06 03:16    31  ************
 ...    ..(  5 skipped).    ..  ************
 102    2013-06-06 09:10    31  ************
 103    2013-06-06 10:09     ?  -
 104    2013-06-06 11:08    26  *******
 105    2013-06-06 12:07    26  *******
 106    2013-06-06 13:06    33  **************
 107    2013-06-06 14:05    34  ***************
 ...    ..(  8 skipped).    ..  ***************
 116    2013-06-06 22:56    34  ***************
 117    2013-06-06 23:55    33  **************
 ...    ..(  2 skipped).    ..  **************
 120    2013-06-07 02:52    33  **************
 121    2013-06-07 03:51    34  ***************
 ...    ..(  9 skipped).    ..  ***************
   3    2013-06-07 13:41    34  ***************
   4    2013-06-07 14:40     ?  -
   5    2013-06-07 15:39    33  **************
   6    2013-06-07 16:38    33  **************
   7    2013-06-07 17:37    34  ***************
   8    2013-06-07 18:36    34  ***************
   9    2013-06-07 19:35    35  ****************
  10    2013-06-07 20:34    35  ****************
  11    2013-06-07 21:33    34  ***************
  12    2013-06-07 22:32    33  **************
 ...    ..(  5 skipped).    ..  **************
  18    2013-06-08 04:26    33  **************
  19    2013-06-08 05:25     ?  -
  20    2013-06-08 06:24    33  **************
  21    2013-06-08 07:23    33  **************
  22    2013-06-08 08:22     ?  -
  23    2013-06-08 09:21    27  ********
  24    2013-06-08 10:20    27  ********
  25    2013-06-08 11:19     ?  -
  26    2013-06-08 12:18    31  ************
  27    2013-06-08 13:17    31  ************
  28    2013-06-08 14:16    33  **************
  29    2013-06-08 15:15    34  ***************
  30    2013-06-08 16:14    34  ***************
  31    2013-06-08 17:13    35  ****************
 ...    ..(  4 skipped).    ..  ****************
  36    2013-06-08 22:08    35  ****************
  37    2013-06-08 23:07    34  ***************
  38    2013-06-09 00:06    34  ***************
  39    2013-06-09 01:05    35  ****************
  40    2013-06-09 02:04    34  ***************
 ...    ..( 10 skipped).    ..  ***************
  51    2013-06-09 12:53    34  ***************

Warning: device does not support SCT Error Recovery Control command
SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2           10  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS

smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.0.0-32-server] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda Green (Adv. Format)
Device Model:     ST2000DL003-9VT166
Serial Number:    5YD46608
LU WWN Device Id: 5 000c50 038edda2f
Firmware Version: CC32
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sun Jun  9 13:08:40 2013 CST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)    Offline data collection activity
                    was completed without error.
                    Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (  623) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                    Auto Offline data collection on/off support.
                    Suspend Offline collection upon new
                    command.
                    Offline surface scan supported.
                    Self-test supported.
                    Conveyance Self-test supported.
                    Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                    power-saving mode.
                    Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                    General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   1) minutes.
Extended self-test routine
recommended polling time:      ( 255) minutes.
Conveyance self-test routine
recommended polling time:      (   2) minutes.
SCT capabilities:            (0x30b7)    SCT Status supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   116   100   006    -    104045136
  3 Spin_Up_Time            PO----   093   093   000    -    0
  4 Start_Stop_Count        -O--CK   100   100   020    -    7
  5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
  7 Seek_Error_Rate         POSR--   100   253   030    -    27
  9 Power_On_Hours          -O--CK   083   083   000    -    15269
 10 Spin_Retry_Count        PO--C-   100   100   097    -    0
 12 Power_Cycle_Count       -O--CK   100   100   020    -    50
183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    0
188 Command_Timeout         -O--CK   100   100   000    -    1
189 High_Fly_Writes         -O-RCK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   066   066   045    -    34 (Min/Max 34/34)
191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
192 Power-Off_Retract_Count -O--CK   100   100   000    -    28
193 Load_Cycle_Count        -O--CK   100   100   000    -    49
194 Temperature_Celsius     -O---K   034   040   000    -    34 (0 16 0 0)
195 Hardware_ECC_Recovered  -O-RC-   020   020   000    -    104045136
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
240 Head_Flying_Hours       ------   100   253   000    -    52411485913107
241 Total_LBAs_Written      ------   100   253   000    -    2955990382
242 Total_LBAs_Read         ------   100   253   000    -    3371798023
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
SMART Log at address 0x02 has    5 sectors [Comprehensive SMART error log]
GP    Log at address 0x03 has    5 sectors [Ext. Comprehensive SMART error log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
GP    Log at address 0x07 has    1 sectors [Extended self-test log]
SMART Log at address 0x09 has    1 sectors [Selective self-test log]
GP    Log at address 0x10 has    1 sectors [NCQ Command Error]
GP    Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
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
GP/S  Log at address 0xa1 has   20 sectors [Device vendor specific log]
GP    Log at address 0xa2 has 2248 sectors [Device vendor specific log]
GP/S  Log at address 0xa8 has   20 sectors [Device vendor specific log]
GP/S  Log at address 0xa9 has    1 sectors [Device vendor specific log]
GP    Log at address 0xab has    1 sectors [Device vendor specific log]
GP    Log at address 0xb0 has 2819 sectors [Device vendor specific log]
GP    Log at address 0xbd has  252 sectors [Device vendor specific log]
GP    Log at address 0xbe has 65535 sectors [Device vendor specific log]
GP    Log at address 0xbf has 65535 sectors [Device vendor specific log]
GP/S  Log at address 0xc0 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
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
SCT Version (vendor specific):       522 (0x020a)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    34 Celsius
Power Cycle Min/Max Temperature:     31/35 Celsius
Lifetime    Min/Max Temperature:     13/48 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        59 minutes
Min/Max recommended Temperature:     14/55 Celsius
Min/Max Temperature Limit:           10/60 Celsius
Temperature History Size (Index):    128 (60)

Index    Estimated Time   Temperature Celsius
  61    2013-06-04 08:00    33  **************
  62    2013-06-04 08:59    33  **************
  63    2013-06-04 09:58    33  **************
  64    2013-06-04 10:57    34  ***************
  65    2013-06-04 11:56    35  ****************
  66    2013-06-04 12:55    34  ***************
  67    2013-06-04 13:54    33  **************
  68    2013-06-04 14:53    32  *************
 ...    ..(  3 skipped).    ..  *************
  72    2013-06-04 18:49    32  *************
  73    2013-06-04 19:48    31  ************
 ...    ..( 15 skipped).    ..  ************
  89    2013-06-05 11:32    31  ************
  90    2013-06-05 12:31    33  **************
  91    2013-06-05 13:30    34  ***************
 ...    ..(  3 skipped).    ..  ***************
  95    2013-06-05 17:26    34  ***************
  96    2013-06-05 18:25    33  **************
  97    2013-06-05 19:24    32  *************
  98    2013-06-05 20:23    31  ************
 ...    ..(  2 skipped).    ..  ************
 101    2013-06-05 23:20    31  ************
 102    2013-06-06 00:19    30  ***********
 103    2013-06-06 01:18    30  ***********
 104    2013-06-06 02:17    31  ************
 ...    ..(  6 skipped).    ..  ************
 111    2013-06-06 09:10    31  ************
 112    2013-06-06 10:09     ?  -
 113    2013-06-06 11:08    26  *******
 114    2013-06-06 12:07    26  *******
 115    2013-06-06 13:06    33  **************
 116    2013-06-06 14:05    34  ***************
 ...    ..(  7 skipped).    ..  ***************
 124    2013-06-06 21:57    34  ***************
 125    2013-06-06 22:56    33  **************
 ...    ..(  5 skipped).    ..  **************
   3    2013-06-07 04:50    33  **************
   4    2013-06-07 05:49    34  ***************
 ...    ..(  2 skipped).    ..  ***************
   7    2013-06-07 08:46    34  ***************
   8    2013-06-07 09:45    33  **************
   9    2013-06-07 10:44    34  ***************
  10    2013-06-07 11:43    34  ***************
  11    2013-06-07 12:42    34  ***************
  12    2013-06-07 13:41    33  **************
  13    2013-06-07 14:40     ?  -
  14    2013-06-07 15:39    33  **************
  15    2013-06-07 16:38    33  **************
  16    2013-06-07 17:37    33  **************
  17    2013-06-07 18:36    34  ***************
  18    2013-06-07 19:35    35  ****************
  19    2013-06-07 20:34    34  ***************
  20    2013-06-07 21:33    33  **************
 ...    ..(  6 skipped).    ..  **************
  27    2013-06-08 04:26    33  **************
  28    2013-06-08 05:25     ?  -
  29    2013-06-08 06:24    33  **************
  30    2013-06-08 07:23    33  **************
  31    2013-06-08 08:22     ?  -
  32    2013-06-08 09:21    26  *******
  33    2013-06-08 10:20    26  *******
  34    2013-06-08 11:19     ?  -
  35    2013-06-08 12:18    31  ************
  36    2013-06-08 13:17    31  ************
  37    2013-06-08 14:16    33  **************
  38    2013-06-08 15:15    34  ***************
  39    2013-06-08 16:14    34  ***************
  40    2013-06-08 17:13    35  ****************
 ...    ..(  4 skipped).    ..  ****************
  45    2013-06-08 22:08    35  ****************
  46    2013-06-08 23:07    34  ***************
  47    2013-06-09 00:06    34  ***************
  48    2013-06-09 01:05    35  ****************
  49    2013-06-09 02:04    34  ***************
 ...    ..( 10 skipped).    ..  ***************
  60    2013-06-09 12:53    34  ***************

Warning: device does not support SCT Error Recovery Control command
SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2           10  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS

smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.0.0-32-server] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD20EZRX-00DC0B0
Serial Number:    WD-WMC301671583
LU WWN Device Id: 5 0014ee 658a8e467
Firmware Version: 80.00A80
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   9
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Sun Jun  9 13:08:40 2013 CST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80)    Offline data collection activity
                    was never started.
                    Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (25500) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                    Auto Offline data collection on/off support.
                    Suspend Offline collection upon new
                    command.
                    Offline surface scan supported.
                    Self-test supported.
                    Conveyance Self-test supported.
                    Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                    power-saving mode.
                    Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                    General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      ( 255) minutes.
Conveyance self-test routine
recommended polling time:      (   5) minutes.
SCT capabilities:            (0x70b5)    SCT Status supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   100   253   051    -    0
  3 Spin_Up_Time            POS--K   100   253   021    -    0
  4 Start_Stop_Count        -O--CK   100   100   000    -    5
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   100   253   000    -    0
  9 Power_On_Hours          -O--CK   100   100   000    -    65
 10 Spin_Retry_Count        -O--CK   100   253   000    -    0
 11 Calibration_Retry_Count -O--CK   100   253   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    5
192 Power-Off_Retract_Count -O--CK   200   200   000    -    1
193 Load_Cycle_Count        -O--CK   200   200   000    -    24
194 Temperature_Celsius     -O---K   118   117   000    -    29
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
GP/S  Log at address 0x00 has    1 sectors [Log Directory]
SMART Log at address 0x01 has    1 sectors [Summary SMART error log]
SMART Log at address 0x02 has    5 sectors [Comprehensive SMART error log]
GP    Log at address 0x03 has    6 sectors [Ext. Comprehensive SMART error log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
GP    Log at address 0x07 has    1 sectors [Extended self-test log]
SMART Log at address 0x09 has    1 sectors [Selective self-test log]
GP    Log at address 0x10 has    1 sectors [NCQ Command Error]
GP    Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
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
GP/S  Log at address 0xa0 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa1 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa2 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa3 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa4 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa5 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa6 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa7 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa8 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xa9 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xaa has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xab has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xac has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xad has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xae has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xaf has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb0 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb1 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb2 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb3 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb4 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb5 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb6 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb7 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xbd has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xc0 has    1 sectors [Device vendor specific log]
GP    Log at address 0xc1 has   93 sectors [Device vendor specific log]
GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
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
Current Temperature:                    29 Celsius
Power Cycle Min/Max Temperature:     27/30 Celsius
Lifetime    Min/Max Temperature:     19/30 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (111)

Index    Estimated Time   Temperature Celsius
 112    2013-06-09 05:11    29  **********
 ...    ..( 91 skipped).    ..  **********
 204    2013-06-09 06:43    29  **********
 205    2013-06-09 06:44    28  *********
 ...    ..(382 skipped).    ..  *********
 110    2013-06-09 13:07    28  *********
 111    2013-06-09 13:08    29  **********

Warning: device does not support SCT Error Recovery Control command
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
0x0009  2            5  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            5  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4        87852  Vendor specific

----------------------------
serial number vs. device name for the subject disks
----------------------------
ata-ST2000DL003-9VT166_5YD40GKJ -> ../../sdc
ata-ST2000DL003-9VT166_5YD4476E -> ../../sdb
ata-ST2000DL003-9VT166_5YD46608 -> ../../sdd
ata-WDC_WD20EZRX-00DC0B0_WD-WMC301671583 -> ../../sde

----------------------------
for x in /sys/block/sd[acde]/device/timeout ; do echo $x $(< $x) ; done
----------------------------
/sys/block/sdb/device/timeout 30
/sys/block/sdc/device/timeout 30
/sys/block/sdd/device/timeout 30
/sys/block/sde/device/timeout 30
