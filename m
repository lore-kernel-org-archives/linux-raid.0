From: Neil Brown <neilb@suse.de>
Subject: Re: md-raid and block sizes
Date: Tue, 28 Dec 2010 22:45:13 +1100
Message-ID: <20101228224513.31e71638@notabene.brown>
References: <1293451228.3266.9.camel@Waves.darkmere>
	<AANLkTikWxCxVUO+O8MXRXRR7Y8R5xGC1Catv-EiNGcDj@mail.gmail.com>
	<1293525980.23780.2.camel@Waves.darkmere>
	<AANLkTin=-0CN-teD5p4H_nFbuZ944DVuDMku3FaD7uv7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin=-0CN-teD5p4H_nFbuZ944DVuDMku3FaD7uv7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: "D.S. Ljungmark" <spider@skuggor.se>, doug@easyco.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 28 Dec 2010 18:29:26 +0700 hansbkk@gmail.com wrote:

> This doesn't actually relate to the blocksize issue, but a caveat -
> I've heard that these "green" drives are not suitable for use in a
> RAID.
> 
> The specific issue is apparently that these drives spin down very
> frequently, but most RAID implementations keep spinning them back up
> again just as frequently (perhaps unnecessarily?), thus causing undue
> wear and tear on the drives' mechanics and ultimately premature
> failure.
> 

After a brief period of no writes, md will update the bitmap and/or the
superblock to record that the array is clean (it may update the bitmap at
other times too, but that is not relevant here).

If the auto-spindown time of the drive is less than the delay-before-marking
the-array-clean of md, then you could get extra spin-ups.

The delay for updating the superblock is in sysfs in the md/safe_mode_timeout
file which defaults to 0.2 seconds (200msec).
The delay for updating the bitmap is set by an mdadm option (--bitmap-delay
or something like that) when adding a bitmap to an array, and I think is
available in sysfs in md/bitmap/something in recent kernels.
The actual delay before a write is between 2 and 3 times this number.
I think it defaults to 5 seconds (hence 10 to 15 second delay).

So if the drive spins down sooner than 15 seconds after the last IO, there
could be a problem but tuning md can git rid of that problem.
If the drive spin-down time is longer than 15 seconds, they should be no
unnecessary spin-ups.

If anyone has any data on default spin-down times of these "green" drives I
would be keen to hear about it.

Thanks,
NeilBrown

