From: antlists <antlists@youngman.org.uk>
Subject: Re: Software RAID6 broke after power outage
Date: Wed, 22 Jul 2020 20:47:47 +0100
Message-ID: <a5634a2c-d6be-e037-da70-2d828f65873e@youngman.org.uk>
References: <CA+CBf3QZP4Yss0U=6Aa_5a+3D2Yy-WT545VazHiFWCZsreNOEg@mail.gmail.com>
 <CA+CBf3Q8sKv9k83dp38ekkBY1qgvOe2seQOYvxukg-X4__7JkA@mail.gmail.com>
 <5F180388.6020402@youngman.org.uk>
 <CA+CBf3T_GtTwLqKrk4UWj_yPPL7vqJQzBD7Z_J34WWSwmudR5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+CBf3T_GtTwLqKrk4UWj_yPPL7vqJQzBD7Z_J34WWSwmudR5g@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Cory Derenburger <cory.derenburger@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/07/2020 17:29, Cory Derenburger wrote:
> Thanks Wols,
> 
> The version on Linux Mint I've been running is quite old.  Once the
> server was last configured it did not have updates.  It was put on a
> shelf and (mostly) left alone to serve files reliably for years.

That's good.
> 
> $ mdadm --version
> mdadm - v3.2.5 - 18th May 2012
> 
And that's not so good. If your root is not on the raid and the system 
actually runs, download and run the latest mdadm. That on an old kernel 
shouldn't be a problem. A franken-kernel that's been patched to buggery 
probably is.

> uname -a
> Linux LIZZY 3.16.0-38-generic #52~14.04.1-Ubuntu SMP Fri May 8
> 09:43:57 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> 
Do you want the good news or the bad news? The good news is we can 
probably recover your data. The bad news is you're probably looking at 
replacing all your drives :-(

https://raid.wiki.kernel.org/index.php/Timeout_Mismatch

A cursory glance says you have several drives that fall foul of this. 
Again, if your system is bootable, you NEED to configure Brad's script 
to run. I'll go into it a bit deeper as I dig through your reply.
> 
> smartctrl for the drives
> # smartctl --xall /dev/sdb
> smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-38-generic] (local build)
> Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> === START OF INFORMATION SECTION ===
> Device Model:     Hitachi HUA723020ALA641
> Serial Number:    YFGK3VXD
> LU WWN Device Id: 5 000cca 223c7c8d4
> Firmware Version: MK7OA840
> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    7200 rpm
> Device is:        Not in smartctl database [for details use: -P showall]
> ATA Version is:   ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 2.6, 6.0 Gb/s (current: 3.0 Gb/s)
> Local Time is:    Tue Jul 21 12:43:42 2020 PDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM feature is:   Unavailable
> APM feature is:   Disabled
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
> Wt Cache Reorder: Enabled
> 
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
> 
> General SMART Values:
> Offline data collection status:  (0x84) Offline data collection activity
>                                          was suspended by an
> interrupting command from host.
>                                          Auto Offline Data Collection: Enabled.
> Self-test execution status:      (   0) The previous self-test routine completed
>                                          without error or no self-test has ever
>                                          been run.
> Total time to complete Offline
> data collection:                (20116) seconds.
> Offline data collection
> capabilities:                    (0x5b) SMART execute Offline immediate.
>                                          Auto Offline data collection
> on/off support.
>                                          Suspend Offline collection upon new
>                                          command.
>                                          Offline surface scan supported.
>                                          Self-test supported.
>                                          No Conveyance Self-test supported.
>                                          Selective Self-test supported.
> SMART capabilities:            (0x0003) Saves SMART data before entering
>                                          power-saving mode.
>                                          Supports SMART auto save timer.
> Error logging capability:        (0x01) Error logging supported.
>                                          General Purpose Logging supported.
> Short self-test routine
> recommended polling time:        (   1) minutes.
> Extended self-test routine
> recommended polling time:        ( 336) minutes.
> SCT capabilities:              (0x003d) SCT Status supported.
>                                          SCT Error Recovery Control supported.
>                                          SCT Feature Control supported.
>                                          SCT Data Table supported.

GOOD. This drive is suitable for RAID.
> 
> 
> SCT Error Recovery Control:
>             Read: Disabled
>            Write: Disabled

And BAD. Brad's script should switch this on. Check that it does!
> 

> 
> # smartctl --xall /dev/sdc
> smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-38-generic] (local build)
> Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> === START OF INFORMATION SECTION ===
> Model Family:     Western Digital Caviar Green (AF)

I don't think green drives are suitable ... but it is a Caviar, which 
have a good rep ...

