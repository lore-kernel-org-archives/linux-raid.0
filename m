From: Phill Watkins <phill.watkins@gmail.com>
Subject: Degraded array but drive healthy
Date: Wed, 4 Dec 2013 22:23:10 +0000
Message-ID: <CAONsccXLi+1rqZQPsUSfzfuTD3+jWugiH4jAFPKQNLh0aAKSuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have an issue that I can't really pin down.

I have two RAID 1 arrays, one for /boot and another for an LVM.

Yesterday one of the arrays (the LVM) became degraded after a reboot
which included an automated fsck on all filesystems.

I've run full SMART tests on both drives and both completed without errors:

The only thing I've noticed is the raw attribute of the
Multi_Zone_Error_Rate from the failed drive:

    ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
      1 Raw_Read_Error_Rate     0x002f   100   100   051    Pre-fail
Always       -       0
      2 Throughput_Performance  0x0026   056   056   000    Old_age
Always       -       11660
      3 Spin_Up_Time            0x0023   089   089   025    Pre-fail
Always       -       3460
      4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       24
      5 Reallocated_Sector_Ct   0x0033   252   252   010    Pre-fail
Always       -       0
      7 Seek_Error_Rate         0x002e   252   252   051    Old_age
Always       -       0
      8 Seek_Time_Performance   0x0024   252   252   015    Old_age
Offline      -       0
      9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       3973
     10 Spin_Retry_Count        0x0032   252   252   051    Old_age
Always       -       0
     11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       37
     12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       24
    191 G-Sense_Error_Rate      0x0022   252   252   000    Old_age
Always       -       0
    192 Power-Off_Retract_Count 0x0022   252   252   000    Old_age
Always       -       0
    194 Temperature_Celsius     0x0002   064   064   000    Old_age
Always       -       29 (Min/Max 21/36)
    195 Hardware_ECC_Recovered  0x003a   100   100   000    Old_age
Always       -       0
    196 Reallocated_Event_Count 0x0032   252   252   000    Old_age
Always       -       0
    197 Current_Pending_Sector  0x0032   252   252   000    Old_age
Always       -       0
    198 Offline_Uncorrectable   0x0030   252   252   000    Old_age
Offline      -       0
    199 UDMA_CRC_Error_Count    0x0036   200   200   000    Old_age
Always       -       0
    200 Multi_Zone_Error_Rate   0x002a   100   100   000    Old_age
Always       -       637
    223 Load_Retry_Count        0x0032   100   100   000    Old_age
Always       -       37
    225 Load_Cycle_Count        0x0032   100   100   000    Old_age
Always       -       2055

And the Raw_Read_Error_Rate of the good drive:

    ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
      1 Raw_Read_Error_Rate     0x002f   100   100   051    Pre-fail
Always       -       1
      2 Throughput_Performance  0x0026   055   055   000    Old_age
Always       -       11961
      3 Spin_Up_Time            0x0023   089   089   025    Pre-fail
Always       -       3462
      4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       24
      5 Reallocated_Sector_Ct   0x0033   252   252   010    Pre-fail
Always       -       0
      7 Seek_Error_Rate         0x002e   252   252   051    Old_age
Always       -       0
      8 Seek_Time_Performance   0x0024   252   252   015    Old_age
Offline      -       0
      9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       3973
     10 Spin_Retry_Count        0x0032   252   252   051    Old_age
Always       -       0
     11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       133
     12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       24
    191 G-Sense_Error_Rate      0x0022   252   252   000    Old_age
Always       -       0
    192 Power-Off_Retract_Count 0x0022   252   252   000    Old_age
Always       -       0
    194 Temperature_Celsius     0x0002   064   063   000    Old_age
Always       -       29 (Min/Max 21/37)
    195 Hardware_ECC_Recovered  0x003a   100   100   000    Old_age
Always       -       0
    196 Reallocated_Event_Count 0x0032   252   252   000    Old_age
Always       -       0
    197 Current_Pending_Sector  0x0032   252   252   000    Old_age
Always       -       0
    198 Offline_Uncorrectable   0x0030   252   252   000    Old_age
Offline      -       0
    199 UDMA_CRC_Error_Count    0x0036   200   200   000    Old_age
Always       -       0
    200 Multi_Zone_Error_Rate   0x002a   100   100   000    Old_age
Always       -       0
    223 Load_Retry_Count        0x0032   100   100   000    Old_age
Always       -       133
    225 Load_Cycle_Count        0x0032   100   100   000    Old_age
Always       -       2157

I've had drives fail in the past but I find this confusing. Is the
drive failing, is there an issue with the
controller/motherboard or should I just zero the drive and add it back.

Here is a small section from the kernel log:

    Dec  3 10:56:41  kernel: [  928.639916] sd 1:0:0:0: [sdb]
Unhandled error code
    Dec  3 10:56:41  kernel: [  928.639917] sd 1:0:0:0: [sdb]
    Dec  3 10:56:41  kernel: [  928.639918] Result: hostbyte=DID_OK
