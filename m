From: Jeff Breidenbach <breidenbach@gmail.com>
Subject: Re: Adding Reed-Solomon Personality to MD, need help/advice
Date: Thu, 29 Dec 2005 11:54:07 -0800
Message-ID: <e03b90ae0512291154x1745986dqef443a6b0b4787bc@mail.gmail.com>
References: <6.0.1.1.2.20040130235924.03f39710@mail.athenet.net>
	 <dlsh2c$2h0$1@sea.gmane.org> <dp1aj1$su0$1@terminus.zytor.com>
Reply-To: jeff@jab.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dp1aj1$su0$1@terminus.zytor.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The fundamental problem is that generic RS requires table lookups even
> in the common case, whereas RAID-6 uses shortcuts to substantially
> speed up the computation in the common case.

If one wanted to support a typical 8-bit RS code (which supports a max of
256 drives, including ECC drives) it is already way too big to use a table. RS
is typically done with finite field math calculations which are -
relatively - fast
but they are much heavier than a parity calculation. Here is one commercial
benchmark, note the throughput numbers at the bottom of the page.

   http://www.4i2i.com/reed_solomon_codes.htm

I can easily imagine CPU being the bottleneck for a large RS RAID, especially
when run in degraded mode. Rakhi Motwani and I worked on a RS based,
RAID-like storage system, although not for magnetic disks. Search for
"Collocated DataGlyph Protocol" if you are interested. It was a lot of fun.

Cheers,
Jeff
