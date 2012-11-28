From: Chris Friesen <chris.friesen@genband.com>
Subject: Re: getting I/O errors in super_written()...any ideas what would
 cause this?
Date: Wed, 28 Nov 2012 14:21:04 -0600
Message-ID: <50B67230.4080602@genband.com>
References: <8134827.27.1354128708501.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8134827.27.1354128708501.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Neil Brown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-raid.ids

On 11/28/2012 12:51 PM, Roy Sigurd Karlsbakk wrote:
>>> I'm running 2.6.27 with LVM over software RAID 1 over a pair of SAS
>>> disks.
>>>
>>> Recently we started seeing messages of the following pattern:
>>>
>>> Nov 28 08:57:10 kernel: end_request: I/O error, dev sda, sector
>>> 1758169523
>>> Nov 28 08:57:10 kernel: md: super_written gets error=-5, uptodate=0
>>> Nov 28 08:57:10 kernel: raid1: Disk failure on sda2, disabling
>>> device.
>>> Nov 28 08:57:10 kernel: raid1: Operation continuing on 1 devices.

>> It would be interesting to see what SMART says about the above, sinde
>> the error is regarding sda first, then md follows.
>>
> 
> Agreed - run smartctl -H /dev/sda or smartctl -a /dev/sda if -H succeeds

Okay, I just got some more information that I didn't have earlier.
Apparently we're doing a disk self-test command at the time we see
the error.  I'm trying to get the details of exactly what is
being run, but from the output below it looks like some form of
background short test.

Is it possible that the self test causes an error message that the kernel
doesn't know how to handle?


In any case, here's the smartctl output from right after a failure:

