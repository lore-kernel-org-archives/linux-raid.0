From: Sebastian Sobolewski <linux@thirdmartini.com>
Subject: Re: Write and verify correct data to read-failed sectors before degrading
 array?
Date: Thu, 16 Sep 2004 19:41:47 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <414A40DB.6070309@thirdmartini.com>
References: <41420D07.4060001@steeleye.com>	<16709.12517.514905.627708@cse.unsw.edu.au>	<41487D18.1050000@steeleye.com>	<4149700F.6060509@buttersideup.com> <16714.12891.987589.769643@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16714.12891.987589.769643@cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>On Thursday September 16, tim@buttersideup.com wrote:
>  
>
>>Just thinking out loud here, but I wonder if the following change is 
>>possible or worth making to this code?  For a failed read, where the 
>>block is then successfully read from another drive, then attempt to 
>>write the correct data for this block to the device with the read 
>>failure (to try to see if the drive firmware thinks this sector is still 
>>usable, and if not then maybe it will reallocate the failed sector).  If 
>>this write succeeds, and can be verified, then don't mark the sector bad 
>>(maybe just complain with a printk)..
>>
>>This would get around a lot of mirror failures that I see in 
>>operation..  In the past, I've had mirrors go bad with individual failed 
>>sectors in different locations on both drives, the array is then 
>>unusable (and the database server is dead, in my experience) unless you 
>>manually try to knit it back together with dd.
>>    
>>
>
>Yes.  Great idea.  Just as good as every other time it gets suggested :-)
>Unfortunately no-one has presented any actual *code* yet, and I
>haven't found/made/allocated time to do it.
>
>   http://neilb.web.cse.unsw.edu.au/SoftRaid/01084418693
>
>NeilBrown
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>
    I have some experimental code that does the read-recovery piece for 
raid1 devices against kernel 2.4.26.  If an error is encountered on a 
read, the failure is delayed until the read is retried to the other 
mirror.  If the retried read succeeds it then writes the recovered block 
back over the previously failed block. 
    If the write fails then the drive is marked faulty otherwise we 
continue without setting the drive faulty.  ( The idea here is that 
modern disk drives have spare sectors, and will be automatically 
reallocate a bad sector to one of the spares on the next write ). 
    The caveat is that if the drive is generating lots of bad/failed 
reads it's most likely going south.. but that's what smart log 
monitoring is for.  If anyone is interested I can post the patch.

-Sebastian


