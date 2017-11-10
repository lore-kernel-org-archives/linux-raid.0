From: Jun-Kai Teoh <kai.teoh@gmail.com>
Subject: Re: RAID5 up, but one drive removed, one says spare building, what now?
Date: Fri, 10 Nov 2017 09:25:30 -0800
Message-ID: <CAA4aoFbOnCtj_+qbfuzz7qS6xrt5HB9XJK-E+h0_eEu=vLdftg@mail.gmail.com>
References: <CAA4aoFaEwv=EPcotAbjzkgXWoOFwxo2XAoMzN1Zfb62k4Fngxw@mail.gmail.com>
 <5A058E25.1020608@youngman.org.uk> <34b72bc9-9a72-3143-bd1e-d00f90493d04@turmel.org>
 <CAK2H+ec6DxBE_Mxq9skOa3XNGMc2BW8Q4+ieoA13uG+UhE4nZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+ec6DxBE_Mxq9skOa3XNGMc2BW8Q4+ieoA13uG+UhE4nZg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I was reshaping/growing my array when it died. Computer came back up
but array wouldn't assemble.

I looked around and saw some commands on how to assemble without the
one drive that looked like it was kicked off sometime ago that I did
not realize (I used --assemble --force --verbose)

I kept getting the error that there were 6 drives, 1 rebuilding, and
not enough to get the array up. I unplugged the one drive that had the
incorrect superblock and ran "mdadm -A -R".

It ran and looked like it was resuming reshaping but it got really
slow - like 7 years slow.

I killed the process, rebooted the machine, and it just auto
reassembled the array and automounted it on boot.

Am in the process of backup right now.

And yes, the drive/array is mounted.

mdadm version 3.3, september 2013

Below is the updated mdadm examine info followed by smartctl (note
that the sd* have changed from the earlier post, likely because I
unplugged that drive):

/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
           Name : livingrm-server:2  (local to host livingrm-server)
  Creation Time : Thu Jun 30 07:57:36 2016
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
     New Offset : 254976 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 2df0b319:bdb18eee:27b318ec:da55d53d

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
  Delta Devices : 1 (7->8)

    Update Time : Fri Nov 10 09:17:35 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : d2b7f433 - correct
         Events : 651498

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
           Name : livingrm-server:2  (local to host livingrm-server)
  Creation Time : Thu Jun 30 07:57:36 2016
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
     New Offset : 254976 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f1a790a9:98e01257:d9ab257d:95c8f1fc

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
  Delta Devices : 1 (7->8)

    Update Time : Fri Nov 10 09:17:35 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 1b42463e - correct
         Events : 651498

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
           Name : livingrm-server:2  (local to host livingrm-server)
  Creation Time : Thu Jun 30 07:57:36 2016
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
     New Offset : 254976 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 6f44eba1:29d246a4:c5e8312e:bac00a7b

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
  Delta Devices : 1 (7->8)

    Update Time : Fri Nov 10 09:17:35 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 8ff6095a - correct
         Events : 651498

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x47
     Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
           Name : livingrm-server:2  (local to host livingrm-server)
  Creation Time : Thu Jun 30 07:57:36 2016
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
     New Offset : 254976 sectors
   Super Offset : 8 sectors
Recovery Offset : 11264816 sectors
          State : clean
    Device UUID : 109b7a2f:0529794c:2cf95cc1:d6c0bd6b

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
  Delta Devices : 1 (7->8)

    Update Time : Fri Nov 10 09:17:35 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 4a41aa92 - correct
         Events : 651498

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
           Name : livingrm-server:2  (local to host livingrm-server)
  Creation Time : Thu Jun 30 07:57:36 2016
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
     New Offset : 254976 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : deb04cea:d6530966:6c70ca90:bebb143e

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
  Delta Devices : 1 (7->8)

    Update Time : Fri Nov 10 09:17:35 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : bfbc7a25 - correct
         Events : 651498

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
           Name : livingrm-server:2  (local to host livingrm-server)
  Creation Time : Thu Jun 30 07:57:36 2016
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
     New Offset : 254976 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 15d85573:6e78f040:8c028ef3:d1301f9d

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
  Delta Devices : 1 (7->8)

    Update Time : Fri Nov 10 09:17:35 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : e57acd25 - correct
         Events : 651498

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdh:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
           Name : livingrm-server:2  (local to host livingrm-server)
  Creation Time : Thu Jun 30 07:57:36 2016
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
     New Offset : 254976 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 64d5961e:230e558c:3748b561:a7c6ab8c

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
  Delta Devices : 1 (7->8)

    Update Time : Fri Nov 10 09:17:35 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 39d43ba7 - correct
         Events : 651498

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)

------

smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-98-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD40EFRX-68WT0N0
Serial Number:    WD-WCC4E2VKP3SV
LU WWN Device Id: 5 0014ee 2620754c8
Firmware Version: 82.00A82
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Fri Nov 10 09:24:03 2017 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
was never started.
Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
without error or no self-test has ever
been run.
Total time to complete Offline
data collection: (51120) seconds.
Offline data collection
capabilities: (0x7b) SMART execute Offline immediate.
Auto Offline data collection on/off support.
Suspend Offline collection upon new
command.
Offline surface scan supported.
Self-test supported.
Conveyance Self-test supported.
Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
power-saving mode.
Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
General Purpose Logging supported.
Short self-test routine
recommended polling time: (   2) minutes.
Extended self-test routine
recommended polling time: ( 512) minutes.
Conveyance self-test routine
recommended polling time: (   5) minutes.
SCT capabilities:        (0x703d) SCT Status supported.
SCT Error Recovery Control supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   191   183   021    Pre-fail
Always       -       7441
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       182
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   082   082   000    Old_age
Always       -       13243
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       182
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       113
193 Load_Cycle_Count        0x0032   192   192   000    Old_age
Always       -       26737
194 Temperature_Celsius     0x0022   118   101   000    Old_age
Always       -       34
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

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

smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-98-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD40EFRX-68WT0N0
Serial Number:    WD-WCC4E4JNHEC6
LU WWN Device Id: 5 0014ee 2614842c3
Firmware Version: 82.00A82
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 1.5 Gb/s)
Local Time is:    Fri Nov 10 09:24:14 2017 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
was never started.
Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
without error or no self-test has ever
been run.
Total time to complete Offline
data collection: (53940) seconds.
Offline data collection
capabilities: (0x7b) SMART execute Offline immediate.
Auto Offline data collection on/off support.
Suspend Offline collection upon new
command.
Offline surface scan supported.
Self-test supported.
Conveyance Self-test supported.
Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
power-saving mode.
Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
General Purpose Logging supported.
Short self-test routine
recommended polling time: (   2) minutes.
Extended self-test routine
recommended polling time: ( 539) minutes.
Conveyance self-test routine
recommended polling time: (   5) minutes.
SCT capabilities:        (0x703d) SCT Status supported.
SCT Error Recovery Control supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   189   180   021    Pre-fail
Always       -       7516
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       214
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   076   076   000    Old_age
Always       -       18057
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       214
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       128
193 Load_Cycle_Count        0x0032   189   189   000    Old_age
Always       -       33162
194 Temperature_Celsius     0x0022   117   092   000    Old_age
Always       -       35
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

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

smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-98-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD40EFRX-68WT0N0
Serial Number:    WD-WCC4E2ZYE8AN
LU WWN Device Id: 5 0014ee 20bf26ce9
Firmware Version: 82.00A82
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 1.5 Gb/s)
Local Time is:    Fri Nov 10 09:24:17 2017 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
was never started.
Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
without error or no self-test has ever
been run.
Total time to complete Offline
data collection: (54960) seconds.
Offline data collection
capabilities: (0x7b) SMART execute Offline immediate.
Auto Offline data collection on/off support.
Suspend Offline collection upon new
command.
Offline surface scan supported.
Self-test supported.
Conveyance Self-test supported.
Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
power-saving mode.
Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
General Purpose Logging supported.
Short self-test routine
recommended polling time: (   2) minutes.
Extended self-test routine
recommended polling time: ( 550) minutes.
Conveyance self-test routine
recommended polling time: (   5) minutes.
SCT capabilities:        (0x703d) SCT Status supported.
SCT Error Recovery Control supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   186   178   021    Pre-fail
Always       -       7658
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       214
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   076   076   000    Old_age
Always       -       18060
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       214
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       121
193 Load_Cycle_Count        0x0032   189   189   000    Old_age
Always       -       33798
194 Temperature_Celsius     0x0022   117   098   000    Old_age
Always       -       35
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

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

smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-98-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD40EFRX-68N32N0
Serial Number:    WD-WCC7K7PZ7R6Z
LU WWN Device Id: 5 0014ee 26410129e
Firmware Version: 82.00A82
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-3 T13/2161-D revision 5
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 1.5 Gb/s)
Local Time is:    Fri Nov 10 09:24:20 2017 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
was never started.
Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
without error or no self-test has ever
been run.
Total time to complete Offline
data collection: (46440) seconds.
Offline data collection
capabilities: (0x7b) SMART execute Offline immediate.
Auto Offline data collection on/off support.
Suspend Offline collection upon new
command.
Offline surface scan supported.
Self-test supported.
Conveyance Self-test supported.
Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
power-saving mode.
Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
General Purpose Logging supported.
Short self-test routine
recommended polling time: (   2) minutes.
Extended self-test routine
recommended polling time: ( 492) minutes.
Conveyance self-test routine
recommended polling time: (   5) minutes.
SCT capabilities:        (0x303d) SCT Status supported.
SCT Error Recovery Control supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   100   253   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   100   253   021    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       5
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       320
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       5
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       2
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       61
194 Temperature_Celsius     0x0022   118   114   000    Old_age
Always       -       32
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

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

smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-98-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD40EFRX-68WT0N0
Serial Number:    WD-WCC4E4JNHKL9
LU WWN Device Id: 5 0014ee 2b69e186b
Firmware Version: 82.00A82
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 1.5 Gb/s)
Local Time is:    Fri Nov 10 09:24:25 2017 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
was never started.
Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
without error or no self-test has ever
been run.
Total time to complete Offline
data collection: (55260) seconds.
Offline data collection
capabilities: (0x7b) SMART execute Offline immediate.
Auto Offline data collection on/off support.
Suspend Offline collection upon new
command.
Offline surface scan supported.
Self-test supported.
Conveyance Self-test supported.
Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
power-saving mode.
Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
General Purpose Logging supported.
Short self-test routine
recommended polling time: (   2) minutes.
Extended self-test routine
recommended polling time: ( 552) minutes.
Conveyance self-test routine
recommended polling time: (   5) minutes.
SCT capabilities:        (0x703d) SCT Status supported.
SCT Error Recovery Control supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       1
  3 Spin_Up_Time            0x0027   187   180   021    Pre-fail
Always       -       7616
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       675
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   074   074   000    Old_age
Always       -       19242
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       263
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       163
193 Load_Cycle_Count        0x0032   188   188   000    Old_age
Always       -       36231
194 Temperature_Celsius     0x0022   116   091   000    Old_age
Always       -       36
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

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

smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-98-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD40EFRX-68WT0N0
Serial Number:    WD-WCC4E4K2JPZT
LU WWN Device Id: 5 0014ee 2b510b64f
Firmware Version: 80.00A80
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Fri Nov 10 09:24:28 2017 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
was never started.
Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
without error or no self-test has ever
been run.
Total time to complete Offline
data collection: (52320) seconds.
Offline data collection
capabilities: (0x7b) SMART execute Offline immediate.
Auto Offline data collection on/off support.
Suspend Offline collection upon new
command.
Offline surface scan supported.
Self-test supported.
Conveyance Self-test supported.
Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
power-saving mode.
Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
General Purpose Logging supported.
Short self-test routine
recommended polling time: (   2) minutes.
Extended self-test routine
recommended polling time: ( 523) minutes.
Conveyance self-test routine
recommended polling time: (   5) minutes.
SCT capabilities:        (0x703d) SCT Status supported.
SCT Error Recovery Control supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   189   179   021    Pre-fail
Always       -       7541
  4 Start_Stop_Count        0x0032   098   098   000    Old_age
Always       -       2626
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   064   064   000    Old_age
Always       -       26956
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       312
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       185
193 Load_Cycle_Count        0x0032   188   188   000    Old_age
Always       -       38926
194 Temperature_Celsius     0x0022   117   092   000    Old_age
Always       -       35
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   192   000    Old_age
Always       -       14
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

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

smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-98-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD40EFRX-68WT0N0
Serial Number:    WD-WCC4E4VTX9TP
LU WWN Device Id: 5 0014ee 261485dc4
Firmware Version: 82.00A82
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Fri Nov 10 09:24:31 2017 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
was never started.
Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
without error or no self-test has ever
been run.
Total time to complete Offline
data collection: (54780) seconds.
Offline data collection
capabilities: (0x7b) SMART execute Offline immediate.
Auto Offline data collection on/off support.
Suspend Offline collection upon new
command.
Offline surface scan supported.
Self-test supported.
Conveyance Self-test supported.
Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
power-saving mode.
Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
General Purpose Logging supported.
Short self-test routine
recommended polling time: (   2) minutes.
Extended self-test routine
recommended polling time: ( 548) minutes.
Conveyance self-test routine
recommended polling time: (   5) minutes.
SCT capabilities:        (0x703d) SCT Status supported.
SCT Error Recovery Control supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   189   181   021    Pre-fail
Always       -       7516
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       212
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   076   076   000    Old_age
Always       -       18057
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       212
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       122
193 Load_Cycle_Count        0x0032   189   189   000    Old_age
Always       -       33611
194 Temperature_Celsius     0x0022   118   092   000    Old_age
Always       -       34
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

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

On Fri, Nov 10, 2017 at 5:13 AM, Mark Knecht <markknecht@gmail.com> wrote:
> On Fri, Nov 10, 2017 at 6:01 AM, Phil Turmel <philip@turmel.org> wrote:
>> Hi Jun-Kai,
>>
>> On 11/10/2017 06:31 AM, Wols Lists wrote:
>>> On 10/11/17 03:09, Jun-Kai Teoh wrote:
>>>> Hi all,
>>>>
>>>> I managed to get my RAID drive back up, content looks like it's still
>>>> there, but it's not resyncing or reshaping and my parity drive was
>>>> removed (I did it when I tried to get it back up).
>>
>> If you can see your content (mounted read-only, I hope), backup up
>> everything, in order from most critical to least critical.
>>
>>>> So what should I do now? I'm afraid of doing anything else at this point.
>>
>> Well, you need to provide more information.  At least the mdadm -E
>> reports for all of the member devices.  Including the "parity" device
>> you removed.  (Parity is spread among all devices in a normal raid5
>> layout, so you may be suffering from a misunderstanding.)
>>
>
> Phil,
>    Please reference the thread entitled
>
> "Raid 5 array down/missing - went through wiki steps"
>
> All the mdadm -E info and much more was reported there a week
> ago. Wols and I helped get him that far but neither of us was confident
> in giving instructions to get him further.
>
> Cheers,
> Mark
