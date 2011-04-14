From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system
 unresponsive
Date: Thu, 14 Apr 2011 09:16:36 -0400
Message-ID: <4DA6F3B4.7040303@turmel.org>
References: <541553.42147.qm@web65113.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <541553.42147.qm@web65113.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Gavin,

I think you might want to investigate your *power supply* ...

On 04/13/2011 08:15 PM, Gavin Flower wrote:

[snip /]

> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x000f   115   099   006    Pre-fail  Always       -       87918991
>   3 Spin_Up_Time            0x0003   099   097   000    Pre-fail  Always       -       0
>   4 Start_Stop_Count        0x0032   085   085   020    Old_age   Always       -       16014
>   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       0
>   7 Seek_Error_Rate         0x000f   072   060   030    Pre-fail  Always       -       20251386
>   9 Power_On_Hours          0x0032   097   097   000    Old_age   Always       -       2940
>  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
>  12 Power_Cycle_Count       0x0032   093   093   020    Old_age   Always       -       7999

SMOKING GUN                                                                              ^^^^

I suspect your power supply is good enough to slowly spin up your drives and get them talking, but when you ask them to work hard, especially when writing, the PS voltage dips enough to reset the drive.

Look up all the power consumption specs for all of your components, and add up the *peak* current requirements.  Make sure your PS can handle it.

HTH,

Phil
