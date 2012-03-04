From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: Speeding up chunk size change?
Date: Sun, 04 Mar 2012 03:37:25 +0100
Message-ID: <4F52D565.7040604@fastmail.fm>
References: <4F5272C9.3010906@crc.id.au> <4F52904E.10203@hardwarefreak.com> <4F52BDC7.5070805@crc.id.au> <4F52D259.4050907@hardwarefreak.com> <4F52D320.4080206@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F52D320.4080206@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: stan@hardwarefreak.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/04/2012 03:27 AM, Steven Haigh wrote:
> On 4/03/2012 1:24 PM, Stan Hoeppner wrote:
>> On 3/3/2012 6:56 PM, Steven Haigh wrote:
>>> On 4/03/2012 8:42 AM, Stan Hoeppner wrote:
>> [snip]
>>>>> blockdev --setra 8192 /dev/sd[abcdefg]
>>>>
>>>> Read-ahead is per file descriptor, and occurs at the filesystem level.
>>>> The read-ahead value used is that of the device immediately underlying
>>>> the filessytem. So don't bother setting these above.
>>>
>>> Interesting - I didn't think that was the case for whole disk arrays -
>>> but there you go... Learnt something else :)
>> [snip]
>>>>> echo 4096> /sys/block/$i/queue/read_ahead_kb
>>>> Eliminate this line ^^^^
>>>
>>> Any insight into why? I would have thought that this would help -
>>> however I'm not quite sure as to the values - as this is much less than
>>> one chunk... That also being said, wouldn't it be a good idea to have
>>> *some* readahead?
>>
>> You read the answer up above, and commented on it. Maybe you didn't
>> fully understand? Or maybe it's because you don't know that these two
>> are functionally equivalent?
>>
>> blockdev --setra X
>> echo X> /sys/block/$i/queue/read_ahead_kb
>
> Ahhh - you're spot on... I didn't think they had the same functionality!
>

Btw, /sys/block/$i/queue/read_ahead_kb is deprecated, as its not a 
kernel-internal queue setting, but rather bdi (backing device) related.
So /sys/block/$i/bdi/read_ahead_kb is recommended to be used (I guess 
queue/read_ahead_kb will go away sometime in the future). In 
/sys/class/bdi you can even control read-head of non-block device file 
systems.

Cheers,
Bernd
