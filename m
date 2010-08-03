From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: mdadm 3.1.x and bitmap chunk
Date: Tue, 3 Aug 2010 20:36:32 +0200
Message-ID: <20100803183632.GB2474@lazy.lzy>
References: <20100609210541.GA12153@lazy.lzy>
 <4C57114A.4000100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C57114A.4000100@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> This depends somewhat on what you mean by "minimum size" to the bitmap
> chunk.  The bitmap chunk size can never be smaller than the minimum size
> on the device, so 512bytes for most drives, 4k for newer drives.  But

as far as I know, there is a limited space for
the bitmap, hence if the chunk is too small,
the bitmap will not fit in that space.

> such a chunk size would be horrible for performance as it would make
> every single write synchronous on the bitmap update.  However, the
> minimum size can also be limited by the available space for the bitmap
> when using an internal bitmap.  So, you can only make the size as small
> as it will go and the bitmap still fit between the end of the
> {array,superblock} and the start of the {superblock,array}.
> 
> However, in general, a bitmap that's small enough that you can sync the
> dirty section in a second or two should be good enough.  With modern
> disks, they can sync 32MB or 64MB in only a second or two, hence the
> default size.  Anything less than that is really a case of diminishing
> returns.  You are sacrificing write speed on each and every write to the
> array in exchange for a *possible* speed up in the event of a crash.
> Not a very good trade off IMO.

Those are my usual USB HDDs in RAID-6 configuration.

Since the setup might be quite fragile, since the
write performances are anyway limited by the USB
and not by the seek time and writinig is anywau slow,
I would like to keep the bitmap resync fast.

That is, if a USB cable fails, I can just replace it
and resync using bitmap, this will be quite fast, if
the bitmap chunk is not too big.

64MB is quite a huge amount of data for USB, so it
will not help to keep the bitmap resync fast.
Which means the chunk should be small, one target
could be the smallest possible, given the available
space in the superblock.

Thanks,

bye,

-- 

piergiorgio
