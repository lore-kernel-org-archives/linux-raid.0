From: Joseba Ibarra <wajalotnet@gmail.com>
Subject: Re: Can't mount /dev/md0 Raid5
Date: Wed, 11 Oct 2017 21:46:15 +0200
Message-ID: <59DE7507.8060406@gmail.com>
References: <59DDF18A.9060800@gmail.com> <8628ddba-8cec-24d8-e07a-195d47f579be@grumpydevil.homelinux.org> <59DDFD19.1040700@gmail.com> <e6566c4a-2476-4554-549a-12b6c90b152f@websitemanagers.com.au> <59DE0705.502@gmail.com> <d6f39002-7120-3613-8163-7fb80b5434a1@websitemanagers.com.au> <59DE1E38.8080604@gmail.com> <e9bcdb2b-6ffe-285d-5d59-313438db61ac@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9bcdb2b-6ffe-285d-5d59-313438db61ac@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, list linux-raid <linux-raid@vger.kernel.org>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, Mikael Abrahamsson <swmike@swm.pp.se>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

Hi Adam,

root@grafico:/mnt# mdadm --manage /dev/md0 --readwrite
root@grafico:/mnt# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md0 : active raid5 sdb1[1] sdd1[3] sdc1[2]
       2929889280 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[4/3] [_UUU]
       bitmap: 5/8 pages [20KB], 65536KB chunk

unused devices: <none>


If you mean mdadm --manage /dev/md0 --run I already done and the result 
is the same.

Doing --detail /dev/md0

root@grafico:/mnt# mdadm --detail /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Sat Aug  5 23:10:50 2017
      Raid Level : raid5
      Array Size : 2929889280 (2794.16 GiB 3000.21 GB)
   Used Dev Size : 976629760 (931.39 GiB 1000.07 GB)
    Raid Devices : 4
   Total Devices : 3
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Wed Oct 11 15:33:13 2017
           State : clean, degraded
  Active Devices : 3
Working Devices : 3
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 512K

            Name : servidor:0
            UUID : 0b44a3b8:83eafabc:644afc87:bdb5b1f3
          Events : 3115

     Number   Major   Minor   RaidDevice State
        -       0        0        0      removed
        1       8       17        1      active sync   /dev/sdb1
        2       8       33        2      active sync   /dev/sdc1
        3       8       49        3      active sync   /dev/sdd1


I started the thread with this 
https://marc.info/?l=linux-raid&m=150607163322491&w=2 but after some 
days out cause travel by work I did found the disk stopped working.

I'll give you the current info:

root@grafico:/mnt# fdisk -l

Disco /dev/sdd: 931,5 GiB, 1000204886016 bytes, 1953525168 sectores
Unidades: sectores de 1 * 512 = 512 bytes
Tamaño de sector (lógico/físico): 512 bytes / 512 bytes
Tamaño de E/S (mínimo/óptimo): 512 bytes / 512 bytes
Tipo de etiqueta de disco: dos
Identificador del disco: 0xa69b0d7f

Disposit.  Inicio Comienzo      Final   Sectores Tamaño Id Tipo
/dev/sdd1             2048 1953523711 1953521664 931,5G fd Linux raid 
autodetect


Disco /dev/sdb: 931,5 GiB, 1000204886016 bytes, 1953525168 sectores
Unidades: sectores de 1 * 512 = 512 bytes
Tamaño de sector (lógico/físico): 512 bytes / 512 bytes
Tamaño de E/S (mínimo/óptimo): 512 bytes / 512 bytes
Tipo de etiqueta de disco: dos
Identificador del disco: 0x87ea0d19

Disposit.  Inicio Comienzo      Final   Sectores Tamaño Id Tipo
/dev/sdb1             2048 1953523711 1953521664 931,5G fd Linux raid 
autodetect


Disco /dev/sdc: 931,5 GiB, 1000204886016 bytes, 1953525168 sectores
Unidades: sectores de 1 * 512 = 512 bytes
Tamaño de sector (lógico/físico): 512 bytes / 512 bytes
Tamaño de E/S (mínimo/óptimo): 512 bytes / 512 bytes
Tipo de etiqueta de disco: dos
Identificador del disco: 0x8b48be4a

Disposit.  Inicio Comienzo      Final   Sectores Tamaño Id Tipo
/dev/sdc1             2048 1953523711 1953521664 931,5G fd Linux raid 
autodetect


