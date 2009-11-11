From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: RAID6 array lost a disk, can someone decode the error?
Date: Wed, 11 Nov 2009 00:08:50 -0700
Message-ID: <200911110008.50501.tfjellstrom@shaw.ca>
References: <D3A8B834526640108021D4968F07C82B@m5> <70ed7c3e0911102152j23404aadgff519e4344dd7d1@mail.gmail.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0911102152j23404aadgff519e4344dd7d1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Guy Watkins <guy@watkins-home.com>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue November 10 2009, you wrote:
> You seem to have very high numbers in Hardware_ECC_Recovered and
> Raw_Read_Error_Rate. I suggest you replace your cables.

It seems to be a standard reply for Seagate disks. ALL of mine regardless of 
the cables return nonsense numbers for several SMART entries. I recall 
people telling me its just something Seagate drives do.

> You don't have bad sectors, which is good.
> 
> Are you using the controller for RAD or just as a way to connect your
>  disks?
> 
> I've had similar link-reset problems, but not written related. Turns
> out one of the disks had a bad PCB.
> 
> On Wed, Nov 11, 2009 at 8:37 AM, Guy Watkins <guy@watkins-home.com> wrote:
> > I have 2 4-disk RAID6 arrays that loose a disk sometimes.  Maybe once
> > every month or 3.  As far as I can tell I don't have disks that have
> > un-readable blocks.  The RAID1 arrays also loose disks sometimes.  I
> > have the 4 disks on 1 controller, from lspci:
> > 00:0e.0 Mass storage controller: Promise Technology, Inc. PDC20318
> > (SATA150 TX4) (rev 02)
> >
> > I thought the RAID6 logic corrected single block errors?  Maybe not on
> > a write? And I think this is a write because of "super_written"?
> >
> > The array is a RAID6 but the errors say RAID5?
> >
> > When I remove and add the disks back in they rebuild just fine.
> >
> > Anyway, does anyone understand what this error really is?  Is it bad
> > disks? Bad cable?  Bad controller?  Bad sunspots?  :)
> >
> > I did see that a smart test had failed at about the same time.  I also
> > read that some disks or controllers can't handle smart tests.  Could
> > that be it? I don't run smart tests vary often, so I know the other
> > failures from the past were not caused by a smart test.  Maybe I am
> > doing the tests wrong?  I used this command: "smartctl --test=long
> > /dev/sda"
> >
> > All info I think might be needed:
> >
> > The disks are all Seagate ST3320620AS (320 GB disks).
> >
> > # uname -a
> > Linux linux.watkins-home.com 2.6.27.35-170.2.94.fc10.i686 #1 SMP Thu
> > Oct 1 14:58:51 EDT 2009 i686 i686 i386 GNU/Linux
> >
> > # rpm -qa mdadm
> > mdadm-2.6.9-1.fc10.i386
> >
> > From /var/log/messages-20091108
> > Nov  1 21:48:29 linux kernel: ata4.00: exception Emask 0x10 SAct 0x0
> > SErr 0x180203 action 0x6 frozen
> > Nov  1 21:48:29 linux kernel: ata4: SError: { RecovData RecovComm
> > Persist 10B8B Dispar }
> > Nov  1 21:48:29 linux kernel: ata4.00: cmd
> > ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> > Nov  1 21:48:29 linux kernel: res 40/00:01:00:4f:c2/00:00:00:00:00/00
> > Emask 0x14 (ATA bus error)
> > Nov  1 21:48:29 linux kernel: ata4.00: status: { DRDY }
> > Nov  1 21:48:29 linux kernel: ata4: hard resetting link
> > Nov  1 21:48:31 linux kernel: ata4: SATA link up 1.5 Gbps (SStatus 113
> > SControl 300)
> > Nov  1 21:48:31 linux kernel: ata4.00: configured for UDMA/133
> > Nov  1 21:48:31 linux kernel: ata4.00: device reported invalid CHS
> > sector 0 Nov  1 21:48:31 linux kernel: ata4: EH complete
> > Nov  1 21:48:31 linux kernel: sd 3:0:0:0: [sdb] 625142448 512-byte
> > hardware sectors (320073 MB)
> > Nov  1 21:48:31 linux kernel: end_request: I/O error, dev sdb, sector
> > 34089705
> > Nov  1 21:48:31 linux kernel: md: super_written gets error=-5,
> > uptodate=0 Nov  1 21:48:31 linux kernel: raid5: Disk failure on sdb2,
> > disabling device. Nov  1 21:48:31 linux kernel: raid5: Operation
> > continuing on 3 devices. Nov  1 21:48:31 linux kernel: sd 3:0:0:0:
> > [sdb] Write Protect is off Nov  1 21:48:31 linux kernel: sd 3:0:0:0:
> > [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or
> > FUA
> > Nov  1 21:48:31 linux kernel: RAID5 conf printout:
> > Nov  1 21:48:31 linux kernel: --- rd:4 wd:3
> > Nov  1 21:48:31 linux kernel: disk 0, o:0, dev:sdb2
> > Nov  1 21:48:31 linux kernel: disk 1, o:1, dev:sdd2
> > Nov  1 21:48:31 linux kernel: disk 2, o:1, dev:sdc2
> > Nov  1 21:48:31 linux kernel: disk 3, o:1, dev:sda2
> > Nov  1 21:48:31 linux kernel: RAID5 conf printout:
> > Nov  1 21:48:31 linux kernel: --- rd:4 wd:3
> > Nov  1 21:48:31 linux kernel: disk 1, o:1, dev:sdd2
> > Nov  1 21:48:31 linux kernel: disk 2, o:1, dev:sdc2
> > Nov  1 21:48:31 linux kernel: disk 3, o:1, dev:sda2
> >
> > # cat /proc/mdstat
> > Personalities : [raid6] [raid5] [raid4] [raid1]
> > md0 : active raid1 sdd1[0] sda1[3] sdc1[2] sdb1[1]
> >      264960 blocks [4/4] [UUUU]
> >      bitmap: 0/33 pages [0KB], 4KB chunk
> >
> > md4 : active raid6 sdd4[0] sda4[3] sdc4[2] sdb4[4](F)
> >      586853888 blocks level 6, 256k chunk, algorithm 2 [4/3] [U_UU]
> >      bitmap: 70/140 pages [280KB], 1024KB chunk
> >
> > md2 : active raid1 sdb3[0] sda3[1]
> >      2096384 blocks [2/2] [UU]
> >      bitmap: 0/128 pages [0KB], 8KB chunk
> >
> > md1 : active raid1 sdd3[0] sdc3[1]
> >      2096384 blocks [2/2] [UU]
> >      bitmap: 0/128 pages [0KB], 8KB chunk
> >
> > md3 : active raid6 sdb2[4](F) sdd2[1] sda2[3] sdc2[2]
> >      33559552 blocks level 6, 256k chunk, algorithm 2 [4/3] [_UUU]
> >      bitmap: 119/129 pages [476KB], 64KB chunk
> >
> > unused devices: <none>
> >
> > # smartctl -a /dev/sda
> > smartctl version 5.38 [i386-redhat-linux-gnu] Copyright (C) 2002-8
> > Bruce Allen
> > Home page is http://smartmontools.sourceforge.net/
> >
> > === START OF INFORMATION SECTION ===
> > Model Family:     Seagate Barracuda 7200.10 family
> > Device Model:     ST3320620AS
> > Serial Number:    3QF08NDL
> > Firmware Version: 3.AAD
> > User Capacity:    320,072,933,376 bytes
> > Device is:        In smartctl database [for details use: -P show]
> > ATA Version is:   7
> > ATA Standard is:  Exact ATA specification draft version not indicated
> > Local Time is:    Tue Nov 10 23:57:28 2009 EST
> > SMART support is: Available - device has SMART capability.
> > SMART support is: Enabled
> >
> > === START OF READ SMART DATA SECTION ===
> > SMART overall-health self-assessment test result: PASSED
> >
> > General SMART Values:
> > Offline data collection status:  (0x82) Offline data collection
> > activity was completed without error. Auto Offline Data Collection:
> > Enabled.
> > Self-test execution status:      (   0) The previous self-test routine
> > completed
> >                                        without error or no self-test
> > has ever
> >                                        been run.
> > Total time to complete Offline
> > data collection:                 ( 430) seconds.
> > Offline data collection
> > capabilities:                    (0x5b) SMART execute Offline
> > immediate. Auto Offline data collection on/off support.
> >                                        Suspend Offline collection upon
> > new command.
> >                                        Offline surface scan supported.
> >                                        Self-test supported.
> >                                        No Conveyance Self-test
> > supported. Selective Self-test supported. SMART capabilities:          
> >  (0x0003) Saves SMART data before entering power-saving mode.
> >                                        Supports SMART auto save timer.
> > Error logging capability:        (0x01) Error logging supported.
> >                                        General Purpose Logging
> > supported. Short self-test routine
> > recommended polling time:        (   1) minutes.
> > Extended self-test routine
> > recommended polling time:        ( 115) minutes.
> >
> > SMART Attributes Data Structure revision number: 10
> > Vendor Specific SMART Attributes with Thresholds:
> > ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE    
> >  UPDATED WHEN_FAILED RAW_VALUE
> >  1 Raw_Read_Error_Rate     0x000f   114   097   006    Pre-fail  Always
> > -       77830969
> >  3 Spin_Up_Time            0x0003   094   090   000    Pre-fail  Always
> > -       0
> >  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always
> > -       83
> >  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always
> > -       0
> >  7 Seek_Error_Rate         0x000f   081   060   030    Pre-fail  Always
> > -       150227385
> >  9 Power_On_Hours          0x0032   073   073   000    Old_age   Always
> > -       23919
> >  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
> >  Always -       0
> >  12 Power_Cycle_Count       0x0032   100   100   020    Old_age  
> > Always -       116
> > 187 Reported_Uncorrect      0x0032   100   100   000    Old_age  
> > Always -       0
> > 189 High_Fly_Writes         0x003a   100   100   000    Old_age  
> > Always -       0
> > 190 Airflow_Temperature_Cel 0x0022   061   046   045    Old_age  
> > Always -       39 (Lifetime Min/Max 37/43)
> > 194 Temperature_Celsius     0x0022   039   054   000    Old_age  
> > Always -       39 (0 21 0 0)
> > 195 Hardware_ECC_Recovered  0x001a   065   054   000    Old_age  
> > Always -       102168431
> > 197 Current_Pending_Sector  0x0012   100   100   000    Old_age  
> > Always -       0
> > 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age  
> > Offline -       0
> > 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age  
> > Always -       0
> > 200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age  
> > Offline -       0
> > 202 TA_Increase_Count       0x0032   100   253   000    Old_age  
> > Always -       0
> >
> > SMART Error Log Version: 1
> > No Errors Logged
> >
> > SMART Self-test log structure revision number 1
> > Num  Test_Description    Status                  Remaining
> >  LifeTime(hours) LBA_of_first_error
> > # 1  Extended offline    Completed without error       00%     23730
> > -
> > # 2  Extended offline    Completed without error       00%     22581
> > -
> > # 3  Short offline       Completed without error       00%     22577
> > -
> > # 4  Extended offline    Completed without error       00%     17267
> > -
> > # 5  Short offline       Completed without error       00%     17259
> > -
> > # 6  Extended offline    Completed without error       00%       384
> > -
> >
> > SMART Selective self-test log data structure revision number 1
> >  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
> >    1        0        0  Not_testing
> >    2        0        0  Not_testing
> >    3        0        0  Not_testing
> >    4        0        0  Not_testing
> >    5        0        0  Not_testing
> > Selective self-test flags (0x0):
> >  After scanning selected spans, do NOT read-scan remainder of disk.
> > If Selective self-test is pending on power-up, resume after 0 minute
> > delay.
> >
> > # smartctl -a /dev/sdb
> > smartctl version 5.38 [i386-redhat-linux-gnu] Copyright (C) 2002-8
> > Bruce Allen
> > Home page is http://smartmontools.sourceforge.net/
> >
> > === START OF INFORMATION SECTION ===
> > Model Family:     Seagate Barracuda 7200.10 family
> > Device Model:     ST3320620AS
> > Serial Number:    3QF08SKR
> > Firmware Version: 3.AAD
> > User Capacity:    320,072,933,376 bytes
> > Device is:        In smartctl database [for details use: -P show]
> > ATA Version is:   7
> > ATA Standard is:  Exact ATA specification draft version not indicated
> > Local Time is:    Wed Nov 11 00:03:14 2009 EST
> > SMART support is: Available - device has SMART capability.
> > SMART support is: Enabled
> >
> > === START OF READ SMART DATA SECTION ===
> > SMART overall-health self-assessment test result: PASSED
> >
> > General SMART Values:
> > Offline data collection status:  (0x82) Offline data collection
> > activity was completed without error. Auto Offline Data Collection:
> > Enabled.
> > Self-test execution status:      (  37) The self-test routine was
> > interrupted
> >                                        by the host with a hard or soft
> > reset.
> > Total time to complete Offline
> > data collection:                 ( 430) seconds.
> > Offline data collection
> > capabilities:                    (0x5b) SMART execute Offline
> > immediate. Auto Offline data collection on/off support.
> >                                        Suspend Offline collection upon
> > new command.
> >                                        Offline surface scan supported.
> >                                        Self-test supported.
> >                                        No Conveyance Self-test
> > supported. Selective Self-test supported. SMART capabilities:          
> >  (0x0003) Saves SMART data before entering power-saving mode.
> >                                        Supports SMART auto save timer.
> > Error logging capability:        (0x01) Error logging supported.
> >                                        General Purpose Logging
> > supported. Short self-test routine
> > recommended polling time:        (   1) minutes.
> > Extended self-test routine
> > recommended polling time:        ( 115) minutes.
> >
> > SMART Attributes Data Structure revision number: 10
> > Vendor Specific SMART Attributes with Thresholds:
> > ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE    
> >  UPDATED WHEN_FAILED RAW_VALUE
> >  1 Raw_Read_Error_Rate     0x000f   111   091   006    Pre-fail  Always
> > -       136981744
> >  3 Spin_Up_Time            0x0003   099   090   000    Pre-fail  Always
> > -       0
> >  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always
> > -       104
> >  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always
> > -       1
> >  7 Seek_Error_Rate         0x000f   084   060   030    Pre-fail  Always
> > -       257877357
> >  9 Power_On_Hours          0x0032   073   073   000    Old_age   Always
> > -       23916
> >  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
> >  Always -       0
> >  12 Power_Cycle_Count       0x0032   100   100   020    Old_age  
> > Always -       157
> > 187 Reported_Uncorrect      0x0032   100   100   000    Old_age  
> > Always -       0
> > 189 High_Fly_Writes         0x003a   100   100   000    Old_age  
> > Always -       0
> > 190 Airflow_Temperature_Cel 0x0022   059   049   045    Old_age  
> > Always -       41 (Lifetime Min/Max 38/43)
> > 194 Temperature_Celsius     0x0022   041   051   000    Old_age  
> > Always -       41 (0 21 0 0)
> > 195 Hardware_ECC_Recovered  0x001a   063   054   000    Old_age  
> > Always -       160751697
> > 197 Current_Pending_Sector  0x0012   100   100   000    Old_age  
> > Always -       0
> > 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age  
> > Offline -       0
> > 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age  
> > Always -       0
> > 200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age  
> > Offline -       0
> > 202 TA_Increase_Count       0x0032   100   253   000    Old_age  
> > Always -       0
> >
> > SMART Error Log Version: 1
> > No Errors Logged
> >
> > SMART Self-test log structure revision number 1
> > Num  Test_Description    Status                  Remaining
> >  LifeTime(hours) LBA_of_first_error
> > # 1  Extended offline    Interrupted (host reset)      50%     23726
> > -
> > # 2  Extended offline    Completed without error       00%     22580
> > -
> > # 3  Short offline       Completed without error       00%     22577
> > -
> > # 4  Extended offline    Completed without error       00%     17267
> > -
> > # 5  Short offline       Completed without error       00%     17260
> > -
> > # 6  Extended offline    Completed without error       00%       384
> > -
> >
> > SMART Selective self-test log data structure revision number 1
> >  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
> >    1        0        0  Not_testing
> >    2        0        0  Not_testing
> >    3        0        0  Not_testing
> >    4        0        0  Not_testing
> >    5        0        0  Not_testing
> > Selective self-test flags (0x0):
> >  After scanning selected spans, do NOT read-scan remainder of disk.
> > If Selective self-test is pending on power-up, resume after 0 minute
> > delay.
> >
> > # smartctl -a /dev/sdc
> > smartctl version 5.38 [i386-redhat-linux-gnu] Copyright (C) 2002-8
> > Bruce Allen
> > Home page is http://smartmontools.sourceforge.net/
> >
> > === START OF INFORMATION SECTION ===
> > Model Family:     Seagate Barracuda 7200.10 family
> > Device Model:     ST3320620AS
> > Serial Number:    3QF08V24
> > Firmware Version: 3.AAD
> > User Capacity:    320,072,933,376 bytes
> > Device is:        In smartctl database [for details use: -P show]
> > ATA Version is:   7
> > ATA Standard is:  Exact ATA specification draft version not indicated
> > Local Time is:    Wed Nov 11 00:03:36 2009 EST
> > SMART support is: Available - device has SMART capability.
> > SMART support is: Enabled
> >
> > === START OF READ SMART DATA SECTION ===
> > SMART overall-health self-assessment test result: PASSED
> > See vendor-specific Attribute list for marginal Attributes.
> >
> > General SMART Values:
> > Offline data collection status:  (0x82) Offline data collection
> > activity was completed without error. Auto Offline Data Collection:
> > Enabled.
> > Self-test execution status:      (   0) The previous self-test routine
> > completed
> >                                        without error or no self-test
> > has ever
> >                                        been run.
> > Total time to complete Offline
> > data collection:                 ( 430) seconds.
> > Offline data collection
> > capabilities:                    (0x5b) SMART execute Offline
> > immediate. Auto Offline data collection on/off support.
> >                                        Suspend Offline collection upon
> > new command.
> >                                        Offline surface scan supported.
> >                                        Self-test supported.
> >                                        No Conveyance Self-test
> > supported. Selective Self-test supported. SMART capabilities:          
> >  (0x0003) Saves SMART data before entering power-saving mode.
> >                                        Supports SMART auto save timer.
> > Error logging capability:        (0x01) Error logging supported.
> >                                        General Purpose Logging
> > supported. Short self-test routine
> > recommended polling time:        (   1) minutes.
> > Extended self-test routine
> > recommended polling time:        ( 115) minutes.
> >
> > SMART Attributes Data Structure revision number: 10
> > Vendor Specific SMART Attributes with Thresholds:
> > ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE    
> >  UPDATED WHEN_FAILED RAW_VALUE
> >  1 Raw_Read_Error_Rate     0x000f   119   090   006    Pre-fail  Always
> > -       221110249
> >  3 Spin_Up_Time            0x0003   094   090   000    Pre-fail  Always
> > -       0
> >  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always
> > -       94
> >  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always
> > -       0
> >  7 Seek_Error_Rate         0x000f   081   060   030    Pre-fail  Always
> > -       138219006
> >  9 Power_On_Hours          0x0032   073   073   000    Old_age   Always
> > -       23917
> >  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
> >  Always -       0
> >  12 Power_Cycle_Count       0x0032   100   100   020    Old_age  
> > Always -       130
> > 187 Reported_Uncorrect      0x0032   082   082   000    Old_age  
> > Always -       18
> > 189 High_Fly_Writes         0x003a   100   100   000    Old_age  
> > Always -       0
> > 190 Airflow_Temperature_Cel 0x0022   059   044   045    Old_age  
> > Always In_the_past 41 (Lifetime Min/Max 39/45)
> > 194 Temperature_Celsius     0x0022   041   056   000    Old_age  
> > Always -       41 (0 22 0 0)
> > 195 Hardware_ECC_Recovered  0x001a   066   057   000    Old_age  
> > Always -       145841009
> > 197 Current_Pending_Sector  0x0012   100   100   000    Old_age  
> > Always -       0
> > 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age  
> > Offline -       0
> > 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age  
> > Always -       0
> > 200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age  
> > Offline -       0
> > 202 TA_Increase_Count       0x0032   100   253   000    Old_age  
> > Always -       0
> >
> > SMART Error Log Version: 1
> > ATA Error Count: 18 (device log contains only the most recent five
> > errors) CR = Command Register [HEX]
> >        FR = Features Register [HEX]
> >        SC = Sector Count Register [HEX]
> >        SN = Sector Number Register [HEX]
> >        CL = Cylinder Low Register [HEX]
> >        CH = Cylinder High Register [HEX]
> >        DH = Device/Head Register [HEX]
> >        DC = Device Command Register [HEX]
> >        ER = Error register [HEX]
> >        ST = Status register [HEX]
> > Powered_Up_Time is measured from power on, and printed as
> > DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
> > SS=sec, and sss=millisec. It "wraps" after 49.710 days.
> >
> > Error 18 occurred at disk power-on lifetime: 5380 hours (224 days + 4
> > hours) When the command that caused the error occurred, the device was
> > active or idle.
> >
> >  After command completion occurred, registers were:
> >  ER ST SC SN CL CH DH
> >  -- -- -- -- -- -- --
> >  40 51 00 63 81 09 e0  Error: UNC at LBA = 0x00098163 = 622947
> >
> >  Commands leading to the command that caused the error were:
> >  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
> >  -- -- -- -- -- -- -- --  ----------------  --------------------
> >  25 00 00 e1 7e 09 e0 00      00:16:26.026  READ DMA EXT
> >  ec 00 00 00 00 00 a0 00      00:16:26.022  IDENTIFY DEVICE
> >  ef 03 46 00 00 00 a0 00      00:16:26.022  SET FEATURES [Set transfer
> > mode]
> >  ec 00 00 00 00 00 a0 00      00:16:26.019  IDENTIFY DEVICE
> >  25 00 00 e1 7e 09 e0 00      00:16:24.456  READ DMA EXT
> >
> > Error 17 occurred at disk power-on lifetime: 5380 hours (224 days + 4
> > hours) When the command that caused the error occurred, the device was
> > active or idle.
> >
> >  After command completion occurred, registers were:
> >  ER ST SC SN CL CH DH
> >  -- -- -- -- -- -- --
> >  40 51 00 63 81 09 e0  Error: UNC at LBA = 0x00098163 = 622947
> >
> >  Commands leading to the command that caused the error were:
> >  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
> >  -- -- -- -- -- -- -- --  ----------------  --------------------
> >  25 00 00 e1 7e 09 e0 00      00:16:21.313  READ DMA EXT
> >  ec 00 00 00 00 00 a0 00      00:16:19.753  IDENTIFY DEVICE
> >  ef 03 46 00 00 00 a0 00      00:16:19.749  SET FEATURES [Set transfer
> > mode]
> >  ec 00 00 00 00 00 a0 00      00:16:19.749  IDENTIFY DEVICE
> >  25 00 00 e1 7e 09 e0 00      00:16:24.456  READ DMA EXT
> >
> > Error 16 occurred at disk power-on lifetime: 5380 hours (224 days + 4
> > hours) When the command that caused the error occurred, the device was
> > active or idle.
> >
> >  After command completion occurred, registers were:
> >  ER ST SC SN CL CH DH
> >  -- -- -- -- -- -- --
> >  40 51 00 63 81 09 e0  Error: UNC at LBA = 0x00098163 = 622947
> >
> >  Commands leading to the command that caused the error were:
> >  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
> >  -- -- -- -- -- -- -- --  ----------------  --------------------
> >  25 00 00 e1 7e 09 e0 00      00:16:21.313  READ DMA EXT
> >  ec 00 00 00 00 00 a0 00      00:16:19.753  IDENTIFY DEVICE
> >  ef 03 46 00 00 00 a0 00      00:16:19.749  SET FEATURES [Set transfer
> > mode]
> >  ec 00 00 00 00 00 a0 00      00:16:19.749  IDENTIFY DEVICE
> >  25 00 00 e1 7e 09 e0 00      00:16:19.745  READ DMA EXT
> >
> > Error 15 occurred at disk power-on lifetime: 5380 hours (224 days + 4
> > hours) When the command that caused the error occurred, the device was
> > active or idle.
> >
> >  After command completion occurred, registers were:
> >  ER ST SC SN CL CH DH
> >  -- -- -- -- -- -- --
> >  40 51 00 63 81 09 e0  Error: UNC at LBA = 0x00098163 = 622947
> >
> >  Commands leading to the command that caused the error were:
> >  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
> >  -- -- -- -- -- -- -- --  ----------------  --------------------
> >  25 00 00 e1 7e 09 e0 00      00:16:21.313  READ DMA EXT
> >  ec 00 00 00 00 00 a0 00      00:16:19.753  IDENTIFY DEVICE
> >  ef 03 46 00 00 00 a0 00      00:16:19.749  SET FEATURES [Set transfer
> > mode]
> >  ec 00 00 00 00 00 a0 00      00:16:19.749  IDENTIFY DEVICE
> >  25 00 00 e1 7e 09 e0 00      00:16:19.745  READ DMA EXT
> >
> > Error 14 occurred at disk power-on lifetime: 5380 hours (224 days + 4
> > hours) When the command that caused the error occurred, the device was
> > active or idle.
> >
> >  After command completion occurred, registers were:
> >  ER ST SC SN CL CH DH
> >  -- -- -- -- -- -- --
> >  40 51 00 63 81 09 e0  Error: UNC at LBA = 0x00098163 = 622947
> >
> >  Commands leading to the command that caused the error were:
> >  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
> >  -- -- -- -- -- -- -- --  ----------------  --------------------
> >  25 00 00 e1 7e 09 e0 00      00:16:17.672  READ DMA EXT
> >  ec 00 00 00 00 00 a0 00      00:16:19.753  IDENTIFY DEVICE
> >  ef 03 46 00 00 00 a0 00      00:16:19.749  SET FEATURES [Set transfer
> > mode]
> >  ec 00 00 00 00 00 a0 00      00:16:19.749  IDENTIFY DEVICE
> >  25 00 00 e1 7e 09 e0 00      00:16:19.745  READ DMA EXT
> >
> > SMART Self-test log structure revision number 1
> > Num  Test_Description    Status                  Remaining
> >  LifeTime(hours) LBA_of_first_error
> > # 1  Extended offline    Completed without error       00%     23728
> > -
> > # 2  Extended offline    Completed without error       00%     22579
> > -
> > # 3  Short offline       Completed without error       00%     22576
> > -
> > # 4  Extended offline    Completed without error       00%     17265
> > -
> > # 5  Short offline       Completed without error       00%     17257
> > -
> > # 6  Extended offline    Completed without error       00%       384
> > -
> >
> > SMART Selective self-test log data structure revision number 1
> >  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
> >    1        0        0  Not_testing
> >    2        0        0  Not_testing
> >    3        0        0  Not_testing
> >    4        0        0  Not_testing
> >    5        0        0  Not_testing
> > Selective self-test flags (0x0):
> >  After scanning selected spans, do NOT read-scan remainder of disk.
> > If Selective self-test is pending on power-up, resume after 0 minute
> > delay.
> >
> > # smartctl -a /dev/sdd
> > smartctl version 5.38 [i386-redhat-linux-gnu] Copyright (C) 2002-8
> > Bruce Allen
> > Home page is http://smartmontools.sourceforge.net/
> >
> > === START OF INFORMATION SECTION ===
> > Model Family:     Seagate Barracuda 7200.10 family
> > Device Model:     ST3320620AS
> > Serial Number:    3QF08WDP
> > Firmware Version: 3.AAD
> > User Capacity:    320,072,933,376 bytes
> > Device is:        In smartctl database [for details use: -P show]
> > ATA Version is:   7
> > ATA Standard is:  Exact ATA specification draft version not indicated
> > Local Time is:    Wed Nov 11 00:04:04 2009 EST
> > SMART support is: Available - device has SMART capability.
> > SMART support is: Enabled
> >
> > === START OF READ SMART DATA SECTION ===
> > SMART overall-health self-assessment test result: PASSED
> >
> > General SMART Values:
> > Offline data collection status:  (0x82) Offline data collection
> > activity was completed without error. Auto Offline Data Collection:
> > Enabled.
> > Self-test execution status:      (   0) The previous self-test routine
> > completed
> >                                        without error or no self-test
> > has ever
> >                                        been run.
> > Total time to complete Offline
> > data collection:                 ( 430) seconds.
> > Offline data collection
> > capabilities:                    (0x5b) SMART execute Offline
> > immediate. Auto Offline data collection on/off support.
> >                                        Suspend Offline collection upon
> > new command.
> >                                        Offline surface scan supported.
> >                                        Self-test supported.
> >                                        No Conveyance Self-test
> > supported. Selective Self-test supported. SMART capabilities:          
> >  (0x0003) Saves SMART data before entering power-saving mode.
> >                                        Supports SMART auto save timer.
> > Error logging capability:        (0x01) Error logging supported.
> >                                        General Purpose Logging
> > supported. Short self-test routine
> > recommended polling time:        (   1) minutes.
> > Extended self-test routine
> > recommended polling time:        ( 115) minutes.
> >
> > SMART Attributes Data Structure revision number: 10
> > Vendor Specific SMART Attributes with Thresholds:
> > ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE    
> >  UPDATED WHEN_FAILED RAW_VALUE
> >  1 Raw_Read_Error_Rate     0x000f   110   090   006    Pre-fail  Always
> > -       25809154
> >  3 Spin_Up_Time            0x0003   098   090   000    Pre-fail  Always
> > -       0
> >  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always
> > -       516
> >  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always
> > -       0
> >  7 Seek_Error_Rate         0x000f   082   060   030    Pre-fail  Always
> > -       192909989
> >  9 Power_On_Hours          0x0032   073   073   000    Old_age   Always
> > -       23896
> >  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
> >  Always -       0
> >  12 Power_Cycle_Count       0x0032   100   100   020    Old_age  
> > Always -       777
> > 187 Reported_Uncorrect      0x0032   100   100   000    Old_age  
> > Always -       0
> > 189 High_Fly_Writes         0x003a   100   100   000    Old_age  
> > Always -       0
> > 190 Airflow_Temperature_Cel 0x0022   061   050   045    Old_age  
> > Always -       39 (Lifetime Min/Max 36/42)
> > 194 Temperature_Celsius     0x0022   039   050   000    Old_age  
> > Always -       39 (0 20 0 0)
> > 195 Hardware_ECC_Recovered  0x001a   064   055   000    Old_age  
> > Always -       81546876
> > 197 Current_Pending_Sector  0x0012   100   100   000    Old_age  
> > Always -       0
> > 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age  
> > Offline -       0
> > 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age  
> > Always -       0
> > 200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age  
> > Offline -       0
> > 202 TA_Increase_Count       0x0032   100   253   000    Old_age  
> > Always -       0
> >
> > SMART Error Log Version: 1
> > ATA Error Count: 6 (device log contains only the most recent five
> > errors) CR = Command Register [HEX]
> >        FR = Features Register [HEX]
> >        SC = Sector Count Register [HEX]
> >        SN = Sector Number Register [HEX]
> >        CL = Cylinder Low Register [HEX]
> >        CH = Cylinder High Register [HEX]
> >        DH = Device/Head Register [HEX]
> >        DC = Device Command Register [HEX]
> >        ER = Error register [HEX]
> >        ST = Status register [HEX]
> > Powered_Up_Time is measured from power on, and printed as
> > DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
> > SS=sec, and sss=millisec. It "wraps" after 49.710 days.
> >
> > Error 6 occurred at disk power-on lifetime: 10007 hours (416 days + 23
> > hours)
> >  When the command that caused the error occurred, the device was active
> > or idle.
> >
> >  After command completion occurred, registers were:
> >  ER ST SC SN CL CH DH
> >  -- -- -- -- -- -- --
> >  40 51 00 a5 0d 4a e0  Error: UNC at LBA = 0x004a0da5 = 4853157
> >
> >  Commands leading to the command that caused the error were:
> >  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
> >  -- -- -- -- -- -- -- --  ----------------  --------------------
> >  25 00 00 8f 0c 4a e0 00      00:05:45.657  READ DMA EXT
> >  27 00 00 00 00 00 e0 00      00:05:45.654  READ NATIVE MAX ADDRESS EXT
> >  ec 00 00 00 00 00 a0 00      00:05:43.727  IDENTIFY DEVICE
> >  ef 03 46 00 00 00 a0 00      00:05:43.660  SET FEATURES [Set transfer
> > mode]
> >  27 00 00 00 00 00 e0 00      00:05:43.658  READ NATIVE MAX ADDRESS EXT
> >
> > Error 5 occurred at disk power-on lifetime: 10007 hours (416 days + 23
> > hours)
> >  When the command that caused the error occurred, the device was active
> > or idle.
> >
> >  After command completion occurred, registers were:
> >  ER ST SC SN CL CH DH
> >  -- -- -- -- -- -- --
> >  40 51 00 a5 0d 4a e0  Error: UNC at LBA = 0x004a0da5 = 4853157
> >
> >  Commands leading to the command that caused the error were:
> >  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
> >  -- -- -- -- -- -- -- --  ----------------  --------------------
> >  25 00 00 8f 0c 4a e0 00      00:05:45.657  READ DMA EXT
> >  27 00 00 00 00 00 e0 00      00:05:45.654  READ NATIVE MAX ADDRESS EXT
> >  ec 00 00 00 00 00 a0 00      00:05:43.727  IDENTIFY DEVICE
> >  ef 03 46 00 00 00 a0 00      00:05:43.660  SET FEATURES [Set transfer
> > mode]
> >  27 00 00 00 00 00 e0 00      00:05:43.658  READ NATIVE MAX ADDRESS EXT
> >
> > Error 4 occurred at disk power-on lifetime: 10007 hours (416 days + 23
> > hours)
> >  When the command that caused the error occurred, the device was active
> > or idle.
> >
> >  After command completion occurred, registers were:
> >  ER ST SC SN CL CH DH
> >  -- -- -- -- -- -- --
> >  40 51 00 a5 0d 4a e0  Error: UNC at LBA = 0x004a0da5 = 4853157
> >
> >  Commands leading to the command that caused the error were:
> >  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
> >  -- -- -- -- -- -- -- --  ----------------  --------------------
> >  25 00 00 8f 0c 4a e0 00      00:05:39.547  READ DMA EXT
> >  27 00 00 00 00 00 e0 00      00:05:39.544  READ NATIVE MAX ADDRESS EXT
> >  ec 00 00 00 00 00 a0 00      00:05:43.727  IDENTIFY DEVICE
> >  ef 03 46 00 00 00 a0 00      00:05:43.660  SET FEATURES [Set transfer
> > mode]
> >  27 00 00 00 00 00 e0 00      00:05:43.658  READ NATIVE MAX ADDRESS EXT
> >
> > Error 3 occurred at disk power-on lifetime: 10007 hours (416 days + 23
> > hours)
> >  When the command that caused the error occurred, the device was active
> > or idle.
> >
> >  After command completion occurred, registers were:
> >  ER ST SC SN CL CH DH
> >  -- -- -- -- -- -- --
> >  40 51 00 a5 0d 4a e0  Error: UNC at LBA = 0x004a0da5 = 4853157
> >
> >  Commands leading to the command that caused the error were:
> >  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
> >  -- -- -- -- -- -- -- --  ----------------  --------------------
> >  25 00 00 8f 0c 4a e0 00      00:05:39.547  READ DMA EXT
> >  27 00 00 00 00 00 e0 00      00:05:39.544  READ NATIVE MAX ADDRESS EXT
> >  ec 00 00 00 00 00 a0 00      00:05:39.530  IDENTIFY DEVICE
> >  ef 03 46 00 00 00 a0 00      00:05:39.475  SET FEATURES [Set transfer
> > mode]
> >  27 00 00 00 00 00 e0 00      00:05:39.472  READ NATIVE MAX ADDRESS EXT
> >
> > Error 2 occurred at disk power-on lifetime: 10007 hours (416 days + 23
> > hours)
> >  When the command that caused the error occurred, the device was active
> > or idle.
> >
> >  After command completion occurred, registers were:
> >  ER ST SC SN CL CH DH
> >  -- -- -- -- -- -- --
> >  40 51 00 a5 0d 4a e0  Error: UNC at LBA = 0x004a0da5 = 4853157
> >
> >  Commands leading to the command that caused the error were:
> >  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
> >  -- -- -- -- -- -- -- --  ----------------  --------------------
> >  25 00 00 8f 0c 4a e0 00      00:05:39.547  READ DMA EXT
> >  27 00 00 00 00 00 e0 00      00:05:39.544  READ NATIVE MAX ADDRESS EXT
> >  ec 00 00 00 00 00 a0 00      00:05:39.530  IDENTIFY DEVICE
> >  ef 03 46 00 00 00 a0 00      00:05:39.475  SET FEATURES [Set transfer
> > mode]
> >  27 00 00 00 00 00 e0 00      00:05:39.472  READ NATIVE MAX ADDRESS EXT
> >
> > SMART Self-test log structure revision number 1
> > Num  Test_Description    Status                  Remaining
> >  LifeTime(hours) LBA_of_first_error
> > # 1  Extended offline    Completed without error       00%     23707
> > -
> > # 2  Extended offline    Completed without error       00%     22559
> > -
> > # 3  Short offline       Completed without error       00%     22555
> > -
> > # 4  Extended offline    Completed without error       00%     17248
> > -
> > # 5  Short offline       Completed without error       00%     17241
> > -
> > # 6  Short offline       Completed without error       00%     17241
> > -
> > # 7  Extended offline    Completed without error       00%       384
> > -
> > # 8  Short offline       Completed without error       00%       381
> > -
> >
> > SMART Selective self-test log data structure revision number 1
> >  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
> >    1        0        0  Not_testing
> >    2        0        0  Not_testing
> >    3        0        0  Not_testing
> >    4        0        0  Not_testing
> >    5        0        0  Not_testing
> > Selective self-test flags (0x0):
> >  After scanning selected spans, do NOT read-scan remainder of disk.
> > If Selective self-test is pending on power-up, resume after 0 minute
> > delay.
> >
> > Thanks,
> > Guy
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
