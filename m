From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid6 check/repair
Date: Thu, 29 Nov 2007 14:30:36 -0500
Message-ID: <474F135C.2000703@tmr.com>
References: <474431BF.30103@ph.tum.de>	<18244.64972.172685.796502@notabene.brown>	<4745B375.4030500@ph.tum.de> <18254.21949.441607.134763@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18254.21949.441607.134763@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: thiemo.nagel@ph.tum.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday November 22, thiemo.nagel@ph.tum.de wrote:
>   
>> Dear Neil,
>>
>> thank you very much for your detailed answer.
>>
>> Neil Brown wrote:
>>     
>>> While it is possible to use the RAID6 P+Q information to deduce which
>>> data block is wrong if it is known that either 0 or 1 datablocks is 
>>> wrong, it is *not* possible to deduce which block or blocks are wrong
>>> if it is possible that more than 1 data block is wrong.
>>>       
>> If I'm not mistaken, this is only partly correct.  Using P+Q redundancy,
>> it *is* possible, to distinguish three cases:
>> a) exactly zero bad blocks
>> b) exactly one bad block
>> c) more than one bad block
>>
>> Of course, it is only possible to recover from b), but one *can* tell,
>> whether the situation is a) or b) or c) and act accordingly.
>>     
>
> It would seem that either you or Peter Anvin is mistaken.
>
> On page 9 of 
>   http://www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf
> at the end of section 4 it says:
>
>       Finally, as a word of caution it should be noted that RAID-6 by
>       itself cannot even detect, never mind recover from, dual-disk
>       corruption. If two disks are corrupt in the same byte positions,
>       the above algorithm will in general introduce additional data
>       corruption by corrupting a third drive.
>
>   
>> The point that I'm trying to make is, that there does exist a specific
>> case, in which recovery is possible, and that implementing recovery for
>> that case will not hurt in any way.
>>     
>
> Assuming that it true (maybe hpa got it wrong) what specific
> conditions would lead to one drive having corrupt data, and would
> correcting it on an occasional 'repair' pass be an appropriate
> response?
>
> Does the value justify the cost of extra code complexity?
>
>   
>>> RAID is not designed to protect again bad RAM, bad cables, chipset 
>>> bugs drivers bugs etc.  It is only designed to protect against drive 
>>> failure, where the drive failure is apparent.  i.e. a read must 
>>> return either the same data that was last written, or a failure 
>>> indication. Anything else is beyond the design parameters for RAID.
>>>       
>> I'm taking a more pragmatic approach here.  In my opinion, RAID should
>> "just protect my data", against drive failure, yes, of course, but if it
>> can help me in case of occasional data corruption, I'd happily take
>> that, too, especially if it doesn't cost extra... ;-)
>>     
>
> Everything costs extra.  Code uses bytes of memory, requires
> maintenance, and possibly introduced new bugs.  I'm not convinced the
> failure mode that you are considering actually happens with a
> meaningful frequency.
>   

People accept the hardware and performance costs of raid-6 in return for 
the better security of their data. If I run a check and find that I have 
an error, right now I have to treat that the same way as an 
unrecoverable failure, because the "repair" function doesn't fix the 
data, it just makes the symptom go away by redoing the p and q values.

This makes the naive user thinks the problem is solved, when in fact 
it's now worse, he has corrupt data with no indication of a problem. The 
fact that (most) people who read this list are advanced enough to 
understand the issue does not protect the majority of users from their 
ignorance. If that sounds elitist, many of the people on this list are 
the elite, and even knowing that you need to learn and understand more 
is a big plus in my book. It's the people who run repair and assume the 
problem is fixed who get hurt by the current behavior.

If you won't fix the recoverable case by recovering, then maybe for 
raid-6 you could print an error message like
  can't recover data, fix parity and hide the problem (y/N)?
or require a --force flag, and at least give a heads up to the people 
who just picked the "most reliable raid level" because they're trying to 
do it right, but need a clue that they have a real and serious problem, 
and just a "repair" can't fix it.

Recovering a filesystem full of "just files" is pretty easy, that's what 
backups with CRC are for, but a large database recovery often takes 
hours to restore and run journal files. I personally consider it the job 
of the kernel to do recovery when it is possible, absent that I would 
like the tools to tell me clearly that I have a problem and what it is.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


