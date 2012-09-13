From: =?ISO-8859-15?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
Subject: raid1 issue after disk failure: both disks of the array are still
 active
Date: Thu, 13 Sep 2012 12:01:59 +0200
Message-ID: <5051AF17.8010501@linuxsystems.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I have a raid1 array with two disks, distro is Squeeze amd64. /dev/sda=20
is slowly dying, here is a snippet of "smartctl -a /dev/sda":

197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Alway=
s=20
       -       2
198 Offline_Uncorrectable   0x0030   100   100   000    Old_age Offline=
=20
      -       1

The bad sector is in the second half-MB of the disk, in fact with "dd=20
if=3D/dev/sda1 of=3D/dev/null bs=3D524228 count=3D1 skip=3D1" I get thi=
s output in=20
/var/log/syslog:

root@asterisk:~# dd if=3D/dev/sda1 of=3D/dev/null bs=3D524228 count=3D1=
 skip=3D1
0+1 record dentro
0+1 record fuori
430140 byte (430 kB) copiati, 11,7265 s, 36,7 kB/s

Sep 12 22:15:02 asterisk kernel: [ 8921.561978] dd: sending ioctl=20
80306d02 to a partition!
Sep 12 22:15:02 asterisk kernel: [ 8921.561986] dd: sending ioctl=20
80306d02 to a partition!
Sep 12 22:15:03 asterisk kernel: [ 8922.529099] ata3.00: exception Emas=
k=20
0x0 SAct 0x0 SErr 0x0 action 0x0
Sep 12 22:15:03 asterisk kernel: [ 8922.531774] ata3.00: BMDMA stat 0x4=
4
Sep 12 22:15:03 asterisk kernel: [ 8922.533547] ata3.00: failed command=
:=20
READ DMA
Sep 12 22:15:03 asterisk kernel: [ 8922.535313] ata3.00: cmd=20
c8/00:08:48:0f:00/00:00:00:00:00/e0 tag 0 dma 4096 in
Sep 12 22:15:03 asterisk kernel: [ 8922.535316]          res=20
51/40:00:48:0f:00/40:00:00:00:00/e0 Emask 0x9 (media error)
Sep 12 22:15:03 asterisk kernel: [ 8922.538891] ata3.00: status: { DRDY=
=20
ERR }
Sep 12 22:15:03 asterisk kernel: [ 8922.540675] ata3.00: error: { UNC }
Sep 12 22:15:04 asterisk kernel: [ 8923.508206] ata3.00: configured for=
=20
UDMA/133
Sep 12 22:15:04 asterisk kernel: [ 8923.508220] ata3: EH complete
Sep 12 22:15:05 asterisk kernel: [ 8924.469512] ata3.00: exception Emas=
k=20
0x0 SAct 0x0 SErr 0x0 action 0x0
Sep 12 22:15:05 asterisk kernel: [ 8924.472323] ata3.00: BMDMA stat 0x4=
4
Sep 12 22:15:05 asterisk kernel: [ 8924.475260] ata3.00: failed command=
:=20
READ DMA
Sep 12 22:15:05 asterisk kernel: [ 8924.477023] ata3.00: cmd=20
c8/00:08:48:0f:00/00:00:00:00:00/e0 tag 0 dma 4096 in
Sep 12 22:15:05 asterisk kernel: [ 8924.477025]          res=20
51/40:00:48:0f:00/40:00:00:00:00/e0 Emask 0x9 (media error)
Sep 12 22:15:05 asterisk kernel: [ 8924.480595] ata3.00: status: { DRDY=
=20
ERR }
Sep 12 22:15:05 asterisk kernel: [ 8924.482370] ata3.00: error: { UNC }
Sep 12 22:15:06 asterisk kernel: [ 8925.452209] ata3.00: configured for=
=20
UDMA/133
Sep 12 22:15:06 asterisk kernel: [ 8925.452224] ata3: EH complete
Sep 12 22:15:07 asterisk kernel: [ 8926.418504] ata3.00: exception Emas=
k=20
0x0 SAct 0x0 SErr 0x0 action 0x0
Sep 12 22:15:07 asterisk kernel: [ 8926.420741] ata3.00: BMDMA stat 0x4=
4
Sep 12 22:15:07 asterisk kernel: [ 8926.422486] ata3.00: failed command=
:=20
READ DMA
Sep 12 22:15:07 asterisk kernel: [ 8926.424279] ata3.00: cmd=20
c8/00:08:48:0f:00/00:00:00:00:00/e0 tag 0 dma 4096 in
Sep 12 22:15:07 asterisk kernel: [ 8926.424281]          res=20
51/40:00:48:0f:00/40:00:00:00:00/e0 Emask 0x9 (media error)
Sep 12 22:15:07 asterisk kernel: [ 8926.427861] ata3.00: status: { DRDY=
=20
ERR }
Sep 12 22:15:07 asterisk kernel: [ 8926.429660] ata3.00: error: { UNC }
Sep 12 22:15:08 asterisk kernel: [ 8927.396270] ata3.00: configured for=
=20
UDMA/133
Sep 12 22:15:08 asterisk kernel: [ 8927.396285] ata3: EH complete
Sep 12 22:15:09 asterisk kernel: [ 8928.359173] ata3.00: exception Emas=
k=20
0x0 SAct 0x0 SErr 0x0 action 0x0
Sep 12 22:15:09 asterisk kernel: [ 8928.361647] ata3.00: BMDMA stat 0x4=
4
Sep 12 22:15:09 asterisk kernel: [ 8928.364273] ata3.00: failed command=
:=20
READ DMA
Sep 12 22:15:09 asterisk kernel: [ 8928.366028] ata3.00: cmd=20
c8/00:08:48:0f:00/00:00:00:00:00/e0 tag 0 dma 4096 in
Sep 12 22:15:09 asterisk kernel: [ 8928.366030]          res=20
51/40:00:48:0f:00/40:00:00:00:00/e0 Emask 0x9 (media error)
Sep 12 22:15:09 asterisk kernel: [ 8928.369643] ata3.00: status: { DRDY=
=20
ERR }
Sep 12 22:15:09 asterisk kernel: [ 8928.371420] ata3.00: error: { UNC }
Sep 12 22:15:10 asterisk kernel: [ 8929.340218] ata3.00: configured for=
=20
UDMA/133
Sep 12 22:15:10 asterisk kernel: [ 8929.340233] ata3: EH complete
Sep 12 22:15:11 asterisk kernel: [ 8930.332648] ata3.00: exception Emas=
k=20
0x0 SAct 0x0 SErr 0x0 action 0x0
Sep 12 22:15:11 asterisk kernel: [ 8930.334453] ata3.00: BMDMA stat 0x4=
4
Sep 12 22:15:11 asterisk kernel: [ 8930.336245] ata3.00: failed command=
:=20
READ DMA
Sep 12 22:15:11 asterisk kernel: [ 8930.337995] ata3.00: cmd=20
c8/00:08:48:0f:00/00:00:00:00:00/e0 tag 0 dma 4096 in
Sep 12 22:15:11 asterisk kernel: [ 8930.337998]          res=20
51/40:00:48:0f:00/40:00:00:00:00/e0 Emask 0x9 (media error)
Sep 12 22:15:11 asterisk kernel: [ 8930.341583] ata3.00: status: { DRDY=
=20
ERR }
Sep 12 22:15:11 asterisk kernel: [ 8930.343360] ata3.00: error: { UNC }
Sep 12 22:15:12 asterisk kernel: [ 8931.344205] ata3.00: configured for=
=20
UDMA/133
Sep 12 22:15:12 asterisk kernel: [ 8931.344220] ata3: EH complete
Sep 12 22:15:13 asterisk kernel: [ 8932.306376] ata3.00: exception Emas=
k=20
0x0 SAct 0x0 SErr 0x0 action 0x0
Sep 12 22:15:13 asterisk kernel: [ 8932.308201] ata3.00: BMDMA stat 0x4=
4
Sep 12 22:15:13 asterisk kernel: [ 8932.309948] ata3.00: failed command=
:=20
READ DMA
Sep 12 22:15:13 asterisk kernel: [ 8932.311695] ata3.00: cmd=20
c8/00:08:48:0f:00/00:00:00:00:00/e0 tag 0 dma 4096 in
Sep 12 22:15:13 asterisk kernel: [ 8932.311697]          res=20
51/40:00:48:0f:00/40:00:00:00:00/e0 Emask 0x9 (media error)
Sep 12 22:15:13 asterisk kernel: [ 8932.315262] ata3.00: status: { DRDY=
=20
ERR }
Sep 12 22:15:13 asterisk kernel: [ 8932.317070] ata3.00: error: { UNC }
Sep 12 22:15:14 asterisk kernel: [ 8933.284204] ata3.00: configured for=
=20
UDMA/133
Sep 12 22:15:14 asterisk kernel: [ 8933.284234] sd 2:0:0:0: [sda]=20
Unhandled sense code
Sep 12 22:15:14 asterisk kernel: [ 8933.284237] sd 2:0:0:0: [sda]=20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
Sep 12 22:15:14 asterisk kernel: [ 8933.284241] sd 2:0:0:0: [sda]  Sens=
e=20
Key : Medium Error [current] [descriptor]
Sep 12 22:15:14 asterisk kernel: [ 8933.284246] Descriptor sense data=20
with sense descriptors (in hex):
Sep 12 22:15:14 asterisk kernel: [ 8933.284248]         72 03 11 04 00=20
00 00 0c 00 0a 80 00 00 00 00 00
Sep 12 22:15:14 asterisk kernel: [ 8933.284256]         00 00 0f 48
Sep 12 22:15:14 asterisk kernel: [ 8933.284260] sd 2:0:0:0: [sda]  Add.=
=20
Sense: Unrecovered read error - auto reallocate failed
Sep 12 22:15:14 asterisk kernel: [ 8933.284267] sd 2:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 0f 48 00 00 08 00
Sep 12 22:15:14 asterisk kernel: [ 8933.284274] end_request: I/O error,=
=20
dev sda, sector 3912
Sep 12 22:15:14 asterisk kernel: [ 8933.286065] Buffer I/O error on=20
device sda1, logical block 233
Sep 12 22:15:14 asterisk kernel: [ 8933.287889] ata3: EH complete


