From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Redundancy check using "echo check > sync_action": error	reporting?
Date: Fri, 21 Mar 2008 15:52:31 +0100
Message-ID: <47E3CBAF.4090808@rabbit.us>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl> <20080320163551.GG13719@mit.edu> <47E2EE64.5080101@rabbit.us> <47E3C504.3010700@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47E3C504.3010700@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Theodore Tso <tytso@MIT.EDU>, Bas van Schaik <bas@tuxes.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> Peter Rabbitson wrote:
>> Theodore Tso wrote:
>>> On Thu, Mar 20, 2008 at 03:19:08PM +0100, Bas van Schaik wrote:
>>>>> There's no explicit message produced by the md module, no.  You 
>>>>> need to
>>>>> check the /sys/block/md{X}/md/mismatch_cnt entry to find out how many
>>>>> mismatches there are.  Similarly, following a repair this will 
>>>>> indicate
>>>>> how many mismatches it thinks have been fixed (by updating the parity
>>>>> block to match the data blocks).
>>>>>   
>>>> Marvellous! I naively assumed that the module would warn me, but that's
>>>> not true. Wouldn't it be appropriate to print a message to dmesg if 
>>>> such
>>>> a mismatch occurs during a check? Such a mismatch clearly means that
>>>> there is something wrong with your hardware lying beneath md, 
>>>> doesn't it?
>>>
>>> If a mismatch is detected in a RAID-6 configuration, it should be
>>> possible to figure out what should be fixed (since with two hot spares
>>> there should be enough redundancy not only to detect an error, but to
>>> correct it.)  Out of curiosity, does md do this automatically, either
>>> when reading from a stripe, or during a resync operation?
>>>
>>
>> In my modest experience with root/high performance spool on various 
>> raid levels I can pretty much conclude that the current check 
>> mechanism doesn't do enough to give power to the user. We can debate 
>> all we want about what the MD driver should do when it finds a 
>> mismatch, yet there is no way for the user to figure out what the 
>> mismatch is and take appropriate action. This does not apply only to 
>> RIAD5/6 - what about RAID1/10 with >2 chunk copies? What if the only 
>> wrong value is taken and written all over the other good blocks?
>>
>> I think that the solution is rather simple, and I would contribute a 
>> patch if I had any C experience. The current check mechanism remains 
>> the same - mismatch_cnt is incremented/reset just the same as before. 
>> However on every mismatching chunk the system printks the following:
>>
>> 1) the start offset of the chunk(md1/10) or stripe(md5/6) within the 
>> MD device
>> 2) one line for every active disk containing:
>>     a) the offset of the chunk within the MD componnent
>>     b) a {md5|sha1}sum of the chunk
>>
>> In a common case array this will take no more than 8 lines in dmesg. 
>> However it will allow:
>>
>> 1) For a human to determine at a glance which disk holds a mismatching 
>> chunk in raid 1/10
>> 2) Determine the same for raid 6 using a userspace tool which will 
>> calculate the parity for every possible permutation of chunks
>> 3) using some external tools to determine which file might have been 
>> affected on the layered file system
>>
>>
>> Now of course the problem remains how to repair the array using the 
>> information obtained above. I think the best way would be to extend 
>> the syntax of repair itself, so that:
>>
>> echo repair > .../sync_action would use the old heuristics
>>
>> echo repair <mdoffset> <component N> > .../sync_action will update the 
>> chunk on drive N which corresponds to the chunk/stripe at mdoffset 
>> within the MD device, using the information from the other drives, and 
>> not the other way around as might happen with just a repair.
> 
> I totally agree, not doing the most likely to be correct thing seems to 
> be the one argument for hardware raid. There are two case in which 
> software can determine (a) if it is likely that there is a single bad 
> block, and (b) what the correct value for that block is.
> 
> <snip>
> 

I was actually specifically advocating that md must _not_ do anything on its 
own. Just provide the hooks to get information (what is the current stripe 
state) and update information (the described repair extension). The logic that 
you are describing can live only in an external app, it has no place in-kernel.

Peter
