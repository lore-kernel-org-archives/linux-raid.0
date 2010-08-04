From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: mdadm 3.1.x and bitmap chunk
Date: Wed, 4 Aug 2010 21:53:02 +0200
Message-ID: <20100804195302.GA3288@lazy.lzy>
References: <20100609210541.GA12153@lazy.lzy>
 <4C57114A.4000100@redhat.com>
 <20100803183632.GB2474@lazy.lzy>
 <4C58BC53.1070304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C58BC53.1070304@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> > Since the setup might be quite fragile, since the
> > write performances are anyway limited by the USB
> > and not by the seek time and writing is anyway slow,
> 
> Seeks will *always* limit array speed, even when the link is slow.
> Especially on bitmaps where the seek is synchronous to the pending write.

not really, in this case.
HDDs have cache and prefetch, being the link slow
these work quite at an optimal point.

Actually, there is a huge difference in case of fast
SATA HDDs (having bitmap or not), but as soon as the
link speed goes down it gets even.
In the end it is a RAID-6, so writes are not easy anyhow...

As a side condition, this USB array is mainly a read
device, it's a storage system.
This means that writes will be almost exclusively
filesystem metadata update (access time), so not
really a big deal.

> > 64MB is quite a huge amount of data for USB, so it
> > will not help to keep the bitmap resync fast.
> 
> It will help, without a doubt.  Any bitmap is better than no bitmap for
> resync.  However, any bitmap is a hurt on performance.  How much of a
> help versus a hurt just depends on the chunk size.

I meant, 64MB will help less than 64KB.

Chunk size is 64KB, that's because it was the default
at the time the arrays were created.

Since the max transfer data chunk for the USB storage
protocol should be 128KB, I wonder if that chunk size
would have been better.
I might try to reshape it.
 
> I don't have an easy answer for the smallest chunk size based upon the
[...]

Thanks for the suggestion, I'll try to see if I can
manage to get the "smaller chunk size".

> In any case though, I would just try reducing the bitmap chunk to the
> old default of 8mb.  At 8mb you are already suffering a 5% or so
> performance penalty on write, but 8mb is not too much to resync, even
> over USB, so it might be a good compromise in your case.

I'll try also this, even if I hope I'll have not
to benchmark... :-)

BTW, a single USB device can transfer up to 30MB/s, with
one HDD limited to 15MB/s (old HDD).

The arrays can achieve around 43MB/s (read, of course),
which seems to be the limit of the USB chipset of the
motherboard (probably todays MBs can do 50~55MB/s).

This 43MB/s seem to be the limit, since this speed is
achieved with 10 HDDs as well as with 4 (a bit less).

Is this data any good to calculate the "optimal" bitmap
chunk size?

Note that with SATA HDDs the read speed I got (4 HDDs in
RAID-5) was almost precisely (n-1)*slowest_disk, i.e.
3*110MB/s.
In case of the USB system it is not (due to the USB
bottleneck) (n-2)*slowest_disk, so the concept of having
a bitmap chunk about around the 1 second transfer is a
bit difficult, for me, to understand.

Thanks again,

bye,

-- 

piergiorgio
