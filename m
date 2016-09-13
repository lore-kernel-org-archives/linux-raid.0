From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Inactive arrays
Date: Tue, 13 Sep 2016 17:02:46 +1000
Message-ID: <19ff05bd-4908-3494-7eff-d30d86e3a786@websitemanagers.com.au>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
 <57A07345.4040708@youngman.org.uk>
 <CAHscji0BQuyKQbLYZ9Ah16hHday_seTaajm8LOn6+HRFqinTyQ@mail.gmail.com>
 <CAHscji3C4Cygs=xh4d4PtREp9mGSBjNS0o7SatW_QotzYShA_Q@mail.gmail.com>
 <CAHscji3HdHaJAvwtYNU=Ykc_qohBkfFfrbP0M=FNhuFMK+d-Jg@mail.gmail.com>
 <CAHscji35kySP4Q8cUpYCXR2P9DBwPcYeWjr_HX==TNX9CPW9NA@mail.gmail.com>
 <CAHscji2k9FyrOs+96XQWEUWU3W0EWxkanaHakjsGhij0hXiVGw@mail.gmail.com>
 <57D72092.20704@youngman.org.uk>
 <CAHscji3KfFfO8CxZTbLX6u-bfA57pOR5i6qvc0NhNODH5tGeEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji3KfFfO8CxZTbLX6u-bfA57pOR5i6qvc0NhNODH5tGeEg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>, Wols Lists <antlists@youngman.org.uk>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 13/09/16 16:56, Daniel Sanabria wrote:
>> What does smartctl report on sdc and sde (I think you want smartctl -x,
>> the extended "display everything" command)?
> [root@lamachine ~]# smartctl -x /dev/{sdc,sdd,sde}
> smartctl 6.4 2015-06-04 r4109 [x86_64-linux-4.3.3-303.fc23.x86_64] (local build)
> Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools.org
>
> ERROR: smartctl takes ONE device name as the final command-line argument.
> You have provided 3 device names:
> /dev/sdc
> /dev/sdd
> /dev/sde
>
> Use smartctl -h to get a usage summary
>
> [root@lamachine ~]# smartctl -x /dev/sdc
> smartctl 6.4 2015-06-04 r4109 [x86_64-linux-4.3.3-303.fc23.x86_64] (local build)
> Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools.org
>
> === START OF INFORMATION SECTION ===
> Model Family:     Western Digital Green

Make sure you have read about linux raid and SCT/ERC and fixed the 
timeout issue for these drives. Do that immediately, before you bother 
trying to recover anything, or do anything else (or else recovery will 
probably fail, things will get worse, the sky will fall in...)

> Device Model:     WDC WD30EZRX-00D8PB0
> Serial Number:    WD-WCC4NCWT13RF
> LU WWN Device Id: 5 0014ee 25fc9e460
> Firmware Version: 80.00A80
> User Capacity:    3,000,591,900,160 bytes [3.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    5400 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ACS-2 (minor revision not indicated)
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
> Local Time is:    Tue Sep 13 07:53:18 2016 BST
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM feature is:   Unavailable
> APM feature is:   Unavailable
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
> Wt Cache Reorder: Enabled
>
> 193 Load_Cycle_Count        -O--CK   142   142   000    -    175500
I recall there is some tool or setting for the drive that will stop it 
from "parking" every 30 seconds, you should read up on that and see if 
you can prevent this. This will slow the drive down every time it needs 
to "restart" the drive to read/write after a short period of inactivity.

Once you fix those two issues, (which might be related to the cause of 
your problem), then someone else with more detailed knowledge can advise 
on the best next step.

Regards,
Adam

-- 
-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
