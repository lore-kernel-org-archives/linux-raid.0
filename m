From: David Lethe <david@santools.com>
Subject: Re: raid failure question
Date: Mon, 1 Feb 2010 14:29:00 -0600
Message-ID: <EB9469C209DB064DA15714214B92D5167D9C84F5E4@34093-MBX-C09.mex07a.mlsrvr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

- bad block on surviving disk during a rebuild gives partial unrecoverable data loss.
- bugs in firmware can be devastating, like NCQ TCQ problems,
-Humans

-----Original Message-----

From:  "Bill Davidsen" <davidsen@tmr.com>
Subj:  Re: raid failure question
Date:  Mon Feb 1, 2010 2:21 pm
Size:  1K
To:  "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>

Robin Hill wrote: 
> On Mon Jan 11, 2010 at 11:00:40AM -0700, Tim Bock wrote: 
> 
>    
>> Hello, 
>> 
>> Excluding the obvious multi-disk or bus failures, can anyone describe 
>> what type of disk failure a raid cannot detect/recover from? 
>> 
>> I have had two disk failures over the last three months, and in spite of 
>> having a hot spare, manual intervention was required each time to make 
>> the raid usable again.  I'm just not sure if I'm not setting something 
>> up right, or if there is some other issue. 
>> 
>> Thanks for any comments or suggestions. 
>> 
>>      
> Any failure where the disk doesn't actually return an error (within a 
> reasonable time).  For example, consumer grade disks often have very 
> long retry times - this can mean the array in unusable for a long time 
> until the disk eventually fails the read. 
> 
> If the disk actually returns an error then, AFAIK, the RAID array should 
> always be able to recover from it. 
>    
 
The problem is that the admin should be able to set a timeout after  
which recovery takes place even if the drive hasn't returned a bad  
status. And some form of counter could be kept such that after a number  
of these the drive is failed. There is no solution, Neil says the  
timeout should be in the driver, the driver writers say that if it hurts  
md the timeout should be there. Everyone points the finger at some other  
code and says "there." 
 
This is not lazyness or buck passing, Neil feels that md is not the  
place, but putting it elsewhere causes other problems. Until someone  
says "perfect is the enemy of good enough" and puts a timer where it  
will solve the problem, this behavior will continue. 
 
--  
Bill Davidsen <davidsen@tmr.com> 
  "We can't solve today's problems by using the same thinking we 
   used in creating them." - Einstein 
 
-- 
To unsubscribe from this list: send the line "unsubscribe linux-raid" in 
the body of a message to majordomo@vger.kernel.org 
More majordomo info at  http://vger.kernel.org/majordomo-info.html 

