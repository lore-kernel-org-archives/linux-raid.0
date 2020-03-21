From: Glenn Greibesland <glenngreibesland@gmail.com>
Subject: Re: Raid6 recovery
Date: Sat, 21 Mar 2020 12:54:45 +0100
Message-ID: <CA+9eyig8U2Tzi1wF97k7eDu5vKg5Jc2sRXKaw0OCy7Cbc9HMog@mail.gmail.com>
References: <CA+9eyijuUEJ7Y8BuxkKaZ=v8zbPpwixOezngPjtJzaLsBd+A4Q@mail.gmail.com>
 <5E75163B.2050602@youngman.org.uk> <CA+9eyigMV-E=FwtXDWZszSsV6JOxxFOFVh6WzmeH=OC3heMUHw@mail.gmail.com>
 <ab2a40b6-b4ab-9ff8-aef6-02d8cce8d587@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ab2a40b6-b4ab-9ff8-aef6-02d8cce8d587@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: antlists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

Yes, I am aware of the problems with WD Green and multiple partitions
on single 4TB disk. I am in the middle of getting rid of old disks and
I have enough new drives to stop having multiple partitions on single
drives, but not enough power and free SATA ports. It is just a
temporary solution. Also a reason why I did not
include much details in the original post, I knew it would just
distract from the problem I want to solve right away.

What I need help with now is just getting the array started with the
16 out of 18 disks. Then I can continue migrating data and replacing
old disks as planned.

When I built the array in 2012, I used WD Green. They turned out to be
horrible disks and I have since replaced some of them with WD Red. The
newest disks I've bought are Ironwolves

l=C3=B8r. 21. mar. 2020 kl. 01:06 skrev antlists <antlists@youngman.org.uk>=
:
>
> On 20/03/2020 21:05, Glenn Greibesland wrote:
> > fre. 20. mar. 2020 kl. 20:15 skrev Wols Lists <antlists@youngman.org.uk=
>:
> >>
> >> On 19/03/20 19:55, Glenn Greibesland wrote:
> >>> After a bit of digging in the manual and on different forums I have
> >>> concluded that the next step for me is to recreate the array using
> >>> =E2=80=93assume-clean and =E2=80=93data-offset=3Dvariable.
> >>> I have tried a dry run of the command (answering no to =E2=80=9CConti=
nue
> >>> creating array=E2=80=9D), and mdadm accepts the parameters without an=
y errors:
> >>
> >> Oh my god NO!!!
> >>
> >> Do NOT use --create unless someone rather more experienced than me tel=
ls
> >> you to!!!
> >>
> >> The obvious thing is to somehow get the sixteen drives that you know
> >> should be okay, re-assembled in a forced manner. The --re-add should n=
ot
> >> have done any real damage because, as mdadm keeps complaining, you
> >> didn't have enough drives so it won't have touched the data on that
> >> drive. Unfortunately, my fu isn't good enough to tell you how to get
> >> that drive back in.
> >>
> >> What's wrong with the two failed drives? Can you ddrescue them? They
> >> might be enough to get you going again.
> >>
> >> You say you've read the web page "Raid recovery" - which says it's
> >> obsolete and points you at "When things go wrogn" - but you don't appe=
ar
> >> to have read that! PLEASE read "asking for help" and in particular you
> >> NEED to run lsdrv and give us that information. Without that, if you D=
O
> >> run --create, you will be in for a world of hurt.
> >>
> >> I know you may feel it's asking for loads of information, and the
> >> resulting email will be massive, but trust me - the experts will look =
at
> >> it and they will probably be able to come up with a plan of action. At
> >> present, they don't have much to go on, and nor will you if carry on a=
s
> >> you're going ...
> >>
> >> Cheers,
> >> Wol
> >
> > Thanks for replying to the thread.
> >
> > The two failed drives has "unreadable (pending) sectors", and they
> > have a lower Event Count than the other disks, so that is why I've
> > been trying to get the array up and running with the remaining 16
> > disks that has the same Event Count.
> >
> > I concluded myself that --create --assume-clean had to be the only
> > thing left to try, that's why I didn't provide any logs or info. Sorry
> > about that, you are right, I should check if there is any other
> > options first. I've been trying to get this array up and running again
> > for quite some time, so I'm all ears if someone has some magic to try.
> > Yesterday I read some of the source code of mdadm and sort of answered
> > my own question. According to the source code, specifying sizes in
> > sectors is supported. I'd still like some confirmation though (talking
> > about parse_size function in util.c).
> >
> > Here's some additional info:
> >
> > mdadm: added /dev/sdj1 to /dev/md/0 as 0
> > mdadm: added /dev/sdk1 to /dev/md/0 as 1
> > mdadm: added /dev/sdi1 to /dev/md/0 as 2
> > mdadm: added /dev/sdh1 to /dev/md/0 as 3
> > mdadm: added /dev/sdo1 to /dev/md/0 as 4
> > mdadm: added /dev/sdp1 to /dev/md/0 as 5
> > mdadm: added /dev/sdr1 to /dev/md/0 as 6
> > mdadm: added /dev/sdq1 to /dev/md/0 as 7
> > mdadm: added /dev/sdf1 to /dev/md/0 as 8
> > mdadm: added /dev/sdb1 to /dev/md/0 as 9
> > mdadm: added /dev/sdg1 to /dev/md/0 as -1   <<<< This is the drive
> > that is now regarded as spare. It originally had slot 10 in the array
> > mdadm: added /dev/sdd1 to /dev/md/0 as 11
> > mdadm: added /dev/sdm1 to /dev/md/0 as 12
> > mdadm: added /dev/sdf2 to /dev/md/0 as 13
> > mdadm: added /dev/sdc2 to /dev/md/0 as 16
> > mdadm: added /dev/sdc1 to /dev/md/0 as 17
> >
> >
> >
> > mdadm: no uptodate device for slot 10 of /dev/md/0 << sdg1
> > mdadm: no uptodate device for slot 14 of /dev/md/0 << drive disconnecte=
d
> > mdadm: no uptodate device for slot 15 of /dev/md/0 << drive disconnecte=
d
> >
> > mdadm: /dev/md/0 assembled from 15 drives and 1 spare - not enough to
> > start the array.
> >
> >   mdadm -D /dev/md0
> > /dev/md0:
> >             Version : 1.2
> >          Raid Level : raid0
> >       Total Devices : 16
> >         Persistence : Superblock is persistent
> >
> >               State : inactive
> >     Working Devices : 16
> >
> >                Name : vm-test:0
> >                UUID : 45ced2f9:947773d4:106077ab:2df799d6
> >              Events : 1937517
> >
> >      Number   Major   Minor   RaidDevice
> >
> >         -       8       17        -        /dev/sdb1
> >         -       8       33        -        /dev/sdc1
> >         -       8       34        -        /dev/sdc2
>
> What's this? Two partitions in the array on the same physical disk?
>
> >         -       8       49        -        /dev/sdd1
> >         -       8       81        -        /dev/sdf1
> >         -       8       82        -        /dev/sdf2
>
> And again?
>
> >         -       8       97        -        /dev/sdg1
> >         -       8      113        -        /dev/sdh1
> >         -       8      129        -        /dev/sdi1
> >         -       8      145        -        /dev/sdj1
> >         -       8      161        -        /dev/sdk1
> >         -       8      193        -        /dev/sdm1
> >         -       8      241        -        /dev/sdp1
> >         -      65        1        -        /dev/sdq1
> >         -      65       17        -        /dev/sdr1
> >         -      65       33        -        /dev/sds1
> >
>
>
> >
> > SMART WRITE LOG does not return COUNT and LBA_LOW register
> > SCT (Get) Error Recovery Control command failed
>
> Which disk is this? No error recovery? BAD sign ...
> >
> > Device Statistics (GP/SMART Log 0x04) not supported
> >
> > SATA Phy Event Counters (GP Log 0x11)
> > ID      Size     Value  Description
> > 0x0001  2            0  Command failed due to ICRC error
> > 0x0002  2            0  R_ERR response for data FIS
> > 0x0003  2            0  R_ERR response for device-to-host data FIS
> > 0x0004  2            0  R_ERR response for host-to-device data FIS
> > 0x0005  2            0  R_ERR response for non-data FIS
> > 0x0006  2            0  R_ERR response for device-to-host non-data FIS
> > 0x0007  2            0  R_ERR response for host-to-device non-data FIS
> > 0x0008  2            0  Device-to-host non-data FIS retries
> > 0x0009  2            2  Transition from drive PhyRdy to drive PhyNRdy
> > 0x000a  2            2  Device-to-host register FISes sent due to a COM=
RESET
> > 0x000b  2            0  CRC errors within host-to-device FIS
> > 0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
> > 0x0012  2            0  R_ERR response for host-to-device non-data FIS,=
 CRC
