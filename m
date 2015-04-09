From: Joe Landman <joe.landman@gmail.com>
Subject: Re: interesting MD-xfs bug
Date: Thu, 09 Apr 2015 18:20:26 -0400
Message-ID: <5526FB2A.8060704@gmail.com>
References: <5526E8E9.3030805@gmail.com> <20150409221846.GG13731@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150409221846.GG13731@dastard>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <xfs@oss.sgi.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 04/09/2015 06:18 PM, Dave Chinner wrote:
> On Thu, Apr 09, 2015 at 05:02:33PM -0400, Joe Landman wrote:
>> If I build an MD raid0 with a non power of 2 chunk size, it appears
>> that I can mkfs.xfs a file system, but it doesn't show up in blkid
>> and is not mountable.  Yet, using a power of 2 chunk size, this does
>> work correctly.   This is kernel 3.18.9.
>>

[...]

> That looks more like a blkid or udev problem. try using blkid -p so
> that it doesn't look up the cache but directly probes devices for
> the signatures. strace might tell you a bit more, too. And if the
> filesystem mounts, then it definitely isn't an XFS problem ;)

Thats the thing, it didn't mount, even when I used the device name 
directly.

Good point on stracing though.  I'll do that tomorrow and report back.   
Thanks!

Joe

>
> Cheers,
>
> Dave.

-- 
Joe Landman
e: joe.landman@gmail.com
t: @sijoe

