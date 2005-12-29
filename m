From: "Bill Rugolsky Jr." <bill@rugolsky.com>
Subject: Re: Adding Reed-Solomon Personality to MD, need help/advice
Date: Thu, 29 Dec 2005 14:23:02 -0500
Message-ID: <20051229192302.GE1493@ti64.telemetry-investments.com>
References: <6.0.1.1.2.20040130235924.03f39710@mail.athenet.net> <dlsh2c$2h0$1@sea.gmane.org> <dp1aj1$su0$1@terminus.zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dp1aj1$su0$1@terminus.zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Dec 29, 2005 at 10:40:33AM -0800, H. Peter Anvin wrote:
> It's not really in-between; generic RS RAID would be many times slower
> than either; however, unlike raid10 it could survive *any* m failures
> where m is the number of redundancy drives.
> 
> The fundamental problem is that generic RS requires table lookups even
> in the common case, whereas RAID-6 uses shortcuts to substantially
> speed up the computation in the common case.  RAID-6 is an important
> corner of the problem space, since it deals with the unfortunately
> fairly common problem of "disk failure discovered during recovery"
> with RAID-5.
> 
> That doesn't mean there couldn't be a problem space where it would
> make sense (in fact, on the contrary), but it's still a substantial
> engineering effort that would have to be justified.
> 
> Heck, I might even be persuaded to look for generic RS shortcuts if
> someone tempted me enough...

Funny, I was just thinking about this last night ...
 
The "obvious" case is distributed RAID (RAIS?), where one might
want something to survive 50% loss or more.  But as you know,
the generic RS suffers from the same read-modify-write latency as
all parity-based RAID levels except Daniel Phillips's RAID 3.5
[ http://sources.redhat.com/cluster/ddraid/ ].

For archival purposes though, slow writes might not be a big deal.
At the margin, this use case begins to overlap various p2p technologies.

Regards,

	Bill Rugolsky
