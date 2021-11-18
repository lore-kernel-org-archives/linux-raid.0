Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6673CC433EF
	for <linux-raid@archiver.kernel.org>; Thu, 18 Nov 2021 17:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CD2261A07
	for <linux-raid@archiver.kernel.org>; Thu, 18 Nov 2021 17:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhKRRbE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Nov 2021 12:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbhKRRbD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 18 Nov 2021 12:31:03 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D48C061574
        for <linux-raid@vger.kernel.org>; Thu, 18 Nov 2021 09:28:03 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id r11so30274005edd.9
        for <linux-raid@vger.kernel.org>; Thu, 18 Nov 2021 09:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UKe2SnCuvfntoMNIVFQtjV2ja2EnhfVHnlDUVx9+qBs=;
        b=N97T+5bzS7M9ckxThAFt2kwjWHmKIS6JbYYYkNjvYx6WUVVq5FF7JcNRCLPAUmxdie
         50SSQbnFC61jIjuXn4L3skBRa2yHM9MKsEA17leTqbkMlAXPimQCrRuv/Ysqxh7q5A2e
         jDMUQMLWQPpYSE4kiCHUIha7Ygd8t5HQlDqqjjfhjf+7Ye4n5JjQfHbvd4wco4irtP+Z
         DZNSi/qN7gFbyOmhZvNNarsHuy5YTVaL1PxmTVrxP8+HtgsU4KN9MbsuKSIDsbrw2AAL
         VSPmUdLfzvlZDmmW9H9vv1V8QQHZRAK7VBMIGnMJiuU/4QgPW847JU+Og8byE8X1HoI5
         asRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UKe2SnCuvfntoMNIVFQtjV2ja2EnhfVHnlDUVx9+qBs=;
        b=z3usCzVR+/jefexS293uaAK8PeTU+UwOxYjK7ZqnqMKKQeG3+0DIkB7boiwVGBFrR6
         jJIUbjuu0xbRLR87XjxRMkGhG37xQEIUS12jyXLuPmGp07PSCQBBc/VCxETXQlrDgQMg
         vPRqnbVQ0GR7YaYku0pNfbGELh5ESgGQnHm5OAKRjnXZgktwM6L0ewTTS9L7QWbijFbZ
         sjCYrg+eq8/mNzNkaF8sHh+a2OY4KAh+YzTjsdgRW7YVMK+W6lAtVfJUQPaHUPCtSpsA
         w0Z7JLQ7kDtAfP8+iBEiGpoE3bGWMgQdEk5twtuKJVA+pTzdBSVlpeS5PHCfjUS3D7Pz
         IGHA==
X-Gm-Message-State: AOAM532EAEksGwSJStzIK11WAg82QSgvYJxQxFFwAVaajM6M7qBDhKDs
        6rrsFs83zae/gxvIENhQ1cRuNasN5A3JP5baUA==
X-Google-Smtp-Source: ABdhPJyUNkb8LBCykB6FBwYTIIO5FTqmlcAiNvJoJ9z4K4n9jJOIBBK3b/8mF82yN4lrNbuAZBAxdqiwhaisB5m+ZYk=
X-Received: by 2002:a50:bf01:: with SMTP id f1mr13536075edk.102.1637256481614;
 Thu, 18 Nov 2021 09:28:01 -0800 (PST)
MIME-Version: 1.0
References: <CAFPgooeJrvrNQcOQXUD82oc52rgB3DvH=JFzDVDMnfc+gs7nDg@mail.gmail.com>
 <06b0f87c-2d06-3f94-f0b3-19d631968fa0@youngman.org.uk> <CAFPgoofZWN8d9O6LQ0LtKaOnU9yofvNAYO6AKxjrztqzod+doQ@mail.gmail.com>
 <09043959-a649-05ba-0e92-b393f6f04420@youngman.org.uk>
In-Reply-To: <09043959-a649-05ba-0e92-b393f6f04420@youngman.org.uk>
From:   Martin Thoma <thomamartin1985@googlemail.com>
Date:   Thu, 18 Nov 2021 18:27:50 +0100
Message-ID: <CAFPgoocQfF0wCbZ=LzqnpLMk=bUxZyj9GTcUjXhmiEovWdQBpQ@mail.gmail.com>
Subject: Re: Failed Raid 5 - one Disk possibly Out of date - 2nd disk damaged
To:     Wol <antlists@youngman.org.uk>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Am Mi., 17. Nov. 2021 um 22:06 Uhr schrieb Wol <antlists@youngman.org.uk>:
>
> On 17/11/2021 18:10, Martin Thoma wrote:
> > Thanks a lot.
> > Will try to get some new drives and do a dd and then will try to
> > assemble the Raid again.
> >
> > The Drives are CMR Drives, a few Western Digital and Seagate drives.
>
> Are they "raid friendly" though? What does "smartctl" tell you? Are the
> Seagates Barracudas (I hope not)?
>
> Whether before or after the copy, I'd look at the smartctl for the dodgy
> drives - they may have just been addled by the power fail but will be
> fine for backups, or they may have been on the way out and the power
> fail tipped them over the edge.
>
> Cheers,
> Wol


