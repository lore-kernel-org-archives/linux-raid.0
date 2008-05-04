From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Redundancy check using "echo check > sync_action": error	reporting?
Date: Sun, 04 May 2008 09:30:02 +0200
Message-ID: <481D65FA.4090107@rabbit.us>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl> <20080320163551.GG13719@mit.edu> <47E2EE64.5080101@rabbit.us> <47E3C504.3010700@tmr.com> <47E3CBAF.4090808@rabbit.us> <47E43E57.5010409@tmr.com> <20080321235557.GA11801@cthulhu.home.robinhill.me.uk> <47E4D95A.9000505@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47E4D95A.9000505@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> Robin Hill wrote:
>> On Fri Mar 21, 2008 at 07:01:43PM -0400, Bill Davidsen wrote:
>>
>>> Peter Rabbitson wrote:
>>>> I was actually specifically advocating that md must _not_ do 
>>>> anything on its own. Just provide the hooks to get information (what 
>>>> is the current stripe state) and update information (the described 
>>>> repair extension). The logic that you are describing can live only 
>>>> in an external app, it has no place in-kernel.
>>> So you advocate the current code being in the kernel, which absent a 
>>> hardware error makes blind assumptions about which data is valid and 
>>> which is not and in all cases hides the problem, instead of the code 
>>> I proposed, which in some cases will be able to avoid action which is 
>>> provably wrong and never be less likely to do the wrong thing than 
>>> the current code?
>>>
>> I would certainly advocate that the current (entirely automatic) code
>> belongs in the kernel whereas any code requiring user
>> intervention/decision making belongs in a user process, yes.  That's not
>> to say that the former should be preferred over the latter though, but
>> there's really no reason to remove the in-kernel automated process until
>> (or even after) a user-side repair process has been coded.
> 
> I am asserting that automatic repair is infeasible in most 
> highly-redundant cases. Lets take the root raid1 of one of my busiest 
> servers:
> 
> /dev/md0:
>         Version : 00.90.03
>   Creation Time : Tue Mar 20 21:58:54 2007
>      Raid Level : raid1
>      Array Size : 6000128 (5.72 GiB 6.14 GB)
>   Used Dev Size : 6000128 (5.72 GiB 6.14 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Sat Mar 22 05:55:08 2008
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
> 
>            UUID : b6a11a74:8b069a29:6e26228f:2ab99bd0 (local to host 
> Arzamas)
>          Events : 0.183270
> 
> As you can see it is pretty old, and does not have many events to speak 
> of. Yet every month when the automatic check is issued I get between 512 
> and 2048 in mismatch_cnt. I maintain md5sums of all files on this 
> filesystem, and there were no deviations for the lifetime of the array 
> (of course there are mismatches after upgrades, after log appends etc, 
> but they are all expected). So all I can do with this array is issue a 
> blind repair, without even having the chance to find what exactly is 
> causing this. Yes, it is raid1 and I could do 1:1 comparison to find 
> which is the offending block. How about raid10 -n f3? There is no way I 
> can figure out _what_ is giving me a problem. I do not know if it is a 
> hardware error (the md5 sums speak against it), some process with weird 
> write patterns resulting in heavy DMA, or a bug in md itself.
> 
> By the way there is no swap file on this array. Just / and /var, with a 
> moderately busy mail spool on top.
> 

I want to resurect this discussion with a peculiar observation - the above 
mismatch was caused by GRUB.

I had some time this weekend and decided to take device snapshots of the 4 
array members as listed above while / is mounted ro. After stripping the md 
superblock I ended up with data from slots 1 2 and 3 being identical, and 0 
(my primary boot device) being different by about 10 bytes. Hexediting 
revealed that the bytes in question belong to /boot/grub/default.

I realized that my grub config contains a savedefault clause, which updates 
the file on the raw ext3 volume before any raid assembly has taken place. 
Executing grub-set-default from within a booted system (with a mounted 
assembled raid) resulted in the subsequent md check to return 0 mismatches. To 
add insult to the injury the way svedefault and grub-set-default update said 
file are different (comments vs empty lines). So even if one savedfault's the 
same entry as the one set initially bu grub-set-default - the result will 
still be a raid1 mismatch.

I assume that this condition is benign, but wanted to bring this to the 
attention of the masses anyway.

Cheers

Peter
