From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Some RAID levels do not support bitmap
Date: Mon, 11 Jun 2007 19:15:59 -0400
Message-ID: <466DD7AF.7030107@tmr.com>
References: <Pine.LNX.4.64.0706111448500.19578@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706111448500.19578@fbirervta.pbzchgretzou.qr>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Jan Engelhardt wrote:
> Hi,
>
>
> RAID levels 0 and 4 do not seem to like the -b internal. Is this 
> intentional? Runs 2.6.20.2 on i586.
> (BTW, do you already have a PAGE_SIZE=8K fix?)
>
> 14:47 ichi:/dev # mdadm -C /dev/md0 -l 4 -e 1.0 -b internal -n 2 /dev/ram[01]
> mdadm: RUN_ARRAY failed: Input/output error
> mdadm: stopped /dev/md0
> 14:47 ichi:/dev # mdadm -C /dev/md0 -l 0 -e 1.0 -b internal -n 2 /dev/ram[01]
> mdadm: RUN_ARRAY failed: Cannot allocate memory
> mdadm: stopped /dev/md0
>
> Right... md: bitmaps not supported for this level.
>   

Bitmaps show what data has been modified but not written. For RAID-0 
there is no copy, therefore there can be no bitmap to show what "still 
needs to be updated." I would have thought that RAID-4 would support 
bitmaps, but maybe it was just never added because use of RAID-4 is 
pretty uncommon.

BTW: RAID-4 seems to work fine with an external bitmap. Were you trying 
to do "internal?"

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

