From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Raid 5 array down/missing - went through wiki steps
Date: Sat, 28 Oct 2017 14:15:52 -0700
Message-ID: <CAK2H+ecV6QXYsT1saAFnkB_t7+B+BXQ=_h_WPPHkrg=sqDvemQ@mail.gmail.com>
References: <CAA4aoFardnK8fOck4kkCWeYNZc=8-03FJzn6KxS6K9wuYN5bdg@mail.gmail.com>
 <CAK2H+efGBYmnPUL2gKqAQ=RRkFBZmBUw8fBcr0efgyb+L7YORA@mail.gmail.com>
 <CAA4aoFY=AK5SMasoRGJEzK=kAVuyJjqQeDu0Fm2mk28juCVXVw@mail.gmail.com>
 <CAA4aoFZxAidceW2duxf-C1nTw429ZOW76WD-UneUSS6e4MPJYw@mail.gmail.com>
 <CAK2H+efan_JOna02sd-EO75ZPadkYWEdRNz2keKp9CWXZxSeGA@mail.gmail.com> <CAA4aoFYh_H-Seg-B2He26pjW2OrZ1zEwQJxLabK3v=6Y=8RBSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA4aoFYh_H-Seg-B2He26pjW2OrZ1zEwQJxLabK3v=6Y=8RBSw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jun-Kai Teoh <kai.teoh@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Oct 28, 2017 at 12:42 PM, Jun-Kai Teoh <kai.teoh@gmail.com> wrote:
> Gotcha, apologies for misunderstanding the question.
>
> 1. I faintly remember looking at the status and they should have all
> been fine, but I'm not 100% sure.
>
> 2. I did not scrub my RAID - don't think I've done it before at all.
>
> 3. Thanks for the reminder and providing me with the command, I wasn't
> entirely sure which smartctl command to run.
>
> smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-97-generic] (local build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org
>
<SNIP>
>
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
>
> General SMART Values:
> Offline data collection status:  (0x00) Offline data collection activity
> was never started.
> Auto Offline Data Collection: Disabled.
> Self-test execution status:      (   0) The previous self-test routine completed
> without error or no self-test has ever
> been run.
> Total time to complete Offline
> data collection: (46440) seconds.
> Offline data collection
> capabilities: (0x7b) SMART execute Offline immediate.
> Auto Offline data collection on/off support.
> Suspend Offline collection upon new
> command.
> Offline surface scan supported.
> Self-test supported.
> Conveyance Self-test supported.
> Selective Self-test supported.
> SMART capabilities:            (0x0003) Saves SMART data before entering
> power-saving mode.
> Supports SMART auto save timer.
> Error logging capability:        (0x01) Error logging supported.
> General Purpose Logging supported.
> Short self-test routine
> recommended polling time: (   2) minutes.
> Extended self-test routine
> recommended polling time: ( 492) minutes.
> Conveyance self-test routine
> recommended polling time: (   5) minutes.
> SCT capabilities:        (0x303d) SCT Status supported.
> SCT Error Recovery Control supported.
> SCT Feature Control supported.
> SCT Data Table supported.
>
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> UPDATED  WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x002f   100   253   051    Pre-fail
> Always       -       0
>   3 Spin_Up_Time            0x0027   100   253   021    Pre-fail
> Always       -       0
>   4 Start_Stop_Count        0x0032   100   100   000    Old_age
> Always       -       3
>   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> Always       -       0
>   7 Seek_Error_Rate         0x002e   100   253   000    Old_age
> Always       -       0
>   9 Power_On_Hours          0x0032   100   100   000    Old_age
> Always       -       11
>  10 Spin_Retry_Count        0x0032   100   253   000    Old_age
> Always       -       0
>  11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
> Always       -       0
>  12 Power_Cycle_Count       0x0032   100   100   000    Old_age
> Always       -       3
> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
> Always       -       1
> 193 Load_Cycle_Count        0x0032   200   200   000    Old_age
> Always       -       3
> 194 Temperature_Celsius     0x0022   121   117   000    Old_age
> Always       -       29
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
> Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> Always       -       0
> 198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
> Always       -       0
> 200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
> Offline      -       0
>
> SMART Error Log Version: 1
> No Errors Logged
>
> SMART Self-test log structure revision number 1
> No self-tests have been logged.  [To run self-tests, use: smartctl -t]
>
> SMART Selective self-test log data structure revision number 1
>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>     1        0        0  Not_testing
>     2        0        0  Not_testing
>     3        0        0  Not_testing
>     4        0        0  Not_testing
>     5        0        0  Not_testing
> Selective self-test flags (0x0):
>   After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute delay.
>
> smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-97-generic] (local build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org
<SNIP>

OK, I cannot tell (and it doesn't matter right now to me) what order
those outputs are in compared to /dev/sd values. The one I didn't snip
out appears to be the new one with 11 hours of power on time. I note
that one of the older drives had a different firmware version. Again,
very unlikely to be a problem. WD Reds are good drives.

Oh, I see you haven't posted (or I'm not finding it) what distro,
kernel and mdadm version you are using. Folks are certainly going to
ask for that.

At this point I'd personally sit tight and wait for someone capable of
giving guidance. I sort of doubt that you've lost data, or at least
not too much data) but who knows? There have been a couple of threads
recently (< 1 month) about people doing reshapes, and maybe new adds,
where the user had problems. There were instructions given for how to
go back in at least one case. You might read through those threads to
just get a feel for it but wait for real advice. Don't force anything.

Good luck,
Mark