> > 0x8000  4      1208382  Vendor specific
> >
> > smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-64-generic] (local bu=
ild)
> > Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools=
.org
> >
>
>
> >
> > smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-64-generic] (local bu=
ild)
> > Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools=
.org
> >
>
>
> >
> > smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-64-generic] (local bu=
ild)
> > Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools=
.org
> >
> > =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> > Model Family:     Western Digital Green
>
> What's this?
>
> > Device Model:     WDC WD20EARX-00PASB0
> > Serial Number:    WD-WMAZA9538601
> > LU WWN Device Id: 5 0014ee 15a0a4ffa
> > Firmware Version: 51.0AB51
> > User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> > Sector Sizes:     512 bytes logical, 4096 bytes physical
> > Device is:        In smartctl database [for details use: -P show]
> > ATA Version is:   ATA8-ACS (minor revision not indicated)
> > SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 1.5 Gb/s)
> > Local Time is:    Fri Mar 20 21:00:38 2020 CET
> > SMART support is: Available - device has SMART capability.
> > SMART support is: Enabled
> > AAM feature is:   Unavailable
> > APM feature is:   Unavailable
> > Rd look-ahead is: Enabled
> > Write cache is:   Enabled
> > ATA Security is:  Disabled, NOT FROZEN [SEC1]
> > Wt Cache Reorder: Enabled
> >
> > =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> > SMART overall-health self-assessment test result: PASSED
> >
> > General SMART Values:
> > Offline data collection status:  (0x84) Offline data collection activit=
y
> > was suspended by an interrupting command from host.
> > Auto Offline Data Collection: Enabled.
> > Self-test execution status:      (   0) The previous self-test routine =
completed
> > without error or no self-test has ever
> > been run.
> > Total time to complete Offline
> > data collection: (37200) seconds.
> > Offline data collection
> > capabilities: (0x7b) SMART execute Offline immediate.
> > Auto Offline data collection on/off support.
> > Suspend Offline collection upon new
> > command.
> > Offline surface scan supported.
> > Self-test supported.
> > Conveyance Self-test supported.
> > Selective Self-test supported.
> > SMART capabilities:            (0x0003) Saves SMART data before enterin=
g
> > power-saving mode.
> > Supports SMART auto save timer.
> > Error logging capability:        (0x01) Error logging supported.
> > General Purpose Logging supported.
> > Short self-test routine
> > recommended polling time: (   2) minutes.
> > Extended self-test routine
> > recommended polling time: ( 359) minutes.
> > Conveyance self-test routine
> > recommended polling time: (   5) minutes.
> > SCT capabilities:        (0x3035) SCT Status supported.
> > SCT Feature Control supported.
> > SCT Data Table supported.
>
> No mention of ERC - Bad sign ...
> >
> > SMART Attributes Data Structure revision number: 16
> > Vendor Specific SMART Attributes with Thresholds:
> > ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
> >    1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
> >    3 Spin_Up_Time            POS--K   171   171   021    -    6416
> >    4 Start_Stop_Count        -O--CK   100   100   000    -    255
> >    5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
> >    7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
> >    9 Power_On_Hours          -O--CK   098   098   000    -    1583
> >   10 Spin_Retry_Count        -O--CK   100   100   000    -    0
> >   11 Calibration_Retry_Count -O--CK   100   100   000    -    0
> >   12 Power_Cycle_Count       -O--CK   100   100   000    -    131
> > 192 Power-Off_Retract_Count -O--CK   200   200   000    -    61
> > 193 Load_Cycle_Count        -O--CK   191   191   000    -    29372
> > 194 Temperature_Celsius     -O---K   122   101   000    -    28
> > 196 Reallocated_Event_Count -O--CK   200   200   000    -    0
> > 197 Current_Pending_Sector  -O--CK   200   200   000    -    0
> > 198 Offline_Uncorrectable   ----CK   200   200   000    -    0
> > 199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
> > 200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
> >                              ||||||_ K auto-keep
> >                              |||||__ C event count
> >                              ||||___ R error rate
> >                              |||____ S speed/performance
> >                              ||_____ O updated online
> >                              |______ P prefailure warning
> >
> > General Purpose Log Directory Version 1
> > SMART           Log Directory Version 1 [multi-sector log support]
> > Address    Access  R/W   Size  Description
> > 0x00       GPL,SL  R/O      1  Log Directory
> > 0x01           SL  R/O      1  Summary SMART error log
> > 0x02           SL  R/O      5  Comprehensive SMART error log
> > 0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
> > 0x06           SL  R/O      1  SMART self-test log
> > 0x07       GPL     R/O      1  Extended self-test log
> > 0x09           SL  R/W      1  Selective self-test log
> > 0x10       GPL     R/O      1  SATA NCQ Queued Error log
> > 0x11       GPL     R/O      1  SATA Phy Event Counters log
> > 0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
> > 0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
> > 0xa8-0xb7  GPL,SL  VS       1  Device vendor specific log
> > 0xbd       GPL,SL  VS       1  Device vendor specific log
> > 0xc0       GPL,SL  VS       1  Device vendor specific log
> > 0xc1       GPL     VS      93  Device vendor specific log
> > 0xe0       GPL,SL  R/W      1  SCT Command/Status
> > 0xe1       GPL,SL  R/W      1  SCT Data Transfer
> >
> > SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
> > No Errors Logged
> >
> > SMART Extended Self-test Log Version: 1 (1 sectors)
> > Num  Test_Description    Status                  Remaining
> > LifeTime(hours)  LBA_of_first_error
> > # 1  Short offline       Completed without error       00%      1245   =
      -
