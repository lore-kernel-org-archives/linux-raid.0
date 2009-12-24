From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: raid5: cannot start dirty degraded array
Date: Thu, 24 Dec 2009 09:40:40 -0700
Message-ID: <200912240940.40713.tfjellstrom@shaw.ca>
References: <579884013.20091223125023@kaneda.iguw.tuwien.ac.at> <512145787.20091223180308@kaneda.iguw.tuwien.ac.at> <alpine.DEB.2.00.0912231322060.18793@p34.internal.lan>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0912231322060.18793@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed December 23 2009, Justin Piszcz wrote:
> Is anyone using (WD) 1.5TB (as noted below) successfully in an array
> without these errors?

I seem to recall SMART making my 2TB Green's flip out if used too much. But 
I'm not sure if that was due to the controller or what.

> On Wed, 23 Dec 2009, Rainer Fuegenstein wrote:
> > MB> Is the disk being kicked always on the same port? (port 1 for
> > example)
> >
> > not sure how to interpret the syslog messages:
> >
> > Nov 28 21:24:40 alfred kernel: ata2.00: exception Emask 0x0 SAct 0x0
> > SErr 0x0 action 0x6 frozen Nov 28 21:24:40 alfred kernel: ata2.00: cmd
> > b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 0 Nov 28 21:24:40 alfred
> > kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
> > (timeout) Nov 28 21:24:40 alfred kernel: ata2.00: status: { DRDY }
> > Nov 28 21:24:40 alfred kernel: ata2: soft resetting link
> > Nov 28 21:24:41 alfred kernel: ata2: SATA link up 3.0 Gbps (SStatus 123
> > SControl 300) Nov 28 21:24:41 alfred kernel: ata2.00: configured for
> > UDMA/133 Nov 28 21:24:41 alfred kernel: ata2: EH complete
> > Nov 28 21:24:41 alfred kernel: SCSI device sdb: 2930277168 512-byte
> > hdwr sectors (1500302 MB) Nov 28 21:24:41 alfred kernel: sdb: Write
> > Protect is off
> > Nov 28 21:24:41 alfred kernel: SCSI device sdb: drive cache: write back
> > Nov 28 21:24:41 alfred smartd[2770]: Device: /dev/sdd, 1 Offline
> > uncorrectable sectors
> >
> > the smartd message for sdd appears frequently, that's why I replaced
> > the drive. the timeout above occured 3 times within the last month for
> > sdb. guess you are right with either the port or the cable.
> >
> > tonight it was sda, but I might have disturbed the cable without
> > noticing when replacing sdd.
> >
> > MB> If so, then you may have a problem with that specific port. If it
> > MB> kicks disks randomly, and you're sure that your cables or disks are
> > MB> healthy, then it's probably time to change the motherboard.
> >
> > I plan to move to the new atom/pinetrail mainboards as soon as they
> > are available in january. hope that solves this issue. but will check
> > the cable anyway.
> >
> > tnx & cu
> >
> >
> > MB> Increasing the resync values of min will slow down your server if
> > MB> you're trying to access it during a resync.
> >
> > MB> On Wed, Dec 23, 2009 at 6:13 PM, Rainer Fuegenstein
> >
> > MB> <rfu@kaneda.iguw.tuwien.ac.at> wrote:
> >>> MB> I don't know why your array takes 3 days to resync. My array is
> >>> 7TB in MB> side (8x1TB @ RAID5) and it takes about 16 hours.
> >>>
> >>> that's definitely a big mystery. I put this to this list some time
> >>> ago when upgrading the same array from 4*750GB to 4*1500GB by
> >>> replacing one disk after the other and finally --growing the raid:
> >>>
> >>> 1st disk took just a few minutes
> >>> 2nd disk some hours
> >>> 3rd disk more than a day
> >>> 4th disk about 2+ days
> >>> --grow also took  2+ days
> >>>
> >>> MB> Check the value of this file:
> >>> MB> cat /proc/sys/dev/raid/speed_limit_max
> >>>
> >>> default values are:
> >>> [root@alfred cdrom]# cat /proc/sys/dev/raid/speed_limit_max
> >>> 200000
> >>> [root@alfred cdrom]# cat /proc/sys/dev/raid/speed_limit_min
> >>> 1000
> >>>
> >>> when resyncing (with these default values), the server becomes awfuly
> >>> slow (streaming mp3 via smb suffers timeouts).
> >>>
> >>> mainboard is an Asus M2N with NFORCE-MCP61 chipset.
> >>>
> >>> this server started on an 800MHz asus board with 4*400 GB PATA disks
> >>> and had this one-disk-failure from the start (every few months). over
> >>> the years everything was replaced (power supply, mainboard, disks,
> >>> controller, pata to sata, ...) but it still kicks out disks (with the
> >>> current asus M2N board about every two to three weeks).
> >>>
> >>> must be cosmic radiation to blame ...
> >>>
> >>>
> >>> MB> Make it a high number so that when there's no process querying
> >>> the MB> disks, the resync process will go for the max speed.
> >>> echo '200000' >> /proc/sys/dev/raid/speed_limit_max
> >>> MB> (200 MB/s)
> >>>
> >>> MB> The file /proc/sys/dev/raid/speed_limit_min specified the minimum
> >>> MB> speed at which the array should resync, even when there are other
> >>> MB> programs querying the disks.
> >>>
> >>> MB> Make sure you run the above changes just before you issue a
> >>> resync. MB> Changes are lost on reboot.
> >>>
> >>> MB> On Wed, Dec 23, 2009 at 5:30 PM, Rainer Fuegenstein
> >>>
> >>> MB> <rfu@kaneda.iguw.tuwien.ac.at> wrote:
> >>>>> tnx for the info, in the meantime I did:
> >>>>>
> >>>>> mdadm --assemble --force /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1
> >>>>> /dev/sdd1
> >>>>>
> >>>>> there was no mdadm.conf file, so I had to specify all devices and
> >>>>> do a --force
> >>>>>
> >>>>>
> >>>>> # cat /proc/mdstat
> >>>>> Personalities : [raid6] [raid5] [raid4]
> >>>>> md0 : active raid5 sdb1[0] sdc1[3] sdd1[1]
> >>>>>      4395407808 blocks level 5, 64k chunk, algorithm 2 [4/3] [UU_U]
> >>>>>
> >>>>> unused devices: <none>
> >>>>>
> >>>>> md0 is up :-)
> >>>>>
> >>>>> I'm about to start backing up the most important data; when this is
> >>>>> done I assume the proper way to get back to normal again is:
> >>>>>
> >>>>> - remove the bad drive from the array: mdadm /dev/md0 -r /dev/sda1
> >>>>> - physically replace sda with a new drive
> >>>>> - add it back: mdadm /dev/md0 -a /dev/sda1
> >>>>> - wait three days for the sync to complete (and keep fingers
> >>>>> crossed that no other drive fails)
> >>>>>
> >>>>> big tnx!
> >>>>>
> >>>>>
> >>>>> MB> sda1 was the only affected member of the array so you should be
> >>>>> able MB> to force-assemble the raid5 array and run it in degraded
> >>>>> mode.
> >>>>>
> >>>>> MB> mdadm -Af /dev/md0
> >>>>> MB> If that doesn't work for any reason, do this:
> >>>>> MB> mdadm -Af /dev/md0 /dev/sdb1 /dev/sdd1 /dev/sdc1
> >>>>>
> >>>>> MB> You can note the disk order from the output of mdadm -E
> >>>>>
> >>>>> MB> On Wed, Dec 23, 2009 at 5:02 PM, Rainer Fuegenstein
> >>>>>
> >>>>> MB> <rfu@kaneda.iguw.tuwien.ac.at> wrote:
> >>>>>>> MB> My bad, run this: mdadm -E /dev/sd[a-z]1
> >>>>>>> should have figured this out myself (sorry; currently running in
> >>>>>>> panic mode ;-) )
> >>>>>>>
> >>>>>>> MB> 1 is the partition which most likely you added to the array
> >>>>>>> rather MB> than the whole disk (which is normal).
> >>>>>>>
> >>>>>>> # mdadm -E /dev/sd[a-z]1
> >>>>>>> /dev/sda1:
> >>>>>>>          Magic : a92b4efc
> >>>>>>>        Version : 0.90.00
> >>>>>>>           UUID : 81833582:d651e953:48cc5797:38b256ea
> >>>>>>>  Creation Time : Mon Mar 31 13:30:45 2008
> >>>>>>>     Raid Level : raid5
> >>>>>>>  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
> >>>>>>>     Array Size : 4395407808 (4191.79 GiB 4500.90 GB)
> >>>>>>>   Raid Devices : 4
> >>>>>>>  Total Devices : 4
> >>>>>>> Preferred Minor : 0
> >>>>>>>
> >>>>>>>    Update Time : Wed Dec 23 02:54:49 2009
> >>>>>>>          State : clean
> >>>>>>>  Active Devices : 4
> >>>>>>> Working Devices : 4
> >>>>>>>  Failed Devices : 0
> >>>>>>>  Spare Devices : 0
> >>>>>>>       Checksum : 6cfa3a64 - correct
> >>>>>>>         Events : 119530
> >>>>>>>
> >>>>>>>         Layout : left-symmetric
> >>>>>>>     Chunk Size : 64K
> >>>>>>>
> >>>>>>>      Number   Major   Minor   RaidDevice State
> >>>>>>> this     2       8        1        2      active sync   /dev/sda1
> >>>>>>>
> >>>>>>>   0     0       8       17        0      active sync   /dev/sdb1
> >>>>>>>   1     1       8       49        1      active sync   /dev/sdd1
> >>>>>>>   2     2       8        1        2      active sync   /dev/sda1
> >>>>>>>   3     3       8       33        3      active sync   /dev/sdc1
> >>>>>>> /dev/sdb1:
> >>>>>>>          Magic : a92b4efc
> >>>>>>>        Version : 0.90.00
> >>>>>>>           UUID : 81833582:d651e953:48cc5797:38b256ea
> >>>>>>>  Creation Time : Mon Mar 31 13:30:45 2008
> >>>>>>>     Raid Level : raid5
> >>>>>>>  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
> >>>>>>>     Array Size : 4395407808 (4191.79 GiB 4500.90 GB)
> >>>>>>>   Raid Devices : 4
> >>>>>>>  Total Devices : 4
> >>>>>>> Preferred Minor : 0
> >>>>>>>
> >>>>>>>    Update Time : Wed Dec 23 10:07:42 2009
> >>>>>>>          State : active
> >>>>>>>  Active Devices : 3
> >>>>>>> Working Devices : 3
> >>>>>>>  Failed Devices : 1
> >>>>>>>  Spare Devices : 0
> >>>>>>>       Checksum : 6cf8f610 - correct
> >>>>>>>         Events : 130037
> >>>>>>>
> >>>>>>>         Layout : left-symmetric
> >>>>>>>     Chunk Size : 64K
> >>>>>>>
> >>>>>>>      Number   Major   Minor   RaidDevice State
> >>>>>>> this     0       8       17        0      active sync   /dev/sdb1
> >>>>>>>
> >>>>>>>   0     0       8       17        0      active sync   /dev/sdb1
> >>>>>>>   1     1       8       49        1      active sync   /dev/sdd1
> >>>>>>>   2     2       0        0        2      faulty removed
> >>>>>>>   3     3       8       33        3      active sync   /dev/sdc1
> >>>>>>> /dev/sdc1:
> >>>>>>>          Magic : a92b4efc
> >>>>>>>        Version : 0.90.00
> >>>>>>>           UUID : 81833582:d651e953:48cc5797:38b256ea
> >>>>>>>  Creation Time : Mon Mar 31 13:30:45 2008
> >>>>>>>     Raid Level : raid5
> >>>>>>>  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
> >>>>>>>     Array Size : 4395407808 (4191.79 GiB 4500.90 GB)
> >>>>>>>   Raid Devices : 4
> >>>>>>>  Total Devices : 4
> >>>>>>> Preferred Minor : 0
> >>>>>>>
> >>>>>>>    Update Time : Wed Dec 23 10:07:42 2009
> >>>>>>>          State : active
> >>>>>>>  Active Devices : 3
> >>>>>>> Working Devices : 3
> >>>>>>>  Failed Devices : 1
> >>>>>>>  Spare Devices : 0
> >>>>>>>       Checksum : 6cf8f626 - correct
> >>>>>>>         Events : 130037
> >>>>>>>
> >>>>>>>         Layout : left-symmetric
> >>>>>>>     Chunk Size : 64K
> >>>>>>>
> >>>>>>>      Number   Major   Minor   RaidDevice State
> >>>>>>> this     3       8       33        3      active sync   /dev/sdc1
> >>>>>>>
> >>>>>>>   0     0       8       17        0      active sync   /dev/sdb1
> >>>>>>>   1     1       8       49        1      active sync   /dev/sdd1
> >>>>>>>   2     2       0        0        2      faulty removed
> >>>>>>>   3     3       8       33        3      active sync   /dev/sdc1
> >>>>>>> /dev/sdd1:
> >>>>>>>          Magic : a92b4efc
> >>>>>>>        Version : 0.90.00
> >>>>>>>           UUID : 81833582:d651e953:48cc5797:38b256ea
> >>>>>>>  Creation Time : Mon Mar 31 13:30:45 2008
> >>>>>>>     Raid Level : raid5
> >>>>>>>  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
> >>>>>>>     Array Size : 4395407808 (4191.79 GiB 4500.90 GB)
> >>>>>>>   Raid Devices : 4
> >>>>>>>  Total Devices : 4
> >>>>>>> Preferred Minor : 0
> >>>>>>>
> >>>>>>>    Update Time : Wed Dec 23 10:07:42 2009
> >>>>>>>          State : active
> >>>>>>>  Active Devices : 3
> >>>>>>> Working Devices : 3
> >>>>>>>  Failed Devices : 1
> >>>>>>>  Spare Devices : 0
> >>>>>>>       Checksum : 6cf8f632 - correct
> >>>>>>>         Events : 130037
> >>>>>>>
> >>>>>>>         Layout : left-symmetric
> >>>>>>>     Chunk Size : 64K
> >>>>>>>
> >>>>>>>      Number   Major   Minor   RaidDevice State
> >>>>>>> this     1       8       49        1      active sync   /dev/sdd1
> >>>>>>>
> >>>>>>>   0     0       8       17        0      active sync   /dev/sdb1
> >>>>>>>   1     1       8       49        1      active sync   /dev/sdd1
> >>>>>>>   2     2       0        0        2      faulty removed
> >>>>>>>   3     3       8       33        3      active sync   /dev/sdc1
> >>>>>>> [root@alfred log]#
> >>>>>>>
> >>>>>>> MB> You've included the smart report of one disk only. I suggest
> >>>>>>> you look MB> at the other disks as well and make sure that
> >>>>>>> they're not reporting MB> any errors. Also, keep in mind that you
> >>>>>>> should run smart test MB> periodically (can be configured) and
> >>>>>>> that if you haven't run any test MB> before, you have to run a
> >>>>>>> long or offline test before making sure that MB> you don't have
> >>>>>>> bad sectors.
> >>>>>>>
> >>>>>>> tnx for the hint, will do that as soon as I got my data back (if
> >>>>>>> ever ...)
> >>>>>>>
> >>>>>>>
> >>>>>>> MB> On Wed, Dec 23, 2009 at 4:44 PM, Rainer Fuegenstein
> >>>>>>>
> >>>>>>> MB> <rfu@kaneda.iguw.tuwien.ac.at> wrote:
> >>>>>>>>> MB> Give the output of these:
> >>>>>>>>> MB> mdadm -E /dev/sd[a-z]
> >>>>>>>>>
> >>>>>>>>> ]# mdadm -E /dev/sd[a-z]
> >>>>>>>>> mdadm: No md superblock detected on /dev/sda.
> >>>>>>>>> mdadm: No md superblock detected on /dev/sdb.
> >>>>>>>>> mdadm: No md superblock detected on /dev/sdc.
> >>>>>>>>> mdadm: No md superblock detected on /dev/sdd.
> >>>>>>>>>
> >>>>>>>>> I assume that's not a good sign ?!
> >>>>>>>>>
> >>>>>>>>> sda was powered on and running after the reboot, a smartctl
> >>>>>>>>> short test revealed no errors and smartctl -a also looks
> >>>>>>>>> unsuspicious (see below). the drives are rather new.
> >>>>>>>>>
> >>>>>>>>> guess its more likely to be either a problem of the power
> >>>>>>>>> supply (400W) or communication between controller and disk.
> >>>>>>>>>
> >>>>>>>>> /dev/sdd (before it was replaced) reported the following:
> >>>>>>>>>
> >>>>>>>>> Dec 20 07:18:54 alfred smartd[2705]: Device: /dev/sdd, 1
> >>>>>>>>> Offline uncorrectable sectors Dec 20 07:48:53 alfred
> >>>>>>>>> smartd[2705]: Device: /dev/sdd, 1 Offline uncorrectable sectors
> >>>>>>>>> Dec 20 08:18:54 alfred smartd[2705]: Device: /dev/sdd, 1
> >>>>>>>>> Offline uncorrectable sectors Dec 20 08:48:55 alfred
> >>>>>>>>> smartd[2705]: Device: /dev/sdd, 1 Offline uncorrectable sectors
> >>>>>>>>> Dec 20 09:18:53 alfred smartd[2705]: Device: /dev/sdd, 1
> >>>>>>>>> Offline uncorrectable sectors Dec 20 09:48:58 alfred
> >>>>>>>>> smartd[2705]: Device: /dev/sdd, 1 Offline uncorrectable sectors
> >>>>>>>>> Dec 20 10:19:01 alfred smartd[2705]: Device: /dev/sdd, 1
> >>>>>>>>> Offline uncorrectable sectors Dec 20 10:48:54 alfred
> >>>>>>>>> smartd[2705]: Device: /dev/sdd, 1 Offline uncorrectable sectors
> >>>>>>>>>
> >>>>>>>>> (what triggered a re-sync of the array)
> >>>>>>>>>
> >>>>>>>>>
> >>>>>>>>> # smartctl -a /dev/sda
> >>>>>>>>> smartctl version 5.38 [i686-redhat-linux-gnu] Copyright (C)
> >>>>>>>>> 2002-8 Bruce Allen Home page is
> >>>>>>>>> http://smartmontools.sourceforge.net/
> >>>>>>>>>
> >>>>>>>>> === START OF INFORMATION SECTION ===
> >>>>>>>>> Device Model:     WDC WD15EADS-00R6B0
> >>>>>>>>> Serial Number:    WD-WCAUP0017818
> >>>>>>>>> Firmware Version: 01.00A01
> >>>>>>>>> User Capacity:    1,500,301,910,016 bytes
> >>>>>>>>> Device is:        Not in smartctl database [for details use: -P
> >>>>>>>>> showall] ATA Version is:   8
> >>>>>>>>> ATA Standard is:  Exact ATA specification draft version not
> >>>>>>>>> indicated Local Time is:    Wed Dec 23 14:40:46 2009 CET
> >>>>>>>>> SMART support is: Available - device has SMART capability.
> >>>>>>>>> SMART support is: Enabled
> >>>>>>>>>
> >>>>>>>>> === START OF READ SMART DATA SECTION ===
> >>>>>>>>> SMART overall-health self-assessment test result: PASSED
> >>>>>>>>>
> >>>>>>>>> General SMART Values:
> >>>>>>>>> Offline data collection status:  (0x82) Offline data collection
> >>>>>>>>> activity was completed without error. Auto Offline Data
> >>>>>>>>> Collection: Enabled. Self-test execution status:      (   0)
> >>>>>>>>> The previous self-test routine completed without error or no
> >>>>>>>>> self-test has ever been run.
> >>>>>>>>> Total time to complete Offline
> >>>>>>>>> data collection:                 (40800) seconds.
> >>>>>>>>> Offline data collection
> >>>>>>>>> capabilities:                    (0x7b) SMART execute Offline
> >>>>>>>>> immediate. Auto Offline data collection on/off support. Suspend
> >>>>>>>>> Offline collection upon new command.
> >>>>>>>>>                                        Offline surface scan
> >>>>>>>>> supported. Self-test supported. Conveyance Self-test supported.
> >>>>>>>>> Selective Self-test supported. SMART capabilities:          
> >>>>>>>>>  (0x0003) Saves SMART data before entering power-saving mode.
> >>>>>>>>> Supports SMART auto save timer. Error logging capability:      
> >>>>>>>>>  (0x01) Error logging supported. General Purpose Logging
> >>>>>>>>> supported. Short self-test routine
> >>>>>>>>> recommended polling time:        (   2) minutes.
> >>>>>>>>> Extended self-test routine
> >>>>>>>>> recommended polling time:        ( 255) minutes.
> >>>>>>>>> Conveyance self-test routine
> >>>>>>>>> recommended polling time:        (   5) minutes.
> >>>>>>>>> SCT capabilities:              (0x303f) SCT Status supported.
> >>>>>>>>>                                        SCT Feature Control
> >>>>>>>>> supported. SCT Data Table supported.
> >>>>>>>>>
> >>>>>>>>> SMART Attributes Data Structure revision number: 16
> >>>>>>>>> Vendor Specific SMART Attributes with Thresholds:
> >>>>>>>>> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE  
> >>>>>>>>>    UPDATED  WHEN_FAILED RAW_VALUE 1 Raw_Read_Error_Rate    
> >>>>>>>>> 0x002f   200   200   051    Pre-fail  Always       -       0 3
> >>>>>>>>> Spin_Up_Time            0x0027   177   145   021    Pre-fail
> >>>>>>>>>  Always       -       8133 4 Start_Stop_Count        0x0032  
> >>>>>>>>> 100   100   000    Old_age   Always       -       15 5
> >>>>>>>>> Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> >>>>>>>>>  Always       -       0 7 Seek_Error_Rate         0x002e   200
> >>>>>>>>>   200   000    Old_age   Always       -       0 9
> >>>>>>>>> Power_On_Hours          0x0032   093   093   000    Old_age  
> >>>>>>>>> Always       -       5272 10 Spin_Retry_Count        0x0032  
> >>>>>>>>> 100   253   000    Old_age   Always       -       0 11
> >>>>>>>>> Calibration_Retry_Count 0x0032   100   253   000    Old_age  
> >>>>>>>>> Always       -       0 12 Power_Cycle_Count       0x0032   100
> >>>>>>>>>   100   000    Old_age   Always       -       14 192
> >>>>>>>>> Power-Off_Retract_Count 0x0032   200   200   000    Old_age  
> >>>>>>>>> Always       -       2 193 Load_Cycle_Count        0x0032   200
> >>>>>>>>>   200   000    Old_age   Always       -       13 194
> >>>>>>>>> Temperature_Celsius     0x0022   125   109   000    Old_age  
> >>>>>>>>> Always       -       27 196 Reallocated_Event_Count 0x0032  
> >>>>>>>>> 200   200   000    Old_age   Always       -       0 197
> >>>>>>>>> Current_Pending_Sector  0x0032   200   200   000    Old_age  
> >>>>>>>>> Always       -       0 198 Offline_Uncorrectable   0x0030   200
> >>>>>>>>>   200   000    Old_age   Offline      -       0 199
> >>>>>>>>> UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age  
> >>>>>>>>> Always       -       0 200 Multi_Zone_Error_Rate   0x0008   200
> >>>>>>>>>   200   000    Old_age   Offline      -       0
> >>>>>>>>>
> >>>>>>>>> SMART Error Log Version: 1
> >>>>>>>>> No Errors Logged
> >>>>>>>>>
> >>>>>>>>> SMART Self-test log structure revision number 1
> >>>>>>>>> Num  Test_Description    Status                  Remaining
> >>>>>>>>>  LifeTime(hours)  LBA_of_first_error # 1  Short offline      
> >>>>>>>>> Completed without error       00%      5272         -
> >>>>>>>>>
> >>>>>>>>> SMART Selective self-test log data structure revision number 1
> >>>>>>>>>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
> >>>>>>>>>    1        0        0  Not_testing
> >>>>>>>>>    2        0        0  Not_testing
> >>>>>>>>>    3        0        0  Not_testing
> >>>>>>>>>    4        0        0  Not_testing
> >>>>>>>>>    5        0        0  Not_testing
> >>>>>>>>> Selective self-test flags (0x0):
> >>>>>>>>>  After scanning selected spans, do NOT read-scan remainder of
> >>>>>>>>> disk. If Selective self-test is pending on power-up, resume
> >>>>>>>>> after 0 minute delay.
> >>>>>>>>>
> >>>>>>>>>>> From the errors you show, it seems like one of the disks is
> >>>>>>>>>>> dead (sda)
> >>>>>>>>>
> >>>>>>>>> MB> or dying. It could be just a bad PCB (the controller board
> >>>>>>>>> of the MB> disk) as it refuses to return SMART data, so you
> >>>>>>>>> might be able to MB> rescue data by changing the PCB, if it's
> >>>>>>>>> that important to have that MB> disk.
> >>>>>>>>>
> >>>>>>>>> MB> As for the array, you can run a degraded array by force
> >>>>>>>>> assembling it: MB> mdadm -Af /dev/md0
> >>>>>>>>> MB> In the command above, mdadm will search on existing disks
> >>>>>>>>> and MB> partitions, which of them belongs to an array and
> >>>>>>>>> assemble that array, MB> if possible.
> >>>>>>>>>
> >>>>>>>>> MB> I also suggest you install smartmontools package and run
> >>>>>>>>> smartctl -a MB> /dev/sd[a-z] and see the report for each disk
> >>>>>>>>> to make sure you don't MB> have bad sectors or bad cables
> >>>>>>>>> (CRC/ATA read errors) on any of the MB> disks.
> >>>>>>>>>
> >>>>>>>>> MB> On Wed, Dec 23, 2009 at 3:50 PM, Rainer Fuegenstein
> >>>>>>>>>
> >>>>>>>>> MB> <rfu@kaneda.iguw.tuwien.ac.at> wrote:
> >>>>>>>>>>> addendum: when going through the logs I found the reason:
> >>>>>>>>>>>
> >>>>>>>>>>> Dec 23 02:55:40 alfred kernel: ata1.00: exception Emask 0x0
> >>>>>>>>>>> SAct 0x0 SErr 0x0 action 0x6 frozen Dec 23 02:55:40 alfred
> >>>>>>>>>>> kernel: ata1.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag
> >>>>>>>>>>> 0 Dec 23 02:55:40 alfred kernel:          res
> >>>>>>>>>>> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout) Dec
> >>>>>>>>>>> 23 02:55:40 alfred kernel: ata1.00: status: { DRDY } Dec 23
> >>>>>>>>>>> 02:55:45 alfred kernel: ata1: link is slow to respond, please
> >>>>>>>>>>> be patient (ready=0) Dec 23 02:55:50 alfred kernel: ata1:
> >>>>>>>>>>> device not ready (errno=-16), forcing hardreset Dec 23
> >>>>>>>>>>> 02:55:50 alfred kernel: ata1: soft resetting link Dec 23
> >>>>>>>>>>> 02:55:55 alfred kernel: ata1: link is slow to respond, please
> >>>>>>>>>>> be patient (ready=0) Dec 23 02:56:00 alfred kernel: ata1:
> >>>>>>>>>>> SRST failed (errno=-16) Dec 23 02:56:00 alfred kernel: ata1:
> >>>>>>>>>>> soft resetting link Dec 23 02:56:05 alfred kernel: ata1: link
> >>>>>>>>>>> is slow to respond, please be patient (ready=0) Dec 23
> >>>>>>>>>>> 02:56:10 alfred kernel: ata1: SRST failed (errno=-16) Dec 23
> >>>>>>>>>>> 02:56:10 alfred kernel: ata1: soft resetting link Dec 23
> >>>>>>>>>>> 02:56:15 alfred kernel: ata1: link is slow to respond, please
> >>>>>>>>>>> be patient (ready=0) Dec 23 02:56:45 alfred kernel: ata1:
> >>>>>>>>>>> SRST failed (errno=-16) Dec 23 02:56:45 alfred kernel: ata1:
> >>>>>>>>>>> limiting SATA link speed to 1.5 Gbps Dec 23 02:56:45 alfred
> >>>>>>>>>>> kernel: ata1: soft resetting link Dec 23 02:56:50 alfred
> >>>>>>>>>>> kernel: ata1: SRST failed (errno=-16) Dec 23 02:56:50 alfred
> >>>>>>>>>>> kernel: ata1: reset failed, giving up Dec 23 02:56:50 alfred
> >>>>>>>>>>> kernel: ata1.00: disabled
> >>>>>>>>>>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: timing out
> >>>>>>>>>>> command, waited 30s Dec 23 02:56:50 alfred kernel: ata1: EH
> >>>>>>>>>>> complete
> >>>>>>>>>>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return
> >>>>>>>>>>> code = 0x00040000 Dec 23 02:56:50 alfred kernel: end_request:
> >>>>>>>>>>> I/O error, dev sda, sector 1244700223 Dec 23 02:56:50 alfred
> >>>>>>>>>>> kernel: sd 0:0:0:0: SCSI error: return code = 0x00040000 Dec
> >>>>>>>>>>> 23 02:56:50 alfred kernel: end_request: I/O error, dev sda,
> >>>>>>>>>>> sector 1554309191 Dec 23 02:56:50 alfred kernel: sd 0:0:0:0:
> >>>>>>>>>>> SCSI error: return code = 0x00040000 Dec 23 02:56:50 alfred
> >>>>>>>>>>> kernel: end_request: I/O error, dev sda, sector 1554309439
> >>>>>>>>>>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return
> >>>>>>>>>>> code = 0x00040000 Dec 23 02:56:50 alfred kernel: end_request:
> >>>>>>>>>>> I/O error, dev sda, sector 572721343 Dec 23 02:56:50 alfred
> >>>>>>>>>>> kernel: raid5: Disk failure on sda1, disabling device.
> >>>>>>>>>>> Operation continuing on 3 devices Dec 23 02:56:50 alfred
> >>>>>>>>>>> kernel: RAID5 conf printout:
> >>>>>>>>>>> Dec 23 02:56:50 alfred kernel:  --- rd:4 wd:3 fd:1
> >>>>>>>>>>> Dec 23 02:56:50 alfred kernel:  disk 0, o:1, dev:sdb1
> >>>>>>>>>>> Dec 23 02:56:50 alfred kernel:  disk 1, o:1, dev:sdd1
> >>>>>>>>>>> Dec 23 02:56:50 alfred kernel:  disk 2, o:0, dev:sda1
> >>>>>>>>>>> Dec 23 02:56:50 alfred kernel:  disk 3, o:1, dev:sdc1
> >>>>>>>>>>> Dec 23 02:56:50 alfred kernel: RAID5 conf printout:
> >>>>>>>>>>> Dec 23 02:56:50 alfred kernel:  --- rd:4 wd:3 fd:1
> >>>>>>>>>>> Dec 23 02:56:50 alfred kernel:  disk 0, o:1, dev:sdb1
> >>>>>>>>>>> Dec 23 02:56:50 alfred kernel:  disk 1, o:1, dev:sdd1
> >>>>>>>>>>> Dec 23 02:56:50 alfred kernel:  disk 3, o:1, dev:sdc1
> >>>>>>>>>>> Dec 23 03:22:57 alfred smartd[2692]: Device: /dev/sda, not
> >>>>>>>>>>> capable of SMART self-check Dec 23 03:22:57 alfred
> >>>>>>>>>>> smartd[2692]: Sending warning via mail to root ... Dec 23
> >>>>>>>>>>> 03:22:58 alfred smartd[2692]: Warning via mail to root:
> >>>>>>>>>>> successful Dec 23 03:22:58 alfred smartd[2692]: Device:
> >>>>>>>>>>> /dev/sda, failed to read SMART Attribute Data Dec 23 03:22:58
> >>>>>>>>>>> alfred smartd[2692]: Sending warning via mail to root ... Dec
> >>>>>>>>>>> 23 03:22:58 alfred smartd[2692]: Warning via mail to root:
> >>>>>>>>>>> successful Dec 23 03:52:57 alfred smartd[2692]: Device:
> >>>>>>>>>>> /dev/sda, not capable of SMART self-check Dec 23 03:52:57
> >>>>>>>>>>> alfred smartd[2692]: Device: /dev/sda, failed to read SMART
> >>>>>>>>>>> Attribute Data Dec 23 04:22:57 alfred smartd[2692]: Device:
> >>>>>>>>>>> /dev/sda, not capable of SMART self-check Dec 23 04:22:57
> >>>>>>>>>>> alfred smartd[2692]: Device: /dev/sda, failed to read SMART
> >>>>>>>>>>> Attribute Data Dec 23 04:52:57 alfred smartd[2692]: Device:
> >>>>>>>>>>> /dev/sda, not capable of SMART self-check [...]
> >>>>>>>>>>> Dec 23 09:52:57 alfred smartd[2692]: Device: /dev/sda, not
> >>>>>>>>>>> capable of SMART self-check Dec 23 09:52:57 alfred
> >>>>>>>>>>> smartd[2692]: Device: /dev/sda, failed to read SMART
> >>>>>>>>>>> Attribute Data (crash here)
> >>>>>>>>>>>
> >>>>>>>>>>>
> >>>>>>>>>>> RF> hi,
> >>>>>>>>>>>
> >>>>>>>>>>> RF> got a "nice" early christmas present this morning: after
> >>>>>>>>>>> a crash, the raid5 RF> (consisting of 4*1.5TB WD caviar green
> >>>>>>>>>>> SATA disks) won't start :-(
> >>>>>>>>>>>
> >>>>>>>>>>> RF> the history:
> >>>>>>>>>>> RF> sometimes, the raid kicked out one disk, started a resync
> >>>>>>>>>>> (which RF> lasted for about 3 days) and was fine after that.
> >>>>>>>>>>> a few days ago I RF> replaced drive sdd (which seemed to
> >>>>>>>>>>> cause the troubles) and synced the RF> raid again which
> >>>>>>>>>>> finished yesterday in the early afternoon. at 10am RF> today
> >>>>>>>>>>> the system crashed and the raid won't start:
> >>>>>>>>>>>
> >>>>>>>>>>> RF> OS is Centos 5
> >>>>>>>>>>> RF> mdadm - v2.6.9 - 10th March 2009
> >>>>>>>>>>> RF> Linux alfred 2.6.18-164.6.1.el5xen #1 SMP Tue Nov 3
> >>>>>>>>>>> 17:53:47 EST 2009 i686 athlon i386 GNU/Linux
> >>>>>>>>>>>
> >>>>>>>>>>>
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: Autodetecting RAID
> >>>>>>>>>>> arrays. RF> Dec 23 12:30:19 alfred kernel: md: autorun ...
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: considering sdd1 ...
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md:  adding sdd1 ...
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md:  adding sdc1 ...
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md:  adding sdb1 ...
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md:  adding sda1 ...
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: created md0
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sda1>
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sdb1>
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sdc1>
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sdd1>
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: running:
> >>>>>>>>>>> <sdd1><sdc1><sdb1><sda1> RF> Dec 23 12:30:19 alfred kernel:
> >>>>>>>>>>> md: kicking non-fresh sda1 from array! RF> Dec 23 12:30:19
> >>>>>>>>>>> alfred kernel: md: unbind<sda1>
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sda1)
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: md0: raid array is not
> >>>>>>>>>>> clean -- starting background reconstruction RF>     (no
> >>>>>>>>>>> reconstruction is actually started, disks are idle) RF> Dec
> >>>>>>>>>>> 23 12:30:19 alfred kernel: raid5: automatically using best
> >>>>>>>>>>> checksumming function: pIII_sse RF> Dec 23 12:30:19 alfred
> >>>>>>>>>>> kernel:    pIII_sse  :  7085.000 MB/sec RF> Dec 23 12:30:19
> >>>>>>>>>>> alfred kernel: raid5: using function: pIII_sse (7085.000
> >>>>>>>>>>> MB/sec) RF> Dec 23 12:30:19 alfred kernel: raid6: int32x1  
> >>>>>>>>>>>  896 MB/s RF> Dec 23 12:30:19 alfred kernel: raid6: int32x2  
> >>>>>>>>>>>  972 MB/s RF> Dec 23 12:30:19 alfred kernel: raid6: int32x4  
> >>>>>>>>>>>  893 MB/s RF> Dec 23 12:30:19 alfred kernel: raid6: int32x8  
> >>>>>>>>>>>  934 MB/s RF> Dec 23 12:30:19 alfred kernel: raid6: mmxx1    
> >>>>>>>>>>> 1845 MB/s RF> Dec 23 12:30:19 alfred kernel: raid6: mmxx2    
> >>>>>>>>>>> 3250 MB/s RF> Dec 23 12:30:19 alfred kernel: raid6: sse1x1  
> >>>>>>>>>>>  1799 MB/s RF> Dec 23 12:30:19 alfred kernel: raid6: sse1x2  
> >>>>>>>>>>>  3067 MB/s RF> Dec 23 12:30:19 alfred kernel: raid6: sse2x1  
> >>>>>>>>>>>  2980 MB/s RF> Dec 23 12:30:19 alfred kernel: raid6: sse2x2  
> >>>>>>>>>>>  4015 MB/s RF> Dec 23 12:30:19 alfred kernel: raid6: using
> >>>>>>>>>>> algorithm sse2x2 (4015 MB/s) RF> Dec 23 12:30:19 alfred
> >>>>>>>>>>> kernel: md: raid6 personality registered for level 6 RF> Dec
> >>>>>>>>>>> 23 12:30:19 alfred kernel: md: raid5 personality registered
> >>>>>>>>>>> for level 5 RF> Dec 23 12:30:19 alfred kernel: md: raid4
> >>>>>>>>>>> personality registered for level 4 RF> Dec 23 12:30:19 alfred
> >>>>>>>>>>> kernel: raid5: device sdd1 operational as raid disk 1 RF> Dec
> >>>>>>>>>>> 23 12:30:19 alfred kernel: raid5: device sdc1 operational as
> >>>>>>>>>>> raid disk 3 RF> Dec 23 12:30:19 alfred kernel: raid5: device
> >>>>>>>>>>> sdb1 operational as raid disk 0 RF> Dec 23 12:30:19 alfred
> >>>>>>>>>>> kernel: raid5: cannot start dirty degraded array for md0 RF>
> >>>>>>>>>>> Dec 23 12:30:19 alfred kernel: RAID5 conf printout: RF> Dec
> >>>>>>>>>>> 23 12:30:19 alfred kernel:  --- rd:4 wd:3 fd:1 RF> Dec 23
> >>>>>>>>>>> 12:30:19 alfred kernel:  disk 0, o:1, dev:sdb1 RF> Dec 23
> >>>>>>>>>>> 12:30:19 alfred kernel:  disk 1, o:1, dev:sdd1 RF> Dec 23
> >>>>>>>>>>> 12:30:19 alfred kernel:  disk 3, o:1, dev:sdc1 RF> Dec 23
> >>>>>>>>>>> 12:30:19 alfred kernel: raid5: failed to run raid set md0 RF>
> >>>>>>>>>>> Dec 23 12:30:19 alfred kernel: md: pers->run() failed ... RF>
> >>>>>>>>>>> Dec 23 12:30:19 alfred kernel: md: do_md_run() returned -5
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: md0 stopped.
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdd1>
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdd1)
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdc1>
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdc1)
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdb1>
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdb1)
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: md: ... autorun DONE.
> >>>>>>>>>>> RF> Dec 23 12:30:19 alfred kernel: device-mapper: multipath:
> >>>>>>>>>>> version 1.0.5 loaded
> >>>>>>>>>>>
> >>>>>>>>>>> RF> # cat /proc/mdstat
> >>>>>>>>>>> RF> Personalities : [raid6] [raid5] [raid4]
> >>>>>>>>>>> RF> unused devices: <none>
> >>>>>>>>>>>
> >>>>>>>>>>> RF> filesystem used on top of md0 is xfs.
> >>>>>>>>>>>
> >>>>>>>>>>> RF> please advice what to do next and let me know if you need
> >>>>>>>>>>> further RF> information. really don't want to lose 3TB worth
> >>>>>>>>>>> of data :-(
> >>>>>>>>>>>
> >>>>>>>>>>>
> >>>>>>>>>>> RF> tnx in advance.
> >>>>>>>>>>>
> >>>>>>>>>>> RF> --
> >>>>>>>>>>> RF> To unsubscribe from this list: send the line "unsubscribe
> >>>>>>>>>>> linux-raid" in RF> the body of a message to
> >>>>>>>>>>> majordomo@vger.kernel.org RF> More majordomo info at
> >>>>>>>>>>>  http://vger.kernel.org/majordomo-info.html
> >>>>>>>>>>>
> >>>>>>>>>>>
> >>>>>>>>>>> -------------------------------------------------------------
> >>>>>>>>>>>----------------- Unix gives you just enough rope to hang
> >>>>>>>>>>> yourself -- and then a couple of more feet, just to be sure.
> >>>>>>>>>>> (Eric Allman)
> >>>>>>>>>>> -------------------------------------------------------------
> >>>>>>>>>>>-----------------
> >>>>>>>>>>>
> >>>>>>>>>>> --
> >>>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
> >>>>>>>>>>> linux-raid" in the body of a message to
> >>>>>>>>>>> majordomo@vger.kernel.org
> >>>>>>>>>>> More majordomo info at
> >>>>>>>>>>>  http://vger.kernel.org/majordomo-info.html
> >>>>>>>>>
> >>>>>>>>> ---------------------------------------------------------------
> >>>>>>>>>--------------- Unix gives you just enough rope to hang yourself
> >>>>>>>>> -- and then a couple of more feet, just to be sure.
> >>>>>>>>> (Eric Allman)
> >>>>>>>>> ---------------------------------------------------------------
> >>>>>>>>>---------------
> >>>>>>>
> >>>>>>> -----------------------------------------------------------------
> >>>>>>>------------- Unix gives you just enough rope to hang yourself --
> >>>>>>> and then a couple of more feet, just to be sure.
> >>>>>>> (Eric Allman)
> >>>>>>> -----------------------------------------------------------------
> >>>>>>>-------------
> >>>>>>>
> >>>>>>> --
> >>>>>>> To unsubscribe from this list: send the line "unsubscribe
> >>>>>>> linux-raid" in the body of a message to majordomo@vger.kernel.org
> >>>>>>> More majordomo info at
> >>>>>>>  http://vger.kernel.org/majordomo-info.html
> >>>>>
> >>>>> -------------------------------------------------------------------
> >>>>>----------- Unix gives you just enough rope to hang yourself -- and
> >>>>> then a couple of more feet, just to be sure.
> >>>>> (Eric Allman)
> >>>>> -------------------------------------------------------------------
> >>>>>-----------
> >>>
> >>> ---------------------------------------------------------------------
> >>>--------- Unix gives you just enough rope to hang yourself -- and then
> >>> a couple of more feet, just to be sure.
> >>> (Eric Allman)
> >>> ---------------------------------------------------------------------
> >>>---------
> >
> > -----------------------------------------------------------------------
> >------- Unix gives you just enough rope to hang yourself -- and then a
> > couple of more feet, just to be sure.
> > (Eric Allman)
> > -----------------------------------------------------------------------
> >-------
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
