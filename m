From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Speeding up chunk size change?
Date: Sat, 03 Mar 2012 20:24:25 -0600
Message-ID: <4F52D259.4050907@hardwarefreak.com>
References: <4F5272C9.3010906@crc.id.au> <4F52904E.10203@hardwarefreak.com> <4F52BDC7.5070805@crc.id.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F52BDC7.5070805@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/3/2012 6:56 PM, Steven Haigh wrote:
> On 4/03/2012 8:42 AM, Stan Hoeppner wrote:
[snip]
>>> blockdev --setra 8192 /dev/sd[abcdefg]
>>
>> Read-ahead is per file descriptor, and occurs at the filesystem level.
>> The read-ahead value used is that of the device immediately underlying
>> the filessytem.  So don't bother setting these above.
> 
> Interesting - I didn't think that was the case for whole disk arrays -
> but there you go... Learnt something else :)
[snip]
>>>          echo 4096>  /sys/block/$i/queue/read_ahead_kb
>> Eliminate this line ^^^^
> 
> Any insight into why? I would have thought that this would help -
> however I'm not quite sure as to the values - as this is much less than
> one chunk... That also being said, wouldn't it be a good idea to have
> *some* readahead?

You read the answer up above, and commented on it.  Maybe you didn't
fully understand?  Or maybe it's because you don't know that these two
are functionally equivalent?

blockdev --setra X
echo X >  /sys/block/$i/queue/read_ahead_kb

-- 
Stan