> >
> > SMART Selective self-test log data structure revision number 1
> >   SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
> >      1        0        0  Not_testing
> >      2        0        0  Not_testing
> >      3        0        0  Not_testing
> >      4        0        0  Not_testing
> >      5        0        0  Not_testing
> > Selective self-test flags (0x0):
> >    After scanning selected spans, do NOT read-scan remainder of disk.
> > If Selective self-test is pending on power-up, resume after 0 minute de=
lay.
> >
> > SCT Status Version:                  3
> > SCT Version (vendor specific):       258 (0x0102)
> > SCT Support Level:                   1
> > Device State:                        Active (0)
> > Current Temperature:                    28 Celsius
> > Power Cycle Min/Max Temperature:      8/43 Celsius
> > Lifetime    Min/Max Temperature:      0/49 Celsius
> > Under/Over Temperature Limit Count:   0/0
> >
> > SCT Temperature History Version:     2
> > Temperature Sampling Period:         1 minute
> > Temperature Logging Interval:        1 minute
> > Min/Max recommended Temperature:      0/60 Celsius
> > Min/Max Temperature Limit:           -41/85 Celsius
> > Temperature History Size (Index):    478 (305)
> >
> > Index    Estimated Time   Temperature Celsius
> >   306    2020-03-20 13:03    23  ****
> >   ...    ..( 33 skipped).    ..  ****
> >   340    2020-03-20 13:37    23  ****
> >   341    2020-03-20 13:38     ?  -
> >   342    2020-03-20 13:39    23  ****
> >   343    2020-03-20 13:40    23  ****
> >   344    2020-03-20 13:41    24  *****
> >   345    2020-03-20 13:42    25  ******
> >   346    2020-03-20 13:43    25  ******
> >   347    2020-03-20 13:44    25  ******
> >   348    2020-03-20 13:45    26  *******
> >   ...    ..(  2 skipped).    ..  *******
> >   351    2020-03-20 13:48    26  *******
> >   352    2020-03-20 13:49    27  ********
> >   353    2020-03-20 13:50    27  ********
> >   354    2020-03-20 13:51    28  *********
> >   355    2020-03-20 13:52    28  *********
> >   356    2020-03-20 13:53    22  ***
> >   ...    ..(276 skipped).    ..  ***
> >   155    2020-03-20 18:30    22  ***
> >   156    2020-03-20 18:31    23  ****
> >   ...    ..(148 skipped).    ..  ****
> >   305    2020-03-20 21:00    23  ****
> >
> > SCT Error Recovery Control command not supported
>
> Yup. Ouch!
> >
> > Device Statistics (GP/SMART Log 0x04) not supported
> >
> > SATA Phy Event Counters (GP Log 0x11)
> > ID      Size     Value  Description
> > 0x0001  2            0  Command failed due to ICRC error
> > 0x0002  2            0  R_ERR response for data FIS
> > 0x0003  2            0  R_ERR response for device-to-host data FIS
> > 0x0004  2            0  R_ERR response for host-to-device data FIS
> > 0x0005  2            0  R_ERR response for non-data FIS
> > 0x0006  2            0  R_ERR response for device-to-host non-data FIS
> > 0x0007  2            0  R_ERR response for host-to-device non-data FIS
> > 0x000a  2            5  Device-to-host register FISes sent due to a COM=
RESET
> > 0x000b  2            0  CRC errors within host-to-device FIS
> > 0x8000  4      1208379  Vendor specific
> >
> > smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-64-generic] (local bu=
ild)
> > Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools=
.org
> >
> > =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> > Model Family:     Western Digital Red
> > Device Model:     WDC WD20EFRX-68AX9N0
> > Serial Number:    WD-WMC300320657
> > LU WWN Device Id: 5 0014ee 0ae1ee098
> > Firmware Version: 80.00A80
> > User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> > Sector Sizes:     512 bytes logical, 4096 bytes physical
> > Device is:        In smartctl database [for details use: -P show]
> > ATA Version is:   ACS-2 (minor revision not indicated)
> > SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
> > Local Time is:    Fri Mar 20 21:00:38 2020 CET
> > SMART support is: Available - device has SMART capability.
> > SMART support is: Enabled
> > AAM feature is:   Unavailable
> > APM feature is:   Unavailable
> > Rd look-ahead is: Enabled
> > Write cache is:   Enabled
> > ATA Security is:  Disabled, NOT FROZEN [SEC1]
> > Wt Cache Reorder: Unknown
> >
> > =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> > SMART overall-health self-assessment test result: PASSED
> >
> > General SMART Values:
> > Offline data collection status:  (0x00) Offline data collection activit=
y
> > was never started.
> > Auto Offline Data Collection: Disabled.
> > Self-test execution status:      (   0) The previous self-test routine =
completed
> > without error or no self-test has ever
> > been run.
> > Total time to complete Offline
> > data collection: (27120) seconds.
> > Offline data collection
> > capabilities: (0x7b) SMART execute Offline immediate.
> > Auto Offline data collection on/off support.
> > Suspend Offline collection upon new
> > command.
> > Offline surface scan supported.
> > Self-test supported.
> > Conveyance Self-test supported.
> > Selective Self-test supported.
> > SMART capabilities:            (0x0003) Saves SMART data before enterin=
g
> > power-saving mode.
> > Supports SMART auto save timer.
> > Error logging capability:        (0x01) Error logging supported.
> > General Purpose Logging supported.
> > Short self-test routine
> > recommended polling time: (   2) minutes.
> > Extended self-test routine
> > recommended polling time: ( 274) minutes.
> > Conveyance self-test routine
> > recommended polling time: (   5) minutes.
> > SCT capabilities:        (0x70bd) SCT Status supported.
> > SCT Error Recovery Control supported.
> > SCT Feature Control supported.
> > SCT Data Table supported.
> >
> > SMART Attributes Data Structure revision number: 16
> > Vendor Specific SMART Attributes with Thresholds:
> > ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
> >    1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
> >    3 Spin_Up_Time            POS--K   176   169   021    -    4183
> >    4 Start_Stop_Count        -O--CK   100   100   000    -    502
> >    5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
> >    7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
> >    9 Power_On_Hours          -O--CK   061   061   000    -    28588
> >   10 Spin_Retry_Count        -O--CK   100   100   000    -    0
> >   11 Calibration_Retry_Count -O--CK   100   100   000    -    0
> >   12 Power_Cycle_Count       -O--CK   100   100   000    -    490
> > 192 Power-Off_Retract_Count -O--CK   200   200   000    -    483
> > 193 Load_Cycle_Count        -O--CK   200   200   000    -    18
> > 194 Temperature_Celsius     -O---K   120   089   000    -    27
> > 196 Reallocated_Event_Count -O--CK   200   200   000    -    0
> > 197 Current_Pending_Sector  -O--CK   200   200   000    -    0
> > 198 Offline_Uncorrectable   ----CK   100   253   000    -    0
> > 199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
> > 200 Multi_Zone_Error_Rate   ---R--   100   253   000    -    0
> >                              ||||||_ K auto-keep
> >                              |||||__ C event count
> >                              ||||___ R error rate
> >                              |||____ S speed/performance
> >                              ||_____ O updated online
> >                              |______ P prefailure warning
> >
> > General Purpose Log Directory Version 1
> > SMART           Log Directory Version 1 [multi-sector log support]
> > Address    Access  R/W   Size  Description
> > 0x00       GPL,SL  R/O      1  Log Directory
> > 0x01           SL  R/O      1  Summary SMART error log
> > 0x02           SL  R/O      5  Comprehensive SMART error log
> > 0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
> > 0x06           SL  R/O      1  SMART self-test log
> > 0x07       GPL     R/O      1  Extended self-test log
> > 0x09           SL  R/W      1  Selective self-test log
> > 0x10       GPL     R/O      1  SATA NCQ Queued Error log
> > 0x11       GPL     R/O      1  SATA Phy Event Counters log
> > 0x21       GPL     R/O      1  Write stream error log
> > 0x22       GPL     R/O      1  Read stream error log
> > 0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
> > 0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
> > 0xa8-0xb7  GPL,SL  VS       1  Device vendor specific log
> > 0xbd       GPL,SL  VS       1  Device vendor specific log
> > 0xc0       GPL,SL  VS       1  Device vendor specific log
> > 0xc1       GPL     VS      93  Device vendor specific log
> > 0xe0       GPL,SL  R/W      1  SCT Command/Status
> > 0xe1       GPL,SL  R/W      1  SCT Data Transfer
> >
> > SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
> > No Errors Logged
> >
> > SMART Extended Self-test Log Version: 1 (1 sectors)
> > Num  Test_Description    Status                  Remaining
> > LifeTime(hours)  LBA_of_first_error
> > # 1  Short offline       Completed without error       00%     26024   =
      -
