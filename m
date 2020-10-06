Return-Path: <SRS0=H5I/=DN=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 036C3C41604
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 08:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CBE52078E
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 08:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgJFIYG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 6 Oct 2020 04:24:06 -0400
Received: from mail.thelounge.net ([91.118.73.15]:22197 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgJFIYG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 6 Oct 2020 04:24:06 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4C59V82dQgzXLv;
        Tue,  6 Oct 2020 10:24:00 +0200 (CEST)
Subject: Re: do i need to give up on this setup
To:     Daniel Sanabria <sanabria.d@gmail.com>,
        Roger Heflin <rogerheflin@gmail.com>
Cc:     Roman Mamedov <rm@romanrm.net>,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <CAHscji30ACa2d0qz-nr5vqPYOP642dwjS5BY07g2DQS7GBG-2A@mail.gmail.com>
 <20201005184449.54225175@natsu>
 <CAHscji0pNezf6xCpjWto5-21ayoCeLWm34GTYh5TSgxkOw90mw@mail.gmail.com>
 <20201005190421.4ecd8f1b@natsu>
 <CAHscji1VrccTOaQc4GdWof4E+Bzs5KL0-tJJj0ZUM9Db=QBriw@mail.gmail.com>
 <CAAMCDedZfx+w3NT_QgB0KGkeEQikCtYVy9YuiNEhNaEjXF1C8w@mail.gmail.com>
 <CAHscji01ikKz4fQ_9i4Tb3AraTD+ZcXBbK-Mm+zY4p3p2qbF4Q@mail.gmail.com>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <620259f4-f371-1045-64de-02c7185227bd@thelounge.net>
Date:   Tue, 6 Oct 2020 10:24:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAHscji01ikKz4fQ_9i4Tb3AraTD+ZcXBbK-Mm+zY4p3p2qbF4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 06.10.20 um 09:56 schrieb Daniel Sanabria:
> Yeah it is quite possible that the hardware can't support the setup
> because this array was an afterthought and considered an upgrade to
> the system.
> 
> For the record here are some more details about the setup:
> 
> Motherboard: ASROCK EP2C602-4L/D16
> PSU: 850W Corsair RM Series
> I have 6 drives connected to the motherboard. The 3 drives forming the
> array are Western Digital Green WDC WD30EZRX-00D8PB0 and are connected
> to 3 ports of the Marvell 9230 SATA controller. The other 3 drives are
> Western Digital Caviar Blue (SATA) WDC WD5000AAKS-00A7B2 are connected
> to the spare Marvell port and the 2 SATA/SAS Motherboard ports
> available.

yeah, unreliable desktop disks without at least increase the timeouts -
currently the only WD disks for a RAID setip are the "WD Gold" after
they lost theri brain and starting SMR on "WD Red"

https://raid.wiki.kernel.org/index.php/Timeout_Mismatch

-------------------------
[root@srv-rhsoft:~]$ cat /etc/systemd/system/disk-timeout.service
[Unit]
Description=SCSI Timeouts

[Service]
Type=oneshot
ExecStart=/usr/local/bin/disk-timeout.sh

[Install]
WantedBy=multi-user.target

-------------------------

[root@srv-rhsoft:~]$ cat /usr/local/bin/disk-timeout.sh
#!/usr/bin/dash

echo 180 > "/sys/block/sda/device/timeout"
echo 180 > "/sys/block/sdb/device/timeout"
echo 180 > "/sys/block/sdc/device/timeout"
echo 180 > "/sys/block/sdd/device/timeout"

-------------------------

> On Mon, 5 Oct 2020 at 16:58, Roger Heflin <rogerheflin@gmail.com> wrote:
>>
>> what they said you have a hardware problem.
>>
>> it could be about anything previously mentioned and could also be the
>> power supply being unable to provide a stable 12V for the disks.
>>
>> You should provide the list more specifics on your hw setup, of
>> interest are what kind of SATA/SAS ports you are using and how the
>> disk are cabled in.
>>
>> Note that there are a number of controllers that aren't the most
>> reliable and some of those controllers when something happens will
>> stop responding for all disks connected to it.
>>
>> I have also seen badly designed motherboards have
>> build-in(non-AMD/non-Intel chips) sata ports that don't work under any
>> load that uses more than a single disk at a time, and/or acts badly
>> when given smart commands.
>>
>> On Mon, Oct 5, 2020 at 9:30 AM Daniel Sanabria <sanabria.d@gmail.com> wrote:
>>>
>>>> I meant not to me personally, but to the mailing list. The drives seem OK
>>>> though, even sde.
>>>
>>> Sorry missed the reply-all button
>>>
>>> On Mon, 5 Oct 2020 at 15:04, Roman Mamedov <rm@romanrm.net> wrote:
>>>>
>>>> On Mon, 5 Oct 2020 14:59:35 +0100
>>>> Daniel Sanabria <sanabria.d@gmail.com> wrote:
>>>>
>>>>>> It looks like a drive is dropping off the bus and then failing to reidentify,
>>>>>> could be bad cabling/controller/PSU, or just a bad drive. You should post
>>>>>> "smartctl -a" of all drives as well.
>>>>
>>>> I meant not to me personally, but to the mailing list. The drives seem OK
>>>> though, even sde.
>>>>
>>>>> [dan@lamachine ~]$ sudo smartctl -a /dev/sdc
>>>>> [sudo] password for dan:
>>>>> smartctl 6.6 2017-11-05 r4594
>>>>> [x86_64-linux-4.18.0-193.14.2.el8_2.x86_64] (local build)
>>>>> Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org
>>>>>
>>>>> === START OF INFORMATION SECTION ===
>>>>> Model Family:     Western Digital Green
>>>>> Device Model:     WDC WD30EZRX-00D8PB0
>>>>> Serial Number:    WD-WCC4NCWT13RF
>>>>> LU WWN Device Id: 5 0014ee 25fc9e460
>>>>> Firmware Version: 80.00A80
>>>>> User Capacity:    3,000,591,900,160 bytes [3.00 TB]
>>>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
>>>>> Rotation Rate:    5400 rpm
>>>>> Device is:        In smartctl database [for details use: -P show]
>>>>> ATA Version is:   ACS-2 (minor revision not indicated)
>>>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
>>>>> Local Time is:    Mon Oct  5 14:58:34 2020 BST
>>>>> SMART support is: Available - device has SMART capability.
>>>>> SMART support is: Enabled
>>>>>
>>>>> === START OF READ SMART DATA SECTION ===
>>>>> SMART overall-health self-assessment test result: PASSED
>>>>>
>>>>> General SMART Values:
>>>>> Offline data collection status:  (0x82) Offline data collection activity
>>>>> was completed without error.
>>>>> Auto Offline Data Collection: Enabled.
>>>>> Self-test execution status:      (   0) The previous self-test routine completed
>>>>> without error or no self-test has ever
>>>>> been run.
>>>>> Total time to complete Offline
>>>>> data collection: (38940) seconds.
>>>>> Offline data collection
>>>>> capabilities: (0x7b) SMART execute Offline immediate.
>>>>> Auto Offline data collection on/off support.
>>>>> Suspend Offline collection upon new
>>>>> command.
>>>>> Offline surface scan supported.
>>>>> Self-test supported.
>>>>> Conveyance Self-test supported.
>>>>> Selective Self-test supported.
>>>>> SMART capabilities:            (0x0003) Saves SMART data before entering
>>>>> power-saving mode.
>>>>> Supports SMART auto save timer.
>>>>> Error logging capability:        (0x01) Error logging supported.
>>>>> General Purpose Logging supported.
>>>>> Short self-test routine
>>>>> recommended polling time: (   2) minutes.
>>>>> Extended self-test routine
>>>>> recommended polling time: ( 391) minutes.
>>>>> Conveyance self-test routine
>>>>> recommended polling time: (   5) minutes.
>>>>> SCT capabilities:        (0x7035) SCT Status supported.
>>>>> SCT Feature Control supported.
>>>>> SCT Data Table supported.
>>>>>
>>>>> SMART Attributes Data Structure revision number: 16
>>>>> Vendor Specific SMART Attributes with Thresholds:
>>>>> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
>>>>> UPDATED  WHEN_FAILED RAW_VALUE
>>>>>   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
>>>>> Always       -       0
>>>>>   3 Spin_Up_Time            0x0027   178   165   021    Pre-fail
>>>>> Always       -       6075
>>>>>   4 Start_Stop_Count        0x0032   100   100   000    Old_age
>>>>> Always       -       81
>>>>>   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
>>>>> Always       -       0
>>>>>   7 Seek_Error_Rate         0x002e   100   253   000    Old_age
>>>>> Always       -       0
>>>>>   9 Power_On_Hours          0x0032   075   075   000    Old_age
>>>>> Always       -       18577
>>>>>  10 Spin_Retry_Count        0x0032   100   253   000    Old_age
>>>>> Always       -       0
>>>>>  11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
>>>>> Always       -       0
>>>>>  12 Power_Cycle_Count       0x0032   100   100   000    Old_age
>>>>> Always       -       81
>>>>> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
>>>>> Always       -       46
>>>>> 193 Load_Cycle_Count        0x0032   142   142   000    Old_age
>>>>> Always       -       176661
>>>>> 194 Temperature_Celsius     0x0022   122   109   000    Old_age
>>>>> Always       -       28
>>>>> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
>>>>> Always       -       0
>>>>> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
>>>>> Always       -       0
>>>>> 198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
>>>>> Offline      -       0
>>>>> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
>>>>> Always       -       0
>>>>> 200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
>>>>> Offline      -       0
>>>>>
>>>>> SMART Error Log Version: 1
>>>>> No Errors Logged
>>>>>
>>>>> SMART Self-test log structure revision number 1
>>>>> Num  Test_Description    Status                  Remaining
>>>>> LifeTime(hours)  LBA_of_first_error
>>>>> # 1  Extended offline    Completed without error       00%     17479         -
>>>>> # 2  Short offline       Completed without error       00%     15531         -
>>>>>
>>>>> SMART Selective self-test log data structure revision number 1
>>>>>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>>>>>     1        0        0  Not_testing
>>>>>     2        0        0  Not_testing
>>>>>     3        0        0  Not_testing
>>>>>     4        0        0  Not_testing
>>>>>     5        0        0  Not_testing
>>>>> Selective self-test flags (0x0):
>>>>>   After scanning selected spans, do NOT read-scan remainder of disk.
>>>>> If Selective self-test is pending on power-up, resume after 0 minute delay.
>>>>>
>>>>> [dan@lamachine ~]$ sudo smartctl -a /dev/sdd
>>>>> smartctl 6.6 2017-11-05 r4594
>>>>> [x86_64-linux-4.18.0-193.14.2.el8_2.x86_64] (local build)
>>>>> Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org
>>>>>
>>>>> === START OF INFORMATION SECTION ===
>>>>> Model Family:     Western Digital Green
>>>>> Device Model:     WDC WD30EZRX-00D8PB0
>>>>> Serial Number:    WD-WCC4NPRDD6D7
>>>>> LU WWN Device Id: 5 0014ee 25fca27b1
>>>>> Firmware Version: 80.00A80
>>>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
>>>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
>>>>> Rotation Rate:    5400 rpm
>>>>> Device is:        In smartctl database [for details use: -P show]
>>>>> ATA Version is:   ACS-2 (minor revision not indicated)
>>>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
>>>>> Local Time is:    Mon Oct  5 14:58:54 2020 BST
>>>>> SMART support is: Available - device has SMART capability.
>>>>> SMART support is: Enabled
>>>>>
>>>>> === START OF READ SMART DATA SECTION ===
>>>>> SMART overall-health self-assessment test result: PASSED
>>>>>
>>>>> General SMART Values:
>>>>> Offline data collection status:  (0x82) Offline data collection activity
>>>>> was completed without error.
>>>>> Auto Offline Data Collection: Enabled.
>>>>> Self-test execution status:      (   0) The previous self-test routine completed
>>>>> without error or no self-test has ever
>>>>> been run.
>>>>> Total time to complete Offline
>>>>> data collection: (39060) seconds.
>>>>> Offline data collection
>>>>> capabilities: (0x7b) SMART execute Offline immediate.
>>>>> Auto Offline data collection on/off support.
>>>>> Suspend Offline collection upon new
>>>>> command.
>>>>> Offline surface scan supported.
>>>>> Self-test supported.
>>>>> Conveyance Self-test supported.
>>>>> Selective Self-test supported.
>>>>> SMART capabilities:            (0x0003) Saves SMART data before entering
>>>>> power-saving mode.
>>>>> Supports SMART auto save timer.
>>>>> Error logging capability:        (0x01) Error logging supported.
>>>>> General Purpose Logging supported.
>>>>> Short self-test routine
>>>>> recommended polling time: (   2) minutes.
>>>>> Extended self-test routine
>>>>> recommended polling time: ( 392) minutes.
>>>>> Conveyance self-test routine
>>>>> recommended polling time: (   5) minutes.
>>>>> SCT capabilities:        (0x7035) SCT Status supported.
>>>>> SCT Feature Control supported.
>>>>> SCT Data Table supported.
>>>>>
>>>>> SMART Attributes Data Structure revision number: 16
>>>>> Vendor Specific SMART Attributes with Thresholds:
>>>>> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
>>>>> UPDATED  WHEN_FAILED RAW_VALUE
>>>>>   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
>>>>> Always       -       0
>>>>>   3 Spin_Up_Time            0x0027   178   164   021    Pre-fail
>>>>> Always       -       6100
>>>>>   4 Start_Stop_Count        0x0032   100   100   000    Old_age
>>>>> Always       -       81
>>>>>   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
>>>>> Always       -       0
>>>>>   7 Seek_Error_Rate         0x002e   100   253   000    Old_age
>>>>> Always       -       0
>>>>>   9 Power_On_Hours          0x0032   075   075   000    Old_age
>>>>> Always       -       18580
>>>>>  10 Spin_Retry_Count        0x0032   100   253   000    Old_age
>>>>> Always       -       0
>>>>>  11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
>>>>> Always       -       0
>>>>>  12 Power_Cycle_Count       0x0032   100   100   000    Old_age
>>>>> Always       -       81
>>>>> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
>>>>> Always       -       53
>>>>> 193 Load_Cycle_Count        0x0032   136   136   000    Old_age
>>>>> Always       -       192427
>>>>> 194 Temperature_Celsius     0x0022   121   108   000    Old_age
>>>>> Always       -       29
>>>>> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
>>>>> Always       -       0
>>>>> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
>>>>> Always       -       0
>>>>> 198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
>>>>> Offline      -       0
>>>>> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
>>>>> Always       -       0
>>>>> 200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
>>>>> Offline      -       0
>>>>>
>>>>> SMART Error Log Version: 1
>>>>> No Errors Logged
>>>>>
>>>>> SMART Self-test log structure revision number 1
>>>>> Num  Test_Description    Status                  Remaining
>>>>> LifeTime(hours)  LBA_of_first_error
>>>>> # 1  Extended offline    Completed without error       00%     17481         -
>>>>> # 2  Short offline       Completed without error       00%     15534         -
>>>>>
>>>>> SMART Selective self-test log data structure revision number 1
>>>>>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>>>>>     1        0        0  Not_testing
>>>>>     2        0        0  Not_testing
>>>>>     3        0        0  Not_testing
>>>>>     4        0        0  Not_testing
>>>>>     5        0        0  Not_testing
>>>>> Selective self-test flags (0x0):
>>>>>   After scanning selected spans, do NOT read-scan remainder of disk.
>>>>> If Selective self-test is pending on power-up, resume after 0 minute delay.
>>>>>
>>>>> [dan@lamachine ~]$ sudo smartctl -a /dev/sde
>>>>> smartctl 6.6 2017-11-05 r4594
>>>>> [x86_64-linux-4.18.0-193.14.2.el8_2.x86_64] (local build)
>>>>> Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org
>>>>>
>>>>> === START OF INFORMATION SECTION ===
>>>>> Model Family:     Western Digital Green
>>>>> Device Model:     WDC WD30EZRX-00D8PB0
>>>>> Serial Number:    WD-WCC4N1294906
>>>>> LU WWN Device Id: 5 0014ee 25f968120
>>>>> Firmware Version: 80.00A80
>>>>> User Capacity:    3,000,591,900,160 bytes [3.00 TB]
>>>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
>>>>> Rotation Rate:    5400 rpm
>>>>> Device is:        In smartctl database [for details use: -P show]
>>>>> ATA Version is:   ACS-2 (minor revision not indicated)
>>>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
>>>>> Local Time is:    Mon Oct  5 14:58:57 2020 BST
>>>>> SMART support is: Available - device has SMART capability.
>>>>> SMART support is: Enabled
>>>>>
>>>>> === START OF READ SMART DATA SECTION ===
>>>>> SMART overall-health self-assessment test result: PASSED
>>>>>
>>>>> General SMART Values:
>>>>> Offline data collection status:  (0x82) Offline data collection activity
>>>>> was completed without error.
>>>>> Auto Offline Data Collection: Enabled.
>>>>> Self-test execution status:      (   0) The previous self-test routine completed
>>>>> without error or no self-test has ever
>>>>> been run.
>>>>> Total time to complete Offline
>>>>> data collection: (43200) seconds.
>>>>> Offline data collection
>>>>> capabilities: (0x7b) SMART execute Offline immediate.
>>>>> Auto Offline data collection on/off support.
>>>>> Suspend Offline collection upon new
>>>>> command.
>>>>> Offline surface scan supported.
>>>>> Self-test supported.
>>>>> Conveyance Self-test supported.
>>>>> Selective Self-test supported.
>>>>> SMART capabilities:            (0x0003) Saves SMART data before entering
>>>>> power-saving mode.
>>>>> Supports SMART auto save timer.
>>>>> Error logging capability:        (0x01) Error logging supported.
>>>>> General Purpose Logging supported.
>>>>> Short self-test routine
>>>>> recommended polling time: (   2) minutes.
>>>>> Extended self-test routine
>>>>> recommended polling time: ( 433) minutes.
>>>>> Conveyance self-test routine
>>>>> recommended polling time: (   5) minutes.
>>>>> SCT capabilities:        (0x7035) SCT Status supported.
>>>>> SCT Feature Control supported.
>>>>> SCT Data Table supported.
>>>>>
>>>>> SMART Attributes Data Structure revision number: 16
>>>>> Vendor Specific SMART Attributes with Thresholds:
>>>>> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
>>>>> UPDATED  WHEN_FAILED RAW_VALUE
>>>>>   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
>>>>> Always       -       0
>>>>>   3 Spin_Up_Time            0x0027   176   166   021    Pre-fail
>>>>> Always       -       6158
>>>>>   4 Start_Stop_Count        0x0032   100   100   000    Old_age
>>>>> Always       -       80
>>>>>   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
>>>>> Always       -       0
>>>>>   7 Seek_Error_Rate         0x002e   200   200   000    Old_age
>>>>> Always       -       0
>>>>>   9 Power_On_Hours          0x0032   075   075   000    Old_age
>>>>> Always       -       18465
>>>>>  10 Spin_Retry_Count        0x0032   100   253   000    Old_age
>>>>> Always       -       0
>>>>>  11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
>>>>> Always       -       0
>>>>>  12 Power_Cycle_Count       0x0032   100   100   000    Old_age
>>>>> Always       -       80
>>>>> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
>>>>> Always       -       53
>>>>> 193 Load_Cycle_Count        0x0032   142   142   000    Old_age
>>>>> Always       -       174015
>>>>> 194 Temperature_Celsius     0x0022   121   107   000    Old_age
>>>>> Always       -       29
>>>>> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
>>>>> Always       -       0
>>>>> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
>>>>> Always       -       0
>>>>> 198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
>>>>> Offline      -       0
>>>>> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
>>>>> Always       -       0
>>>>> 200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
>>>>> Offline      -       0
>>>>>
>>>>> SMART Error Log Version: 1
>>>>> No Errors Logged
>>>>>
>>>>> SMART Self-test log structure revision number 1
>>>>> Num  Test_Description    Status                  Remaining
>>>>> LifeTime(hours)  LBA_of_first_error
>>>>> # 1  Extended offline    Completed without error       00%     17347         -
>>>>> # 2  Short offline       Completed without error       00%     15414         -
>>>>>
>>>>> SMART Selective self-test log data structure revision number 1
>>>>>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>>>>>     1        0        0  Not_testing
>>>>>     2        0        0  Not_testing
>>>>>     3        0        0  Not_testing
>>>>>     4        0        0  Not_testing
>>>>>     5        0        0  Not_testing
>>>>> Selective self-test flags (0x0):
>>>>>   After scanning selected spans, do NOT read-scan remainder of disk.
>>>>> If Selective self-test is pending on power-up, resume after 0 minute delay.
>>>>>
>>>>> [dan@lamachine ~]$
>>>>>
>>>>>
>>>>> On Mon, 5 Oct 2020 at 14:44, Roman Mamedov <rm@romanrm.net> wrote:
>>>>>>
>>>>>> On Mon, 5 Oct 2020 14:10:25 +0100
>>>>>> Daniel Sanabria <sanabria.d@gmail.com> wrote:
>>>>>>
>>>>>>> Hi all,
>>>>>>>
>>>>>>> Scrubbing ( # echo check >
>>>>>>> /sys/devices/virtual/block/md1/md/sync_action) is killing my array :(
>>>>>>>
>>>>>>> I'm attaching details of the array and disks (bloody wd greens) as
>>>>>>> well as journalctl errors providing some details about the issue.
>>>>>>>
>>>>>>> If you have any pointers on what might be the cause of this as well as
>>>>>>> any recommendations on how to improve things please let me thank you
>>>>>>> in advance ...
>>>>>>>
>>>>>>> I have backups of the data so happy to move this to a different setup
>>>>>>> you might recommend (apps will be mostly reading from the array via
>>>>>>> NFS since most of the content will be media).
>>>>>>>
>>>>>>> My suspicion is that a timer service is kicking in and disrupting the
>>>>>>> scrubbing somehow but can't pinpoint what causes this.
>>>>>>
>>>>>> It looks like a drive is dropping off the bus and then failing to reidentify,
>>>>>> could be bad cabling/controller/PSU, or just a bad drive. You should post
>>>>>> "smartctl -a" of all drives as well.

