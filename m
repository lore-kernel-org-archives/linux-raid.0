From: Andrew Ryder <tireman@shaw.ca>
Subject: cannot re-assmble mdadm array
Date: Sat, 12 Apr 2014 01:18:32 -0600 (MDT)
Message-ID: <400635298.23842674.1397287112819.JavaMail.root@cds036>
References: <1250925833.23839319.1397286490552.JavaMail.root@cds036>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1250925833.23839319.1397286490552.JavaMail.root@cds036>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a 4 disk raid 5 array which I can't reassmble after one drive in the array failed and caused the port-multiplier to reset multiple times which messed up the array.

Is there any way to get the other 3 drives back in sync to re-assemble the array?

Thanks,
Andrew


/dev/sdd1 and /dev/sde1 are both good. /dev/sdh1 is good but won't re-add. /dev/sdi1 is the failing drive.


/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : b03879ae:9db37418:170a2e25:200f8b00
           Name : movies:0
  Creation Time : Sat Jul 16 03:53:42 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
     Array Size : 5860536768 (5589.04 GiB 6001.19 GB)
  Used Dev Size : 3907024512 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=384 sectors
          State : clean
    Device UUID : c348a635:c282dd97:bfd9f4ab:b8a53b56

    Update Time : Sat Apr 12 01:48:16 2014
       Checksum : 71a5ebf9 - correct
         Events : 88746

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : AA.. ('A' == active, '.' == missing, 'R' == replacing)



/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : b03879ae:9db37418:170a2e25:200f8b00
           Name : movies:0
  Creation Time : Sat Jul 16 03:53:42 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
     Array Size : 5860536768 (5589.04 GiB 6001.19 GB)
  Used Dev Size : 3907024512 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=384 sectors
          State : clean
    Device UUID : be5b9988:f84c23af:3cab00f8:2bbf93b8

    Update Time : Sat Apr 12 01:48:16 2014
       Checksum : 8a42b420 - correct
         Events : 88746

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : AA.. ('A' == active, '.' == missing, 'R' == replacing)




(this is the other good disk that won't re-add)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : b03879ae:9db37418:170a2e25:200f8b00
           Name : movies:0
  Creation Time : Sat Jul 16 03:53:42 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
     Array Size : 5860536768 (5589.04 GiB 6001.19 GB)
  Used Dev Size : 3907024512 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=384 sectors
          State : active
    Device UUID : 6ae605a9:fc15017b:e4f9ea88:95769e36

    Update Time : Sat Apr 12 01:25:59 2014
       Checksum : 858006ef - correct
         Events : 88291

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)



(this is the failing disk)
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : b03879ae:9db37418:170a2e25:200f8b00
           Name : movies:0
  Creation Time : Sat Jul 16 03:53:42 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907024513 (1863.01 GiB 2000.40 GB)
     Array Size : 5860536768 (5589.04 GiB 6001.19 GB)
  Used Dev Size : 3907024512 (1863.01 GiB 2000.40 GB)
    Data Offset : 384 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 2f05fa6e:67af6f2f:ad1560f3:d71735cf

    Update Time : Sat Apr 12 01:39:24 2014
       Checksum : 2ef78fe - correct
         Events : 88730

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 3
   Array State : AA.A ('A' == active, '.' == missing, 'R' == replacing)



# mdadm --assemble --run --force -vvv /dev/md2 