> >
> > SMART Selective self-test log data structure revision number 1
> >   SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
> >      1        0        0  Not_testing
> >      2        0        0  Not_testing
> >      3        0        0  Not_testing
> >      4        0        0  Not_testing
> >      5        0        0  Not_testing
> > Selective self-test flags (0x0):
> >    After scanning selected spans, do NOT read-scan remainder of disk.
> > If Selective self-test is pending on power-up, resume after 0 minute de=
lay.
> >
> > SCT Status Version:                  3
> > SCT Version (vendor specific):       258 (0x0102)
> > SCT Support Level:                   1
> > Device State:                        Active (0)
> > Current Temperature:                    27 Celsius
> > Power Cycle Min/Max Temperature:     10/32 Celsius
> > Lifetime    Min/Max Temperature:      2/58 Celsius
> > Under/Over Temperature Limit Count:   0/0
> > Vendor specific:
> > 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >
> > SCT Temperature History Version:     2
> > Temperature Sampling Period:         1 minute
> > Temperature Logging Interval:        1 minute
> > Min/Max recommended Temperature:      0/60 Celsius
> > Min/Max Temperature Limit:           -41/85 Celsius
> > Temperature History Size (Index):    478 (56)
> >
> > Index    Estimated Time   Temperature Celsius
> >    57    2020-03-20 13:03    24  *****
> >   ...    ..(377 skipped).    ..  *****
> >   435    2020-03-20 19:21    24  *****
> >   436    2020-03-20 19:22     ?  -
> >   437    2020-03-20 19:23    24  *****
> >   438    2020-03-20 19:24    25  ******
> >   ...    ..(  3 skipped).    ..  ******
> >   442    2020-03-20 19:28    25  ******
> >   443    2020-03-20 19:29    26  *******
> >   444    2020-03-20 19:30    26  *******
> >   445    2020-03-20 19:31    26  *******
> >   446    2020-03-20 19:32    27  ********
> >   ...    ..(  3 skipped).    ..  ********
> >   450    2020-03-20 19:36    27  ********
> >   451    2020-03-20 19:37    24  *****
> >   ...    ..( 82 skipped).    ..  *****
> >    56    2020-03-20 21:00    24  *****
> >
> > SCT Error Recovery Control:
> >             Read: Disabled
> >            Write: Disabled
>
> What's going on here? We have a RED drive, but ERC isn't working ...
> >
> > Device Statistics (GP/SMART Log 0x04) not supported
> >
> > SATA Phy Event Counters (GP Log 0x11)
> > ID      Size     Value  Description
> > 0x0001  2            0  Command failed due to ICRC error
> > 0x0002  2            0  R_ERR response for data FIS
> > 0x0003  2            0  R_ERR response for device-to-host data FIS
> > 0x0004  2            0  R_ERR response for host-to-device data FIS
> > 0x0005  2            0  R_ERR response for non-data FIS
> > 0x0006  2            0  R_ERR response for device-to-host non-data FIS
> > 0x0007  2            0  R_ERR response for host-to-device non-data FIS
> > 0x0008  2            0  Device-to-host non-data FIS retries
> > 0x0009  2           33  Transition from drive PhyRdy to drive PhyNRdy
> > 0x000a  2           34  Device-to-host register FISes sent due to a COM=
RESET
> > 0x000b  2            0  CRC errors within host-to-device FIS
> > 0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
> > 0x0012  2            0  R_ERR response for host-to-device non-data FIS,=
 CRC