Hey,

some of the drives are indeed Seagate Baracudas. The two faulty drives
ist one Western Digital and the other a Toshiba
Here are the smartctl Data for those drives
/dev/sbc

smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.10.0-21-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Green
Device Model:     WDC WD30EZRX-00D8PB0
Serial Number:    WD-WMC4N0E0NN71
LU WWN Device Id: 5 0014ee 6050ae2f5
Firmware Version: 80.00A80
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Thu Nov 18 17:31:01 2021 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART Status not supported: Incomplete response, ATA output registers missing
SMART overall-health self-assessment test result: PASSED
Warning: This result is based on an Attribute check.

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
was completed without error.
Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
without error or no self-test has ever
been run.
Total time to complete Offline
data collection: (39120) seconds.
Offline data collection
capabilities: (0x7b) SMART execute Offline immediate.
Auto Offline data collection on/off support.
Suspend Offline collection upon new
command.
Offline surface scan supported.
Self-test supported.
Conveyance Self-test supported.
Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
power-saving mode.
Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
General Purpose Logging supported.
Short self-test routine
recommended polling time: (   2) minutes.
Extended self-test routine
recommended polling time: ( 393) minutes.
Conveyance self-test routine
recommended polling time: (   5) minutes.
SCT capabilities:        (0x7035) SCT Status supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   185   166   021    Pre-fail
Always       -       5708
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       668
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   023   021   000    Old_age
Always       -       56908
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       39
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       23
193 Load_Cycle_Count        0x0032   117   117   000    Old_age
Always       -       250280
194 Temperature_Celsius     0x0022   129   090   000    Old_age
Always       -       21
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

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


/dev/sdd
smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.10.0-21-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     TOSHIBA HDWD130
Serial Number:    27R3EJDAS
LU WWN Device Id: 5 000039 fe6cfa767
Firmware Version: MX6OACF0
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Thu Nov 18 17:31:33 2021 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART Status not supported: Incomplete response, ATA output registers missing
SMART overall-health self-assessment test result: PASSED
Warning: This result is based on an Attribute check.

General SMART Values:
Offline data collection status:  (0x80) Offline data collection activity
was never started.
Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
without error or no self-test has ever
been run.
Total time to complete Offline
data collection: (21935) seconds.
Offline data collection
capabilities: (0x5b) SMART execute Offline immediate.
Auto Offline data collection on/off support.
Suspend Offline collection upon new
command.
Offline surface scan supported.
Self-test supported.
No Conveyance Self-test supported.
Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
power-saving mode.
Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
General Purpose Logging supported.
Short self-test routine
recommended polling time: (   1) minutes.
Extended self-test routine
recommended polling time: ( 366) minutes.
SCT capabilities:        (0x003d) SCT Status supported.
SCT Error Recovery Control supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000b   100   100   016    Pre-fail
Always       -       0
  2 Throughput_Performance  0x0005   139   139   054    Pre-fail
Offline      -       71
  3 Spin_Up_Time            0x0007   130   130   024    Pre-fail
Always       -       439 (Average 440)
  4 Start_Stop_Count        0x0012   100   100   000    Old_age
Always       -       23
  5 Reallocated_Sector_Ct   0x0033   100   100   005    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000b   100   100   067    Pre-fail
Always       -       0
  8 Seek_Time_Performance   0x0005   124   124   020    Pre-fail
Offline      -       33
  9 Power_On_Hours          0x0012   095   095   000    Old_age
Always       -       39181
 10 Spin_Retry_Count        0x0013   100   100   060    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       16
192 Power-Off_Retract_Count 0x0032   099   099   000    Old_age
Always       -       1239
193 Load_Cycle_Count        0x0012   099   099   000    Old_age
Always       -       1239
194 Temperature_Celsius     0x0002   222   222   000    Old_age
Always       -       27 (Min/Max 23/67)
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0022   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0008   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x000a   200   200   000    Old_age
Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

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

Again thanks a lot.

Regards

Martin
