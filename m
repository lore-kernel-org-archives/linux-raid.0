From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Bug in MDADM or just crappy computer?
Date: Fri, 22 Apr 2005 14:26:06 +0200
Message-ID: <62b0912f050422052612fac70a@mail.gmail.com>
References: <cv9gbc$84g$1@sea.gmane.org>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cv9gbc$84g$1@sea.gmane.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Phantazm <phantazm@phantazm.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Phantazm wrote:
> And the kernel log is filled up with this.
> 
> Feb 20 08:43:13 [kernel] md: md0: sync done.
> Feb 20 08:43:13 [kernel] md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 5000
> KB/sec/disc.
> Feb 20 08:43:13 [kernel] md: md0: sync done.
> Feb 20 08:43:13 [kernel] .<6>md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 5000
> KB/sec/disc.

No "sync done" here? What is it doing, multiple syncs in parallel?

> Feb 20 08:43:13 [kernel] .<6>md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 5000
> KB/sec/disc.

Again (below line)?

> Feb 20 08:43:13 [kernel] md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 5000
> KB/sec/disc.
> Feb 20 08:43:13 [kernel] md: using maximum available idle IO bandwith (but
> not more than 15000 KB/sec) for reconstruction.
> Feb 20 08:43:13 [kernel] md: using 128k window, over a total of 199141632
> blocks.
> Feb 20 08:43:13 [kernel] md: md0: sync done.

There we go, a "sync done" (above)....

> Feb 20 08:43:13 [kernel] .<6>md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 5000
> KB/sec/disc.

But then again (below)..

> Feb 20 08:43:13 [kernel] .<6>md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 5000
> KB/sec/disc.

And again...

> Feb 20 08:43:13 [kernel] .<6>md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 5000
> KB/sec/disc.

And again...

> Feb 20 08:43:13 [kernel] .<6>md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 5000
> KB/sec/disc.

And again?!

> Feb 20 08:43:13 [kernel] .<6>md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 5000
> KB/sec/disc.

And again...

> Feb 20 08:43:13 [kernel] .<6>md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 5000
> KB/sec/disc.

And again...

> Feb 20 08:43:13 [kernel] md: syncing RAID array md0

[snip]
Odd!

> aint got a single clue what it could be.

I'm seeing something that looks like the same, so let me know if you
found out what happened.