> > 0x8000  4      1208361  Vendor specific
> >
> > smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-64-generic] (local bu=
ild)
> > Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools=
.org
> >
> > =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> > Device Model:     ST4000VN008-2DR166
> > Serial Number:    ZDH82183
> > LU WWN Device Id: 5 000c50 0c37c42c0
> > Firmware Version: SC60
> > User Capacity:    4,000,787,030,016 bytes [4.00 TB]
> > Sector Sizes:     512 bytes logical, 4096 bytes physical
> > Rotation Rate:    5980 rpm
> > Form Factor:      3.5 inches
> > Device is:        Not in smartctl database [for details use: -P showall=
]
> > ATA Version is:   ACS-3 T13/2161-D revision 5
> > SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
> > Local Time is:    Fri Mar 20 21:00:38 2020 CET
> > SMART support is: Available - device has SMART capability.
> > SMART support is: Enabled
> > AAM feature is:   Unavailable
> > APM level is:     254 (maximum performance)
> > Rd look-ahead is: Enabled
> > Write cache is:   Enabled
> > ATA Security is:  Disabled, NOT FROZEN [SEC1]
> > Wt Cache Reorder: Unknown
> >
> > =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> > SMART overall-health self-assessment test result: PASSED
> >
> > General SMART Values:
> > Offline data collection status:  (0x82) Offline data collection activit=
y
> > was completed without error.
> > Auto Offline Data Collection: Enabled.
> > Self-test execution status:      (   0) The previous self-test routine =
completed
> > without error or no self-test has ever
> > been run.
> > Total time to complete Offline
> > data collection: (  581) seconds.
> > Offline data collection
> > capabilities: (0x7b) SMART execute Offline immediate.
> > Auto Offline data collection on/off support.
> > Suspend Offline collection upon new
> > command.
> > Offline surface scan supported.
> > Self-test supported.
> > Conveyance Self-test supported.
> > Selective Self-test supported.
> > SMART capabilities:            (0x0003) Saves SMART data before enterin=
g
> > power-saving mode.
> > Supports SMART auto save timer.
> > Error logging capability:        (0x01) Error logging supported.
> > General Purpose Logging supported.
> > Short self-test routine
> > recommended polling time: (   1) minutes.
> > Extended self-test routine
> > recommended polling time: ( 621) minutes.
> > Conveyance self-test routine
> > recommended polling time: (   2) minutes.
> > SCT capabilities:        (0x50bd) SCT Status supported.
> > SCT Error Recovery Control supported.
> > SCT Feature Control supported.
> > SCT Data Table supported.
> >
> > SMART Attributes Data Structure revision number: 10
> > Vendor Specific SMART Attributes with Thresholds:
> > ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
> >    1 Raw_Read_Error_Rate     POSR--   070   065   044    -    10856451
> >    3 Spin_Up_Time            PO----   094   094   000    -    0
> >    4 Start_Stop_Count        -O--CK   100   100   020    -    53
> >    5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
> >    7 Seek_Error_Rate         POSR--   075   061   045    -    29667756
> >    9 Power_On_Hours          -O--CK   100   100   000    -    506 (130 =
79 0)
> >   10 Spin_Retry_Count        PO--C-   100   100   097    -    0
> >   12 Power_Cycle_Count       -O--CK   100   100   020    -    5
> > 184 End-to-End_Error        -O--CK   100   100   099    -    0
> > 187 Reported_Uncorrect      -O--CK   100   100   000    -    0
> > 188 Command_Timeout         -O--CK   098   098   000    -    65538
> > 189 High_Fly_Writes         -O-RCK   100   100   000    -    0
> > 190 Airflow_Temperature_Cel -O---K   076   070   040    -    24 (Min/Ma=
x 9/26)
> > 191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
> > 192 Power-Off_Retract_Count -O--CK   100   100   000    -    44
> > 193 Load_Cycle_Count        -O--CK   100   100   000    -    284
> > 194 Temperature_Celsius     -O---K   024   040   000    -    24 (0 9 0 =
0 0)
> > 197 Current_Pending_Sector  -O--C-   100   100   000    -    0
> > 198 Offline_Uncorrectable   ----C-   100   100   000    -    0
> > 199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
> > 240 Head_Flying_Hours       ------   100   253   000    -    139 (51 45=
 0)
