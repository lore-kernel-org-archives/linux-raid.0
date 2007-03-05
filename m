From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: detecting/correcting _slightly_ flaky disks
Date: Mon, 5 Mar 2007 12:11:46 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0703051211350.14012@p34.internal.lan>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>
 <17898.45673.573800.56474@notabene.brown> <45EB3867.8050907@eyal.emu.id.au>
 <17899.18568.523543.478792@notabene.brown> <45EBCA83.40106@eyal.emu.id.au>
 <45EC2F89.2070703@pobox.com> <Pine.LNX.4.64.0703051008190.14012@p34.internal.lan>
 <45EC4CFD.3050106@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45EC4CFD.3050106@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Stumpf <mjstumpf@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Besides being run for a long time, I don't see anything strange with this 
drive.

Justin.

On Mon, 5 Mar 2007, Michael Stumpf wrote:

> This is the drive I think is most suspect.  What isn't obvious, because it 
> isn't listed in the self test log, is between #1 and #2 there was an aborted, 
> hung test.   The #4 short test that was aborted was also a hung test that I 
> eventually, manually aborted--heard clicking from drives at that time, can't 
> swear it was from this drive though.
>
> Not sure I fully understand the nuances of this report.  If anything jumps 
> out at you, I'd appreciate a tip on how you read it.  (to me, looks mostly 
> healthy)
>
>> 
>> 
>> Also, what does smartctl -a /dev/hda for each of your drives show?
>> 
>> Justin.
>> 
>> 
> === START OF INFORMATION SECTION ===
> Model Family:     Western Digital Caviar SE family
> Device Model:     WDC WD1200JB-75CRA0
> Serial Number:    WD-WMA8C3115683
> Firmware Version: 16.06V76
> User Capacity:    120,000,000,000 bytes
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   5
> ATA Standard is:  Exact ATA specification draft version not indicated
> Local Time is:    Mon Mar 05 10:52:05 2007 CAST
> SMART support is: Available - device has SMART capability.
>                 Enabled status cached by OS, trying SMART RETURN STATUS cmd.
> SMART support is: Enabled
>
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
>
> General SMART Values:
> Offline data collection status:  (0x85) Offline data collection activity
>                                       was aborted by an interrupting command 
> from host.
>                                       Auto Offline Data Collection: Enabled.
> Self-test execution status:      (   0) The previous self-test routine 
> completed
>                                       without error or no self-test has ever
>                                       been run.
> Total time to complete Offline
> data collection:                 (4680) seconds.
> Offline data collection
> capabilities:                    (0x3b) SMART execute Offline immediate.
>                                       Auto Offline data collection on/off 
> support.
>                                       Suspend Offline collection upon new
>                                       command.
>                                       Offline surface scan supported.
>                                       Self-test supported.
>                                       Conveyance Self-test supported.
>                                       No Selective Self-test supported.
> SMART capabilities:            (0x0003) Saves SMART data before entering
>                                       power-saving mode.
>                                       Supports SMART auto save timer.
> Error logging capability:        (0x01) Error logging supported.
>                                       No General Purpose Logging support.
> Short self-test routine
> recommended polling time:        (   2) minutes.
> Extended self-test routine
> recommended polling time:        (  87) minutes.
> Conveyance self-test routine
> recommended polling time:        (   5) minutes.
>
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED 
> WHEN_FAILED RAW_VALUE
> 1 Raw_Read_Error_Rate     0x000b   200   200   051    Pre-fail  Always 
> -       0
> 3 Spin_Up_Time            0x0007   146   098   021    Pre-fail  Always 
> -       3491
> 4 Start_Stop_Count        0x0032   100   100   040    Old_age   Always 
> -       399
> 5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always 
> -       0
> 7 Seek_Error_Rate         0x000b   200   200   051    Pre-fail  Always 
> -       0
> 9 Power_On_Hours          0x0032   070   070   000    Old_age   Always 
> -       22147
> 10 Spin_Retry_Count        0x0013   100   100   051    Pre-fail  Always 
> -       0
> 11 Calibration_Retry_Count 0x0013   100   100   051    Pre-fail  Always 
> -       0
> 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always 
> -       397
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always 
> -       0
> 197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always 
> -       0
> 198 Offline_Uncorrectable   0x0012   200   200   000    Old_age   Always 
> -       0
> 199 UDMA_CRC_Error_Count    0x000a   200   253   000    Old_age   Always 
> -       0
> 200 Multi_Zone_Error_Rate   0x0009   200   200   051    Pre-fail  Offline 
> -       0
>
> SMART Error Log Version: 1
> No Errors Logged
>
> SMART Self-test log structure revision number 1
> Num  Test_Description    Status                  Remaining  LifeTime(hours) 
> LBA_of_first_error
> # 1  Extended offline    Completed without error       00%       299 
> -
> # 2  Extended offline    Interrupted (host reset)      50%       279 
> -
> # 3  Short offline       Completed without error       00%       279 
> -
> # 4  Short offline       Aborted by host               80%       279 
> -
> # 5  Extended offline    Completed without error       00%       102 
> -
> # 6  Extended offline    Completed without error       00%      1026 
> -
> # 7  Extended offline    Completed without error       00%       859 
> -
> # 8  Extended offline    Completed without error       00%       692 
> -
> # 9  Extended offline    Completed without error       00%       525 
> -
> #10  Extended offline    Completed without error       00%       380 
> -
> #11  Extended offline    Completed without error       00%       370 
> -
>
> Device does not support Selective Self Tests/Logging
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
