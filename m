From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: How do I tell which disk failed?
Date: Tue, 08 Jan 2013 16:30:35 -0600
Message-ID: <50EC9E0B.2010904@hardwarefreak.com>
References: <1357610701.16366.13.camel@corn.betterworld.us>  <50EBAC5D.8080000@hardwarefreak.com>  <1357628351.16366.86.camel@corn.betterworld.us>  <02B6762C-3755-4CE3-9AB1-A48D3384CACB@colorremedies.com>  <1357631387.16366.131.camel@corn.betterworld.us>  <F5C2E9CA-635E-4FA5-9C20-EB0F6AE94838@colorremedies.com> <1357637558.16366.154.camel@corn.betterworld.us>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1357637558.16366.154.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: Chris Murphy <lists@colorremedies.com>, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/8/2013 3:32 AM, Ross Boylan wrote:

> # date; smartctl -a /dev/sda
> Device Model:     ST3750330NS
> Serial Number:    9QK1MBCW

> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x000f   075   063   044    Pre-fail  Always       -       38010669
>   7 Seek_Error_Rate         0x000f   078   060   030    Pre-fail  Always       -       65563711282
> 195 Hardware_ECC_Recovered  0x001a   044   024   000    Old_age   Always       -       38010669

This 750GB Seagate drive is FUBAR.  Replace it as soon as possible.


> Device Model:     WDC WD2003FYYS-02W0B1
> Serial Number:    WD-WCAY00580447

> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       0
>   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
>   7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Always       -       0
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       0
> 198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offline      -       0

This Western Digital appears to be fine.  Please show log entries that
lead you to believe it has problems.

-- 
Stan