> > 241 Total_LBAs_Written      ------   100   253   000    -    8177237744
> > 242 Total_LBAs_Read         ------   100   253   000    -    5818370819
> >                              ||||||_ K auto-keep
> >                              |||||__ C event count
> >                              ||||___ R error rate
> >                              |||____ S speed/performance
> >                              ||_____ O updated online
> >                              |______ P prefailure warning
> >
> > General Purpose Log Directory Version 1
> > SMART           Log Directory Version 1 [multi-sector log support]
> > Address    Access  R/W   Size  Description
> > 0x00       GPL,SL  R/O      1  Log Directory
> > 0x01           SL  R/O      1  Summary SMART error log
> > 0x02           SL  R/O      5  Comprehensive SMART error log
> > 0x03       GPL     R/O      5  Ext. Comprehensive SMART error log
> > 0x04       GPL,SL  R/O      8  Device Statistics log
> > 0x06           SL  R/O      1  SMART self-test log
> > 0x07       GPL     R/O      1  Extended self-test log
> > 0x09           SL  R/W      1  Selective self-test log
> > 0x10       GPL     R/O      1  SATA NCQ Queued Error log
> > 0x11       GPL     R/O      1  SATA Phy Event Counters log
> > 0x13       GPL     R/O      1  SATA NCQ Send and Receive log
> > 0x15       GPL     R/W      1  SATA Rebuild Assist log
> > 0x21       GPL     R/O      1  Write stream error log
> > 0x22       GPL     R/O      1  Read stream error log
> > 0x24       GPL     R/O    512  Current Device Internal Status Data log
> > 0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
> > 0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
> > 0xa1       GPL,SL  VS      24  Device vendor specific log
> > 0xa2       GPL     VS    8160  Device vendor specific log
> > 0xa6       GPL     VS     192  Device vendor specific log
> > 0xa8-0xa9  GPL,SL  VS     136  Device vendor specific log
> > 0xab       GPL     VS       1  Device vendor specific log
> > 0xb0       GPL     VS    9048  Device vendor specific log
> > 0xbe-0xbf  GPL     VS   65535  Device vendor specific log
> > 0xc1       GPL,SL  VS      16  Device vendor specific log
> > 0xd1       GPL     VS     136  Device vendor specific log
> > 0xd2       GPL     VS   10000  Device vendor specific log
> > 0xd3       GPL     VS    1920  Device vendor specific log
> > 0xe0       GPL,SL  R/W      1  SCT Command/Status
> > 0xe1       GPL,SL  R/W      1  SCT Data Transfer
> >
> > SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
> > No Errors Logged
> >
> > SMART Extended Self-test Log Version: 1 (1 sectors)
> > No self-tests have been logged.  [To run self-tests, use: smartctl -t]
> >
> > SMART Selective self-test log data structure revision number 1
> >   SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
> >      1        0        0  Not_testing
> >      2        0        0  Not_testing
> >      3        0        0  Not_testing
> >      4        0        0  Not_testing
> >      5        0        0  Not_testing
> > Selective self-test flags (0x0):
> >    After scanning selected spans, do NOT read-scan remainder of disk.
> > If Selective self-test is pending on power-up, resume after 0 minute de=
lay.
> >
> > SCT Status Version:                  3
> > SCT Version (vendor specific):       522 (0x020a)
> > SCT Support Level:                   1
> > Device State:                        Active (0)
> > Current Temperature:                    23 Celsius
> > Power Cycle Min/Max Temperature:      8/26 Celsius
> > Lifetime    Min/Max Temperature:      8/30 Celsius
> > Under/Over Temperature Limit Count:   0/336
> >
> > SCT Temperature History Version:     2
> > Temperature Sampling Period:         3 minutes
> > Temperature Logging Interval:        59 minutes
> > Min/Max recommended Temperature:      0/ 0 Celsius
> > Min/Max Temperature Limit:            0/ 0 Celsius
> > Temperature History Size (Index):    128 (119)
> >
> > Index    Estimated Time   Temperature Celsius
> >   120    2020-03-15 16:02    21  **
> >   ...    ..(  5 skipped).    ..  **
> >   126    2020-03-15 21:56    21  **
> >   127    2020-03-15 22:55    22  ***
> >   ...    ..( 16 skipped).    ..  ***
> >    16    2020-03-16 15:38    22  ***
> >    17    2020-03-16 16:37    23  ****
> >   ...    ..(  3 skipped).    ..  ****
> >    21    2020-03-16 20:33    23  ****
> >    22    2020-03-16 21:32    24  *****
> >    23    2020-03-16 22:31    23  ****
> >    24    2020-03-16 23:30    24  *****
> >    25    2020-03-17 00:29    24  *****
> >    26    2020-03-17 01:28    24  *****
> >    27    2020-03-17 02:27    23  ****
> >   ...    ..(  7 skipped).    ..  ****
> >    35    2020-03-17 10:19    23  ****
> >    36    2020-03-17 11:18    22  ***
> >   ...    ..(  3 skipped).    ..  ***
> >    40    2020-03-17 15:14    22  ***
> >    41    2020-03-17 16:13    23  ****
> >   ...    ..( 14 skipped).    ..  ****
> >    56    2020-03-18 06:58    23  ****
> >    57    2020-03-18 07:57    22  ***
> >   ...    ..(  2 skipped).    ..  ***
> >    60    2020-03-18 10:54    22  ***
> >    61    2020-03-18 11:53    21  **
> >    62    2020-03-18 12:52    20  *
> >    63    2020-03-18 13:51    21  **
> >    64    2020-03-18 14:50    20  *
> >    65    2020-03-18 15:49    20  *
> >    66    2020-03-18 16:48    21  **
> >   ...    ..(  5 skipped).    ..  **
> >    72    2020-03-18 22:42    21  **
> >    73    2020-03-18 23:41    24  *****
> >    74    2020-03-19 00:40    26  *******
> >   ...    ..(  2 skipped).    ..  *******
> >    77    2020-03-19 03:37    26  *******
> >    78    2020-03-19 04:36    22  ***
> >   ...    ..(  2 skipped).    ..  ***
> >    81    2020-03-19 07:33    22  ***
> >    82    2020-03-19 08:32    21  **
> >    83    2020-03-19 09:31    22  ***
> >    84    2020-03-19 10:30    22  ***
> >    85    2020-03-19 11:29    21  **
> >   ...    ..(  2 skipped).    ..  **
> >    88    2020-03-19 14:26    21  **
> >    89    2020-03-19 15:25    25  ******
> >    90    2020-03-19 16:24    25  ******
> >    91    2020-03-19 17:23    26  *******
> >    92    2020-03-19 18:22    25  ******
> >    93    2020-03-19 19:21    22  ***
> >   ...    ..(  3 skipped).    ..  ***
> >    97    2020-03-19 23:17    22  ***
> >    98    2020-03-20 00:16    21  **
> >   ...    ..(  4 skipped).    ..  **
> >   103    2020-03-20 05:11    21  **
> >   104    2020-03-20 06:10    20  *
> >   ...    ..( 11 skipped).    ..  *
> >   116    2020-03-20 17:58    20  *
> >   117    2020-03-20 18:57    21  **
> >   118    2020-03-20 19:56    21  **
> >   119    2020-03-20 20:55    21  **
> >
> > SCT Error Recovery Control:
> >             Read: Disabled
> >            Write: Disabled
>
> OUCH! AGAIN!
> >
> > Device Statistics (GP Log 0x04)
> > Page  Offset Size        Value Flags Description
> > 0x01  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D General=
 Statistics (rev 1) =3D=3D
