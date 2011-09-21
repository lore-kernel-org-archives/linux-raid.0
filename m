From: David Brown <david@westcontrol.com>
Subject: Re: making a hot spare ... hot
Date: Wed, 21 Sep 2011 09:18:24 +0200
Message-ID: <j5c38q$sjq$1@dough.gmane.org>
References: <4E795A49.1060000@swiftspirit.co.za> <20110921140551.31828ea9@notabene.brown> <4E798B3B.5050004@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E798B3B.5050004@swiftspirit.co.za>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/09/2011 08:59, Brendan Hide wrote:
> On 2011/09/21 06:05 AM, NeilBrown wrote:
>> On Wed, 21 Sep 2011 05:30:17 +0200 Brendan
>> Hide<brendan@swiftspirit.co.za>
>> wrote:
>>
>>> Hi all
>>>
>>> To the point: When a disk is designated as a hot spare, would it be of
>>> benefit to spread copies of data chunks from the other disks onto the
>>> hot spare even before a failure? Has this been tried before?
>> I see what you are getting at, but I doubt the value justifies the extra
>> complexity.
>> If you want more redundancy and have a spare device - use RAID6.
>>
>> NeilBrown
> That makes sense then that there's no point in a hot spare when you're
> using RAID5 - as you say, rather use RAID6. This concept could be used
> on top of a RAID6 too. However, I also see what you mean by the
> complexity issue.
>

Correct - there /is/ no point in using a hot spare with RAID5 when you 
can use RAID6 (unless you have several RAID5 arrays with a shared hot 
spare).  There are a few types of access that are a little faster with 
RAID5 plus spare than with RAID6, but other accesses that are faster 
with the RAID6 (since you have an extra spindle to read from).

And if you are thinking of RAID6 + hot spare, then one day I hope that 
triple parity RAID6 will be supported by mdadm - it will be less 
complicated than this method.  (I've almost finished a paper explaining 
the maths of triple parity raid - I just have to tidy up the examples a 
bit.)

There is one potential improvement to hot spares that is already on 
Neil's "things to do" list - Hot Replace.  The idea there is that when 
you have a disk that is feeling poorly, but not completely dead, then 
data will be copied from it to the replacement device before the dying 
device is removed.

> There's diminishing benefits when you have lots of disks and, with fewer
> disks, you're better off having a bigger RAID6. Given a typical RAID6 (8
> disks-worth of capacity), the potential improvements are still
> *relatively* significant, but much less than the numbers given
> previously. Maximum potential numbers:
> read speed improvement: 9.09%
> sync progress at disk fail-time before any pro-active sync work starts:
> 12.5%
>
> In my books, any trickery that improves integrity is a good thing but,
> until I have time to hack around in mdadm code (not likely at the
> moment), I guess I'll leave it to whoever else who thinks these numbers
> are worth it. :)
>
> Thanks, all.
>


