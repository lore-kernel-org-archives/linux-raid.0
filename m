From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Considering a complete rework of RAID on my home compute server
Date: Thu, 06 Jan 2011 23:57:37 +0000
Message-ID: <4D2656F1.2090508@anonymous.org.uk>
References: <AANLkTinsQoPVaYVe4H9kMK7_-GFzHoKt_Zdf4nUKc+C2@mail.gmail.com>	<87.68.02631.5E6052D4@cdptpa-omtalb.mail.rr.com> <AANLkTikxViM45MfjZvMCDAobeVVwBqMZHrm_Ws-bsAQt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikxViM45MfjZvMCDAobeVVwBqMZHrm_Ws-bsAQt@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: lrhorer@satx.rr.com, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/01/2011 18:17, Mark Knecht wrote:
> On Wed, Jan 5, 2011 at 4:03 PM, Leslie Rhorer<lrhorer@satx.rr.com>  wrote:
[...]
>>> 3) I think with 5 disks I could get better performance  than I
>>> currently get , with similar or better safety using maybe RAID5 or
>>> RAID6.
>>
>>         No, RAID1 is as safe as it gets.  RAID0 allows for better
>> performance, but if you make the RAID0 into your backup solution, the
>> performance won't matter much.
>
> If I'm wrong about RAID6 please correct me as this understanding is
> why I chose it.
>
> 1) A 5-drive RAID6 can survive losing 2 disks and still return good data.

Yes, but then everything's still spread across three discs, with no 
redundancy, which will be less reliable than just one disc. Of course 
you ought to be replacing a disc as soon as it fails, then the remaining 
redundancy should get you through the rebuild.

> 2) A 5-drive RAID6 reads data as nearly fast as a 3-drive RAID0.

Potentially nearly as fast as a 5-drive RAID0 actually, because data is 
striped all across all 5 discs.

> If those two aren't true then my choice of RAID6 doesn't improve my
> system as I hoped.
>
> 3) My current 3-drive RAID1 can lose 2 disks and still return good
> data making #1 equivalent to #3

Sorry, I'm a bit confused by what these #s are.

> 4) #2 would be faster than my current 2-drive RAID0 and wouldn't have
> the risk of a single drive loss.
>
> If #3&  #4 aren't correct then maybe RAID6 isn't buying me anything.

Running your VMs on a 5-drive RAID-6 instead of a 2-drive RAID-0 will 
give you better read performance, streaming or random, maybe similar 
streaming write performance if you're lucky, but generally worse write 
performance, maybe much worse, no better than a single disc.

If you want to keep a backup partition that you can take offline, you 
could make your RAID-6 partitioned, or run LVM over the top of it.

Cheers,

John.

