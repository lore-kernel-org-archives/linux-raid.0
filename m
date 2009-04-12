From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Converting system to raid
Date: Sun, 12 Apr 2009 13:18:44 -0400
Message-ID: <49E22274.9000404@garzik.org>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg> <49DF0D06.8030705@musmo.com> <20090410195303.GB21242@cthulhu.home.robinhill.me.uk> <00cc01c9ba1d$3aefecf0$0a00a8c0@vorg> <20090410205942.GC21242@cthulhu.home.robinhill.me.uk> <00f301c9ba23$032025f0$0a00a8c0@vorg> <20090410215129.GD21242@cthulhu.home.robinhill.me.uk> <019701c9ba66$aeed5630$0a00a8c0@vorg> <20090411143642.GA9915@cthulhu.home.robinhill.me.uk> <49E0B188.8050009@hp.com> <49E0BAF9.3090209@garzik.org> <49E0D60E.7040904@hp.com> <49E1CC6F.7020409@garzik.org> <49E21A1A.4020004@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49E21A1A.4020004@hp.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

jim owens wrote:
> To continue the pointless (but maybe entertaining) argument :)
> 
> Jeff Garzik wrote:
>> jim owens wrote:
>>> The filesystem mod-time might have nanoseconds in it, but
>>> that does not mean 2 writes 100 nanoseconds apart will have
>>> different mod-times.
>>
>> Modern Linux filesystems absolutely do do metadata updates at that 
>> level of granularity.
> 
> In filesystems it only counts if it makes it to disk.
> 
> 10,000,000 write-to-disk metadata updates per second?  I think not.

Does every write (mtime update) trigger a write to disk?  I think not :) 
  You can write (== update inode mtime) 10,000,000 times, without ever 
touching disk.  Yet you fstat() still returns a nanosecond-granularity 
mtime.

	Jeff