Disco /dev/md0: 2,7 TiB, 3000206622720 bytes, 5859778560 sectores
Unidades: sectores de 1 * 512 = 512 bytes
Tamaño de sector (lógico/físico): 512 bytes / 512 bytes
Tamaño de E/S (mínimo/óptimo): 524288 bytes / 1572864 bytes
Tipo de etiqueta de disco: gpt
Identificador del disco: A87C8BBF-5876-4FA6-83F6-46DAF1BDCF75

Disposit.  Comienzo      Final   Sectores Tamaño Tipo
/dev/md0p1     2048 5859776511 5859774464   2,7T Sistema de ficheros de 
Linux

root@grafico:/mnt# mdadm --examine /dev/sdb
/dev/sdb:
    MBR Magic : aa55
Partition[0] :   1953521664 sectors at         2048 (type fd)

root@grafico:/mnt# mdadm --examine /dev/sdc
/dev/sdc:
    MBR Magic : aa55
Partition[0] :   1953521664 sectors at         2048 (type fd)

root@grafico:/mnt# mdadm --examine /dev/sdd
/dev/sdd:
    MBR Magic : aa55
Partition[0] :   1953521664 sectors at                                   2048 (type fd)

root@grafico:/mnt# mdadm --misc --examine /dev/sd[bcd]1
/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 0b44a3b8:83eafabc:644afc87:bdb5b1f3
            Name : servidor:0
   Creation Time : Sat Aug  5 23:10:50 2017
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
      Array Size : 2929889280 (2794.16 GiB 3000.21 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=0 sectors
           State : clean
     Device UUID : 32271db0:38a5220c:c19968af:8fe1a3fb

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Oct 11 15:33:13 2017
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 86b5e249 - correct
          Events : 3115

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : .AAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 0b44a3b8:83eafabc:644afc87:bdb5b1f3
            Name : servidor:0
   Creation Time : Sat Aug  5 23:10:50 2017
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
      Array Size : 2929889280 (2794.16 GiB 3000.21 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=0 sectors
           State : clean
     Device UUID : 9014cf8b:ea7e22e2:9274be9d:9aeee689

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Oct 11 15:33:13 2017
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : b5009136 - correct
          Events : 3115

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : .AAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x9
      Array UUID : 0b44a3b8:83eafabc:644afc87:bdb5b1f3
            Name : servidor:0
   Creation Time : Sat Aug  5 23:10:50 2017
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
      Array Size : 2929889280 (2794.16 GiB 3000.21 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=0 sectors
           State : clean
     Device UUID : f95affb4:138bca63:d10df091:1f20af37

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Oct 11 15:33:13 2017
   Bad Block Log : 512 entries available at offset 72 sectors - bad 
blocks present.
        Checksum : 1d2ae95 - correct
          Events : 3115

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : .AAA ('A' == active, '.' == missing, 'R' == replacing)


The smartctl -a give this log:

root@grafico:/mnt# smartctl -a /dev/sdb
smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.9.0-3-amd64] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     QEMU HARDDISK
Serial Number:    QM00009
Firmware Version: 2.5+
User Capacity:    1.000.204.886.016 bytes [1,00 TB]
Sector Size:      512 bytes logical/physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA/ATAPI-7, ATA/ATAPI-5 published, ANSI NCITS 340-2000
Local Time is:    Wed Oct 11 21:42:39 2017 CEST
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
data collection:         (  288) seconds.
Offline data collection
capabilities:              (0x19) SMART execute Offline immediate.
                     No Auto Offline data collection support.
                     Suspend Offline collection upon new
                     command.
                     Offline surface scan supported.
                     Self-test supported.
                     No Conveyance Self-test supported.
                     No Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                     power-saving mode.
                     Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                     No General Purpose Logging support.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      (  54) minutes.

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x0003   100   100   006    Pre-fail  
Always       -       0
   3 Spin_Up_Time            0x0003   100   100   000    Pre-fail  
Always       -       16
   4 Start_Stop_Count        0x0002   100   100   020    Old_age   
Always       -       100
   5 Reallocated_Sector_Ct   0x0003   100   100   036    Pre-fail  
Always       -       0
   9 Power_On_Hours          0x0003   100   100   000    Pre-fail  
Always       -       1
  12 Power_Cycle_Count       0x0003   100   100   000    Pre-fail  
Always       -       0
190 Airflow_Temperature_Cel 0x0003   069   069   050    Pre-fail  
Always       -       31 (Min/Max 31/31)

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

Selective Self-tests/Logging not supported


root@grafico:/mnt# smartctl -a /dev/sdc
smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.9.0-3-amd64] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     QEMU HARDDISK
Serial Number:    QM00011
Firmware Version: 2.5+
User Capacity:    1.000.204.886.016 bytes [1,00 TB]
Sector Size:      512 bytes logical/physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA/ATAPI-7, ATA/ATAPI-5 published, ANSI NCITS 340-2000
Local Time is:    Wed Oct 11 21:44:02 2017 CEST
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
data collection:         (  288) seconds.
Offline data collection
capabilities:              (0x19) SMART execute Offline immediate.
                     No Auto Offline data collection support.
                     Suspend Offline collection upon new
                     command.
                     Offline surface scan supported.
                     Self-test supported.
                     No Conveyance Self-test supported.
                     No Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                     power-saving mode.
                     Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                     No General Purpose Logging support.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      (  54) minutes.

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x0003   100   100   006    Pre-fail  
Always       -       0
   3 Spin_Up_Time            0x0003   100   100   000    Pre-fail  
Always       -       16
   4 Start_Stop_Count        0x0002   100   100   020    Old_age   
Always       -       100
   5 Reallocated_Sector_Ct   0x0003   100   100   036    Pre-fail  
Always       -       0
   9 Power_On_Hours          0x0003   100   100   000    Pre-fail  
Always       -       1
  12 Power_Cycle_Count       0x0003   100   100   000    Pre-fail  
Always       -       0
190 Airflow_Temperature_Cel 0x0003   069   069   050    Pre-fail  
Always       -       31 (Min/Max 31/31)

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

Selective Self-tests/Logging not supported


root@grafico:/mnt# smartctl -a /dev/sdd
smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.9.0-3-amd64] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     QEMU HARDDISK
Serial Number:    QM00013
Firmware Version: 2.5+
User Capacity:    1.000.204.886.016 bytes [1,00 TB]
Sector Size:      512 bytes logical/physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA/ATAPI-7, ATA/ATAPI-5 published, ANSI NCITS 340-2000
Local Time is:    Wed Oct 11 21:44:24 2017 CEST
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
data collection:         (  288) seconds.
Offline data collection
capabilities:              (0x19) SMART execute Offline immediate.
                     No Auto Offline data collection support.
                     Suspend Offline collection upon new
                     command.
                     Offline surface scan supported.
                     Self-test supported.
                     No Conveyance Self-test supported.
                     No Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                     power-saving mode.
                     Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                     No General Purpose Logging support.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      (  54) minutes.

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x0003   100   100   006    Pre-fail  
Always       -       0
   3 Spin_Up_Time            0x0003   100   100   000    Pre-fail  
