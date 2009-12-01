From: Neil Brown <neilb@suse.de>
Subject: Re: md: oops on dropping bitmaps from an array
Date: Tue, 1 Dec 2009 12:18:51 +1100
Message-ID: <20091201121851.45cd4e41@notabene.brown>
References: <200911301500.24223.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200911301500.24223.a.miskiewicz@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 30 Nov 2009 15:00:24 +0100
Arkadiusz Miskiewicz <a.miskiewicz@gmail.com> wrote:

> 
> After reading
> http://etbe.coker.com.au/2008/01/28/write-intent-bitmaps/ wanted to
> check bitmaps, turned these on but
> http://blog.liw.fi/posts/write-intent-bitmaps/ caused me to do

Yes, bitmaps can slow things down.  Using a larger bitmap chunk size
can help.  mdadm-3.1.1 uses a significantly larger chunk size by
default which should help.
I just ran some fairly simple tests on a RAID5 over 5 150G drives.
The test was untaring and then removing the linux kernel source.

The old default bitmap chunksize is 512K which resulted in a slowdown of
7%-9% compared with no bitmap.
The new default size is 64MB with resulted in a slowdown or 0.3% to 2%.

So there is still a cost, but smaller.
A larger bitmap chunksize will theoretically make the resync time after
a crash a little longer, but it would still be a fraction of 1% with
this size of bitmap chunk.

Like any insurance there is a cost.
  They pay you every time your house burns down,
  You pay them every time it doesn't.

It is a question of when the cost is justified, which needs to be made
on an individual basis.


> 
> mdadm --grow --bitmap=none /dev/md3
> 
> which ended with the oops below:
> 
> 2.6.31.5, raid10 array
> 
> [2500705.083965] BUG: unable to handle kernel NULL pointer
> dereference at
> (null) [2500705.090142] IP: [<ffffffffa001387a>]
> bitmap_daemon_work+0x20a/0x500

That is bad.  I think I can see what is happening.  I suspect that this
is a fairly hard race to hit - you must been unlucky:-(   But thanks
very much for reporting it.  I'll see about getting it fixed.  I
probably just need to wrap a mutex around bitmap_daemon_work and grab
it before destroying the bitmap, but I need to read the code more
carefully and make sure.

Thanks,
NeilBrown

