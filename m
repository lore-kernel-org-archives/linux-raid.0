From: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Subject: Re: md faster than h/w?
Date: Wed, 18 Jan 2006 12:43:15 +0800
Message-ID: <dqkh18$mf2$2@sea.gmane.org>
References: <dqicp8$47j$1@sea.gmane.org> <20060117170901.84523.qmail@web54604.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060117170901.84523.qmail@web54604.mail.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andargor wrote:
> 
> --- Max Waterman
> <davidmaxwaterman+gmane@fastmail.co.uk> wrote:
> 
>> Andargor wrote:
>>> I haven't found a benchmark that is 100%
>>> reliable/comparable. Of course, it all depends how
>> the
>>> drive is used in production, which may have little
>>> correlation with the benchmarks...
>> Indeed.
>>
>> Do you think that if it is configured for the best
>> possible
>> read performance, then that would be it's worst
>> possible
>> write performance?
>>
>> I was hoping that having it configured for good read
>> perf.
>> would mean it was pretty good for write too....
>>
>> Max.
>>
> 
> I don't have nearly the expertise some people here
> show, but intuitively I don't think that's true. If
> anything, it would be the opposite, unless write
> caching was as good as read caching (both h/w and
> kernel).

Ok. I wonder if it's possible to have the best possible read 
performance, and the worst possible write performance at the same time?

I'm noticing these messages :

"sda: asking for cache data failed
sda: assuming drive cache: write through"

in the dmesg output. We've set the raid drive to be write-back for 
better bandwidth, but if sd is assuming write through, I wonder what 
impact that will have on write performance? ... but I've asked that in a 
separate message already.

> Also, the number of disks you have to write
> to or read from depending on RAID level has an impact.

I'm assuming more is better? We're trying to get an extra one to make it 
up to 6.

What RAID should we use for best write bandwidth?

I'm assuming RAID5 isn't the best...doesn't it have to touch every disk 
for a write - ie no benefit over a single disk?

> And as Mark Hahn has indicated, the actual location on
> disk you are reading/writing has an impact as well.
> Difficult to evaluate objectively.

Yes, but I don't see that I have much control over that in the end 
system...or do I? I suppose I could partition for performance - sounds 
messy.

Max.