> Device Model:     WDC WD20EARS-00MVWB0
> Serial Number:    WD-WCAZA1597296
> LU WWN Device Id: 5 0014ee 25a653961
> Firmware Version: 51.0AB51
> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> Sector Size:      512 bytes logical/physical
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ATA8-ACS (minor revision not indicated)
> SATA Version is:  SATA 2.6, 3.0 Gb/s
> Local Time is:    Tue Jul 21 12:45:57 2020 PDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM feature is:   Disabled
> APM feature is:   Unavailable
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
> Wt Cache Reorder: Enabled
> 
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
> 
> General SMART Values:
> Offline data collection status:  (0x82) Offline data collection activity
>                                          was completed without error.
>                                          Auto Offline Data Collection: Enabled.
> Self-test execution status:      (   0) The previous self-test routine completed
>                                          without error or no self-test has ever
>                                          been run.
> Total time to complete Offline
> data collection:                (38460) seconds.
> Offline data collection
> capabilities:                    (0x7b) SMART execute Offline immediate.
>                                          Auto Offline data collection
> on/off support.
>                                          Suspend Offline collection upon new
>                                          command.
>                                          Offline surface scan supported.
>                                          Self-test supported.
>                                          Conveyance Self-test supported.
>                                          Selective Self-test supported.
> SMART capabilities:            (0x0003) Saves SMART data before entering
>                                          power-saving mode.
>                                          Supports SMART auto save timer.
> Error logging capability:        (0x01) Error logging supported.
>                                          General Purpose Logging supported.
> Short self-test routine
> recommended polling time:        (   2) minutes.
> Extended self-test routine
> recommended polling time:        ( 371) minutes.
> Conveyance self-test routine
> recommended polling time:        (   5) minutes.
> SCT capabilities:              (0x3035) SCT Status supported.
>                                          SCT Feature Control supported.
>                                          SCT Data Table supported.

No mention of Error Recovery ... BAAAADDDDD!!!
> 
> 
> SCT Error Recovery Control command not supported

BAAAAADDDDDD!!!!

Greens aren't suitable - and this is sdc, the dodgy drive, so I suspect 
using it in a raid array has knackered it.
> 
> # smartctl --xall /dev/sdd
> smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-38-generic] (local build)
> Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> === START OF INFORMATION SECTION ===
> Device Model:     Hitachi HUA723020ALA641
> Serial Number:    YFHK9JAA
> LU WWN Device Id: 5 000cca 223d5f593
> Firmware Version: MK7OA840
> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    7200 rpm
> Device is:        Not in smartctl database [for details use: -P showall]
> ATA Version is:   ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 2.6, 6.0 Gb/s (current: 3.0 Gb/s)
> Local Time is:    Tue Jul 21 12:47:13 2020 PDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM feature is:   Unavailable
> APM feature is:   Disabled
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
> Wt Cache Reorder: Enabled
> 
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
> 
> General SMART Values:
> Offline data collection status:  (0x84) Offline data collection activity
>                                          was suspended by an
> interrupting command from host.
>                                          Auto Offline Data Collection: Enabled.
> Self-test execution status:      (   0) The previous self-test routine completed
>                                          without error or no self-test has ever
>                                          been run.
> Total time to complete Offline
> data collection:                (19618) seconds.
> Offline data collection
> capabilities:                    (0x5b) SMART execute Offline immediate.
>                                          Auto Offline data collection
> on/off support.
>                                          Suspend Offline collection upon new
>                                          command.
>                                          Offline surface scan supported.
>                                          Self-test supported.
>                                          No Conveyance Self-test supported.
>                                          Selective Self-test supported.
> SMART capabilities:            (0x0003) Saves SMART data before entering
>                                          power-saving mode.
>                                          Supports SMART auto save timer.
> Error logging capability:        (0x01) Error logging supported.
>                                          General Purpose Logging supported.
> Short self-test routine
> recommended polling time:        (   1) minutes.
> Extended self-test routine
> recommended polling time:        ( 327) minutes.
> SCT capabilities:              (0x003d) SCT Status supported.
>                                          SCT Error Recovery Control supported.

Good...

>                                          SCT Feature Control supported.
>                                          SCT Data Table supported.
> 
> 
> SCT Error Recovery Control:
>             Read: Disabled
>            Write: Disabled

And bad, but at least it's got it ... as above make sure it's enabled.
> 

> 
> # smartctl --xall /dev/sde
> smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-38-generic] (local build)
> Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> === START OF INFORMATION SECTION ===
> Device Model:     Hitachi HUA723020ALA641

Okay, I assume this is the same as the previous drive ...

> Serial Number:    YFG7LWBA
> LU WWN Device Id: 5 000cca 223c3757b
> Firmware Version: MK7OA840
> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    7200 rpm
> Device is:        Not in smartctl database [for details use: -P showall]
> ATA Version is:   ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 2.6, 6.0 Gb/s (current: 3.0 Gb/s)
> Local Time is:    Tue Jul 21 12:47:56 2020 PDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM feature is:   Unavailable
> APM feature is:   Disabled
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
> Wt Cache Reorder: Enabled
> 

Okay, we'll assume sdc is dead. The first thing is to try to assemble 
the remaining disks without it. Boot from a rescue disk so you've got 
the latest and greatest available. And don't forget, if you get "device 
busy", you've probably got the remains of a previous assemble messing 
things up, so you need to do a --stop. Just DON'T do a --force, not yet.

Next thing we need is the event count - I think that's mdadm --examine 
over each partition that makes the array.

And make sure you've got a replacement for that Green. You NEED to get 
rid of it.

Let's see how it goes ... if the array assembles fine with the rescue 
disk, just add your new disk and replace sdc, but make sure Brad's 
script has enabled ERC!

Cheers,
Wol
