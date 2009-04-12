From: jim owens <jowens@hp.com>
Subject: Re: Converting system to raid
Date: Sun, 12 Apr 2009 12:43:06 -0400
Message-ID: <49E21A1A.4020004@hp.com>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg> <49DF0D06.8030705@musmo.com> <20090410195303.GB21242@cthulhu.home.robinhill.me.uk> <00cc01c9ba1d$3aefecf0$0a00a8c0@vorg> <20090410205942.GC21242@cthulhu.home.robinhill.me.uk> <00f301c9ba23$032025f0$0a00a8c0@vorg> <20090410215129.GD21242@cthulhu.home.robinhill.me.uk> <019701c9ba66$aeed5630$0a00a8c0@vorg> <20090411143642.GA9915@cthulhu.home.robinhill.me.uk> <49E0B188.8050009@hp.com> <49E0BAF9.3090209@garzik.org> <49E0D60E.7040904@hp.com> <49E1CC6F.7020409@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49E1CC6F.7020409@garzik.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

To continue the pointless (but maybe entertaining) argument :)

Jeff Garzik wrote:
> jim owens wrote:
>> The filesystem mod-time might have nanoseconds in it, but
>> that does not mean 2 writes 100 nanoseconds apart will have
>> different mod-times.
> 
> Modern Linux filesystems absolutely do do metadata updates at that level 
> of granularity.

In filesystems it only counts if it makes it to disk.

10,000,000 write-to-disk metadata updates per second?  I think not.

Even the top-of-the-line intel ssd can only do 3,300 writes per second.

> Are you guaranteed district timestamps between writes?  No, but then 
> again, metadata updates were never guaranteed between two writes either. 
>  You might just be dirtying a mmap'd page, for example.

So this sounds like you at least agree with my original statement
that mod-time is not a 100% guarantee that no write occurred after
you read a particular block of a file.  Regardless of the fact we
disagree about how accurate filesystems record times.

jim