> > 0x01  0x008  4               5  ---  Lifetime Power-On Resets
> > 0x01  0x010  4             506  ---  Power-on Hours
> > 0x01  0x018  6      8177237744  ---  Logical Sectors Written
> > 0x01  0x020  6        32254131  ---  Number of Write Commands
> > 0x01  0x028  6      5818370805  ---  Logical Sectors Read
> > 0x01  0x030  6        24397122  ---  Number of Read Commands
> > 0x01  0x038  6               -  ---  Date and Time TimeStamp
> > 0x03  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D Rotatin=
g Media Statistics (rev 1) =3D=3D
> > 0x03  0x008  4             159  ---  Spindle Motor Power-on Hours
> > 0x03  0x010  4              10  ---  Head Flying Hours
> > 0x03  0x018  4             284  ---  Head Load Events
> > 0x03  0x020  4               0  ---  Number of Reallocated Logical Sect=
ors
> > 0x03  0x028  4               0  ---  Read Recovery Attempts
> > 0x03  0x030  4               0  ---  Number of Mechanical Start Failure=
s
> > 0x03  0x038  4               0  ---  Number of Realloc. Candidate
> > Logical Sectors
> > 0x03  0x040  4              45  ---  Number of High Priority Unload Eve=
nts
> > 0x04  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D General=
 Errors Statistics (rev 1) =3D=3D
