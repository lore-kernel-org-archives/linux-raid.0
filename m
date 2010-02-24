From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Why does one get mismatches?
Date: Wed, 24 Feb 2010 09:46:23 -0500
Message-ID: <4B853BBF.7000607@tmr.com>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>	<4B67451F.8040206@tmr.com>	<20100202093738.44b4fece@notabene.brown>	<4B684087.50001@tmr.com>	<20100211161444.7a0ea7bb@notabene.brown>	<20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu>	<4B7B0D45.7040801@tmr.com>	<6db64f7872286165ac1fd3436e9d6476@localhost> <20100218100547.7aecdc34@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100218100547.7aecdc34@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Steven Haigh <netwiz@crc.id.au>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wed, 17 Feb 2010 08:38:11 +1100
> Steven Haigh <netwiz@crc.id.au> wrote:
>
>   
>> On Tue, 16 Feb 2010 16:25:25 -0500, Bill Davidsen <davidsen@tmr.com>
>> wrote:
>>     
>>> Bryan Mesich wrote:
>>>       
>>>> On Thu, Feb 11, 2010 at 04:14:44PM +1100, Neil Brown wrote:
>>>>   
>>>>         
>>>>>> This whole discussion simply shows that for RAID-1 software RAID is
>>>>>> less
>>>>>> reliable than hardware RAID (no, I don't mean fake-RAID), because it 
>>>>>> doesn't pin the data buffer until all copies are written.
>>>>>>       
>>>>>>             
>>>>> That doesn't make it less reliable.  It just makes it more confusing.
>>>>>     
>>>>>           
>>>> I agree that linux software RAID is no less reliable than
>>>> hardware RAID with regards to the above conversation.  It's
>>>> however confusing to have a counter that indicates there are
>>>> problems with a RAID 1 array when in fact there is not.
>>>>   
>>>>         
>>> Sorry, but real hardware raid is more reliable than software raid, and 
>>> Neil's justification for not doing smart recovery mentions it. Note this
>>>       
>>> referes to real hardware raid, not fakeraid which is just some firmware 
>>> in a BIOS to use the existing hardware.
>>>
>>> The issue lies with data changing between write to multiple drives. In 
>>> hardware raid the data traverses the memory bus once, only once, and 
>>> goes into cache in the controller, from which it is written to all 
>>> mirrored drives. With software raid an individual write is done to each 
>>> drive, and if the data in the buffer changes between writes to one drive
>>>       
>>> or the other you get different values. Neil may be convinced that the OS
>>>       
>>> somehow "knows" which of the mirror copies is correct, ie. most recent, 
>>> and never uses the stale data, but if that information was really 
>>> available reads would always return the latest value and it wouldn't be 
>>> possible to read the same file multiple times and get different MD5sums.
>>>       
>>> It would also be possible to do a stable smart recovery by propagating 
>>> the most recent copy to the other mirror drives.
>>>
>>> I hoped that mounting data=journal would lead to consistency, that seems
>>>       
>>> not to be true either.
>>>       
>> I agree Bill, there is an issue with the software RAID1 when it comes down
>> to some hardware. I have one machine where the ONLY way to stop the root
>> filesystem going readonly due to journal issues is to remove RAID. Having
>> RAID1 enabled gives silent corruption of both data and the journal at
>> seemingly random times.
>>
>> I can see the data corruption from running a verify between RPM and data
>> on the drive. Reinstalling these packages fixes things - until something
>> random things get corrupted next time.
>>     
>
> Sounds very much like dodgy drives.
>
>   
>> The myth that data corruption in RAID1 ONLY happens to swap and/or unused
>> space on a drive is absolute rubbish.
>>
>>     
>
> Absolute rubbish does seem to be a suitable phrase here.
> There is no question of data corruption.
> When memory changes between being written to one device and to another, this
> does not cause corruption, only inconsistency.   Either the block will be
> written again consistently soon, or it will never be read.
>   

Just what is it that rewrites the data block? The user program doesn't 
know it's needed, the filesystem, if any, doesn't know it's needed, and 
as far as I can tell md doesn't do checksum before issuing the write and 
after the last write is done. Doesn't make a copy and write from that. 
So what sees that the data has changed and rewrites it?

> If the host crashes before the blocks are made consistent, then the 
> inconsistency will not be visible as the resync will fix it.
>
> If you are getting any corruption, then it is NOT due to this facet of the
> RAID1 implementation - it due to something else.
> My guess is bad hardware - anywhere from memory to hard drive.
>   

Having switched an array from three way raid-1 to raid-6, using the same 
kernel, utilities, and hardware, I can speak to that. When I first 
started to run checks, I took the array offline to do repair, and 
usually saw ~12k mismatches by the end of a week. After changing the 
array to raid-6 I never had a mismatch again. Therefore, while hardware 
clearly can be a factor, it is unlikely to be the cause of all mismatch 
events.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

