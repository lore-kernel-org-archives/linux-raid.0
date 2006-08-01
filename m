From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH 005 of 9] md: Replace magic numbers in sb_dirty with well
 defined bit flags
Date: Tue, 01 Aug 2006 13:12:52 -0400
Message-ID: <44CF8B94.8030506@tmr.com>
References: <20060731172842.24323.patches@notabene> <1060731073218.24482@suse.de> <200607311733.12848.ioe-lkml@rameria.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751475AbWHAQ6F@vger.kernel.org>
In-Reply-To: <200607311733.12848.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: NeilBrown <neilb@suse.de>, Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Ingo Oeser wrote:

>Hi Neil,
>
>I think the names in this patch don't match the description at all.
>May I suggest different ones?
>
>On Monday, 31. July 2006 09:32, NeilBrown wrote:
>  
>
>>Instead of magic numbers (0,1,2,3) in sb_dirty, we have
>>some flags instead:
>>MD_CHANGE_DEVS
>>   Some device state has changed requiring superblock update
>>   on all devices.
>>    
>>
>
>MD_SB_STALE or MD_SB_NEED_UPDATE
>  
>
I think STALE is better, it is unambigous.

>  
>
>>MD_CHANGE_CLEAN
>>   The array has transitions from 'clean' to 'dirty' or back,
>>   requiring a superblock update on active devices, but possibly
>>   not on spares
>>    
>>
>
>Maybe split this into MD_SB_DIRTY and MD_SB_CLEAN ?
>  
>
I don't think the split is beneficial, but I don't care for the name 
much. Some name like SB_UPDATE_NEEDED or the like might be better.

>  
>
>>MD_CHANGE_PENDING
>>   A superblock update is underway.  
>>    
>>
>
>MD_SB_PENDING_UPDATE
>
>  
>
I would have said UPDATE_PENDING, but either is more descriptive than 
the original.

Neil - the logic in this code is pretty complex, all the help you can 
give the occasional reader, by using very descriptive names for things, 
is helpful to the reader and reduces your "question due to 
misunderstanding" load.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979
