From: Brendan Hide <brendan@swiftspirit.co.za>
Subject: Re: making a hot spare ... hot
Date: Wed, 21 Sep 2011 08:59:07 +0200
Message-ID: <4E798B3B.5050004@swiftspirit.co.za>
References: <4E795A49.1060000@swiftspirit.co.za> <20110921140551.31828ea9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110921140551.31828ea9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2011/09/21 06:05 AM, NeilBrown wrote:
> On Wed, 21 Sep 2011 05:30:17 +0200 Brendan Hide<brendan@swiftspirit.co.za>
> wrote:
>
>> Hi all
>>
>> To the point: When a disk is designated as a hot spare, would it be of
>> benefit to spread copies of data chunks from the other disks onto the
>> hot spare even before a failure? Has this been tried before?
> I see what you are getting at, but I doubt the value justifies the extra
> complexity.
> If you want more redundancy and have a spare device - use RAID6.
>
> NeilBrown
That makes sense then that there's no point in a hot spare when you're 
using RAID5 - as you say, rather use RAID6. This concept could be used 
on top of a RAID6 too. However, I also see what you mean by the 
complexity issue.

There's diminishing benefits when you have lots of disks and, with fewer 
disks, you're better off having a bigger RAID6. Given a typical RAID6 (8 
disks-worth of capacity), the potential improvements are still 
*relatively* significant, but much less than the numbers given 
previously. Maximum potential numbers:
read speed improvement: 9.09%
sync progress at disk fail-time before any pro-active sync work starts: 
12.5%

In my books, any trickery that improves integrity is a good thing but, 
until I have time to hack around in mdadm code (not likely at the 
moment), I guess I'll leave it to whoever else who thinks these numbers 
are worth it. :)

Thanks, all.

-- 
Brendan Hide

http://swiftspirit.co.za/

