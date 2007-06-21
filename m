From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: limits on raid
Date: Thu, 21 Jun 2007 19:03:29 -0400
Message-ID: <467B03C1.50809@tmr.com>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>	<18034.479.256870.600360@notabene.brown>	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <46756BE2.7010401@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752899AbXFUXDZ@vger.kernel.org>
In-Reply-To: <46756BE2.7010401@tmr.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I didn't get a comment on my suggestion for a quick and dirty fix for 
-assume-clean issues...

Bill Davidsen wrote:
> Neil Brown wrote:
>> On Thursday June 14, david@lang.hm wrote:
>>  
>>> it's now churning away 'rebuilding' the brand new array.
>>>
>>> a few questions/thoughts.
>>>
>>> why does it need to do a rebuild when makeing a new array? couldn't 
>>> it just zero all the drives instead? (or better still just record 
>>> most of the space as 'unused' and initialize it as it starts useing 
>>> it?)
>>>     
>>
>> Yes, it could zero all the drives first.  But that would take the same
>> length of time (unless p/q generation was very very slow), and you
>> wouldn't be able to start writing data until it had finished.
>> You can "dd" /dev/zero onto all drives and then create the array with
>> --assume-clean if you want to.  You could even write a shell script to
>> do it for you.
>>
>> Yes, you could record which space is used vs unused, but I really
>> don't think the complexity is worth it.
>>
>>   
> How about a simple solution which would get an array on line and still 
> be safe? All it would take is a flag which forced reconstruct writes 
> for RAID-5. You could set it with an option, or automatically if 
> someone puts --assume-clean with --create, leave it in the superblock 
> until the first "repair" runs to completion. And for repair you could 
> make some assumptions about bad parity not being caused by error but 
> just unwritten.
>
> Thought 2: I think the unwritten bit is easier than you think, you 
> only need it on parity blocks for RAID5, not on data blocks. When a 
> write is done, if the bit is set do a reconstruct, write the parity 
> block, and clear the bit. Keeping a bit per data block is madness, and 
> appears to be unnecessary as well.
>>> while I consider zfs to be ~80% hype, one advantage it could have 
>>> (but I don't know if it has) is that since the filesystem an raid 
>>> are integrated into one layer they can optimize the case where files 
>>> are being written onto unallocated space and instead of reading 
>>> blocks from disk to calculate the parity they could just put zeros 
>>> in the unallocated space, potentially speeding up the system by 
>>> reducing the amount of disk I/O.
>>>     
>>
>> Certainly.  But the raid doesn't need to be tightly integrated
>> into the filesystem to achieve this.  The filesystem need only know
>> the geometry of the RAID and when it comes to write, it tries to write
>> full stripes at a time.  If that means writing some extra blocks full
>> of zeros, it can try to do that.  This would require a little bit
>> better communication between filesystem and raid, but not much.  If
>> anyone has a filesystem that they want to be able to talk to raid
>> better, they need only ask...
>>  
>>  
>>> is there any way that linux would be able to do this sort of thing? 
>>> or is it impossible due to the layering preventing the nessasary 
>>> knowledge from being in the right place?
>>>     
>>
>> Linux can do anything we want it to.  Interfaces can be changed.  All
>> it takes is a fairly well defined requirement, and the will to make it
>> happen (and some technical expertise, and lots of time .... and
>> coffee?).
>>   
> Well, I gave you two thoughts, one which would be slow until a repair 
> but sounds easy to do, and one which is slightly harder but works 
> better and minimizes performance impact.
>


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979