driverbyte=DRIVER_TIMEOUT
    Dec  3 10:56:41  kernel: [  928.639920] sd 1:0:0:0: [sdb] CDB:
    Dec  3 10:56:41  kernel: [  928.639921] Read(10): 28 00 00 72 13
a0 00 00 08 00
    Dec  3 10:56:41  kernel: [  928.639926] end_request: I/O error,
dev sdb, sector 7476128
    Dec  3 10:56:41  kernel: [  928.639950] md/raid1:md1: sdb3:
rescheduling sector 6210464
    Dec  3 10:56:41  kernel: [  928.639977] sd 1:0:0:0: [sdb]
Unhandled error code
    Dec  3 10:56:41  kernel: [  928.639978] sd 1:0:0:0: [sdb]
    Dec  3 10:56:41  kernel: [  928.639979] Result: hostbyte=DID_OK
driverbyte=DRIVER_TIMEOUT
    Dec  3 10:56:41  kernel: [  928.639981] sd 1:0:0:0: [sdb] CDB:
    Dec  3 10:56:41  kernel: [  928.639982] Write(10): 2a 00 01 35 37
b8 00 00 38 00
    Dec  3 10:56:41  kernel: [  928.639987] end_request: I/O error,
dev sdb, sector 20264888
    Dec  3 10:56:41  kernel: [  928.640015] sd 1:0:0:0: [sdb]
Unhandled error code
    Dec  3 10:56:41  kernel: [  928.640017] sd 1:0:0:0: [sdb]
    Dec  3 10:56:41  kernel: [  928.640018] Result: hostbyte=DID_OK
driverbyte=DRIVER_TIMEOUT
    Dec  3 10:56:41  kernel: [  928.640019] sd 1:0:0:0: [sdb] CDB:
    Dec  3 10:56:41  kernel: [  928.640020] Write(10): 2a 00 3b 49 19
c0 00 00 10 00
    Dec  3 10:56:41  kernel: [  928.640026] end_request: I/O error,
dev sdb, sector 994646464
    Dec  3 10:56:41  kernel: [  928.697578] md/raid1:md1: redirecting
sector 23223656 to other mirror: sda3
    Dec  3 10:56:41  kernel: [  928.713801] md/raid1:md1: redirecting
sector 6210464 to other mirror: sda3
    Dec  3 10:56:41  kernel: [  928.713864] RAID1 conf printout:
    Dec  3 10:56:41  kernel: [  928.713866]  --- wd:1 rd:2
    Dec  3 10:56:41  kernel: [  928.713869]  disk 0, wo:1, o:0, dev:sdb3
    Dec  3 10:56:41  kernel: [  928.713871]  disk 1, wo:0, o:1, dev:sda3
    Dec  3 10:56:41  kernel: [  928.717843] RAID1 conf printout:
    Dec  3 10:56:41  kernel: [  928.717846]  --- wd:1 rd:2
    Dec  3 10:56:41  kernel: [  928.717848]  disk 1, wo:0, o:1, dev:sda3

And here's some details from mdadm:

    Personalities : [linear] [multipath] [raid0] [raid1] [raid6]
[raid5] [raid4] [raid10]
    md0 : active raid1 sda2[1] sdb2[0]
          499392 blocks super 1.2 [2/2] [UU]

    md1 : active raid1 sda3[1] sdb3[0](F)
          975552320 blocks super 1.2 [2/1] [_U]

    unused devices: <none>

    /dev/md0:
            Version : 1.2
      Creation Time : Sat Jun 22 11:30:54 2013
         Raid Level : raid1
         Array Size : 499392 (487.77 MiB 511.38 MB)
      Used Dev Size : 499392 (487.77 MiB 511.38 MB)
       Raid Devices : 2
      Total Devices : 2
        Persistence : Superblock is persistent

        Update Time : Tue Dec  3 21:12:57 2013
              State : clean
     Active Devices : 2
    Working Devices : 2
     Failed Devices : 0
      Spare Devices : 0

               Name : ubuntu:0
               UUID : 83f80fc5:e1da5cd9:67eed912:09c62536
             Events : 35

        Number   Major   Minor   RaidDevice State
           0       8       18        0      active sync   /dev/sdb2
           1       8        2        1      active sync   /dev/sda2

    /dev/md1:
            Version : 1.2
      Creation Time : Sat Jun 22 11:31:06 2013
         Raid Level : raid1
         Array Size : 975552320 (930.36 GiB 998.97 GB)
      Used Dev Size : 975552320 (930.36 GiB 998.97 GB)
       Raid Devices : 2
      Total Devices : 2
        Persistence : Superblock is persistent

        Update Time : Wed Dec  4 18:20:00 2013
              State : clean, degraded
     Active Devices : 1
    Working Devices : 1
     Failed Devices : 1
      Spare Devices : 0

               Name : ubuntu:1
               UUID : 49dbfe44:d988b67b:06f285ee:f28ffeb9
             Events : 11036

        Number   Major   Minor   RaidDevice State
           0       0        0        0      removed
           1       8        3        1      active sync   /dev/sda3

           0       8       19        -      faulty spare   /dev/sdb3

I'd really appreciate some advice.

Regards
