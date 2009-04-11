From: jim owens <jowens@hp.com>
Subject: Re: Converting system to raid
Date: Sat, 11 Apr 2009 13:40:30 -0400
Message-ID: <49E0D60E.7040904@hp.com>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg> <49DF0D06.8030705@musmo.com> <20090410195303.GB21242@cthulhu.home.robinhill.me.uk> <00cc01c9ba1d$3aefecf0$0a00a8c0@vorg> <20090410205942.GC21242@cthulhu.home.robinhill.me.uk> <00f301c9ba23$032025f0$0a00a8c0@vorg> <20090410215129.GD21242@cthulhu.home.robinhill.me.uk> <019701c9ba66$aeed5630$0a00a8c0@vorg> <20090411143642.GA9915@cthulhu.home.robinhill.me.uk> <49E0B188.8050009@hp.com> <49E0BAF9.3090209@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49E0BAF9.3090209@garzik.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Garzik wrote:
> jim owens wrote:
>> nanosecond time stamps are a myth!
> 
> Not true, in the age of NO_HZ...

While nanosecond time is real on some hardware platforms,
I don't know of any hard disk filesystem that does metadata
updates at that level of granularity and guarantees distinct
timestamps between writes at extremely short intervals.

Even SSD performance would suck if we did that.

The filesystem mod-time might have nanoseconds in it, but
that does not mean 2 writes 100 nanoseconds apart will have
different mod-times.

jim
