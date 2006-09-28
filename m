From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [BUG/PATCH] md bitmap broken on big endian machines
Date: Fri, 29 Sep 2006 02:09:24 +0400
Message-ID: <451C4814.9030601@tls.msk.ru>
References: <4512F55D.5030907@steeleye.com> <17691.27892.571457.628971@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17691.27892.571457.628971@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Paul Clements <paul.clements@steeleye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
[]
> Use ffz instead of find_first_set to convert multiplier to shift.
> 
> From: Paul Clements <paul.clements@steeleye.com>
> 
> find_first_set doesn't find the least-significant bit on bigendian
> machines, so it is really wrong to use it.
> 
> ffs is closer, but takes an 'int' and we have a 'unsigned long'.
> So use ffz(~X) to convert a chunksize into a chunkshift.

So we don't use ffs(int) for an unsigned value because of int vs
unsigned int, but we use ffz() with negated UNSIGNED.  Looks even
more broken to me, even if it happens to work correctly... ;)

/mjt
