From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH/Resend] md: Push down data integrity code to personalities.
Date: Tue, 07 Jul 2009 18:10:24 -0400
Message-ID: <4A53C7D0.6070701@tmr.com>
References: <20090701083802.GC9910@skl-net.de> <19026.50240.504728.428875@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19026.50240.504728.428875@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andre Noll <maan@systemlinux.org>, linux-raid <linux-raid@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wednesday July 1, maan@systemlinux.org wrote:
>   
>> Hi Neil,
>>
>> here's again the patch that reduces the knowledge about specific
>> raid levels from md.c by moving the data integrity code to the
>> personalities. The patch was tested and acked by Martin.
>>
>> Please review.
>>     
>
> Apologies for the delay.  I've been fighting a flu :-(
>
> This patch seems to treat spares inconsistently.
>
> md_integrity_register ignores spares.
> However bind_rdev_to_array - which is used for adding a spare - calls
> md_integrity_add_rdev to check that the integrity profile of the new
> device matches.
>
> We need to be consistent.
> Either all devices that are bound to the array - whether active,
> spare, or failed - are considered, or only the active devices are
> considered.
>
> In the former case we want to take action in bind_rdev_to_array
> and possibly in unbind_rdev_from_array.
> In the latter we need to take action either in remove_and_add_spares,
> or in the per-personality ->hot_add_disk and ->hot_remove_disk
> methods.
>
> I think I lean towards the latter, and put code in ->hot_*_disk, but
> it isn't a strong leaning.
>   

Does this open problems with shared spares between arrays of different 
types?

-- 
Bill Davidsen <davidsen@tmr.com>
  Obscure bug of 2004: BASH BUFFER OVERFLOW - if bash is being run by a
normal user and is setuid root, with the "vi" line edit mode selected,
and the character set is "big5," an off-by-one error occurs during
wildcard (glob) expansion.

