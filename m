From: jim@rubylane.com
Subject: Re: Reduce Timeout on Disk Failure
Date: Tue, 29 Apr 2003 06:23:29 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030429132329.20854.qmail@rome.rubylane.com>
References: <Pine.LNX.4.44.0304291208100.31701-100000@aka.coware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0304291208100.31701-100000@aka.coware.de> from "Andreas Kahnt" at Apr 29, 2003 01:04:11 PM
To: Andreas Kahnt <aka@aka.coware.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If this is patched, I hope it is also put into a 2.2 update.  When a
SW raid is running, a couple of I/O retries might be reasonable, but
not heroic recovery attempts that would make good sense in a
single-disk environment.

We did a simple test of powering down an IDE drive that was part of an
(idle) SW raid, then trying to access the filesystem, and the system
just locked up.  Maybe it would have eventually come back to life - I
dunno.

For the curious, we haven't upgraded to 2.4x because whenever I check
the kernel traffic page, it seems there are still important bugs being
found and corrected - ones we don't want to experience in a production
setup.

Jim

> 
> Hello,
> 
> we've raid5 configured and removed one disk. The system hangs over one minute
> on io (try to copy a big file, cp is in 'uninterruptible sleep') before
> continuing in degraded mode. Lots of scsi errors occurred while pending
> (kernel 2.4.19). Is it possible to reduce this dead time? Where is it
> controlled that md recognizes disk failure at 17:37:09 but remove sde1 at
> 17:38:23, over one minute later?

...