root@typhoon-base-unit0:/root> ./smartctl --all /dev/sda
smartctl version 5.38 [i686-wrs-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Device: WD       WD9001BKHG-02D22 Version: SR03
Serial number:         WX21EB1ANU78
Device type: disk
Transport protocol: SAS
Local Time is: Fri Nov 23 00:35:03 2012 HKT
Device supports SMART and is Enabled
Temperature Warning Enabled
SMART Health Status: OK

Current Drive Temperature:     39 C
Drive Trip Temperature:        69 C
Manufactured in week 01 of year 2010
Recommended maximum start stop count:  1048576 times
Current start stop count:      26 times
Elements in grown defect list: 0

Error counter log:
           Errors Corrected by           Total   Correction     Gigabytes    Total
               ECC          rereads/    errors   algorithm      processed    uncorrected
           fast | delayed   rewrites  corrected  invocations   [109 bytes]  errors
read:      21187        2         2     21189          2       4950.446           0
write:        89        4         0        93          4       1317.938           0
verify:      103        0         0       103          0          0.000           0

Non-medium error count:   169436

SMART Self-test log
Num  Test              Status                 segment  LifeTime  LBA_first_err [SK ASC ASQ]
     Description                              number   (hours)
# 1  Background short  Self test in progress ...   4     NOW                 - [-   -    -]
# 2  Background short  Completed                   -    1377                 - [-   -    -]
# 3  Background short  Completed                   -    1377                 - [-   -    -]
# 4  Background short  Completed                   -    1377                 - [-   -    -]
# 5  Background short  Completed                   -    1377                 - [-   -    -]
# 6  Background short  Completed                   -    1377                 - [-   -    -]
# 7  Background short  Completed                   -    1377                 - [-   -    -]
# 8  Background short  Completed                   -    1377                 - [-   -    -]
# 9  Background short  Completed                   -    1377                 - [-   -    -]
#10  Background short  Completed                   -    1377                 - [-   -    -]
#11  Background short  Completed                   -    1377                 - [-   -    -]
#12  Background short  Completed                   -    1377                 - [-   -    -]
#13  Background short  Completed                   -    1377                 - [-   -    -]
#14  Background short  Completed                   -    1377                 - [-   -    -]
#15  Background short  Completed                   -    1377                 - [-   -    -]
#16  Background short  Completed                   -    1377                 - [-   -    -]
#17  Background short  Completed                   -    1377                 - [-   -    -]
#18  Background short  Completed                   -    1377                 - [-   -    -]
#19  Background short  Completed                   -    1377                 - [-   -    -]
#20  Background short  Completed                   -    1377                 - [-   -    -]

Long (extended) Self Test duration: 6362 seconds [106.0 minutes]




I also have this from ten minutes later with a newer version of smartctl:

root@typhoon-base-unit0:/root> ./smartctl.eric -x /dev/sda
smartctl 5.40 2010-10-16 r3189 [i686-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

Device: WD       WD9001BKHG-02D22 Version: SR03
Serial number:         WX21EB1ANU78
Device type: disk
Transport protocol: SAS
Local Time is: Fri Nov 23 00:45:08 2012 HKT
Device supports SMART and is Enabled
Temperature Warning Enabled
SMART Health Status: OK

Current Drive Temperature:     39 C
Drive Trip Temperature:        69 C
Manufactured in week 01 of year 2010
Specified cycle count over device lifetime:  1048576
Accumulated start-stop cycles:  26
Specified load-unload count over device lifetime:  1114112
Accumulated load-unload cycles:  0
Elements in grown defect list: 0

Error counter log:
           Errors Corrected by           Total   Correction     Gigabytes    Total
               ECC          rereads/    errors   algorithm      processed    uncorrected
           fast | delayed   rewrites  corrected  invocations   [109 bytes]  errors
read:      21189        2         2     21191          2       4950.446           0
write:        89        4         0        93          4       1317.939           0
verify:      103        0         0       103          0          0.000           0

Non-medium error count:   169436

SMART Self-test log
Num  Test              Status                 segment  LifeTime  LBA_first_err [SK ASC ASQ]
     Description                              number   (hours)
# 1  Background short  Completed                   -    1378                 - [-   -    -]
# 2  Background short  Completed                   -    1378                 - [-   -    -]
# 3  Background short  Completed                   -    1378                 - [-   -    -]
# 4  Background short  Completed                   -    1377                 - [-   -    -]
# 5  Background short  Completed                   -    1377                 - [-   -    -]
# 6  Background short  Completed                   -    1377                 - [-   -    -]
# 7  Background short  Completed                   -    1377                 - [-   -    -]
# 8  Background short  Completed                   -    1377                 - [-   -    -]
# 9  Background short  Completed                   -    1377                 - [-   -    -]
#10  Background short  Completed                   -    1377                 - [-   -    -]
#11  Background short  Completed                   -    1377                 - [-   -    -]
#12  Background short  Completed                   -    1377                 - [-   -    -]
#13  Background short  Completed                   -    1377                 - [-   -    -]
#14  Background short  Completed                   -    1377                 - [-   -    -]
#15  Background short  Completed                   -    1377                 - [-   -    -]
#16  Background short  Completed                   -    1377                 - [-   -    -]
#17  Background short  Completed                   -    1377                 - [-   -    -]
#18  Background short  Completed                   -    1377                 - [-   -    -]
#19  Background short  Completed                   -    1377                 - [-   -    -]
#20  Background short  Completed                   -    1377                 - [-   -    -]

Long (extended) Self Test duration: 6362 seconds [106.0 minutes]

Background scan results log
  Status: no scans active
    Accumulated power on time, hours:minutes 1378:08 [82688 minutes]
    Number of background scans performed: 0,  scan progress: 0.00%
    Number of background medium scans performed: 0
Protocol Specific port log page for SAS SSP
relative target port id = 1
  generation code = 0
  number of phys = 1
  phy identifier = 0
    attached device type: end device
    attached reason: unknown
    reason: unknown
    negotiated logical link rate: phy enabled; 3 Gbps
    attached initiator port: ssp=1 stp=1 smp=1
    attached target port: ssp=0 stp=0 smp=0
    SAS address = 0x50014ee3556977a6
    attached SAS address = 0x5fcfffff00000001
    attached phy identifier = 0
    Invalid DWORD count = 0
    Running disparity error count = 0
    Loss of DWORD synchronization = 3
    Phy reset problem = 0
    Phy event descriptors:
     Transmitted SSP frame error count: 0
     Received SSP frame error count: 0
relative target port id = 2
  generation code = 0
  number of phys = 1
  phy identifier = 1
    attached device type: no device attached
    attached reason: unknown
    reason: unknown
    negotiated logical link rate: phy enabled; unknown
    attached initiator port: ssp=0 stp=0 smp=0
    attached target port: ssp=0 stp=0 smp=0
    SAS address = 0x50014ee3556977a7
    attached SAS address = 0x0
    attached phy identifier = 0
    Invalid DWORD count = 0
    Running disparity error count = 0
    Loss of DWORD synchronization = 0
    Phy reset problem = 0
    Phy event descriptors:
     Transmitted SSP frame error count: 0
     Received SSP frame error count: 0




