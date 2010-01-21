From: Erno Kuusela <erno@iki.fi>
Subject: Re: Stupid question regarding RAID-1 access pattern
Date: 21 Jan 2010 09:34:19 +0200
Message-ID: <gu4hbqfzzb8.fsf@tk-cn0001.oulu.fi>
References: <4B44EB58.2090400@northarc.com> <20100106213723.GA12318@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Hill <robin@robinhill.me.uk> writes:

> I doubt this would help much really.  If you're reading sequential data
> then it's pretty much as quick to keep reading as to seek to the next
> chunk.

Only if your stripe size is smaller than your bandwidth x seek time.
Break even stripe size for 100MB/s 10ms disks would be 1 MB, so it
might work well with 4-10 MB stripes provided the IO stack is up to it?

Erno

