From: Phil Turmel <philip@turmel.org>
Subject: Re: Help raid10 recovery from 2 disks removed
Date: Thu, 24 Oct 2013 08:16:50 -0400
Message-ID: <52690FB2.6000005@turmel.org>
References: <1F36A02C60ACD1478457DCD917DA0FA8034656@ZEX001-0M9030.jp.ykgw.net> <alpine.DEB.2.02.1310241050290.1838@uplift.swm.pp.se> <1F36A02C60ACD1478457DCD917DA0FA8034983@ZEX001-0M9030.jp.ykgw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1F36A02C60ACD1478457DCD917DA0FA8034983@ZEX001-0M9030.jp.ykgw.net>
Sender: linux-raid-owner@vger.kernel.org
To: yuji_touya@yokogawa-digital.com, swmike@swm.pp.se
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning,

On 10/24/2013 06:14 AM, yuji_touya@yokogawa-digital.com wrote:
> Mikael,

[trim /]

>> You need to figure out what happened to get sdb kicked out of the array,
>> check logs and "dmesg". Also use smartctl to check sdb and see if it's
>> failing.

[trim /]

> Device Model:     ST2000DM001-9YN164

If I recall correctly, this model doesn't support error recovery
control.  If you haven't fixed your driver timeouts, it explains your
situation.


> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x000f   115   097   006    Pre-fail  Always       -       88125160
>   3 Spin_Up_Time            0x0003   093   093   000    Pre-fail  Always       -       0
>   4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       14
>   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       0

No reallocations...

> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       112
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       112

But many sectors waiting for rewrite (which will either fix them or
reallocate them).  Rewrites can't succeed in normal MD operation with
mismatched timeouts.

If you search the archives for various combinations of "scterc",
"timeout mismatch", "URE" and "error recovery", you'll find numerous
discussion of this problem and ways to mitigate it.  (More like horror
stories, to be honest.)  Most importantly, plan to buy RAID-capable
drives in the future.

HTH,

Phil