Always       -       16
   4 Start_Stop_Count        0x0002   100   100   020    Old_age   
Always       -       100
   5 Reallocated_Sector_Ct   0x0003   100   100   036    Pre-fail  
Always       -       0
   9 Power_On_Hours          0x0003   100   100   000    Pre-fail  
Always       -       1
  12 Power_Cycle_Count       0x0003   100   100   000    Pre-fail  
Always       -       0
190 Airflow_Temperature_Cel 0x0003   069   069   050    Pre-fail  
Always       -       31 (Min/Max 31/31)

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

Selective Self-tests/Logging not supported


In my humble opinioin all these three disks are ok.

Thanks again

Adam Goryachev escribió:
> What is the output of cat /proc/mdstat after running the readwrite below?
>
> Did you try the --run option?
>
> You need to make sure the array is active/running before you try to 
> mount it.
>
> BTW, has anything else happened to the array, other than the drive 
> that failed?
>
> Probably should have asked for this before, but what is the full 
> output of smartctl for each drive, also mdadm --misc --examine 
> /dev/sd[bcd]1 (or all three relevant devices)?
>
> Regards,
> Adam
>
>
> On 12/10/17 00:35, Joseba Ibarra wrote:
>> Still the same. Nothing seems to have changed.
>>
>>
>> Same answers for mount commands.
>>
>> Adam Goryachev escribió:
>>> mdadm --manage /dev/md0 --readwrite 
>>
>> Jose Ibarra
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html

-- 
<http://64bits.es/>