mdadm: looking for devices for /dev/md2
mdadm: /dev/disk/by-id/ata-ST2000DL003-9VT166_5YD4PLD3-part1 is not one of
/dev/disk/by-id/ata-SAMSUNG_HD204UI_S2HGJ9CZB04511-part1,/dev/disk/by-id/ata-SAMSUNG_HD204UI_S2HGJ9BZB13889-part1,/dev/disk/by-id/ata-ST2000DL001-9VT156_5YD1516L-part1,/dev/disk/by-id/ata-ST3000DM001-1CH166_Z1F31KGY-part1
mdadm: /dev/disk/by-id/ata-ST2000DL003-9VT166_5YD4PSMK-part1 is not one of
/dev/disk/by-id/ata-SAMSUNG_HD204UI_S2HGJ9CZB04511-part1,/dev/disk/by-id/ata-SAMSUNG_HD204UI_S2HGJ9BZB13889-part1,/dev/disk/by-id/ata-ST2000DL001-9VT156_5YD1516L-part1,/dev/disk/by-id/ata-ST3000DM001-1CH166_Z1F31KGY-part1
mdadm: /dev/disk/by-id/ata-ST2000DL003-9VT166_5YD4QHNL-part1 is not one of
/dev/disk/by-id/ata-SAMSUNG_HD204UI_S2HGJ9CZB04511-part1,/dev/disk/by-id/ata-SAMSUNG_HD204UI_S2HGJ9BZB13889-part1,/dev/disk/by-id/ata-ST2000DL001-9VT156_5YD1516L-part1,/dev/disk/by-id/ata-ST3000DM001-1CH166_Z1F31KGY-part1
mdadm: Not a listed device for /dev/md1.
mdadm: Not a listed device for /dev/md3.
mdadm: Not a listed device for /dev/md1.
mdadm: Not a listed device for /dev/md3.
mdadm: Not a listed device for /dev/md1.
mdadm: Not a listed device for /dev/md3.
mdadm: Not a listed device for /dev/md1.
mdadm: Not a listed device for /dev/md3.
mdadm: /dev/disk/by-id/ata-SAMSUNG_HD204UI_S2HGJ9CZB04511-part1 is identified as a member of /dev/md2, slot 0.
mdadm: /dev/disk/by-id/ata-SAMSUNG_HD204UI_S2HGJ9BZB13889-part1 is identified as a member of /dev/md2, slot 1.
mdadm: /dev/disk/by-id/ata-ST2000DL001-9VT156_5YD1516L-part1 is identified as a member of /dev/md2, slot 2.
mdadm: /dev/disk/by-id/ata-ST3000DM001-1CH166_Z1F31KGY-part1 is identified as a member of /dev/md2, slot 3.
mdadm: added /dev/disk/by-id/ata-SAMSUNG_HD204UI_S2HGJ9BZB13889-part1 to /dev/md2 as 1
mdadm: added /dev/disk/by-id/ata-ST2000DL001-9VT156_5YD1516L-part1 to /dev/md2 as 2 (possibly out of date)
mdadm: added /dev/disk/by-id/ata-ST3000DM001-1CH166_Z1F31KGY-part1 to /dev/md2 as 3 (possibly out of date)
mdadm: added /dev/disk/by-id/ata-SAMSUNG_HD204UI_S2HGJ9CZB04511-part1 to /dev/md2 as 0
mdadm: failed to RUN_ARRAY /dev/md2: Input/output error
mdadm: Not enough devices to start the array.



#smartctl -a /dev/sdh

smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.6.11] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda Green (AF)
Device Model:     ST2000DL001-9VT156
Serial Number:    5YD1516L
LU WWN Device Id: 5 000c50 02f1ca352
Firmware Version: CC96
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5900 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 3.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sat Apr 12 03:17:06 2014 EDT

==> WARNING: A firmware update for this drive may be available,
see the following Seagate web pages:
http://knowledge.seagate.com/articles/en_US/FAQ/207931en
http://knowledge.seagate.com/articles/en_US/FAQ/218171en

SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)	Offline data collection activity
					was completed without error.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		(  612) seconds.
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
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 ( 331) minutes.
Conveyance self-test routine
recommended polling time: 	 (   2) minutes.
SCT capabilities: 	       (0x103b)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   123   099   006    Pre-fail  Always       -       670547944
  3 Spin_Up_Time            0x0003   085   071   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       59
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000f   079   060   030    Pre-fail  Always       -       97355585
  9 Power_On_Hours          0x0032   073   073   000    Old_age   Always       -       23934
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       57
183 Runtime_Bad_Block       0x0032   098   098   000    Old_age   Always       -       2
184 End-to-End_Error        0x0032   100   100   099    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
188 Command_Timeout         0x0032   098   098   000    Old_age   Always       -       107375820845
189 High_Fly_Writes         0x003a   099   099   000    Old_age   Always       -       1
190 Airflow_Temperature_Cel 0x0022   070   058   045    Old_age   Always       -       30 (Min/Max 23/30)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       49
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       59
194 Temperature_Celsius     0x0022   030   042   000    Old_age   Always       -       30 (0 19 0 0 0)
195 Hardware_ECC_Recovered  0x001a   123   099   000    Old_age   Always       -       670547944
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       147
240 Head_Flying_Hours       0x0000   100   253   000    Old_age   Offline      -       178400056596126
241 Total_LBAs_Written      0x0000   100   253   000    Old_age   Offline      -       3394475871
242 Total_LBAs_Read         0x0000   100   253   000    Old_age   Offline      -       624855241

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%     23933         -

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



