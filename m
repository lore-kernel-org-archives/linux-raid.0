Return-Path: <SRS0=oy2H=DM=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8273AC4363A
	for <linux-raid@archiver.kernel.org>; Mon,  5 Oct 2020 14:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 367BB207F7
	for <linux-raid@archiver.kernel.org>; Mon,  5 Oct 2020 14:28:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LJY8ndm3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgJEO2f (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Oct 2020 10:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgJEO2f (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 5 Oct 2020 10:28:35 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13EBC0613CE
        for <linux-raid@vger.kernel.org>; Mon,  5 Oct 2020 07:28:33 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id y13so9331894iow.4
        for <linux-raid@vger.kernel.org>; Mon, 05 Oct 2020 07:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C+cd9L7DInoFhqoTSPjvkrNtcmeBhFwDnWu59RswJpY=;
        b=LJY8ndm3VLmTRylhGWnv1/JAfaKlyE+O7NuiP9PKZ+MiXW1K8i8pjtGlFdG7FQ9plP
         5b03/YD+3NGFDvqrE4mfnF7bq4CzBTpZGDOdfGzJYY+56t0iFOZQdm8pK5zePuCGd1qd
         /Jmpo4Co5OErvkFpKWo9aru3DCdJcxYSduLGirVveVYlQM0PU4hgmF6AukMkHkTaUJRw
         i/VZulyiltnJgskNZFxcnPebuQFuqrD7ZcJHWdF4NsF/yBt1vzLonluWX75RtFNInzFA
         eupZS3hZQNM4cp2GShWOAiMCmLObHmGpAoN6YKvRCtR+370V0nTeywwxI8e+o035AJ8i
         oiSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C+cd9L7DInoFhqoTSPjvkrNtcmeBhFwDnWu59RswJpY=;
        b=ukrFF+XFN0jldk5s+d5wSLZb1P/rKDox8DXVfulOQ5JZVDf17HkPkJjYIE4UanLpTN
         Bqh2NJ3uGw0k1QZbB+jMugxNu3Qb8V+6QcV6efD/wudC9ivI1TFq3MFf1LwIGMelmV5Q
         TnKUoPn06t5/d3spkTJz10/b85tonne/27ac73h6bcXzaRyQWdXwyvAf938OB9hZ5j7u
         NU8ag6LZQXgzuvy7e5L1SW24Y+BjFkKhCbOJ0cgM5JNKf9F9uhwZES0MmUBICtPia1Mx
         jwYdJE82CDjj66NddrPjxzFBoLdkI3l6Aivisw9axSiuUOH20h7FtHLFEMUiZ22c1RbG
         qfIg==
X-Gm-Message-State: AOAM531MYePkFu0diom+cQX7NhSqy277mLz5j0v44AZlxkkKA2SnpySI
        qqgXMhB1Q4m3lgQ4da+NIuw1svObx+Bc0TwsJr4DvlgNAnOz1w==
X-Google-Smtp-Source: ABdhPJyBK6Xw6uiQnEFAOn2Gis3fSpO5z+hExHATigZDWozcf6m8MTI3zRPxHbH1lvVO+9f0KYDnRw66ofuTvHeaimc=
X-Received: by 2002:a6b:d214:: with SMTP id q20mr60620iob.23.1601908112430;
 Mon, 05 Oct 2020 07:28:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAHscji30ACa2d0qz-nr5vqPYOP642dwjS5BY07g2DQS7GBG-2A@mail.gmail.com>
 <20201005184449.54225175@natsu> <CAHscji0pNezf6xCpjWto5-21ayoCeLWm34GTYh5TSgxkOw90mw@mail.gmail.com>
 <20201005190421.4ecd8f1b@natsu>
In-Reply-To: <20201005190421.4ecd8f1b@natsu>
From:   Daniel Sanabria <sanabria.d@gmail.com>
Date:   Mon, 5 Oct 2020 15:28:20 +0100
Message-ID: <CAHscji1VrccTOaQc4GdWof4E+Bzs5KL0-tJJj0ZUM9Db=QBriw@mail.gmail.com>
Subject: Re: do i need to give up on this setup
To:     Roman Mamedov <rm@romanrm.net>
Cc:     Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> I meant not to me personally, but to the mailing list. The drives seem OK
> though, even sde.

Sorry missed the reply-all button

On Mon, 5 Oct 2020 at 15:04, Roman Mamedov <rm@romanrm.net> wrote:
>
> On Mon, 5 Oct 2020 14:59:35 +0100
> Daniel Sanabria <sanabria.d@gmail.com> wrote:
>
> > > It looks like a drive is dropping off the bus and then failing to reidentify,
> > > could be bad cabling/controller/PSU, or just a bad drive. You should post
> > > "smartctl -a" of all drives as well.
>
> I meant not to me personally, but to the mailing list. The drives seem OK
> though, even sde.
>
> > [dan@lamachine ~]$ sudo smartctl -a /dev/sdc
> > [sudo] password for dan:
> > smartctl 6.6 2017-11-05 r4594
> > [x86_64-linux-4.18.0-193.14.2.el8_2.x86_64] (local build)
> > Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org
> >
> > === START OF INFORMATION SECTION ===
> > Model Family:     Western Digital Green
> > Device Model:     WDC WD30EZRX-00D8PB0
> > Serial Number:    WD-WCC4NCWT13RF
> > LU WWN Device Id: 5 0014ee 25fc9e460
> > Firmware Version: 80.00A80
> > User Capacity:    3,000,591,900,160 bytes [3.00 TB]
> > Sector Sizes:     512 bytes logical, 4096 bytes physical
> > Rotation Rate:    5400 rpm
> > Device is:        In smartctl database [for details use: -P show]
> > ATA Version is:   ACS-2 (minor revision not indicated)
> > SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
> > Local Time is:    Mon Oct  5 14:58:34 2020 BST
> > SMART support is: Available - device has SMART capability.
> > SMART support is: Enabled
> >
> > === START OF READ SMART DATA SECTION ===
> > SMART overall-health self-assessment test result: PASSED
> >
> > General SMART Values:
> > Offline data collection status:  (0x82) Offline data collection activity
> > was completed without error.
> > Auto Offline Data Collection: Enabled.
> > Self-test execution status:      (   0) The previous self-test routine completed
> > without error or no self-test has ever
> > been run.
> > Total time to complete Offline
> > data collection: (38940) seconds.
> > Offline data collection
> > capabilities: (0x7b) SMART execute Offline immediate.
> > Auto Offline data collection on/off support.
> > Suspend Offline collection upon new
> > command.
> > Offline surface scan supported.
> > Self-test supported.
> > Conveyance Self-test supported.
> > Selective Self-test supported.
> > SMART capabilities:            (0x0003) Saves SMART data before entering
> > power-saving mode.
> > Supports SMART auto save timer.
> > Error logging capability:        (0x01) Error logging supported.
> > General Purpose Logging supported.
> > Short self-test routine
> > recommended polling time: (   2) minutes.
> > Extended self-test routine
> > recommended polling time: ( 391) minutes.
> > Conveyance self-test routine
> > recommended polling time: (   5) minutes.
> > SCT capabilities:        (0x7035) SCT Status supported.
> > SCT Feature Control supported.
> > SCT Data Table supported.
> >
> > SMART Attributes Data Structure revision number: 16
> > Vendor Specific SMART Attributes with Thresholds:
> > ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> > UPDATED  WHEN_FAILED RAW_VALUE
> >   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
> > Always       -       0
> >   3 Spin_Up_Time            0x0027   178   165   021    Pre-fail
> > Always       -       6075
> >   4 Start_Stop_Count        0x0032   100   100   000    Old_age
> > Always       -       81
> >   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> > Always       -       0
> >   7 Seek_Error_Rate         0x002e   100   253   000    Old_age
> > Always       -       0
> >   9 Power_On_Hours          0x0032   075   075   000    Old_age
> > Always       -       18577
> >  10 Spin_Retry_Count        0x0032   100   253   000    Old_age
> > Always       -       0
> >  11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
> > Always       -       0
> >  12 Power_Cycle_Count       0x0032   100   100   000    Old_age
> > Always       -       81
> > 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
> > Always       -       46
> > 193 Load_Cycle_Count        0x0032   142   142   000    Old_age
> > Always       -       176661
> > 194 Temperature_Celsius     0x0022   122   109   000    Old_age
> > Always       -       28
> > 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
> > Always       -       0
> > 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> > Always       -       0
> > 198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
> > Offline      -       0
> > 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
> > Always       -       0
> > 200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
> > Offline      -       0
> >
> > SMART Error Log Version: 1
> > No Errors Logged
> >
> > SMART Self-test log structure revision number 1
> > Num  Test_Description    Status                  Remaining
> > LifeTime(hours)  LBA_of_first_error
> > # 1  Extended offline    Completed without error       00%     17479         -
> > # 2  Short offline       Completed without error       00%     15531         -
> >
> > SMART Selective self-test log data structure revision number 1
> >  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
> >     1        0        0  Not_testing
> >     2        0        0  Not_testing
> >     3        0        0  Not_testing
> >     4        0        0  Not_testing
> >     5        0        0  Not_testing
> > Selective self-test flags (0x0):
> >   After scanning selected spans, do NOT read-scan remainder of disk.
> > If Selective self-test is pending on power-up, resume after 0 minute delay.
> >
> > [dan@lamachine ~]$ sudo smartctl -a /dev/sdd
> > smartctl 6.6 2017-11-05 r4594
> > [x86_64-linux-4.18.0-193.14.2.el8_2.x86_64] (local build)
> > Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org
> >
> > === START OF INFORMATION SECTION ===
> > Model Family:     Western Digital Green
> > Device Model:     WDC WD30EZRX-00D8PB0
> > Serial Number:    WD-WCC4NPRDD6D7
> > LU WWN Device Id: 5 0014ee 25fca27b1
> > Firmware Version: 80.00A80
> > User Capacity:    3,000,592,982,016 bytes [3.00 TB]
> > Sector Sizes:     512 bytes logical, 4096 bytes physical
> > Rotation Rate:    5400 rpm
> > Device is:        In smartctl database [for details use: -P show]
> > ATA Version is:   ACS-2 (minor revision not indicated)
> > SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
> > Local Time is:    Mon Oct  5 14:58:54 2020 BST
> > SMART support is: Available - device has SMART capability.
> > SMART support is: Enabled
> >
> > === START OF READ SMART DATA SECTION ===
> > SMART overall-health self-assessment test result: PASSED
> >
> > General SMART Values:
> > Offline data collection status:  (0x82) Offline data collection activity
> > was completed without error.
> > Auto Offline Data Collection: Enabled.
> > Self-test execution status:      (   0) The previous self-test routine completed
> > without error or no self-test has ever
> > been run.
> > Total time to complete Offline
> > data collection: (39060) seconds.
> > Offline data collection
> > capabilities: (0x7b) SMART execute Offline immediate.
> > Auto Offline data collection on/off support.
> > Suspend Offline collection upon new
> > command.
> > Offline surface scan supported.
> > Self-test supported.
> > Conveyance Self-test supported.
> > Selective Self-test supported.
> > SMART capabilities:            (0x0003) Saves SMART data before entering
> > power-saving mode.
> > Supports SMART auto save timer.
> > Error logging capability:        (0x01) Error logging supported.
> > General Purpose Logging supported.
> > Short self-test routine
> > recommended polling time: (   2) minutes.
> > Extended self-test routine
> > recommended polling time: ( 392) minutes.
> > Conveyance self-test routine
> > recommended polling time: (   5) minutes.
> > SCT capabilities:        (0x7035) SCT Status supported.
> > SCT Feature Control supported.
> > SCT Data Table supported.
> >
> > SMART Attributes Data Structure revision number: 16
> > Vendor Specific SMART Attributes with Thresholds:
> > ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> > UPDATED  WHEN_FAILED RAW_VALUE
> >   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
> > Always       -       0
> >   3 Spin_Up_Time            0x0027   178   164   021    Pre-fail
> > Always       -       6100
> >   4 Start_Stop_Count        0x0032   100   100   000    Old_age
> > Always       -       81
> >   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> > Always       -       0
> >   7 Seek_Error_Rate         0x002e   100   253   000    Old_age
> > Always       -       0
> >   9 Power_On_Hours          0x0032   075   075   000    Old_age
> > Always       -       18580
> >  10 Spin_Retry_Count        0x0032   100   253   000    Old_age
> > Always       -       0
> >  11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
> > Always       -       0
> >  12 Power_Cycle_Count       0x0032   100   100   000    Old_age
> > Always       -       81
> > 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
> > Always       -       53
> > 193 Load_Cycle_Count        0x0032   136   136   000    Old_age
> > Always       -       192427
> > 194 Temperature_Celsius     0x0022   121   108   000    Old_age
> > Always       -       29
> > 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
> > Always       -       0
> > 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> > Always       -       0
> > 198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
> > Offline      -       0
> > 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
> > Always       -       0
> > 200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
> > Offline      -       0
> >
> > SMART Error Log Version: 1
> > No Errors Logged
> >
> > SMART Self-test log structure revision number 1
> > Num  Test_Description    Status                  Remaining
> > LifeTime(hours)  LBA_of_first_error
> > # 1  Extended offline    Completed without error       00%     17481         -
> > # 2  Short offline       Completed without error       00%     15534         -
> >
> > SMART Selective self-test log data structure revision number 1
> >  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
> >     1        0        0  Not_testing
> >     2        0        0  Not_testing
> >     3        0        0  Not_testing
> >     4        0        0  Not_testing
> >     5        0        0  Not_testing
> > Selective self-test flags (0x0):
> >   After scanning selected spans, do NOT read-scan remainder of disk.
> > If Selective self-test is pending on power-up, resume after 0 minute delay.
> >
> > [dan@lamachine ~]$ sudo smartctl -a /dev/sde
> > smartctl 6.6 2017-11-05 r4594
> > [x86_64-linux-4.18.0-193.14.2.el8_2.x86_64] (local build)
> > Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org
> >
> > === START OF INFORMATION SECTION ===
> > Model Family:     Western Digital Green
> > Device Model:     WDC WD30EZRX-00D8PB0
> > Serial Number:    WD-WCC4N1294906
> > LU WWN Device Id: 5 0014ee 25f968120
> > Firmware Version: 80.00A80
> > User Capacity:    3,000,591,900,160 bytes [3.00 TB]
> > Sector Sizes:     512 bytes logical, 4096 bytes physical
> > Rotation Rate:    5400 rpm
> > Device is:        In smartctl database [for details use: -P show]
> > ATA Version is:   ACS-2 (minor revision not indicated)
> > SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
> > Local Time is:    Mon Oct  5 14:58:57 2020 BST
> > SMART support is: Available - device has SMART capability.
> > SMART support is: Enabled
> >
> > === START OF READ SMART DATA SECTION ===
> > SMART overall-health self-assessment test result: PASSED
> >
> > General SMART Values:
> > Offline data collection status:  (0x82) Offline data collection activity
> > was completed without error.
> > Auto Offline Data Collection: Enabled.
> > Self-test execution status:      (   0) The previous self-test routine completed
> > without error or no self-test has ever
> > been run.
> > Total time to complete Offline
> > data collection: (43200) seconds.
> > Offline data collection
> > capabilities: (0x7b) SMART execute Offline immediate.
> > Auto Offline data collection on/off support.
> > Suspend Offline collection upon new
> > command.
> > Offline surface scan supported.
> > Self-test supported.
> > Conveyance Self-test supported.
> > Selective Self-test supported.
> > SMART capabilities:            (0x0003) Saves SMART data before entering
> > power-saving mode.
> > Supports SMART auto save timer.
> > Error logging capability:        (0x01) Error logging supported.
> > General Purpose Logging supported.
> > Short self-test routine
> > recommended polling time: (   2) minutes.
> > Extended self-test routine
> > recommended polling time: ( 433) minutes.
> > Conveyance self-test routine
> > recommended polling time: (   5) minutes.
> > SCT capabilities:        (0x7035) SCT Status supported.
> > SCT Feature Control supported.
> > SCT Data Table supported.
> >
> > SMART Attributes Data Structure revision number: 16
> > Vendor Specific SMART Attributes with Thresholds:
> > ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> > UPDATED  WHEN_FAILED RAW_VALUE
> >   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
> > Always       -       0
> >   3 Spin_Up_Time            0x0027   176   166   021    Pre-fail
> > Always       -       6158
> >   4 Start_Stop_Count        0x0032   100   100   000    Old_age
> > Always       -       80
> >   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> > Always       -       0
> >   7 Seek_Error_Rate         0x002e   200   200   000    Old_age
> > Always       -       0
> >   9 Power_On_Hours          0x0032   075   075   000    Old_age
> > Always       -       18465
> >  10 Spin_Retry_Count        0x0032   100   253   000    Old_age
> > Always       -       0
> >  11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
> > Always       -       0
> >  12 Power_Cycle_Count       0x0032   100   100   000    Old_age
> > Always       -       80
> > 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
> > Always       -       53
> > 193 Load_Cycle_Count        0x0032   142   142   000    Old_age
> > Always       -       174015
> > 194 Temperature_Celsius     0x0022   121   107   000    Old_age
> > Always       -       29
> > 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
> > Always       -       0
> > 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> > Always       -       0
> > 198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
> > Offline      -       0
> > 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
> > Always       -       0
> > 200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
> > Offline      -       0
> >
> > SMART Error Log Version: 1
> > No Errors Logged
> >
> > SMART Self-test log structure revision number 1
> > Num  Test_Description    Status                  Remaining
> > LifeTime(hours)  LBA_of_first_error
> > # 1  Extended offline    Completed without error       00%     17347         -
> > # 2  Short offline       Completed without error       00%     15414         -
> >
> > SMART Selective self-test log data structure revision number 1
> >  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
> >     1        0        0  Not_testing
> >     2        0        0  Not_testing
> >     3        0        0  Not_testing
> >     4        0        0  Not_testing
> >     5        0        0  Not_testing
> > Selective self-test flags (0x0):
> >   After scanning selected spans, do NOT read-scan remainder of disk.
> > If Selective self-test is pending on power-up, resume after 0 minute delay.
> >
> > [dan@lamachine ~]$
> >
> >
> > On Mon, 5 Oct 2020 at 14:44, Roman Mamedov <rm@romanrm.net> wrote:
> > >
> > > On Mon, 5 Oct 2020 14:10:25 +0100
> > > Daniel Sanabria <sanabria.d@gmail.com> wrote:
> > >
> > > > Hi all,
> > > >
> > > > Scrubbing ( # echo check >
> > > > /sys/devices/virtual/block/md1/md/sync_action) is killing my array :(
> > > >
> > > > I'm attaching details of the array and disks (bloody wd greens) as
> > > > well as journalctl errors providing some details about the issue.
> > > >
> > > > If you have any pointers on what might be the cause of this as well as
> > > > any recommendations on how to improve things please let me thank you
> > > > in advance ...
> > > >
> > > > I have backups of the data so happy to move this to a different setup
> > > > you might recommend (apps will be mostly reading from the array via
> > > > NFS since most of the content will be media).
> > > >
> > > > My suspicion is that a timer service is kicking in and disrupting the
> > > > scrubbing somehow but can't pinpoint what causes this.
> > >
> > > It looks like a drive is dropping off the bus and then failing to reidentify,
> > > could be bad cabling/controller/PSU, or just a bad drive. You should post
> > > "smartctl -a" of all drives as well.
> > >
> > > --
> > > With respect,
> > > Roman
>
>
> --
> With respect,
> Roman