> > 0x04  0x008  4               0  ---  Number of Reported Uncorrectable E=
rrors
> > 0x04  0x010  4               2  ---  Resets Between Cmd Acceptance and
> > Completion
> > 0x05  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D Tempera=
ture Statistics (rev 1) =3D=3D
> > 0x05  0x008  1              23  ---  Current Temperature
> > 0x05  0x010  1              20  ---  Average Short Term Temperature
> > 0x05  0x018  1               -  ---  Average Long Term Temperature
> > 0x05  0x020  1              30  ---  Highest Temperature
> > 0x05  0x028  1               0  ---  Lowest Temperature
> > 0x05  0x030  1              27  ---  Highest Average Short Term Tempera=
ture
> > 0x05  0x038  1              14  ---  Lowest Average Short Term Temperat=
ure
> > 0x05  0x040  1               -  ---  Highest Average Long Term Temperat=
ure
> > 0x05  0x048  1               -  ---  Lowest Average Long Term Temperatu=
re
> > 0x05  0x050  4               0  ---  Time in Over-Temperature
> > 0x05  0x058  1              70  ---  Specified Maximum Operating Temper=
ature
> > 0x05  0x060  4               0  ---  Time in Under-Temperature
> > 0x05  0x068  1               0  ---  Specified Minimum Operating Temper=
ature
> > 0x06  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D Transpo=
rt Statistics (rev 1) =3D=3D
> > 0x06  0x008  4             101  ---  Number of Hardware Resets
> > 0x06  0x010  4              17  ---  Number of ASR Events
> > 0x06  0x018  4               0  ---  Number of Interface CRC Errors
> >                                  |||_ C monitored condition met
> >                                  ||__ D supports DSN
> >                                  |___ N normalized value
> >
> > SATA Phy Event Counters (GP Log 0x11)
> > ID      Size     Value  Description
> > 0x000a  2           34  Device-to-host register FISes sent due to a COM=
RESET
> > 0x0001  2            0  Command failed due to ICRC error
> > 0x0003  2            0  R_ERR response for device-to-host data FIS
> > 0x0004  2            0  R_ERR response for host-to-device data FIS
> > 0x0006  2            0  R_ERR response for device-to-host non-data FIS
> > 0x0007  2            0  R_ERR response for host-to-device non-data FIS
> >
> > smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-64-generic] (local bu=
ild)
> > Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools=
.org
> >
> Oh My God.
>
> This array is just asking for disaster. Whoops, you've just had one, sorr=
y.
>
> I'm looking for details of your two failed drives, but I don't seem able
> to find any. But as soon as you can get the array back, you need to fix
> those problems ASAP!!!
>
> Firstly, get rid of that Green!!! Were the two failed drives greens?
> Read the timeout page to find out why.
>
> https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
>
> That will hopefully also fix the problem with those Reds with ERC
> disabled. It would not surprise me in the slightest if this is what has
> done the damage to your array.
>
> Lastly, those ST4000s. Are they Ironwolves? I guess they're good drives,
> but they've just trashed your raid-6 redundancy - lose just one of them
> and your array is teetering on the edge. You need to get your sdx2
> partitions copied on to new drives ASAP.
>
> What I'd do is get a couple more ST4000s, and use them, creating 4GB
> partitions. Then take your existing ST4000s, and convert them to 4GB
> partitions. At which point you only need five more ST4000s to move your
> array on to new drives.
>
> I'm not sure how you get there - once you've got your 9 4GB drives you
> *may* be able to just fail and remove the remaining 2GB drives.
> Otherwise, I'd use the freed-up 2GB drives to create 4GB raid-0s. You'd
> end up having to buy a couple of spare 4GB drives to move the entire
> array on to 4GB "drives", but then you could remove the raid-0 arrays.
>
> Cheers,
> Wol
