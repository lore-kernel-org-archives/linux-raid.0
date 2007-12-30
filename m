From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Linux RAID Partition Offset 63 cylinders / 30% performance hit?
Date: Sun, 30 Dec 2007 04:33:09 +0300
Message-ID: <4776F555.7040607@msgid.tls.msk.ru>
References: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan> <20071219215948.GA7129@cthulhu.home.robinhill.me.uk> <477154C1.6000503@tmr.com> <alpine.DEB.0.999999.0712290852140.5207@twinlark.arctic.org> <Pine.LNX.4.64.0712291234230.31479@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712291234230.31479@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: dean gaudet <dean@arctic.org>, Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

Justin Piszcz wrote:
[]
> Good to know/have it confirmed by someone else, the alignment does not
> matter with Linux/SW RAID.

Alignment matters when one partitions Linux/SW raid array.
If the inside partitions will not be aligned on a stripe
boundary, esp. in the worst case when the filesystem blocks
cross the stripe boundary (wonder if it's ever possible...
and I think it is, if a partition starts at some odd 512
bytes boundary, and filesystem block size is 4Kb, there's
just no chance for an inside filesystem to do full-stripe
writes, ever, so (modulo stripe cache size) all writes will
go read-modify-write or similar way.

And that's what the original article is about, by the way.
It just happens that hardware raid array is more often split
into partitions (using native tools) than linux software raid
arrays.

And that's what has been pointed out in this thread, as well... ;)

/mjt
