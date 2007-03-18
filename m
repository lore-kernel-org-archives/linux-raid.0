From: Neil Brown <neilb@suse.de>
Subject: Re: Data corruption on software raid.
Date: Mon, 19 Mar 2007 09:16:12 +1100
Message-ID: <17917.47660.761394.926259@notabene.brown>
References: <20070318131606.GJ6063@freshdot.net>
	<45FD7258.1040208@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Sunday March 18
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org, ssmeenk@freshdot.net
List-Id: linux-raid.ids

On Sunday March 18, davidsen@tmr.com wrote:
> 
> This may be due to a characteristic of RAID1, which I believe Neil 
> described when discussing "check" failures in using RAID1 for swap. In 
> some cases, the data is being written from a user buffer, which is 
> changing. and the RAID software does two write, one to each device, 
> resulting in the data in the buffer changing as the write occurs. More 
> on this at the end.

While you can get different data written to different devices in a
RAID1, this difference is NEVER visible above the filesystem.

It is mostly likely to happen with swap and, if it does, the swap
system will never try to read that data back.
It can conceivably happen with regular filesystems, but only if a file
is being changed immediately before being truncated.  Some of the blocks
that were in the file might end up different on each device.  But
the data in those blocks will never be read (because the file has been
truncated). 

So this could not explain the current problem.

> 
> I do have a thought which MIGHT address this issue in a general way, 
> perhaps Neil will share he opinion. When writing to any array with 
> multiple copies which are written from user buffers, perhaps the code 
> could set the page(s) as copy on write. Then if the program tried to 
> modify the data it could be done safely. When the write to all drives 
> was complete, the COW could be cleared, and if the page had not been 
> modified very little overhead would be generated. If the page had been 
> modified, then the original would no longer be mapped to a process and 
> could be released.
> 
> Neil, what think you? This would be e general solution to the mismatched 
> multiple copies issue, assuming that it could be done at all.

Copy-on-write is not as easy as it sounds.  Trying to trigger COW from
the md driver would be incredibly messy and wouldn't solve any serious
problem.

NeilBrown
