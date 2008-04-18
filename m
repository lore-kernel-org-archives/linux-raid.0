From: "David Lethe" <david@santools.com>
Subject: Re: Question: how to identify failing disk in a RAID1
Date: Fri, 18 Apr 2008 12:36:00 -0500
Message-ID: <063701c8a17a$b3dacddf$9201a8c0@exchange.rackspace.com>
Reply-To: <David@santools.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>, Maurice Hilarius <maurice@harddata.com>
Cc: vger majordomo for lists <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The sympoms are indicative of a standard bad block reallocation.  Depending on make, model, firmare rev and even location of the new defect it could take several seconds for the disk to grab a spare from the reserved are and fix the defect. No reason for concern ... The system worked like it was desigmed to .

-----Original Message-----

From:  "Bill Davidsen" <davidsen@tmr.com>
Subj:  Re: Question: how to identify failing disk in a RAID1
Date:  Fri Apr 18, 2008 8:15 am
Size:  2K
To:  "Maurice Hilarius" <maurice@harddata.com>
cc:  "vger majordomo for lists" <linux-raid@vger.kernel.org>

Maurice Hilarius wrote: 
> Bill Davidsen wrote: 
>> Maurice Hilarius wrote: 
>>> Morning Bill. 
>>> 
>>> BTW< I want to say "Thanks for your help with this" first. 
>>> Just in case I forgot. 
>>> 
>>> So, I ran "check" once. It complained, and failed. 
>>> 
>> Does the failure provide any useful information? 
>> 
> No. 
> Here is what I got the first time: 
> 
> root@localhost md]# echo check >sync_action; cat mismatch_cnt 
> -bash: echo: write error: Device or resource busy 
> 0 
> 
> Later, on my second try, a few hours later, it worked, reporting no error. 
> .. 
> [maurice@localhost ~]$ su - 
> Password: 
> [root@localhost ~]# cd /sys/block/md0/md 
> [root@localhost md]# cat /proc/mdstat 
> Personalities : [raid1] [raid6] [raid5] [raid4] 
> md0 : active raid1 sda3[0] sdb2[1] 
>       386403328 blocks [2/2] [UU] 
> 
> unused devices: <none> 
> [root@localhost md]# echo check >sync_action; cat mismatch_cnt 
> 0 
> 
>> 
>> I think it's time to be keeping a good backup, and hopefully someone  
>> else has a good thought on running this down more. 
>> 
> Thanks, updated that backup at the first sign of trouble 
>>> Any thoughts on that? 
>> 
>> The only thought I have at the moment is marginal power supply, and  
>> that's just because it can generate all manner of odd behaviors,  
>> rather than any other hints. Sorry. 
>> 
> Yeah. I am going to replace *both* disks, and then run the  
> manufacturers utility (Seatest) on them. 
>> If you aren't getting errors from SMART or logs, and I don't remember  
>> you sending me that info, I'm not sure how you determine which drive  
>> is the problem. 
> Exactly. 
> 
> Thanks a LOT for trying, Bill.. 
 
Actually, my though is that you may not actually be getting hardware  
errors, which is why they are not being report by either the kernel or  
SMART. That's why I thought of memory and/or power issues, either of  
which could cause what you are seeing. 
 
Guess I have to leave it there, maybe someone else will have a thought. 
 
--  
Bill Davidsen <davidsen@tmr.com> 
  "Woe unto the statesman who makes war without a reason that will still 
  be valid when the war is over..." Otto von Bismark  
 
 
-- 
To unsubscribe from this list: send the line "unsubscribe linux-raid" in 
the body of a message to majordomo@vger.kernel.org 
More majordomo info at  http://vger.kernel.org/majordomo-info.html 
 


