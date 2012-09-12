From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: raid6 low performance 8x3tb drives in singledegraded mode(=7x3tb)
Date: Wed, 12 Sep 2012 14:38:05 +0100
Message-ID: <20560.36925.644039.819033@tree.ty.sabi.co.UK>
References: <504FD153.9090602@sandberg-consult.dk>
	<20560.22789.265849.102178@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20560.22789.265849.102178@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> It is (euphemism) mysterious that 'rsec/s' is nearly twice as
> high as 'wsec/s', and (euphemism) obscure that the RAID set is
> also 'sync'ing:

Oops I meant "sync"'ed. It is actually slightly obscure because
twice as many reads as writes even in degraded mode should not
happen, if writes are somewhat naturally aligned. It would be
easier to think that MD is rebuilding, but it is not.

>> Number   Major   Minor   RaidDevice State
>> 0       8        0        0      active sync   /dev/sda
>> [ ... ]
>> 8       8       96        6      active sync   /dev/sdg
>> 7       0        0        7      removed

Perhaps writes are indeed poorly aligned and a way to get this
(euphemism) astutely degraded-by-design setup to be less slow
would be to greatly increase the stripe cache size, but that
might not work, as this reply by NeilB for a a similar previous
case hints that things are somewhat complicated:

  http://www.spinics.net/lists/raid/msg38922.html

BAARF.com! :-)

[ ... ]
