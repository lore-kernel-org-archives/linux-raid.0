From: Vegard Haugland <vegard@haugland.at>
Subject: Re: Help with assembling a stopped array
Date: Fri, 15 Jul 2016 19:02:45 +0200
Message-ID: <CANz1=THkLw6tEYxPhEwb2WTfhfuRXu2E1--tAPGV2hmSSLpyLQ@mail.gmail.com>
References: <CANz1=TGr3_ayX-CxcjsBx6Q0Ggh5PXp1STmqHW1XuMS8GGE7Lg@mail.gmail.com>
 <caf338d7-cc3f-0aca-e928-7619a64d888c@turmel.org> <CANz1=TEdGxvDo8WRfCwQy4Ymar2Oo7Ct9acBYJcz06XpaFM15w@mail.gmail.com>
 <69b8afa7-bfeb-e85a-aba6-b6013b2302aa@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <69b8afa7-bfeb-e85a-aba6-b6013b2302aa@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil

Here's an update to my problem:.

> The device that's popping up as a spare every time really does have the
> spare marker (role #10).  That's the drive that was partially re-added
> when the array crashed again.  Just leave it out of your next attempts.

OK. Done.

> The key is "SCT Error Recovery Control command not supported" on most of
> your drives.  In fact, upgrading model 7200.11 1T drives to your 2T
> Barracudas is precisely the set of models that first bit me in the ass.
> I mention that somewhere in the threads I pointed at.
>
> The key is that you have desktop drives in a raid array, and they don't
> handle read errors in a way friendly to the linux kernel -- they take
> too long.  The one 7200.11 drive can be told to timeout quicker (7.0
> seconds is typical for spinning disks).  The kernel will have to be told
> to wait extra long for all of the others.  2-3 minutes.  Details in the
> reading assignments.  The precise sequence of events that breaks MD raid
> is described in the sixth:
>
> http://marc.info/?l=linux-raid&m=133665797115876&w=2

Thanks for the explanation. I'll look into this more to get a better
comprehension of this.

>
> After you get your array assembled again, I suggest you run the lsdrv[1]
> script to document which drive serial numbers correspond to which array
> roles.  Also consider using the --update=metadata at some point (not
> now) to get away from the v0.90 metadata.  It is unreliable when used on
> partitions that extend to the end of their parent device.
>

Adding this to the todo list. Thanks.

> Your problem is "timeout mismatch", which is use of drives with
> extended error recovery times in any linux software raid array. (I
> understand hardware raid also struggles with this, but I don't know the
> details.)
>
> For now, use at every boot:
>
> for x in /sys/block/*/device/timeout ; do echo 180 > $x ; done

Done.

> This time, omit the drive that shows up as "spare".  Use all nine
> others.  You really want nine, so the redundancy in your array can
> reconstruct when it hits the UREs you obviously have.  See "Current
> Pending Sector" != 0 in your smartctl reports.
>
> After it assembles the nine, issue "mdadm --run /dev/md4" if it didn't
> start.  Then "echo check >>/sys/block/md4/md/sync_action".
>
> Wait for that to finish.  Then add the spare back to the array.

OK. Here's whats been happening for the past two days. I can this
command to rebuild the array

# mdadm -A /dev/md4 /dev/sda3 /dev/sdb3 /dev/sdc3 /dev/sdd3 /dev/sde3
/dev/sdg3 /dev/sdh3 /dev/sdi3 /dev/sdj3 --force
mdadm: forcing event count in /dev/sdc3(4) from 32679348 upto 32680549
mdadm: forcing event count in /dev/sdd3(3) from 32677935 upto 32680549
mdadm: clearing FAULTY flag for device 3 in /dev/md4 for /dev/sdd3
mdadm: clearing FAULTY flag for device 2 in /dev/md4 for /dev/sdc3
mdadm: Marking array /dev/md4 as 'clean'
mdadm: /dev/md4 has been started with 8 drives (out of 10) and 1 spare.

As the output mentioned, the array started and I got access to the
data again. Yay! In order to start the rebuild, I ran "echo check
>>/sys/block/md4/md/sync_action".

The array just finished the rebuild, but not with the results I hoped
for. Here's the output from mdadm -D /dev/md4

# mdadm -D -v /dev/md4
/dev/md4:
        Version : 0.90
  Creation Time : Tue Jun 15 06:37:57 2010
     Raid Level : raid6
     Array Size : 11719545344 (11176.63 GiB 12000.81 GB)
  Used Dev Size : 1464943168 (1397.08 GiB 1500.10 GB)
   Raid Devices : 10
  Total Devices : 9
Preferred Minor : 4
    Persistence : Superblock is persistent

    Update Time : Fri Jul 15 14:36:51 2016
          State : clean, FAILED
 Active Devices : 7
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric-6
     Chunk Size : 64K

           UUID : c807562b:f8dbc4e5:457de8e9:4807bcad
         Events : 0.32687312

    Number   Major   Minor   RaidDevice State
       0       8       19        0      active sync   /dev/sdb3
       1       8       99        1      active sync   /dev/sdg3
       4       0        0        4      removed
       3       8       51        3      active sync   /dev/sdd3
       8       0        0        8      removed
       5       8      115        5      active sync   /dev/sdh3
       6       8       67        6      active sync   /dev/sde3
       7       8      131        7      active sync   /dev/sdi3
       8       8      147        8      active sync   /dev/sdj3
      18       0        0       18      removed

      10       8        3        -      spare   /dev/sda3
      11       8       35        -      faulty   /dev/sdc3

Here's the output from /proc/mdstat during the rebuild (which just completed).

root@debian:~# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md4 : active raid6 sdb3[0] sda3[10] sdj3[8] sdi3[7] sde3[6] sdh3[5]
sdc3[4] sdd3[3] sdg3[1]
      11719545344 blocks level 6, 64k chunk, algorithm 18 [10/8] [UU_UUUUUU_]
      [=================>...]  recovery = 86.1%
(1262406304/1464943168) finish=178.0min speed=18957K/sec

The current output from /proc/mdstat is the following:

Personalities : [raid1] [raid6] [raid5] [raid4]
md4 : active raid6 sdb3[0] sda3[10](S) sdj3[8] sdi3[7] sde3[6] sdh3[5]
sdc3[11](F) sdd3[3] sdg3[1]
      11719545344 blocks level 6, 64k chunk, algorithm 18 [10/7] [UU_U_UUUU_]

Looks like /dev/sdc is faulty. I ran smartctl on that disk, and the
output is as follows. Note that this error was logged just 4 hours ago
(mentioned in the below log at 24702 hours).

# root@debian:~# smartctl -a /dev/sdc
smartctl 6.4 2014-10-07 r4002 [x86_64-linux-3.16.0-4-amd64] (local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.14 (AF)
Device Model:     ST1500DM003-9YN16G
Serial Number:    W1E2VMF3
LU WWN Device Id: 5 000c50 05e0ec925
Firmware Version: CC4B
User Capacity:    1,500,301,910,016 bytes [1.50 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Fri Jul 15 18:56:16 2016 UTC

==> WARNING: A firmware update for this drive may be available,
see the following Seagate web pages:
http://knowledge.seagate.com/articles/en_US/FAQ/207931en
http://knowledge.seagate.com/articles/en_US/FAQ/223651en

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
data collection: (  600) seconds.
Offline data collection
capabilities: (0x73) SMART execute Offline immediate.
Auto Offline data collection on/off support.
Suspend Offline collection upon new
command.
No Offline surface scan supported.
Self-test supported.
Conveyance Self-test supported.
Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
power-saving mode.
Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
General Purpose Logging supported.
Short self-test routine
recommended polling time: (   1) minutes.
Extended self-test routine
recommended polling time: ( 185) minutes.
Conveyance self-test routine
recommended polling time: (   2) minutes.
SCT capabilities:       (0x3085) SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   109   099   006    Pre-fail
Always       -       45495242
  3 Spin_Up_Time            0x0003   096   095   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       31
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000f   087   060   030    Pre-fail
Always       -       653305433
  9 Power_On_Hours          0x0032   072   072   000    Old_age
Always       -       24706
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       28
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age
Always       -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   091   091   000    Old_age
Always       -       9
188 Command_Timeout         0x0032   100   099   000    Old_age
Always       -       1 1 2
189 High_Fly_Writes         0x003a   050   050   000    Old_age
Always       -       50
190 Airflow_Temperature_Cel 0x0022   065   052   045    Old_age
Always       -       35 (Min/Max 33/40)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       19
193 Load_Cycle_Count        0x0032   095   095   000    Old_age
Always       -       10077
194 Temperature_Celsius     0x0022   035   048   000    Old_age
Always       -       35 (0 17 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       80
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       80
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age
Offline      -       24656h+37m+41.577s
241 Total_LBAs_Written      0x0000   100   253   000    Old_age
Offline      -       2232552343992
242 Total_LBAs_Read         0x0000   100   253   000    Old_age
Offline      -       144336591164585

SMART Error Log Version: 1
ATA Error Count: 2
CR = Command Register [HEX]
FR = Features Register [HEX]
SC = Sector Count Register [HEX]
SN = Sector Number Register [HEX]
CL = Cylinder Low Register [HEX]
CH = Cylinder High Register [HEX]
DH = Device/Head Register [HEX]
DC = Device Command Register [HEX]
ER = Error register [HEX]
ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 2 occurred at disk power-on lifetime: 24702 hours (1029 days + 6 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 00 a0 ff ff ff ef 00   1d+19:17:33.086  READ DMA EXT
  25 00 18 ff ff ff ef 00   1d+19:17:32.528  READ DMA EXT
  25 00 f8 ff ff ff ef 00   1d+19:17:32.167  READ DMA EXT
  27 00 00 00 00 00 e0 00   1d+19:17:32.166  READ NATIVE MAX ADDRESS
EXT [OBS-ACS-3]
  ec 00 00 00 00 00 a0 00   1d+19:17:32.158  IDENTIFY DEVICE

Error 1 occurred at disk power-on lifetime: 24702 hours (1029 days + 6 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 00 f0 ff ff ff ef 00   1d+19:17:29.011  READ DMA EXT
  25 00 18 ff ff ff ef 00   1d+19:17:29.010  READ DMA EXT
  25 00 f8 ff ff ff ef 00   1d+19:17:28.988  READ DMA EXT
  25 00 f8 ff ff ff ef 00   1d+19:17:21.227  READ DMA EXT
  25 00 f8 ff ff ff ef 00   1d+19:17:21.195  READ DMA EXT

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%     24622         -
# 2  Short offline       Completed without error       00%     24598         -
# 3  Short offline       Completed without error       00%     24574         -
# 4  Extended offline    Completed without error       00%     24556         -
# 5  Short offline       Completed without error       00%     24550         -
# 6  Short offline       Completed without error       00%     24526         -
# 7  Short offline       Completed without error       00%     24502         -
# 8  Short offline       Completed without error       00%     24478         -
# 9  Short offline       Completed without error       00%     24454         -
#10  Short offline       Completed without error       00%     24430         -
#11  Short offline       Completed without error       00%     24406         -
#12  Extended offline    Completed without error       00%     24388         -
#13  Short offline       Completed without error       00%     24382         -
#14  Short offline       Completed without error       00%     24358         -
#15  Short offline       Completed without error       00%     24334         -
#16  Short offline       Completed without error       00%     24310         -
#17  Short offline       Completed without error       00%     24286         -
#18  Short offline       Completed without error       00%     24262         -
#19  Short offline       Completed without error       00%     24238         -
#20  Extended offline    Completed without error       00%     24220         -
#21  Short offline       Completed without error       00%     24214         -

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

----

For some reason, the other faulty disk (not the one mentioned below,
or the one that initially showed up as spare) also shows up as spare
now (like the good one did earlier). Issuing "echo check >>
/sys/block/md4/md/sync_action" does not make any attempts to rebuild
the array. Should I use mdadm --manage --add to re-add it before I
replace the faulty disk with a new one?

>
> Also, in the future, paste drive reports and console output inline in
> your mails, with word wrapping disabled.  That puts the details in the
> archives for future googlers to find.  (This list allows ~ 100k per mail.)
>

OK. I did that this time instead of using pastebins.

Vegard