*Why doesn't it fail the first hard disk of the array!!??*

root@asterisk:~# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sda2[0] sdb2[1]
       949236 blocks super 1.2 [2/2] [UU]

md0 : active raid1 sda1[0] sdb1[1]
       311619448 blocks super 1.2 [2/2] [UU]

unused devices: <none>


root@asterisk:~# mdadm --detail /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Fri Jun 15 22:45:13 2012
      Raid Level : raid1
      Array Size : 311619448 (297.18 GiB 319.10 GB)
   Used Dev Size : 311619448 (297.18 GiB 319.10 GB)
    Raid Devices : 2
   Total Devices : 2
     Persistence : Superblock is persistent

     Update Time : Wed Sep 12 22:07:58 2012
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            Name : asterisk:0  (local to host asterisk)
            UUID : cea0c4c3:181e2ee3:e4d1f3c0:1008ea62
          Events : 68

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sda1
        1       8       17        1      active sync   /dev/sdb1


As you can see the firmware of the hard disk reports a read error and=20
linux still doesn't fail the drive: this is the best way to corrupt dat=
a
As far as I know it should fail the bad drive or at least try to resync=
=20
it allowing the firmware to reallocate the bad sectors on write.

I really want to understand how raid1 is expected to work, I simply=20
cannot trust something like this. I'd like to take advantage of the=20
failure to learn something about linux's raid1 behavior.

