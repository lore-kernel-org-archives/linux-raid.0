From: Gilad Arnold <arnold@cs.berkeley.edu>
Subject: Re: migrating from RAID5 to RAID10
Date: Thu, 10 Jun 2010 15:30:48 -0700
Message-ID: <20100610223047.GB14165@libra.CS.Berkeley.EDU>
References: <20100609151132.GA10082@libra.CS.Berkeley.EDU>
 <20100611005231.401529c0@natsu>
 <20100610195851.GA8408@libra.CS.Berkeley.EDU>
 <AANLkTim3vrtAfgzY87IAmP6mY9PNiYiQZ1LyuqWHisiD@mail.gmail.com>
 <AANLkTimW4IMO55vL-icTcpkcg9d10dK13yIGu4XZbrQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimW4IMO55vL-icTcpkcg9d10dK13yIGu4XZbrQQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 10, 2010 at 03:21:27PM -0700, Drew wrote:
> In this case, you're parity blocks will actually be identical to your
> non-parity blocks. This is because P1 is calculated as P1 = A1 XOR ??
> Since there is no other block to XOR your bits with, md falls back to
> ?? = 0, and we all know that the XOR of 0 is the identity. That is, P1
> = A1 XOR 0 == A1

I'm curious whether md actually computes the XOR or has a shortcut path
for the case where n=2.

> I stand corrected. :-)

No problem ;-)

Gilad