Thanks,
Niccol=F2





More info about the failed disk:

root@asterisk:~# smartctl -a /dev/sda
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-2-amd64] (local buil=
d)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.=
net

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     SAMSUNG SpinPoint F1 DT
Device Model:     SAMSUNG HD322HJ
Serial Number:    S17AJDWQ402689
LU WWN Device Id: 5 0000f0 003046298
=46irmware Version: 1AC01110
User Capacity:    320,072,933,376 bytes [320 GB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 3b
Local Time is:    Wed Sep 12 22:27:56 2012 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activit=
y
                                         was never started.
                                         Auto Offline Data Collection:=20
Disabled.
Self-test execution status:      ( 114) The previous self-test complete=
d=20
having
                                         the read element of the test=20
failed.
Total time to complete Offline
data collection:                ( 3888) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate=
=2E
                                         Auto Offline data collection=20
on/off support.
                                         Suspend Offline collection upo=
n new
                                         command.
                                         Offline surface scan supported=
=2E
                                         Self-test supported.
                                         Conveyance Self-test supported=
=2E
                                         Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before enterin=
g
                                         power-saving mode.
                                         Supports SMART auto save timer=
=2E
Error logging capability:        (0x01) Error logging supported.
                                         General Purpose Logging suppor=
ted.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        (  66) minutes.
Conveyance self-test routine
recommended polling time:        (   8) minutes.
SCT capabilities:              (0x003f) SCT Status supported.
                                         SCT Error Recovery Control=20
supported.
                                         SCT Feature Control supported.
                                         SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED=20
WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   099   099   051    Pre-fail Alway=
s=20
       -       428
   3 Spin_Up_Time            0x0007   094   094   011    Pre-fail Alway=
s=20
       -       2810
   4 Start_Stop_Count        0x0032   099   099   000    Old_age Always=
=20
       -       1077
   5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail Alway=
s=20
       -       0
   7 Seek_Error_Rate         0x000f   253   253   051    Pre-fail Alway=
s=20
       -       0
   8 Seek_Time_Performance   0x0025   100   100   015    Pre-fail=20
Offline      -       9666
   9 Power_On_Hours          0x0032   098   098   000    Old_age Always=
=20
       -       8915
  10 Spin_Retry_Count        0x0033   100   100   051    Pre-fail Alway=
s=20
       -       0
  11 Calibration_Retry_Count 0x0012   100   100   000    Old_age Always=
=20
       -       0
  12 Power_Cycle_Count       0x0032   099   099   000    Old_age Always=
=20
       -       1077
  13 Read_Soft_Error_Rate    0x000e   099   099   000    Old_age Always=
=20
       -       400
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Alway=
s=20
       -       0
184 End-to-End_Error        0x0033   100   100   099    Pre-fail  Alway=
s=20
       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Alway=
s=20
       -       400
188 Command_Timeout         0x0032   100   100   000    Old_age   Alway=
s=20
       -       0
190 Airflow_Temperature_Cel 0x0022   063   055   000    Old_age   Alway=
s=20
       -       37 (Min/Max 28/45)
194 Temperature_Celsius     0x0022   063   054   000    Old_age   Alway=
s=20
       -       37 (Min/Max 28/46)
195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Alway=
s=20
       -       355155576
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Alway=
s=20
       -       0
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Alway=
s=20
       -       2
198 Offline_Uncorrectable   0x0030   100   100   000    Old_age Offline=
=20
      -       1
199 UDMA_CRC_Error_Count    0x003e   100   100   000    Old_age   Alway=
s=20
       -       0
200 Multi_Zone_Error_Rate   0x000a   100   100   000    Old_age   Alway=
s=20
       -       0
201 Soft_Read_Error_Rate    0x000a   096   096   000    Old_age   Alway=
s=20
       -       361

SMART Error Log Version: 1
ATA Error Count: 173 (device log contains only the most recent five err=
ors)
         CR =3D Command Register [HEX]
         FR =3D Features Register [HEX]
         SC =3D Sector Count Register [HEX]
         SN =3D Sector Number Register [HEX]
         CL =3D Cylinder Low Register [HEX]
         CH =3D Cylinder High Register [HEX]
         DH =3D Device/Head Register [HEX]
         DC =3D Device Command Register [HEX]
         ER =3D Error register [HEX]
         ST =3D Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=3Ddays, hh=3Dhours, mm=3Dminutes,
SS=3Dsec, and sss=3Dmillisec. It "wraps" after 49.710 days.

Error 173 occurred at disk power-on lifetime: 0 hours (0 days + 0 hours=
)
   When the command that caused the error occurred, the device was=20
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 00 48 0f 00 e0  Error: UNC at LBA =3D 0x00000f48 =3D 3912

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   c8 00 08 48 0f 00 e0 08  18d+09:02:03.824  READ DMA
   ec 00 00 00 00 00 a0 08  18d+09:02:03.814  IDENTIFY DEVICE
   ef 03 46 00 00 00 a0 08  18d+09:02:03.814  SET FEATURES [Set transfe=
r=20
mode]
   ec 00 00 00 00 00 a0 08  18d+09:02:02.824  IDENTIFY DEVICE

Error 172 occurred at disk power-on lifetime: 0 hours (0 days + 0 hours=
)
   When the command that caused the error occurred, the device was=20
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 00 48 0f 00 e0  Error: UNC at LBA =3D 0x00000f48 =3D 3912

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   c8 00 08 48 0f 00 e0 08  18d+09:02:01.814  READ DMA
   ec 00 00 00 00 00 a0 08  18d+09:02:01.804  IDENTIFY DEVICE
   ef 03 46 00 00 00 a0 08  18d+09:02:01.804  SET FEATURES [Set transfe=
r=20
mode]
   ec 00 00 00 00 00 a0 08  18d+09:02:00.854  IDENTIFY DEVICE

Error 171 occurred at disk power-on lifetime: 0 hours (0 days + 0 hours=
)
   When the command that caused the error occurred, the device was=20
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 00 48 0f 00 e0  Error: UNC at LBA =3D 0x00000f48 =3D 3912

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   c8 00 08 48 0f 00 e0 08  18d+09:01:59.874  READ DMA
   ec 00 00 00 00 00 a0 08  18d+09:01:59.864  IDENTIFY DEVICE
   ef 03 46 00 00 00 a0 08  18d+09:01:59.864  SET FEATURES [Set transfe=
r=20
mode]
   ec 00 00 00 00 00 a0 08  18d+09:01:58.904  IDENTIFY DEVICE

Error 170 occurred at disk power-on lifetime: 0 hours (0 days + 0 hours=
)
   When the command that caused the error occurred, the device was=20
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 00 48 0f 00 e0  Error: UNC at LBA =3D 0x00000f48 =3D 3912

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   c8 00 08 48 0f 00 e0 08  18d+09:01:57.924  READ DMA
   ec 00 00 00 00 00 a0 08  18d+09:01:57.924  IDENTIFY DEVICE
   ef 03 46 00 00 00 a0 08  18d+09:01:57.924  SET FEATURES [Set transfe=
r=20
mode]
   ec 00 00 00 00 00 a0 08  18d+09:01:56.964  IDENTIFY DEVICE

Error 169 occurred at disk power-on lifetime: 0 hours (0 days + 0 hours=
)
   When the command that caused the error occurred, the device was=20
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 00 48 0f 00 e0  Error: UNC at LBA =3D 0x00000f48 =3D 3912

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   c8 00 08 48 0f 00 e0 08  18d+09:01:55.984  READ DMA
   ec 00 00 00 00 00 a0 08  18d+09:01:55.974  IDENTIFY DEVICE
   ef 03 46 00 00 00 a0 08  18d+09:01:55.974  SET FEATURES [Set transfe=
r=20
mode]
   ec 00 00 00 00 00 a0 08  18d+09:01:55.014  IDENTIFY DEVICE

SMART Self-test log structure revision number 0
Warning: ATA Specification requires self-test log structure revision=20
number =3D 1
Num  Test_Description    Status                  Remaining=20
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed: read failure       20%      8895=20
   3912
# 2  Short offline       Aborted by host               20%      8871   =
   -
# 3  Short offline       Aborted by host               20%      8847   =
   -
# 4  Short offline       Aborted by host               20%      8823   =
   -
# 5  Extended offline    Aborted by host               90%      8800   =
   -
# 6  Short offline       Aborted by host               20%      8799   =
   -
# 7  Short offline       Aborted by host               20%      8775   =
   -
# 8  Short offline       Aborted by host               20%      8751   =
   -
# 9  Short offline       Aborted by host               20%      8727   =
   -
#10  Short offline       Aborted by host               20%      8703   =
   -
#11  Short offline       Aborted by host               20%      8679   =
   -
#12  Short offline       Aborted by host               20%      8655   =
   -
#13  Extended offline    Aborted by host               90%      8632   =
   -
#14  Short offline       Aborted by host               20%      8631   =
   -
#15  Short offline       Aborted by host               20%      8607   =
   -
#16  Short offline       Aborted by host               20%      8583   =
   -
#17  Short offline       Aborted by host               20%      8559   =
   -
#18  Short offline       Aborted by host               20%      8535   =
   -
#19  Short offline       Aborted by host               20%      8511   =
   -
#20  Short offline       Aborted by host               20%      8487   =
   -
#21  Extended offline    Aborted by host               90%      8464   =
   -

Note: selective self-test log revision number (0) not 1 implies that no=
=20
selective self-test has ever been run
SMART Selective self-test log data structure revision number 0
Note: revision number not 1 implies that no selective self-test has eve=
r=20
been run
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing
Selective self-test flags (0x0):
   After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute de=
lay.
--=20
http://www.linuxsystems.it
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
